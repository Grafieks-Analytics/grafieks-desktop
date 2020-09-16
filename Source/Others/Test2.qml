import QtQuick 2.15
import QtQuick.Controls 2.15


Page{
    width: parent.width
    height: parent.height

    ListView {
        id: canvas
        clip: true
        width: parent.width
        height:parent.height

        model: [1,2,3,4,5,6,7]

        delegate: Component {
            id: c

            Rectangle{
                id: ret1
                width: 100
                height:20

                Text{
                    id: a
                    text: modelData
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle{
                    id: x
                    width: 100
                    height: 100
                    color: "red"
                    visible: false
                    anchors.top: a.bottom
                }

                MouseArea{
                    anchors.fill: parent
                    onDoubleClicked: {
                        console.log(modelData)

                        if(x.visible === true){
                            x.visible = false
                            ret1.height -= x.height
                        } else{
                            x.visible = true
                            ret1.height += x.height
                        }


                    }
                }


            }

        }
    }
}


