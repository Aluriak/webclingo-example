# Clingo in WASM

Simple example of how to use clingo into browsers, client-side.
The main principle is to compile clingo to WebAssembly, then wrap it into client-side js modules.

Try Clingo in your browser at https://aluriak.github.io/webclingo-example.

**This method is working, but probably not the best way to embed clingo in websites.**

## compile_web.sh

The `compile_web.sh` script will:

* download [emscripten](http://kripken.github.io/emscripten-site/index.html) and source its env
* download the clingo repository
* compile lua (from https://github.com/kripken/emscripten/tree/incoming/tests/lua)
* compile clingo to wasm
* properly place the output files into `docs/`

**You should probably not use this script as-is**, but instead take inspiration from it.

## docs

This is a simple website copied and pruned from [potassco.org/clingo/run](https://potassco.org/clingo/run),
which should be fully functional after the incorporation of `clingo.js` and `clingo.wasm` files
(made by `compile_web.sh` script)

To open the website,

1. `cd docs`
2. `python3 serve.py`
3. Then open http://0.0.0.0:8000/

This site is static.

* `clingo.wasm`: compiled Webassembly from clingo sources. To be placed next to the index.
* `js/clingo.js`: compiled from clingo sources. To be placed in js directory.
* `js/clingo-module.js`: wrapper around the clingo module, defining clingo call options based on user input and extracting the clingo output.
* `js/mode-gringo.js`: wrapper around the ASP language (in order to manage lua extensions ?).
* `js/ace.js`: [code editor](https://ace.c9.io/) allowing to edit and highlight ASP source code.
* `css/`: [potassco.org](https://potassco.org/clingo/run) stylesheets.
