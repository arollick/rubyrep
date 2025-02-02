module RR
  # This class implements the base functionality for all runners
  class AbstractRunner
    # Default options if not overriden in command line
    DEFAULT_OPTIONS = {}

    # Provided options
    attr_accessor :options

    # Returns the active +Session+. 
    # Loads config file and creates session if necessary.
    def session
      unless @session
        load options[:config_file]

        # Якщо є included_table_specs в конфігурації
        if Initializer.configuration.respond_to?(:included_table_specs)
          # Collecting schemas independently for the left and right databases.
          left_schemas = Set.new(['public'])
          right_schemas = Set.new(['public'])

          # Modifying included_table_specs, add public schema if it is not specified
          specs = Initializer.configuration.included_table_specs.map do |spec|
            if spec.is_a?(String)
              left_table, right_table = spec.split(',').map(&:strip)
              right_table ||= left_table

              left_table = "public.#{left_table}" unless left_table.include?('.')
              right_table = "public.#{right_table}" unless right_table.include?('.')

              right_table == left_table ? left_table : "#{left_table},#{right_table}"
            else
              spec
            end
          end

          # New included_table_specs
          Initializer.configuration.instance_variable_set(:@included_table_specs, specs)

          # Collecting schemas
          Initializer.configuration.included_table_specs.each do |spec|
            if spec.is_a?(String)
              left_table, right_table = spec.split(',').map(&:strip)
              right_table ||= left_table

              schema = left_table.split('.').first
              left_schemas.add(schema)

              schema = right_table.split('.').first
              right_schemas.add(schema)
            end
          end

          # Setting schema_search_path for left and right databases
          Initializer.configuration.left[:schema_search_path] = left_schemas.to_a.sort.join(',')
          Initializer.configuration.right[:schema_search_path] = right_schemas.to_a.sort.join(',')
        end

        @session = Session.new Initializer.configuration
      end
      @session
    end

    attr_writer :session

    # Entry points for executing a processing run.
    # args: the array of command line options that were provided by the user.
    def self.run(args)
      runner = new

      status = runner.process_options(args)
      if runner.options
        runner.execute
      end
      status
    end
  end
end 