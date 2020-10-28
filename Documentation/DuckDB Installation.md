# DuckDB Installation

Grafieks utilizes [DuckDB](https://duckdb.org/) to handle InMemory operations for data extracts.

## Project Configuration

Download shared library binaries and header files for all the required platforms from https://duckdb.org/docs/installation/. In Grafieks project, all the third party `shared libraries` are located inside `<project root>/libraries` folder and add the following lines in the `.pro` file

```
win32:CONFIG(release, debug|release): LIBS += -L$$PWD/Libraries/release/ -lduckdb
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/Libraries/debug/ -lduckdb
else:macx: LIBS += -L$$PWD/Libraries/ -lduckdb

INCLUDEPATH += $$PWD/Libraries
DEPENDPATH += $$PWD/Libraries
```

Alternatively, you can follow this tutorial https://doc.qt.io/qtcreator/creator-project-qmake-libraries.html to add using QT's GUI

## Importing Headers

`duckdb.hpp` file is required to compile duckdb. In Grafieks, the file is located in `<project root>/code`
