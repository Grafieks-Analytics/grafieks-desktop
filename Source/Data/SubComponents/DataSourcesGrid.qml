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

    Grid{
        id: ds_grid
        columns:3
        spacing: 30



        DataSourceGridComponent{
            id: a1
        }

        DataSourceGridComponent{
            id: a2
        }
        DataSourceGridComponent{
            id: a3
        }
        DataSourceGridComponent{
            id: a4
        }
        DataSourceGridComponent{
            id: a5
        }
        DataSourceGridComponent{
            id: a6
        }


    }


}

