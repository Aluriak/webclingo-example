# Web clingo

This is a simple example of how to use clingo into browsers, client-side. </br>
The main principle is to compile clingo to WebAssembly, then wrap it into client-side js modules. </br>
Repository forked from: https://github.com/Aluriak/webclingo-example </br>
Try clingo in your browser at http://flavioeverardo.com/clingo/ </br>

## Table of Contents

- [Ready to Use](#ready-to-use)
- [Requirements](#requirements)
- [Build](#build)
- [Resources](#resources)
- [License](#license)

## Ready to Use
Import the static website shown in http://flavioeverardo.com/clingo/ directly into your server. </br>
Simply add the content from the docs directory into your public_html tree.</br>
- `clingo.wasm`: compiled Webassembly from clingo sources. To be placed next to the index.
- `js/clingo.js`: compiled from clingo sources. To be placed in js directory.
- `js/clingo-module.js`: wrapper around the clingo module, defining clingo call options based on user input and extracting the clingo output.
- `js/mode-gringo.js`: wrapper around the ASP language (in order to manage lua extensions ?).
- `js/ace.js`: [code editor](https://ace.c9.io/) allowing to edit and highlight ASP source code.
- `css/`: [potassco.org](https://potassco.org/clingo/run) stylesheets.

If you want to build yourself the latest clingo version, keep reading. </br>


## Requirements
- Python version (at least) 2.7.12. Depending on your platform you might need to interchange Python versions 2.7.X and 3.X during the build phase. For more info click [here](https://github.com/emscripten-core/emscripten/issues/6275#issuecomment-466627778)
- cmake. I recommend using Homebrew to get it. ```brew install cmake```
- For Mac users, install this Java SDK https://support.apple.com/kb/dl1572?locale=en_US
- Any other missing platform-dependency for emscripten. https://emscripten.org/docs/getting_started/downloads.html

## Build
Simply run ```./compile_web.sh```.</br>
This script:
- downloads [emscripten](http://kripken.github.io/emscripten-site/index.html) and source its env
- download the clingo repository
- compile lua (from https://github.com/kripken/emscripten/tree/incoming/tests/lua)
- compile clingo to wasm
- properly place the output files into `docs/`

## Resources
This website is copied and modified from [potassco.org/clingo/run](https://potassco.org/clingo/run).</br>
For more information about compiling clingo for javascript, check https://github.com/potassco/clingo/blob/master/INSTALL.md#compilation-to-javascript

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
