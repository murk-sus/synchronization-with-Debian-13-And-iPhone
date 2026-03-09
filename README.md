# Debian Full Sync tweak (iOS ↔ Debian 13)

Твик для **jailbreak iPhone** (включая iPhone X, iOS 16.7.x), который даёт:

- синхронизацию буфера обмена в обе стороны;
- двустороннюю синхронизацию файлов через `rsync`;
- автосинхронизацию каждые 60 секунд через LaunchDaemon.

> Важно: iOS без jailbreak не позволяет такой уровень фоновой синхронизации и доступ к системным демонам.

## Как скачать проект на iPhone

Ниже самые рабочие варианты.

### Вариант 1 (рекомендуется): `git clone`

На iPhone в терминале (NewTerm/SSH):

```bash
apt update && apt install -y git
cd /var/mobile
# Подставь URL своего репо вместо <REPO_URL>
git clone <REPO_URL> debian-sync-project
cd debian-sync-project
```

### Вариант 2: скачать ZIP и распаковать

1. На Debian/ПК скачай ZIP репозитория.
2. Передай его на iPhone (AirDrop/Filza/SSH/SFTP) в `/var/mobile`.
3. На iPhone распакуй и зайди в папку проекта.

### Вариант 3: скопировать папку проекта с Debian на iPhone через SCP

На Debian:

```bash
scp -r ./synchronization-with-Debian-13-And-iPhone mobile@IPHONE_IP:/var/mobile/debian-sync-project
```

На iPhone:

```bash
cd /var/mobile/debian-sync-project
```

---

## Что внутри пакета

- `/usr/bin/debian-sync` — основной CLI для sync;
- `/etc/debiansync.conf` — конфиг Debian-хоста и путей;
- `/Library/LaunchDaemons/com.debiansync.fullsync.plist` — автозапуск полной синхронизации.

## Как собрать `.deb` (только на iPhone)

В папке проекта на iPhone:

```bash
chmod +x build-on-iphone.sh
./build-on-iphone.sh
```

Если всё ок, получишь файл:

```bash
dist/com.debiansync.fullsync_0.1.0_iphoneos-arm.deb
```

> Скрипт специально проверяет `uname -s == Darwin` и завершится ошибкой на Linux/macOS контейнерах — это нормально.

## Как установить на iPhone

```bash
dpkg -i dist/com.debiansync.fullsync_0.1.0_iphoneos-arm.deb
```

После установки открой и заполни конфиг:

```bash
nano /etc/debiansync.conf
```

Минимум нужно указать:

- `REMOTE_HOST`
- `REMOTE_USER`
- `REMOTE_SHARE_DIR`

## Что нужно на Debian 13

```bash
sudo apt update
sudo apt install -y openssh-server rsync xclip wl-clipboard
```

И желательно настроить SSH-ключ с iPhone на Debian (вход без пароля).

## Команды

```bash
debian-sync clip sync
debian-sync files sync
debian-sync full
```


## Если ошибка `dpkg-deb not found`

На некоторых jailbreak-системах `dpkg-deb` лежит не в `/usr/bin` (например rootless: `/var/jb/usr/bin` или Procursus: `/opt/procursus/bin`).

Что сделать:

```bash
# 1) Проверить, найден ли dpkg-deb
which dpkg-deb

# 2) Если не найден — установить инструменты dpkg через менеджер пакетов
# (Sileo / Zebra / Cydia): пакет dpkg или dpkg-dev

# 3) Повторить сборку
./build-on-iphone.sh
```

Скрипт теперь сам ищет `dpkg-deb` в `PATH`, `/usr/bin`, `/var/jb/usr/bin`, `/opt/procursus/bin`.

