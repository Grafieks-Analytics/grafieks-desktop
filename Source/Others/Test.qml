import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.15

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"

Rectangle {

    Button{
        id: downloadBtn
        text: "Click to Download"
        onClicked: DriveDS.downloadFile("1swdjquWqq5tjMm9tpxMa-9C8rjCyWVWHs-ODdAXfWDw")
    }

    Button{
        id: downloadBtnBox
        anchors.top: downloadBtn.bottom
        text: "Click to Box"
        onClicked: BoxDS.downloadFile("773507838319")
    }
}
