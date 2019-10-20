/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Data Sources Grid Component
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as OldControls

import "../../MainSubComponents"


Page {

    id: datasources_grid

    Grid{
        id: ds_grid
        columns:3
        spacing: 30


        Repeater {
            model: Datasources.fetchDatasources(); // just define the number you want, can be a variable too
            delegate: DataSourceGridComponent{
                id: a1
                datasource_name: modelData.datasource_name
                description: modelData.description
                owner_name: modelData.owner_name
                mode: modelData.source_type
            }
        }



    }
}

