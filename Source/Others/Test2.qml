import QtQuick 2.15
import QtQuick.Controls 2.15

import "../MainSubComponents"


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

                ListView{
                    id: innerListView
                    visible: false
                    anchors.top: a.bottom
                    height: model.length * 40
                    width:innerListView1.width
                    model: [1,2,3]
                    z: 20


                    delegate:Rectangle{
                        id: innerListView1
                        height: 40
                        width: 100
                        color: "beige"
                        anchors.top: a.bottom

                        CheckBoxTpl{
                            id: checkBox1
                            checkbox_text: modelData
                            checkbox_checked: true
                            parent_dimension: 16

                        }
                    }
                }


                MouseArea{
                    anchors.fill: parent
                    onDoubleClicked: {
                        console.log("outer is clicked")

                        if(innerListView.visible === true){
                            innerListView.visible = false
                            ret1.height -= innerListView.height
                        } else{
                            innerListView.visible = true
                            ret1.height += innerListView.height
                        }


                    }
                }
            }

        }
    }


}


