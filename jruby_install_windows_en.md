[ukrainian](jruby_install_windows_uk.md)
# Installation Guide for RubyRep on Windows

## 1. Installing Java
1. Download and install **Java Runtime Environment (JRE)**:  
   [jre-8u441-windows-i586](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)
2. Verify that Java is installed correctly:
   ```sh
   java -version
   ```
   If the command does not work, check the environment variables (see the PATH section).

## 2. Installing JRuby
1. Download and install **JRuby**:  
   [jruby_windows_x64_9_4_10_0](https://www.jruby.org/download)
2. Make sure that the `jruby` path is added to the `PATH` environment variable:
   - Press `Win + R`, type `sysdm.cpl` → OK.
   - Go to the **Advanced** tab → **Environment Variables**.
   - In the **System Variables** section, find `Path` and click **Edit**.
   - Add the JRuby path, for example:
     ```
     C:\jruby...\bin
     ```
   - Click **OK**.
3. Open a **new** `cmd.exe` window and verify the installation:
   ```sh
   jruby -v
   ```
   If the command does not work, check the `PATH` settings or restart the command prompt.

## 3. Downloading and Setting Up RubyRep
1. Download the archive from the repository:  
   ```sh
   git clone https://github.com/arollick/rubyrep.git
   ```
   or manually download and extract it into a folder, for example:
   ```sh
   C:\home\rubyrep
   ```
2. Navigate to the `rubyrep` folder:
   ```sh
   cd C:\home\rubyrep
   ```
3. Create a folder for syncs:
   ```sh
   mkdir syncs
   ```

## 4. Install Bundler
After installing JRuby, install Bundler, which is required for dependency management:

```cmd
jruby -S gem install bundler
```

## 5. Install Project Dependencies
Navigate to your project folder and run:

```cmd
cd C:\home\rubyrep
jruby -S bundle install
```

## 6. Editing the Startup File
1. Open the `rubyrep.bat` file in a text editor.
2. Find the line:
   ```bat
   set jruby_path=%~dp0jruby\bin\jruby.bat
   ```
3. Replace it with:
   ```bat
   set jruby_path=jruby.bat
   ```
4. Save the changes.

## 7. Running RubyRep
1. Open `cmd.exe` and navigate to the `rubyrep` folder:
   ```sh
   cd C:\home\rubyrep
   ```
2. Run `rubyrep.bat`:
   ```sh
   rubyrep.bat
   ```
3. If you see a message about a missing path, check the `PATH` settings and open a new command prompt window.

---
