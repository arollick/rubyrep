[english](jruby_install_windows_en.md)
# Інструкція з налаштування RubyRep на Windows

## 1. Встановлення Java
1. Завантажте та встановіть **Java Runtime Environment (JRE)**:  
   [jre-8u441-windows-i586](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)
2. Переконайтеся, що Java встановлена правильно:
   ```sh
   java -version
   ```
   Якщо команда не працює, перевірте змінні середовища (див. розділ про PATH).

## 2. Встановлення JRuby
1. Завантажте та встановіть **JRuby**:  
   [jruby_windows_x64_9_4_10_0](https://www.jruby.org/download)
2. Переконайтеся, що шлях до `jruby` додано в змінну середовища `PATH`:
    - Натисніть `Win + R`, введіть `sysdm.cpl` → ОК.
    - Перейдіть у вкладку **Додатково** → **Змінні середовища**.
    - У розділі **Системні змінні** знайдіть `Path` і натисніть **Змінити**.
    - Додайте шлях до JRuby, наприклад:
      ```
      C:\jruby...\bin
      ```
    - Натисніть **ОК**.
3. Відкрийте **нове** вікно `cmd.exe` та перевірте:
   ```sh
   jruby -v
   ```
   Якщо команда не працює, перевірте налаштування `PATH` або перезапустіть командний рядок.

## 3. Завантаження та налаштування RubyRep
1. Завантажте архів із репозиторію:
   ```sh
   git clone https://github.com/arollick/rubyrep.git
   ```
   або вручну скачайте та розархівуйте в папку, наприклад:
   ```sh
   C:\home\rubyrep
   ```
2. Перейдіть у папку `rubyrep`:
   ```sh
   cd C:\home\rubyrep
   ```
3. Створіть папку для синхронізацій:
   ```sh
   mkdir syncs
   ```

## 4. Встановіть Bundler
Після встановлення JRuby інсталюйте Bundler, який потрібен для управління залежностями:

```cmd
jruby -S gem install bundler
```

## 5. Встановіть залежності проекту
Перейдіть до папки вашого проекту і виконайте:

```cmd
cd C:\home\rubyrep
jruby -S bundle install
```

## 6. Редагування файлу запуску
1. Відкрийте файл `rubyrep.bat` у текстовому редакторі.
2. Знайдіть рядок:
   ```bat
   set jruby_path=%~dp0jruby\bin\jruby.bat
   ```
3. Замініть його на:
   ```bat
   set jruby_path=jruby.bat
   ```
4. Збережіть зміни.

## 7. Запуск RubyRep
1. Відкрийте `cmd.exe`, перейдіть у папку `rubyrep`:
   ```sh
   cd C:\home\rubyrep
   ```
2. Запустіть `rubyrep.bat`:
   ```sh
   rubyrep.bat
   ```
3. Якщо з’являється повідомлення про відсутність шляху, перевірте налаштування `PATH` та відкрийте новий командний рядок.

---
