require 'time'

module RR
  module ConnectionExtenders

    # Provides various PostgreSQL specific functionality required by Rubyrep.
    module PostgreSQLExtender
      RR::ConnectionExtenders.register :postgresql => self
      
      # Returns an array of schemas in the current search path.
      def schemas
        unless @schemas
          search_path = select_one("show search_path")['search_path']
          @schemas = search_path.split(/,/).map { |p| quote(p.strip) }.join(',')
        end
        @schemas
      end

      # *** Monkey patch***
      # Returns the list of all tables in the schema search path or a specified schema.
      # This overwrites the according ActiveRecord::PostgreSQLAdapter method
      # to make sure that also search paths with spaces work
      # (E. g. 'public, rr' instead of only 'public,rr')
      def tables(name = nil)
        select_all(<<-SQL, name).map { |row| row['tablename'] }
          SELECT schemaname||'.'||tablename as tablename
            FROM pg_tables
           WHERE schemaname IN (#{schemas})
        SQL
      end

      # Returns an ordered list of primary key column names of the given table

      def primary_key_names(table)
        # Розбиваємо "schema.table" на окремі значення
        schema, table_name = table.include?('.') ? table.split('.', 2) : [nil, table]

        # Check if the table exists.
        row = self.select_one(<<-SQL)
            SELECT relname
            FROM pg_class rel
            JOIN pg_namespace nsp ON rel.relnamespace = nsp.oid
            WHERE rel.relname = '#{table_name}'
            #{schema ? "AND nsp.nspname = '#{schema}'" : ""}
          SQL

        raise "Table '#{table}' does not exist" if row.nil?

        # Retrieving a list of attributes (column numbers) that make up the primary key.
        row = self.select_one(<<-SQL)
            SELECT cons.conkey 
            FROM pg_class rel
            JOIN pg_namespace nsp ON rel.relnamespace = nsp.oid
            JOIN pg_constraint cons ON rel.oid = cons.conrelid
            WHERE cons.contype = 'p'
            AND rel.relname = '#{table_name}'
            #{schema ? "AND nsp.nspname = '#{schema}'" : ""}
          SQL

        return [] if row.nil?

        column_parray = row['conkey']

        # Change a Postgres Array of attribute numbers
        # (returned in String form, e. g.: "{1,2}") into an array of Integers
        column_ids = if column_parray.is_a?(Array)
                       column_parray # in JRuby the attribute numbers are already returned as array
                     else
                       column_parray.sub(/^\{(.*)\}$/, '\1').split(',').map(&:to_i)
                     end

        # Retrieving column names by their numbers.
        columns = {}
        rows = self.select_all(<<-SQL)
          SELECT attr.attnum, attr.attname
          FROM pg_class rel
          JOIN pg_namespace nsp ON rel.relnamespace = nsp.oid
          JOIN pg_constraint cons ON rel.oid = cons.conrelid
          JOIN pg_attribute attr ON rel.oid = attr.attrelid AND attr.attnum = ANY (cons.conkey)
          WHERE cons.contype = 'p'
          AND rel.relname = '#{table_name}'
          #{schema ? "AND nsp.nspname = '#{schema}'" : ""}
        SQL

        sorted_columns = []
        unless rows.nil?
          rows.each { |r| columns[r['attnum'].to_i] = r['attname'] }
          sorted_columns = column_ids.map { |column_id| columns[column_id] }
        end

        sorted_columns
      end


      # Returns for each given table, which other tables it references via
      # foreign key constraints.
      # * tables: an array of table names
      # Returns: a hash with
      # * key: name of the referencing table
      # * value: an array of names of referenced tables
      def referenced_tables(tables)
        # Splitting each “schema.table” record into separate components.
        schema_table_pairs = tables.map do |table|
          schema, table_name = table.include?('.') ? table.split('.', 2) : [nil, table]
          { schema: schema, table: table_name }
        end

        # Preparing a condition for table filtering.
        table_conditions = schema_table_pairs.map do |pair|
          if pair[:schema]
            "(nsp.nspname = '#{pair[:schema]}' AND referencing.relname = '#{pair[:table]}')"
          else
            "referencing.relname = '#{pair[:table]}'"
          end
        end.join(" OR ")

        rows = self.select_all(<<-SQL)
          SELECT DISTINCT referencing.relname AS referencing_table, 
                          referenced.relname AS referenced_table,
                          nsp.nspname AS referencing_schema,
                          ref_nsp.nspname AS referenced_schema
          FROM pg_class referencing
          LEFT JOIN pg_namespace nsp ON referencing.relnamespace = nsp.oid
          LEFT JOIN pg_constraint ON referencing.oid = pg_constraint.conrelid
          LEFT JOIN pg_class referenced ON pg_constraint.confrelid = referenced.oid
          LEFT JOIN pg_namespace ref_nsp ON referenced.relnamespace = ref_nsp.oid
          WHERE referencing.relkind = 'r'
          AND (#{table_conditions})
        SQL

        result = {}

        rows.each do |row|
          referencing_full_name = "#{row['referencing_schema']}.#{row['referencing_table']}"
          referenced_full_name = row['referenced_schema'] ? "#{row['referenced_schema']}.#{row['referenced_table']}" : nil

          result[referencing_full_name] ||= []
          result[referencing_full_name] << referenced_full_name if referenced_full_name
        end

        result
      end


      # Quotes the value so it can be used in SQL insert / update statements.
      #
      # @param [Object] value the target value
      # @param [ActiveRecord::ConnectionAdapters::PostgreSQLColumn] column the target column
      # @return [String] the quoted string
      def column_aware_quote(value, column)
        quote column.type_cast_for_database value
      end

      # Casts a value returned from the database back into the according ruby type.
      #
      # @param [Object] value the received value
      # @param [ActiveRecord::ConnectionAdapters::PostgreSQLColumn] column the originating column
      # @return [Object] the casted value
      def fixed_type_cast(value, column)
        if column.sql_type == 'bytea' and RUBY_PLATFORM == 'java'
          # Apparently in Java / JRuby binary data are automatically unescaped.
          # So #type_cast_from_database must be prevented from double-unescaping the binary data.
            value
        else
          column.type_cast_from_database value
        end
      end

    end
  end
end

