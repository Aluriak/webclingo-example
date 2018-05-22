#!/usr/bin/env bash

set -e
set -x

# install emscripten (copy-paste of documentation)
mkdir -p emscripten
cd emscripten
wget http://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
tar -xvf emsdk-portable.tar.gz
cd emsdk-portable

# Fetch the latest registry of available tools.
./emsdk update
# Download and install the latest SDK tools.
./emsdk install latest
# Make the "latest" SDK "active" for the current user. (writes ~/.emscripten file)
./emsdk activate latest
# Activate PATH and other environment variables in the current terminal
source ./emsdk_env.sh

cd ../..

# remove clingo if it already exists
rm -rf clingo

# now compile clingo
git clone https://github.com/potassco/clingo.git
cd clingo
git submodule update --init --recursive

mkdir -p build/web
cd build/web

# to compile ASM.js instead of WebAssembly, set -s ASM_JS=1 in CMAKE_CXX_FLAGS
emcmake cmake \
        -DCLINGO_BUILD_WEB=On \
        -DCLINGO_BUILD_WITH_PYTHON=Off \
        -DCLINGO_BUILD_WITH_LUA=On \
        -DCLINGO_BUILD_SHARED=Off \
        -DCLASP_BUILD_WITH_THREADS=Off \
        -DCMAKE_VERBOSE_MAKEFILE=On \
        -DCMAKE_BUILD_TYPE=release \
        -DCMAKE_CXX_FLAGS="-s ALLOW_MEMORY_GROWTH=1 -s ASM_JS=0" \
        -DCMAKE_EXE_LINKER_FLAGS="" \
        -DCMAKE_EXE_LINKER_FLAGS_RELEASE="" \
        ../..

cd ../..
make -C build/web web

# copy the result into the test site
cd ..  # return to root
cp ./clingo/build/web/bin/clingo.js ./test_site/js/
# cp ./clingo/build/web/bin/clingo.js.mem ./test_site # when ASM_JS=1 is given
cp ./clingo/build/web/bin/clingo.wasm ./test_site
