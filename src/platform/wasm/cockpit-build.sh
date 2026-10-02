#!/bin/sh
# Build mGBA-wasm in the emsdk image as the current user (the image's /home/mgba is 750, so mount at /work instead).
set -e
cd "$(dirname "$0")/../../.."
exec docker run --rm -t --user "$(id -u):$(id -g)" -w /work -v "$PWD":/work \
  -e HOME=/tmp -e EM_CACHE=/tmp/emcache \
  -e GIT_CONFIG_COUNT=1 -e GIT_CONFIG_KEY_0=safe.directory -e GIT_CONFIG_VALUE_0=/work \
  local-mgba/wasm:2.0 "$@"
