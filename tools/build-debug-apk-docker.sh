#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is not installed or not in PATH." >&2
  exit 1
fi

if [[ -n "${1:-}" ]]; then
  SHORT_SHA="$1"
else
  SHORT_SHA="$(git -C "$ROOT_DIR" rev-parse --short HEAD)"
fi

if [[ -n "${2:-}" ]]; then
  BUILD_NAME="$2"
else
  BUILD_NAME="$(date +%Y.%m.%d)"
fi

OUTPUT_DIR="$ROOT_DIR/build/app/outputs/flutter-apk"

mkdir -p "$OUTPUT_DIR"

echo "Building debug APK in Docker..."
echo "Version: $BUILD_NAME"
echo "Hash: $SHORT_SHA"

docker run --rm \
  -v "$ROOT_DIR:/workspace" \
  -w /workspace \
  -e GIT_SHA_SHORT="$SHORT_SHA" \
  ghcr.io/cirruslabs/flutter:3.24.5 \
  bash -lc "flutter pub get && flutter build apk --debug --build-name '$BUILD_NAME' && cp build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/flauncher-debug-$SHORT_SHA.apk"

echo "Done. APK: $OUTPUT_DIR/flauncher-debug-$SHORT_SHA.apk"
