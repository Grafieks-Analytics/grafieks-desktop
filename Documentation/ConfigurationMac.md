# Mac Installation

#### Xcode dependencies

Qt requires Xcode command line tools as bare minimum requirement to compile the desktop applications. It is not recommended to download the complete Xcode package as it is huge (7GB download and 20+GB after installation).

Command line tools can be downloaded from [Apple Developer Downloads](https://developer.apple.com/downloads/index.action) or using the following commands

```
xcode-select --install
```

Then after downloading the online verion of Qt (ignore the Xcode dependency error), install it. For first time, run the Qt creator using the following command and select the default kit.

```
PATH="$(xcode-select -p)/usr/bin:${PATH}" ~/Qt/Qt\ Creator.app/Contents/MacOS/Qt\ Creator
```

This path is assuming that the Qt is location in ~/Qt, else change the path. Once the kit is set, you can open the creator normally

#### Qmake

Set the path for Qmake in the ~/.zshrc file.

```
export PATH=$HOME/Qt/x.x.x/clang_64/bin:$PATH
export PATH=$PATH
```

Set the path accroding to your Qt install directory.
