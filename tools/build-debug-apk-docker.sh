#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is not installed or not in PATH." >&2
  exit 1
fi

SHORT_SHA="${1:-$(git -C "$ROOT_DIR" rev-parse --short HEAD)}"
BUILD_NAME="${2:-$(date +%Y.%m.%d)}"

OUTPUT_DIR="$ROOT_DIR/build/app/outputs/flutter-apk"
mkdir -p "$OUTPUT_DIR"

echo "Building debug APK in Docker..."
echo "Version: $BUILD_NAME"
echo "Hash:    $SHORT_SHA"

docker run --rm \
  -v "$ROOT_DIR:/workspace" \
  -v flutter_pub_cache:/root/.pub-cache \
  -v flutter_gradle_cache:/root/.gradle \
  -w /workspace \
  -e GIT_SHA_SHORT="$SHORT_SHA" \
  -e GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.parallel=true -Dorg.gradle.caching=true" \
  ghcr.io/cirruslabs/flutter:3.24.5 \
  bash -lc "
    flutter pub get && \
    flutter build apk --debug \
      --build-name '$BUILD_NAME' \
      --no-tree-shake-icons && \
    cp build/app/outputs/flutter-apk/app-debug.apk \
       build/app/outputs/flutter-apk/flauncher-debug-$SHORT_SHA.apk
  "

echo "Done. APK: $OUTPUT_DIR/flauncher-debug-$SHORT_SHA.apk"