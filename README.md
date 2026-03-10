# Debian Full Sync tweak (iOS ↔ Debian 13)

Твик для **jailbreak iPhone** (включая iPhone X, iOS 16.7.x), который даёт:

- синхронизацию буфера обмена в обе стороны;
- двустороннюю синхронизацию файлов через `rsync`;
- автосинхронизацию через LaunchDaemon;
- **настоящий пункт в Настройках iPhone** для изменения параметров синка.

> Важно: iOS без jailbreak не позволяет такой уровень фоновой синхронизации и доступ к системным демонам.

## Новое: настройки в iPhone Settings

После установки открой:

**Настройки → Debian Full Sync**

Там можно менять:

- вкл/выкл автосинхронизации;
- интервал синхронизации (сек);
- IP/домен Debian хоста;
- SSH user/port;
- локальную и удалённую папки синхронизации.

Также в этом разделе добавлены твои контакты:

- GitHub: https://github.com/murk-sus
- Telegram канал: https://t.me/femboynayaa
- Telegram аккаунт: `@natsuki_my_wife_mur`
- Email: `afk9659@gmail.com`

## Как скачать проект на iPhone

### Вариант 1 (рекомендуется): `git clone`

```bash
apt update && apt install -y git
cd /var/mobile
git clone <REPO_URL> debian-sync-project
cd debian-sync-project
```

### Вариант 2: ZIP

Скачай ZIP на ПК, передай в `/var/mobile`, распакуй и зайди в папку проекта.

### Вариант 3: SCP с Debian

```bash
scp -r ./synchronization-with-Debian-13-And-iPhone mobile@IPHONE_IP:/var/mobile/debian-sync-project
```

## Как собрать `.deb` в PyCharm (Windows)

Ты получал ошибку `sudo отключен`, потому что запуск был из PowerShell.
`sudo/apt` работают только в Linux-окружении (WSL/Ubuntu).

### Через WSL

```powershell
wsl --install -d Ubuntu
```

Дальше в Ubuntu терминале:

```bash
sudo apt update
sudo apt install -y dpkg-dev
cd /path/to/project
chmod +x build-on-iphone.sh
./build-on-iphone.sh --allow-non-ios
```

## Как собрать `.deb` на iPhone

```bash
chmod +x build-on-iphone.sh
./build-on-iphone.sh
```

Готовый файл:

```bash
dist/com.debiansync.fullsync_0.1.0_iphoneos-arm64.deb
```

## Установка на iPhone

```bash
dpkg -i dist/com.debiansync.fullsync_0.1.0_iphoneos-arm64.deb
```

## Установка на iPhone (правильно, с root)

На скрине у тебя ошибка из-за запуска от пользователя `mobile`:

- `dpkg ... requires superuser privilege`
- `killall ... Operation not permitted`

Это нормально: для установки твика и перезапуска системных процессов нужны root-права.

### Вариант 1 (рекомендуется): авто-скрипт

```bash
chmod +x install-on-iphone.sh
./install-on-iphone.sh
```

Скрипт сам попробует `sudo` или `su`, установит deb и сделает reload кэшей.

### Вариант 2: вручную через root shell

```bash
su
# введи пароль root, если запрашивается

dpkg -i dist/com.debiansync.fullsync_0.1.0_iphoneos-arm64.deb
killall -9 cfprefsd
killall -9 Preferences
uicache -a || true
sbreload || killall -9 SpringBoard
```

## Debian зависимости

```bash
sudo apt update
sudo apt install -y openssh-server rsync xclip wl-clipboard
```

## Команды

```bash
/var/jb/usr/bin/debian-sync clip sync
/var/jb/usr/bin/debian-sync files sync
/var/jb/usr/bin/debian-sync full
```


## Ошибка в Sileo: `Depends ... iphoneos-arm`

Если видишь красные ошибки вида:

- `Depends rsync:iphoneos-arm`
- `Depends preferenceloader:iphoneos-arm`
- `Depends openssh:iphoneos-arm`

это означает, что менеджер пакетов не нашёл нужные пакеты в подключённых репо.

