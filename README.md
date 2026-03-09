# Debian Full Sync tweak (iOS ↔ Debian 13)

Твик для **jailbreak iPhone** (включая iPhone X, iOS 16.7.x), который даёт:

- синхронизацию буфера обмена в обе стороны;
- двустороннюю синхронизацию файлов через `rsync`;
- автосинхронизацию каждые 60 секунд через LaunchDaemon.

> Важно: iOS без jailbreak не позволяет такой уровень фоновой синхронизации и доступ к системным демонам.

## Что внутри пакета

- `/usr/bin/debian-sync` — основной CLI для sync;
- `/etc/debiansync.conf` — конфиг Debian-хоста и путей;
- `/Library/LaunchDaemons/com.debiansync.fullsync.plist` — автозапуск полной синхронизации.

## Быстрый старт

1. Скопируй проект на iPhone.
2. На iPhone выполни сборку:
   ```bash
   ./build-on-iphone.sh
   ```
3. Установи пакет на iPhone:
   ```bash
   dpkg -i dist/com.debiansync.fullsync_0.1.0_iphoneos-arm.deb
   ```
4. Открой `/etc/debiansync.conf` и укажи:
   - `REMOTE_HOST`
   - `REMOTE_USER`
   - `REMOTE_SHARE_DIR`
5. На Debian установи:
   - `openssh-server`
   - `rsync`
   - `xclip` (или `wl-clipboard` на Wayland)
6. Настрой SSH-ключи с iPhone на Debian для входа без пароля.

## Команды

```bash
debian-sync clip sync
debian-sync files sync
debian-sync full
```

## Сборка только на iPhone

Скрипт `build-on-iphone.sh` специально проверяет `uname -s == Darwin` и завершится ошибкой на Linux/macOS CI контейнерах. Это сделано намеренно, чтобы итоговый `.deb` собирался только на самом iPhone.

