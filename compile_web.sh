#!/usr/bin/env bash

set -e
set -x

if [ ! -d "emsdk" ] ; then
    # install emscripten (copy-paste of documentation)
	git clone https://github.com/emscripten-core/emsdk.git
	cd emsdk
else
	cd emsdk
	git pull
fi

# Download and install the latest SDK tools.
./emsdk install latest
# Make the "latest" SDK "active" for the current user. (writes ~/.emscripten file)
./emsdk activate latest
# Activate PATH and other environment variables in the current terminal
source ./emsdk_env.sh
cd ..

# compile lua
unzip -o lua.zip -d lua
cd lua
emcmake make generic local
cd ..

# now compile clingo
if [ ! -d "clingo" ] ; then
    git clone https://github.com/potassco/clingo.git
    cd clingo
else
    cd clingo
    git pull
fi
git submodule update --init --recursive

mkdir -p build/web

emcmake cmake -H. -B"build/web" \
		-DCLINGO_BUILD_WEB=On \
		-DCLINGO_BUILD_WITH_PYTHON=Off \
		-DCLINGO_BUILD_WITH_LUA=Off \
		-DCLINGO_BUILD_SHARED=Off \
		-DCLASP_BUILD_WITH_THREADS=Off \
		-DCMAKE_VERBOSE_MAKEFILE=On \
		-DCMAKE_BUILD_TYPE=release \
		-DCMAKE_CXX_FLAGS="-std=c++11 -Wall -s DISABLE_EXCEPTION_CATCHING=0" \
		-DCMAKE_CXX_FLAGS_RELEASE="-Os -DNDEBUG" \
		-DCMAKE_EXE_LINKER_FLAGS="-s WASM=0" \
        -DCMAKE_EXE_LINKER_FLAGS_RELEASE="-s WASM=0" \

cmake --build "build/web" --target web

# copy the result into the test site
cd ..  # return to root
cp ./clingo/build/web/bin/clingo.* ./docs/js/
