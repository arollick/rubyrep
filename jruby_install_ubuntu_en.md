[ukrainian](jruby_install_ubuntu_uk.md)
# Install JRuby and RubyRep on Ubuntu 22.04

## 1. Update the System

Before starting, ensure your system is up-to-date.

Note: During the update, some services (e.g., PostgreSQL) may temporarily stop working.

If you're installing RubyRep on a production server, it's better to skip this step and return to it only if installation issues arise.

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. Install Required Dependencies

JRuby requires Java. Install OpenJDK:

```bash
sudo apt install openjdk-11-jdk -y
```

Verify the Java version:

```bash
java -version
```

---

## 3. Download and Install JRuby

Go to the official JRuby website and download the latest version:

[https://www.jruby.org/download](https://www.jruby.org/download)

Alternatively, use the `wget` command:

```bash
wget https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.4.2.0/jruby-dist-9.4.2.0-bin.tar.gz
```

Extract the archive:

```bash
tar -xvzf jruby-dist-9.4.2.0-bin.tar.gz
```

Move it to `/opt` (or another directory of your choice):

```bash
sudo mv jruby-9.4.2.0 /opt/jruby
```

---

## 4. Add JRuby to PATH

Add JRuby to the system PATH to make it accessible from anywhere:

```bash
echo 'export PATH=/opt/jruby/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Verify that JRuby is correctly installed:

```bash
jruby -v
```

---

## 5. Install RubyRep

Navigate to the directory where RubyRep will be located and clone the project from GitHub or GitLab:

```bash
cd /pqhome
git clone https://github.com/arollick/rubyrep.git
```

---

## 6. Install Bundler

After installing JRuby, install `bundler`, which is required for dependency management:

```bash
jruby -S gem install bundler
```

---

## 7. Install Project Dependencies

Navigate to your project folder and run:

```bash
cd /pqhome/rubyrep
jruby -S bundle install
```

---

## 8. Test the Project

Verify that everything is working correctly from the command line. Then proceed to configuration and testing with `pqstore`:

```bash
./rubyrep
```

