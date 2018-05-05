# install emscripten (copy-paste of documentation)
mkdir emscripten -p
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


# now compile clingo
# git clone git@github.com:potassco/clingo.git
git clone https://github.com/potassco/clingo.git
cd clingo -p
git submodule update --init --recursive

mkdir -p build/web
cd build/web

cmake .

# to compile to WebAssembly, add -s WASM=1 to CMAKE_CXX_FLAGS
emcmake cmake \
        -DCLINGO_BUILD_WEB=On \
        -DCLINGO_BUILD_WITH_PYTHON=Off \
        -DCLINGO_BUILD_WITH_LUA=Off \
        -DCLINGO_BUILD_SHARED=Off \
        -DCLASP_BUILD_WITH_THREADS=Off \
        -DCMAKE_VERBOSE_MAKEFILE=On \
        -DCMAKE_BUILD_TYPE=release \
        -DCMAKE_CXX_FLAGS="-std=c++11 -Wall -s DISABLE_EXCEPTION_CATCHING=0" \
        -DCMAKE_CXX_FLAGS_RELEASE="-Os -DNDEBUG" \
        -DCMAKE_EXE_LINKER_FLAGS="" \
        -DCMAKE_EXE_LINKER_FLAGS_RELEASE="" \
        ../..

cd ../..
make -C build/web web

# copy the result into the test site
cp ./clingo/build/web/bin/clingo.js ./test_site/js/
cp ./clingo/build/web/bin/clingo.js.mem ./test_site/
# cp ./clingo/build/web/bin/clingo.wasm ./test_site   # when WASM is given
