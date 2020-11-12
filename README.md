## Sql Driver Compilation error

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
