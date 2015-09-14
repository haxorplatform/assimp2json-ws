assimp2json-ws
========

Assimp2Json Node.js Webservice

## CMake
This webservice uses the `Assimp2Json` tool to convert the supported models to `json`.  
For more information, visit [https://github.com/acgessler/assimp2json]  

### Build  
The build system for `assimp2json` is CMake. To build, use either the CMake GUI or the CMake command line utility. __Note__: make sure you pulled the `assimp2json` submodule, i.e. with `git submodule init && git submodule update`

## Haxe
This tool uses the Haxe language [http://www.haxe.org] and the NodeJS SDK to run. 

### Install
* `wget http://www.openfl.org/builds/haxe/haxe-3.2.0-linux-installer.tar.gz`
* `tar -vzxf haxe-3.2.0-linux-installer.tar.gz`
* `./install-haxe.sh`
* `haxelib selfupdate`
* `haxelib git hxnodejs https://github.com/HaxeFoundation/hxnodejs`
* `haxelib git nodews https://github.com/haxorplatform/nodews.git`

### Build  
* `./tools/unix/build.sh`

### Run
This command will start the nodejs daemon using the `forever` tool.  
* `./tools/unix/run.sh`
