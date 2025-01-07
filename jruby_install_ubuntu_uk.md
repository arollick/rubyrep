[english](jruby_install_ubuntu_en)
# Установка JRuby та RubyRep на Ubuntu 22.04

## 1. Оновіть систему
Перед початком переконайтеся, що система оновлена.
Зверніть увагу: під час оновлення служби та сервіси (наприклад, PostgreSQL) можуть тимчасово не працювати.
Якщо ви встановлюєте RubyRep на робочий сервер, краще пропустіть цей пункт і поверніться до нього, лише якщо виникнуть проблеми з установкою.
```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. Встановіть необхідні залежності
JRuby потребує Java. Встановіть OpenJDK:

```bash
sudo apt install openjdk-11-jdk -y
```

Перевірте версію Java:

```bash
java -version
```

---

## 3. Завантажте та встановіть JRuby
Перейдіть на офіційний сайт JRuby і завантажте останню версію:
[https://www.jruby.org/download](https://www.jruby.org/download)

Або скористайтеся командою `wget`:

```bash
wget https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.4.2.0/jruby-dist-9.4.2.0-bin.tar.gz
```

Розпакуйте архів:

```bash
tar -xvzf jruby-dist-9.4.2.0-bin.tar.gz
```

Перемістіть його до `/opt` (або іншого каталогу за вашим вибором):

```bash
sudo mv jruby-9.4.2.0 /opt/jruby
```

---

## 4. Додайте JRuby до PATH
Додайте JRuby до системного PATH, щоб його можна було викликати з будь-якого місця:

```bash
echo 'export PATH=/opt/jruby/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Перевірте, чи JRuby встановлено правильно:

```bash
jruby -v
```
---

## 5. Встановіть rubyrep
Перейдіть до папки, де буде розміщено RubyRep, і завантажте проєкт із GitHub або GitLab.
```bash
cd /pqhome
git clone https://github.com/arollick/rubyrep.git
```

---

## 6. Встановіть Bundler
Після встановлення JRuby інсталюйте `bundler`, який потрібен для управління залежностями:

```bash
jruby -S gem install bundler
```

---

## 7. Встановіть залежності проекту
Перейдіть до папки вашого проекту і виконайте:

```bash
cd /pqhome/rubyrep
jruby -S bundle install
```

---

## 7. Тестуйте проект
Перевірте, що все працює як слід з командного рядка. Тоді переходьте до налаштувань і тестування з pqstore.

```bash
./rubyrep
```


---

