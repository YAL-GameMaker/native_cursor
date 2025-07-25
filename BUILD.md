## Preparing to build

Needless to say, this requires basic familiarity with Visual Studio, Command Prompt/PowerShell, and Windows in general.

**Note:** Both GmxGen and GmlCppExtFuncs are already set up in the VS solution
so these steps are enough - you do not have to follow build-setup instructions
from the repositories' READMEs.

### Setting up GmxGen

1. [Install Haxe](https://haxe.org/download/) (make sure to install Neko VM!)
2. [Download the source code](https://github.com/YAL-GameMaker-Tools/GmxGen/archive/refs/heads/master.zip) 
(or [check out the git repository](https://github.com/YAL-GameMaker-Tools/GmxGen))
3. Compile the program: `haxe build-neko.hxml`
4. Create an executable: `nekotools boot bin/GmxGen.n`
5. Copy `bin/GmxGen.exe` to a folder in your PATH (e.g. to the Haxe directory )

### Setting up GmlCppExtFuncs

1. (you should still have Haxe and Neko VM installed)
2. [Download the source code](https://github.com/YAL-GameMaker-Tools/GmlCppExtFuncs/archive/refs/heads/master.zip) 
(or [check out the git repository](https://github.com/YAL-GameMaker-Tools/GmlCppExtFuncs))
3. Compile the program: `haxe build.hxml`
4. Create an executable: `nekotools boot bin/GmlCppExtFuncs.n`
5. Copy `bin/GmlCppExtFuncs.exe` to a folder in your PATH (e.g. to the Haxe directory )

## Building the Windows `.dll`

Open the `.sln` in Visual Studio (VS2019 was used as of writing this), compile for x86 - Release and then x64 - Release.

If you have correctly set up `GmxGen` and `GmlCppExtFuncs`,
the project will generate the `autogen.gml` files for GML<->C++ interop during pre-build
and will copy and [re-]link files during post-build.

## Building the Linux `.so`

Run `build_linux.sh` in `native_cursor` directory.
This will place the updated `.so` in the GM project folder.

## Building the HTML5 `.js`

Do `haxe build.hxml` in the project directory.

Updated `.js` will be placed in the GM project folder.