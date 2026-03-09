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
dist/com.debiansync.fullsync_0.1.0_iphoneos-arm.deb
```

## Установка на iPhone

```bash
dpkg -i dist/com.debiansync.fullsync_0.1.0_iphoneos-arm.deb
```

## Debian зависимости

```bash
sudo apt update
sudo apt install -y openssh-server rsync xclip wl-clipboard
```

## Команды

```bash
debian-sync clip sync
debian-sync files sync
debian-sync full
```
