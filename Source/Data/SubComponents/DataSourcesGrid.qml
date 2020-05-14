/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Sources Grid
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
//import QtQuick.Controls 1.4 as OldControls

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"


Page {

    id: datasources_grid
    width: parent.width
    height: parent.height

    GridView {
        width: datasources_grid.width
        height: datasources_grid.height
        cellWidth: width/3
        cellHeight: 300
        model: DatasourceModel;

        delegate: DataSourceGridComponent{
            id: a1
            datasource_name: datasourceName
            description: descriptions
            owner_name: firstname + " "+lastname
            mode: connectionType

            Component.onCompleted: {


                console.log(qsTr(descriptions))
            }
        }
    }




}

