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

if [[ ! -x /usr/bin/dpkg-deb ]]; then
  echo "ERROR: /usr/bin/dpkg-deb not found. Install dpkg on iPhone first."
  exit 1
fi

mkdir -p "$OUT_DIR"
/usr/bin/dpkg-deb --build "$PKG_DIR" "$OUT_DEB"
echo "Built: $OUT_DEB"