Я убрал жёсткие `Depends` из этого твика, чтобы установка не блокировалась.

Что сделать на iPhone:

1. Обновить источники в Sileo/Zebra (**Refresh**).
2. Установить вручную (если доступны):
   - OpenSSH
   - rsync
   - PreferenceLoader
3. Если `PreferenceLoader` не находится — добавь репо, где он есть (обычно BigBoss/Procursus в зависимости от jailbreak).
4. Переустанови наш пакет.

Через терминал (если есть apt):

```bash
apt update
apt install -y openssh rsync preferenceloader || true
```

Проверка после установки:

```bash
which ssh
which rsync
ls /Library/PreferenceLoader/Preferences/com.debiansync.fullsyncprefs.plist
```



## Ошибка `package architecture (iphoneos-arm) does not match system (iphoneos-arm64)`

Это значит, что ставится старый deb, собранный под `iphoneos-arm`.
Нужно пересобрать пакет с архитектурой `iphoneos-arm64` и ставить именно новый файл.

```bash
./build-on-iphone.sh
dpkg -i dist/com.debiansync.fullsync_0.1.0_iphoneos-arm64.deb
```

Если рядом лежит старый `...iphoneos-arm.deb`, удали его, чтобы не перепутать.


## Если твик не появляется в "Настройки"

На rootless iOS 16.7.14 твик должен лежать в `/var/jb/Library/...`.

В новой версии postinst работает в rootless-путях и перезапускает приложение Настройки.

Если всё равно не видно, выполни на iPhone:

```bash
# 1) Переустанови пакет

dpkg -i dist/com.debiansync.fullsync_0.1.0_iphoneos-arm64.deb

# 2) Проверь наличие plist и bundle в обоих путях
ls -l /var/jb/Library/PreferenceLoader/Preferences/com.debiansync.fullsyncprefs.plist
ls -ld /var/jb/Library/PreferenceBundles/DebianSyncPrefs.bundle

# 3) Очисти кэш настроек и перезапусти UI
killall -9 cfprefsd
killall -9 Preferences
uicache -a || true
sbreload || killall -9 SpringBoard
```

И проверь, установлен ли `PreferenceLoader` в rootless bootstrap.


## Ошибка `Read-only file system` при установке

Если видишь ошибку вида:

`unable to create '/Library/LaunchDaemons/...': Read-only file system`

это rootless-ограничение: нельзя писать в rootful путь `/Library/...`.

В новой сборке daemon ставится в `/var/jb/Library/LaunchDaemons`, поэтому пересобери и установи **новый** deb:

```bash
./build-on-iphone.sh
./install-on-iphone.sh
```

## Важно про `su`

Команда `su ./install-on-iphone.sh` неверная.

Правильно:

```bash
su -c ./install-on-iphone.sh
```

или сначала войти в root shell:

```bash
su
./install-on-iphone.sh
```



## Rootless iOS 16.7.14

Эта версия переписана под **rootless**:

- daemon: `/var/jb/Library/LaunchDaemons/com.debiansync.fullsync.plist`
- настройки: `/var/jb/Library/PreferenceLoader/...`
- бинарник: `/var/jb/usr/bin/debian-sync`
- конфиг: `/var/jb/etc/debiansync.conf`

Если ты на Dopamine/Palera1n rootless — ставь именно этот пакет.


## Ошибка `Не удалось загрузить пакет DebianSyncPrefs, не найден исполняемый файл`

Это ошибка загрузки PreferenceBundle в Настройках (NSCocoaErrorDomain Code=4).

Причина: у бандла не было исполняемого файла `DebianSyncPrefs`.

В этой версии исправлено: возвращён `CFBundleExecutable=DebianSyncPrefs`, а в bundle кладётся rootless-симлинк `DebianSyncPrefs -> /var/jb/usr/lib/libobjc.A.dylib` (и postinst его чинит при установке).

Что делать:

```bash
./build-on-iphone.sh
su -c ./install-on-iphone.sh
```

После установки открой Настройки снова.

