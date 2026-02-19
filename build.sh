#! /bin/sh

script=$(readlink -f "$0")
scriptdir=$(dirname "$script")

echo $scriptdir

cd $scriptdir
cd ..
# Note: no `-s MODULARIZE` to keep the final build simpler
LDFLAGS="-s WASM=1 -s EXPORTED_FUNCTIONS=\"['_main']\" -s ENVIRONMENT='web' -s EXPORTED_RUNTIME_METHODS='[\"FS\",\"callMain\"]' -s INVOKE_RUN=0 -s NO_EXIT_RUNTIME=1" CC=emcc CXX=em++ AR=emar RANLIB=emranlib make
cd dstar
LDFLAGS="-s WASM=1 -s EXPORTED_FUNCTIONS=\"['_main']\" -s ENVIRONMENT='web' -s EXPORTED_RUNTIME_METHODS='[\"FS\",\"callMain\"]' -s INVOKE_RUN=0 -s NO_EXIT_RUNTIME=1" CC=emcc CXX=em++ AR=emar RANLIB=emranlib make
# Run the last compilation command again, with a different output file, SeBa.js
em++ -I../include -I../include/star -D_SRC_='"no_source_available"' -DHAVE_CONFIG_H  -DTOOLBOX  -O  -s WASM=1 -s EXPORTED_FUNCTIONS="['_main']" -s ENVIRONMENT='web'  -s EXPORTED_RUNTIME_METHODS='["FS","callMain"]' -s INVOKE_RUN=0 -s NO_EXIT_RUNTIME=1  SeBa.C  -L. -ldstar -L../sstar -lsstar -L../node -lnode -L../node/dyn -ldyn -L../std -lstd -lm -o SeBa.js

cp SeBa.js $scriptdir/
cp SeBa.wasm $scriptdir/


