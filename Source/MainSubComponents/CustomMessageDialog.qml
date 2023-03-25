/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** MainSubComponents
** MassageDialog Button Template
**
****************************************************************************/
import QtQuick
import QtQuick.Layouts 
import QtQuick.Controls
import QtQuick.Dialogs
// import Qt.labs.platform

import com.grafieks.singleton.constants

    Dialog{
        id: dialog
        title: "Dashboard Disabled"
        x:parent.parent.width/2-200
        y:parent.height/2-70
        standardButtons: Dialog.Ok
        Rectangle {
          color: "white"
          implicitWidth: 400
          width: 410
          implicitHeight: 140
          height: 140
          anchors.left:parent.left
          anchors.leftMargin:-5
          Text {
              text: "Create or Select a Datasource before creating a dashboard!"
              color: "black"
              anchors.centerIn: parent
          }
      }
    }
