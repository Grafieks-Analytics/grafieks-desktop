# Grafieks Desktop

## Layout Documentation

> This document only explains the Layout architecture of the project. The layout files may not run properly if the other dependent setups (eg database, APIs, etc) are not setup properly. To view the complete workflow, you have to refer to the **Adobe XD layout files**

> This is an evolving document. As the project progresses, relevant information will be updated here.

For this project, all the Layout files are located in **GrafieksDesktop —> Resources**

Resources are

1.  **qml.qrc** contains layout files
2.  **assets.qrc** contains static assets for html files
3.  **images.qrc** contains project icons and logos

**qml.qrc** will be referred to as `Root` hereon in this document

Below, the details of individual files (main layout files only and excluding sub components) and folders are mentioned, along with order of navigation

### Folder Structure

1. **Root —> Source —> Charts**

This folder contains html files with [D3js](<[https://d3js.org/](https://d3js.org/)>) charts (code only). The data will be programatically fetched to the code here in the desktop later on.

2. **Root —> Source —> Dashboard**

This folder contains the main Dashboard designer QML files. A **SubComponents** folder within folder contains reusable layout sub components for the Dashboard.

3. **Root —> Source —> Data**

Data folder contains the main layout files for Data modelling canvas. A **SubComponents** folder within this contains reusable layout sub components for the Data modeller

4. **Root —> Source —> MainSubComponents**

This folder contains general layout sub components which are reused and called in many of the layout components irrespective of their location.

5. **Root —> Source —> Others**

All the other miscellaneous layout files will be kept here.

> In the future, we may have a few other folders which will be need based.

### Layout Files

The order in which the files below are listed/explained is also the general order in which the compiled application will flow if creating a visualization from scratch . Hence, one should try to navigate the layout files as listed below

1.  **Root —> main.qml**

This file is the entry point for Grafieks layout. It defines the overall layout of the application. The main content area is defined by a **StackLayout**.

> Please do not change the order of the components within the StackLayout unless its a must

The landing content area is defined by `CurrentIndex` property of the StackLayout. Currently, it is set to `Root —> Source —> Others —> Home.qml`

2. **Root —> Source —> Others —> Home.qml**

-   StackLayout ID: 2

Default home content for the application within the StackLayout (from the `main.qml`). This file will contain video tutorials and other information. It can also hold information about the recent opened projects and other details. To navigate further, you have to use the `Left Menu Bar` or the `Top Menu Bar`. The options in the Left Menu Bar either take you to `Data Modeller` or `Dashboard Designer` depending on the option selected.

3. **Root —> Source —> Data —> SelectConnection.qml**

-   StackLayout ID: 3

This layout will list the possible options to create/connect to a datasource.

4. **Root —> Source —> Data —> DataSources.qml**

-   StackLayout ID: 4

This layout appears only if a user selects existing datasource from the above step and will show up all the existing datasources for the current user.

5. **Root —> Source —> Data —> DataQueryModeller.qml**

-   StackLayout ID: 5

Data Query Modelling page is where a user will create relationships between various entities. This layout will show contain a ER Diagram to depict the relationships and contain tools to model or publish them

5. **Root —> Source —> Dashboard —> NewReport.qml**

-   StackLayout ID: 6

Report Designer page. This layout will have tools to select a html chart described above and bind data to the selected charts

6. **Root —> Source —> Dashboard —> NewDashboard.qml**

-   StackLayout ID: 7

Several reports combined together makes up a dashboard. This layout will show and allow a user to arrange and share the created dashboards.
