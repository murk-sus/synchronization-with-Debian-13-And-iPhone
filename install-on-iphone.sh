#!/bin/bash
set -euo pipefail

DEB_PATH="${1:-dist/com.debiansync.fullsync_0.1.0_iphoneos-arm64.deb}"

run_as_root() {
  local cmd="$*"

  if [[ "$(id -u)" -eq 0 ]]; then
    bash -lc "$cmd"
    return
  fi

  if command -v sudo >/dev/null 2>&1; then
    sudo bash -lc "$cmd"
    return
  fi

  if command -v su >/dev/null 2>&1; then
    su -c "$cmd"
    return
  fi

  echo "ERROR: root privileges required. Run as root or install sudo/su."
  exit 1
}

if [[ ! -f "$DEB_PATH" ]]; then
  echo "ERROR: deb file not found: $DEB_PATH"
  echo "Build first: ./build-on-iphone.sh"
  exit 1
fi

echo "[*] Installing $DEB_PATH"
run_as_root "dpkg -i '$DEB_PATH'"

echo "[*] Reloading Settings/SpringBoard caches"
run_as_root "killall -9 cfprefsd >/dev/null 2>&1 || true"
run_as_root "killall -9 Preferences >/dev/null 2>&1 || true"
run_as_root "uicache -a >/dev/null 2>&1 || true"
run_as_root "sbreload >/dev/null 2>&1 || killall -9 SpringBoard >/dev/null 2>&1 || true"

echo "[+] Done. Open Settings and find: Debian Full Sync"
