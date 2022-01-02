## Generate `.lib` file from `.dll`

Qt needs to provided a path to the `lib` file in the `.pro`. If the lib file is missing from the third party, the lib file can be generated using the following commands


```
1) dumpbin /exports THIRDPARTY.dll > THIRDPARTY.def
3) lib /def:THIRDPARTY.def /out:THIRDPARTY.lib /machine:x64
```

Clear all the data in `def` file and only keep generated function names. The `.def` file should only contain the function names in the format of

```
EXPORTS
function_name_1
function_name_2
...
```

`cd $QT_PATH/5.x/Src/qtbase/src/plugins/sqldrivers`

Delete the files `config.cache` and `config.log` and try to recompile according to the documentation. If compilation fails or there is an issue, delete config.cache as otherwise qmake will not search for the available drivers again

## Share Windows build

```
windeployqt --qmldir <path-to-app-qml-files> <path-to-app-binary>
```

> Remember to add **windeployqt** to Windows path

## To overcome Slow QT download issue (obsolete app)

Download the binary from [https://github.com/JKSH/QtSdkRepoChooser/releases](https://github.com/JKSH/QtSdkRepoChooser/releases) and select the fastest mirror. Use the mirror in the Maintenance tool or Qt Online installer settings `user defined repository`

# Application Dependencies

-   Openssl - For calling HTTPS requests. On Linux/Mac, directly install from package repo manager. For Windows use the [link](https://slproweb.com/products/Win32OpenSSL.html)

## How to get Charts: 
### When you clone for first time
``` 
git clone --recurse-submodules https://github.com/Grafieks-Analytics/grafieks-desktop/
```

### Already cloned or missed cloning with -recurse-submodule flag
```
git submodule update --init
```
These commands will add a folder "Charts" at `Sources/` folder