#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${ROOT_DIR}/build-emscripten"
BUILD_TYPE="${BUILD_TYPE:-Release}"
EMSCRIPTEN_PTHREADS="${EMSCRIPTEN_PTHREADS:-1}"
CLEAN="${CLEAN:-0}"

if [[ "${EMSCRIPTEN_PTHREADS}" == "1" ]]; then
  EMSCRIPTEN_PTHREADS_CMAKE="ON"
else
  EMSCRIPTEN_PTHREADS_CMAKE="OFF"
fi

if [[ "${CLEAN}" == "1" ]]; then
  rm -rf "${BUILD_DIR}"
fi

# Override if you want a different cache location.
: "${EM_CACHE:=/tmp/emscripten-cache}"
mkdir -p "${EM_CACHE}"
export EM_CACHE

emcmake cmake -S "${ROOT_DIR}" -B "${BUILD_DIR}" \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
  -DEMSCRIPTEN_PTHREADS="${EMSCRIPTEN_PTHREADS_CMAKE}"
cmake --build "${BUILD_DIR}" --clean-first -j"$(nproc)"

echo "Built:"
echo "  ${BUILD_DIR}/source/libzmusic.a"
echo "  ${BUILD_DIR}/source/libzmusiclite.a"
