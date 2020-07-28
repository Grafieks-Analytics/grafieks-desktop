# Windows 10 installation

#### Visual Studio 2019 Dependencies

We will be using VS2019 community edition for this project. If you have not already downloaded it, [download it here](https://visualstudio.microsoft.com/downloads/)

Click the **Modify** button and select the **Individual Components** tab on the top. Search and select the following components

1. MSBuild
2. C++ Core Features
3. MSVC v xxxx (Choose the latest version)
4. Windows 10 SDK
5. Windows Universal CRT SDK

A few components can be automatically selected. But that is ok
![Visual Studio 2019 Community Components](https://imgur.com/PtbVqPD)

#### QT Installation 5.15

Download the Online installer and select Qt SDK 5.15.0. You need not download all the components.

The following components will be enough for Grafieks

**QT 5.15.0**

1. Web Assembly
2. MSVC 2019 (32 or 64 bit depending on your system)
3. Sources (Needed to compile drivers later on)
4. Qt Web engine
5. Qt Network Authorization

**Developer and Designer tools**

1. QT Creator 4.12.4
2. QT Creator 4.12.4 CDB Debugger Support
3. Debugging tool for Windows
4. Openssl 1.1.1d Toolkit

The above steps should be enough for Windows installation
![QT 5.15.0 components](https://imgur.com/a/wl2EHe6)
![Developer and Designer tools](https://imgur.com/a/nLxX0n6)
