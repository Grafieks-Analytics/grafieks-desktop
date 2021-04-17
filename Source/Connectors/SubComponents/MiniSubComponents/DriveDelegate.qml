import QtQuick 2.15

import com.grafieks.singleton.constants 1.0

Rectangle{
    height:30
    width: popup.width * 0.6
    objectName: id
    color: objectName === generalObjectName ? Constants.darkThemeColor : "transparent"

    Row{
        height:30
        width: popup.width * 0.6

        Column{
            width: 20
            height: parent.height
            Row{

                Image{
                    id: fileMenuIcon
                    source: type=="folder"?"/Images/icons/folder-invoices.png" :"/Images/icons/file-icon.png"
                    width:25
                    height: 25
                }
            }
        }

        Column{
            width: parent.width / 2
            height: parent.height


            Row{
                height: parent.height
                width: parent.width
                anchors.left: parent
                anchors.leftMargin: 2

                Text {
                    text: qsTr(name)
                    padding: 5
                    leftPadding: 20
                }


                MouseArea{

                    anchors.fill:parent
                    hoverEnabled: true
                    onClicked:onFileClicked(id, name, extension, modifiedTime);
                    onDoubleClicked: onFolderDoubleClicked(id, name, extension)
                    onHoveredChanged: generalObjectName = containsMouse ? id : ""
                }
            }

        }


        Column{
            width: parent.width / 4
            height: 30

            Row{
                height: parent.height
                width: parent.width
                anchors.left: parent
                anchors.leftMargin: 2

                Text {
                    text: qsTr(extension)
                    padding: 5
                    leftPadding: 20
                }

                MouseArea{

                    anchors.fill:parent
                    hoverEnabled: true
                    onClicked:onFileClicked(id, name, extension, modifiedTime);
                    onDoubleClicked: onFolderDoubleClicked(id, name, extension)
                    onHoveredChanged: generalObjectName = containsMouse ? id : ""
                }
            }

        }

        Column{
            width: parent.width / 4
            height: 30

            Row{
                height: parent.height
                width: parent.width
                anchors.left: parent
                anchors.leftMargin: 2

                Text {
                    text: qsTr(modifiedTime)
                    padding: 5
                    leftPadding: 20
                }


                MouseArea{

                    anchors.fill:parent
                    hoverEnabled: true
                    onClicked:onFileClicked(id, name, extension, modifiedTime);
                    onDoubleClicked: onFolderDoubleClicked(id, name, extension)
                    onHoveredChanged: generalObjectName = containsMouse ? id : ""
                }
            }
        }

    }
}
