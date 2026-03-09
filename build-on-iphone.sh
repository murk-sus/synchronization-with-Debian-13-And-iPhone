#!/bin/bash
set -euo pipefail

PKG_DIR="pkg/debiansync"
OUT_DIR="dist"
OUT_DEB="$OUT_DIR/com.debiansync.fullsync_0.1.0_iphoneos-arm.deb"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "ERROR: build-on-iphone.sh must be run on iPhone/iOS (Darwin)."
  echo "Current system: $(uname -s)"
  exit 1
fi

find_dpkg_deb() {
  local candidates=(
    "$(command -v dpkg-deb 2>/dev/null || true)"
    "/usr/bin/dpkg-deb"
    "/var/jb/usr/bin/dpkg-deb"
    "/opt/procursus/bin/dpkg-deb"
  )

  local path
  for path in "${candidates[@]}"; do
    [[ -n "$path" && -x "$path" ]] && {
      printf '%s\n' "$path"
      return 0
    }
  done

  return 1
}

DPKG_DEB_BIN="$(find_dpkg_deb || true)"
if [[ -z "$DPKG_DEB_BIN" ]]; then
  echo "ERROR: dpkg-deb not found."
  echo "Install package manager tools on iPhone (Sileo/Zebra/Cydia), then install package 'dpkg' or 'dpkg-dev'."
  echo "Checked paths: /usr/bin, /var/jb/usr/bin, /opt/procursus/bin and PATH."
  exit 1
fi

mkdir -p "$OUT_DIR"
"$DPKG_DEB_BIN" --build "$PKG_DIR" "$OUT_DEB"
echo "Built: $OUT_DEB"
