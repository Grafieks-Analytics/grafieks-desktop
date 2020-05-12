/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Sources List
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import com.grafieks.singleton.constants 1.0

Page {

    ListView {
        id: listView
        anchors.fill: parent
        contentWidth: parent.width
        flickableDirection: Flickable.HorizontalAndVerticalFlick


        header: Row {
            spacing: 1
            function itemAt(index) { return repeater.itemAt(index) }
            Repeater {
                id: repeater
                model: ["Data Source Name", "Published By", "Live/Extract", "Published On", "Last Refreshed", "Edit"]
                Label {
                    id: label_headers
                    text: modelData
                    font.bold: true
                    padding: 1
                    width: 180

                    background: Rectangle {
                        color: Constants.themeColor
                        height: 30

                    }
                }
            }
        }

        model: 3
        delegate: Column {
            id: delegate
            property int row: index
            Row {
                spacing: 1
                Repeater {
                    model: 6
                    ItemDelegate {
                        property int column: index
                        text: qsTr("%1x%2").arg(delegate.row).arg(column)
                        width: listView.headerItem.itemAt(column).width
                    }
                }
            }
            Rectangle {
                color: Constants.themeColor
                width: parent.width
                height: 1
            }
        }

        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }
    }

}
