# Windows 10 installation

## Visual Studio 2019 Dependencies

We will be using VS2019 community edition for this project. If you have not already downloaded it, [download it here](https://visualstudio.microsoft.com/downloads/)

Click the **Modify** button and select the **Individual Components** tab on the top. Search and select the following components

1. MSBuild
2. C++ Core Features
3. MSVC v xxxx (Choose the latest version)
4. Windows 10 SDK
5. Windows Universal CRT SDK
6. C++CMake tools for Windows

A few components can be automatically selected. But that is ok
![Visual Studio 2019 Community Components](https://i.imgur.com/s1COSjT.png?1)

#### QT Installation 5.15

Download the Online installer and select Qt SDK 5.15.0. You need not download all the components.

The following components will be enough for Grafieks

**QT 5.15.0**

1. Web Assembly
2. MSVC 2019 (32 or 64 bit depending on your system)
3. Sources (Needed to compile drivers later on)
4. Qt Web engine
5. Qt Network Authorization

![QT 5.15.0 components](https://i.imgur.com/xnLGvpN.png)

**Developer and Designer tools**

1. QT Creator 4.12.4
2. QT Creator 4.12.4 CDB Debugger Support
3. Debugging tool for Windows
4. Openssl 1.1.1d Toolkit

![Developer and Designer tools](https://i.imgur.com/DlIuFfc.png)

## Command Prompt Setup

This step is needed because later a lots of plugins and drivers will have to be manually compiled using command prompt.

### vcvarsall

Any of the native or cross compiler tools build configurations can be used on the command line by running the vcvarsall. bat command file. This command file configures the path and environment variables that enable a particular build architecture in an existing command prompt window. When used with no arguments, vcvarsall. bat configures the environment variables to use the current x86-native compiler for 32-bit Windows Desktop targets. You can add arguments to configure the environment to use any of the native or cross compiler tools.

**Compile**

**NOTE:** Paths may vary. Check your system's actual path

1. Open Command Prompt
2. `cd C:/Program Files (x)/Microsoft Visual Studio /2019/Community/VC/Auxiliary/Build`
3. Try`./vcvarsall.bat`. If it doesn't work, `./vcvars64.bat` or `./vcvars32.bat` depending on your system architeture
4. Restart Command Prompt

![vcvarsall path](https://i.imgur.com/bzkLVKn.png)

### Environment Variables for **qmake** and **nmake**

These tools are necessary to build and install the plugins and drivers. To add these to the path, open Environment variables screen

**NOTE:** Paths may vary. Check your system's actual path

1. qmake: `C:\Qt\5.15.0\msvc_2019_64\bin`
2. nmake: `C:\Program Files(x)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.xxx\bin\Hostxx\xx`
3. Restart Command Prompt if already open

## Conclusion

The above steps should be enough for Windows installation
