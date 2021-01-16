# Creating Installers

1. Put all the logo icons (Windows -.ico, Mac - .icns) inside `config` folder

## Offline installer
```
binarycreatory.exe -c config/windows_config.xml -p packages "Offline Installer.exe"
binarycreatory -c config/mac_config.xml -p packages "Offline Installer"
```

## Online installer
```
repogen.exe -p <package_directory> <repository_directory>


binarycreatory.exe -n -c config/windows_config.xml -p packages "Online Installer.exe"
binarycreatory -n -c config/mac_config.xml -p packages "Online Installer"
```