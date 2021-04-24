import QtQuick 2.0
import QtQuick.Controls 2.15

import "../../SubComponents"
import "../../../MainSubComponents"

import com.grafieks.singleton.constants 1.0

Rectangle{
    id: joinPopupItem
    anchors.right:parent.right
    anchors.bottom: parent.bottom
    height:parent.height - 28
    width: 400
    z:10
//    border.color: Constants.darkThemeColor
    border.color: Constants.darkThemeColor
    visible: false


    property int counter : 0
    property int refObjId : 0
    property var leftParam : new Map()
    property var rightParam : new Map()
    property var leftDefaultIndex : new Map()
    property var rightDefaultIndex : new Map()
    property var joinType: ""
    property var tmpModel : []
    property var tmpModelArray: []
    property int availableJoins: 4

    onVisibleChanged: fetchJoinTableInfo(visible)



    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: removeListModel
    }

    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal clearModel(bool haveExistingValues)
    signal deleteModel(int counter)
    signal modelCounterChanged(int modelCounter)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    Connections{
        target: DSParamsModel

        function onJoinIdChanged(joinId){

            refObjId = joinId
            fetchJoinTableInfo(true)
            setPreviousJoin(DSParamsModel.fetchJoinTypeMap(refObjId))
        }

    }

    Connections{
        target: ConnectorsLoginModel

        function onMysqlLoginStatus(status){
            if(status.status === true){

                availableJoins = 3

                leftJoinCol.visible = true
                rightJoinCol.visible = true
                innerJoinCol.visible = true
                fullJoinCol.visible = false
            }
        }
        function onPostgresLoginStatus(status){
            if(status.status === true){
                availableJoins = 4

                leftJoinCol.visible = true
                rightJoinCol.visible = true
                innerJoinCol.visible = true
                fullJoinCol.visible = true
            }
        }
        function onMssqlLoginStatus(status){
            if(status.status === true){
                availableJoins = 4

                leftJoinCol.visible = true
                rightJoinCol.visible = true
                innerJoinCol.visible = true
                fullJoinCol.visible = true
            }
        }
        function onSqliteLoginStatus(status){
            if(status.status === true){
                availableJoins = 2

                leftJoinCol.visible = true
                rightJoinCol.visible = false
                innerJoinCol.visible = true
                fullJoinCol.visible = false
            }
        }
        function onMongoLoginStatus(status){
            if(status.status === true){
                availableJoins = 3

                leftJoinCol.visible = true
                rightJoinCol.visible = true
                innerJoinCol.visible = true
                fullJoinCol.visible = true
            }
        }
        function onSnowflakeLoginStatus(status){
            if(status.status === true){
                availableJoins = 4

                leftJoinCol.visible = true
                rightJoinCol.visible = true
                innerJoinCol.visible = true
                fullJoinCol.visible = true
            }
        }
        function onRedshiftLoginStatus(status){
            if(status.status === true){
                availableJoins = 4

                leftJoinCol.visible = true
                rightJoinCol.visible = true
                innerJoinCol.visible = true
                fullJoinCol.visible = true
            }
        }

        function onExcelLoginStatus(status){
            if(status.status === true){
                availableJoins = 4

                leftJoinCol.visible = true
                rightJoinCol.visible = true
                innerJoinCol.visible = true
                fullJoinCol.visible = true
            }
        }

        function onCsvLoginStatus(status){
            if(status.status === true){
                availableJoins = 4

                leftJoinCol.visible = true
                rightJoinCol.visible = true
                innerJoinCol.visible = true
                fullJoinCol.visible = true
            }
        }

        function onJsonLoginStatus(status){
            if(status.status === true){
                availableJoins = 4

                leftJoinCol.visible = true
                rightJoinCol.visible = true
                innerJoinCol.visible = true
                fullJoinCol.visible = true
            }
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        table1.selectedColumn.connect(joinPopupItem.slotColumnChanged)
        table2.selectedColumn.connect(joinPopupItem.slotColumnChanged)

        joinPopupItem.modelCounterChanged.connect(table1.slotCounterModelChanged)
        joinPopupItem.modelCounterChanged.connect(table2.slotCounterModelChanged)

        joinPopupItem.deleteModel.connect(table1.slotDeleteModel)
        joinPopupItem.deleteModel.connect(table2.slotDeleteModel)

        joinPopupItem.clearModel.connect(table1.slotClearModel)
        joinPopupItem.clearModel.connect(table2.slotClearModel)

    }


    function slotColumnChanged(columnName, tableName, counter){

        let joinTableInfo = DSParamsModel.fetchJoinBoxTableMap(refObjId)
        if(columnName !== "" && tableName !== "" && counter !== ""){
            if(tableName === joinTableInfo[1]){
                leftParam.set(counter, columnName)
            } else{
                rightParam.set(counter, columnName)
            }

            DSParamsModel.addToJoinMapList(DSParamsModel.joinId, counter, leftParam.get(counter), rightParam.get(counter))
        }
    }


    function setPreviousJoin(joinType){

        switch(joinType){
        case Constants.innerJoin:
            innerJoinRadioBtn.checked = true
            break;

        case Constants.fullJoin:
            fullJoinRadioBtn.checked = true
            break;

        case Constants.leftJoin:
            leftJoinRadioBtn.checked = true
            break;

        case Constants.rightJoin:
            rightJoinRadioBtn.checked = true
            break;
        }
    }


    function fetchJoinTableInfo(visible){

        if(visible === true){

            // Set join info in both the tables
            let joinTableInfo = DSParamsModel.fetchJoinBoxTableMap(refObjId)
            table1.tableName = joinTableInfo[1]
            table2.tableName = joinTableInfo[2]

            // Set tablenames in primary join table radio boxes
            leftJoinRadio.radio_text = table1.tableName
            rightJoinRadio.radio_text = table2.tableName

            // Set default primary join table
            if(DSParamsModel.fetchPrimaryJoinTable(refObjId) === ""){

                DSParamsModel.addToPrimaryJoinTable(refObjId, table2.tableName)
                rightJoinRadio.checked = true

            } else{

                if(DSParamsModel.fetchPrimaryJoinTable(refObjId) === table1.tableName){
                    leftJoinRadio.checked = true
                } else{
                    rightJoinRadio.checked = true
                }
            }


            // Reset the counter, if it appears for the first time
            // Or fetch existing counter value & joins from DSParamsModel


            var tableModel = DSParamsModel.fetchJoinMapList(refObjId)


            if(Object.keys(tableModel).length > 0){

                for (var i=0; i<Object.keys(tableModel).length; i++){

                    let key = Object.keys(tableModel)[i]

                    leftDefaultIndex.set(key, tableModel[key][0])
                    rightDefaultIndex.set(key, tableModel[key][1])
                }


                table1.existingModel = Object.keys(tableModel)
                table2.existingModel = Object.keys(tableModel)

                table1.selectedKeys = leftDefaultIndex
                table2.selectedKeys = rightDefaultIndex

                joinPopupItem.clearModel(true)

                // Restore the total keys from the existing value
                relationListView.model = []
                relationListView.model = Object.keys(tableModel)
                tmpModelArray = Object.keys(tableModel)

            } else{

                joinPopupItem.clearModel(false)
                joinPopupItem.counter = 0

                // Restore the total keys from the existing value
                tmpModelArray = [joinPopupItem.counter]
                relationListView.model = tmpModelArray

            }
        }
    }

    function addKeyToList(){

        let lastItem = tmpModelArray[tmpModelArray.length - 1]

        joinPopupItem.counter = parseInt(lastItem) + 1


        relationListView.model = tmpModelArray.push(joinPopupItem.counter)
        //        table1.modelCounter = joinPopupItem.counter
        //        table2.modelCounter = joinPopupItem.counter

        modelCounterChanged(joinPopup.counter)


    }

    function removeJoinItem(removeItem){

        let itemId = tmpModelArray.indexOf(removeItem)
        tmpModelArray.splice(itemId, 1)

        relationListView.model = tmpModelArray
        joinPopupItem.deleteModel(itemId)
        DSParamsModel.removeJoinMapList(refObjId, removeItem, false)

    }

    function closePopup(){
        joinPopup.visible = false
    }

    function onJoinChanged(joinType){

        let iconSource = ""
        switch (joinType){

        case Constants.innerJoin:
            iconSource = "/Images/icons/inner_join_32.png"
            break;

        case Constants.leftJoin:
            iconSource = "/Images/icons/left_join_32.png"
            break;

        case Constants.rightJoin:
            iconSource = "/Images/icons/right_join_32.png"
            break;

        case Constants.fullJoin:
            iconSource = "/Images/icons/outer_join_32.png"
            break;
        }

        DSParamsModel.updateJoinIconMap(DSParamsModel.joinId, iconSource)
        DSParamsModel.updateJoinTypeMap(DSParamsModel.joinId, joinType)

    }


    function onDoneClicked(){
        joinPopup.visible = false
    }

    function onDragJoinPopup(mouse){
        console.log('Write here to drag the panel')
    }

    function changePrimaryJoinTable(tableName){
        DSParamsModel.addToPrimaryJoinTable(DSParamsModel.joinId, tableName)
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    ButtonGroup{
        id: joinBtnGroup
    }



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Page Design Ends
    /***********************************************************************************************************************/


    // header starts

    Rectangle{
        id: headerPopup

        color: Constants.lightThemeColor
        border.color: Constants.darkThemeColor
        height: 30
        width: parent.width

        Text{
            id : title
            text: "Relationship"
            anchors.centerIn: parent
            anchors.left : parent.left
            anchors.leftMargin: 10

        }
        Image {
            id: closeBtn
            source: "/Images/icons/remove.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 14
            width: 14
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: closePopup()
            }
        }
    }

    // header ends

    // Select Option

    Row{
        id: selectJoin
        anchors.top: headerPopup.bottom
        height: 80
        width: parent.width

        Column{
            id: innerJoinCol
            width: parent.width/availableJoins
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: 5

            CustomRadioDelegate{
                id: innerJoinRadioBtn
                checked: true
                width: 90
                height: 90

                ButtonGroup.group:joinBtnGroup
                onClicked: onJoinChanged(Constants.innerJoin)

                contentItem: Image {
                    id: innerIcon
                    source: "/Images/icons/Inner.png"
                    width: parent.width
                    height: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 22
                    verticalAlignment: Image.AlignVCenter
                }

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Inner Join")
            }
        }


        Column{
            id: leftJoinCol
            width: parent.width/availableJoins
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: 5

            CustomRadioDelegate{
                id: leftJoinRadioBtn
                width: 90
                height: 90

                ButtonGroup.group:joinBtnGroup
                onClicked: onJoinChanged(Constants.leftJoin)


                contentItem: Image {
                    id: leftIcon
                    source: "/Images/icons/Left.png"
                    width: parent.width
                    height: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 22
                    verticalAlignment: Image.AlignVCenter
                }

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Left Join")
            }

        }
        Column{
            id: rightJoinCol
            width: parent.width/availableJoins
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: 5

            CustomRadioDelegate{
                id: rightJoinRadioBtn
                width: 90
                height: 90

                ButtonGroup.group:joinBtnGroup
                onClicked: onJoinChanged(Constants.rightJoin)

                contentItem: Image {
                    id: rightIcon
                    source: "/Images/icons/Right.png"
                    width: parent.width
                    height: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 22
                    verticalAlignment: Image.AlignVCenter
                }

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Right Join")
            }

        }
        Column{
            id: fullJoinCol
            width: parent.width/availableJoins
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: 5

            CustomRadioDelegate{
                id: fullJoinRadioBtn
                width: 90
                height: 90

                ButtonGroup.group:joinBtnGroup
                onClicked: onJoinChanged(Constants.fullJoin)

                contentItem: Image {
                    id: outerIcon
                    source: "/Images/icons/Full Outer.png"
                    width: parent.width
                    height: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 22
                    verticalAlignment: Image.AlignVCenter
                }

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Full Outer Join")
            }

        }
    }

    // Select Option Ends

    // Primary Table Starts

    Column{
        id: primaryTableRow
        anchors.top: selectJoin.bottom
        width: parent.width

        anchors.left: parent.left
        anchors.leftMargin: 12

        Text{
            text: "Select Primary Table"
        }

        Row{
            // For Table 1
            // Text set by function
            // Default Checked set from the function
            CustomRadioButton{

                id: leftJoinRadio
                parent_dimension: 16
                ButtonGroup.group: tableLeftRightJoinGrp
                onClicked: changePrimaryJoinTable(leftJoinRadio.radio_text)

            }

            // For Table 2
            // Text set by function
            // Default Checked set from the function
            CustomRadioButton{
                id: rightJoinRadio
                checked: true
                parent_dimension: 16
                ButtonGroup.group: tableLeftRightJoinGrp
                onClicked: changePrimaryJoinTable(rightJoinRadio.radio_text)
            }
        }


    }

    // Primary Table Ends

    // Add Key Starts

    Row{
        id: addKeyRow
        height: 30
        anchors.top: primaryTableRow.bottom
        anchors.left: primaryTableRow.left

        CustomButton{

            id: addKey
            textValue: "Add key"
            onClicked: addKeyToList()

        }


    }


    // Add key Ends



    Column{
        id: tables
        anchors.top: addKeyRow.bottom

        width: parent.width
        height: parent.height - selectJoin.height - headerPopup.height - addKeyRow.height - doneBtn.height - primaryTableRow.height



        Row{

            id: tableContent
            height: parent.height
            width: parent.width
            Rectangle{
             height: parent.height
             width: 1
             color: "transparent"
            }

            Column{

                height: parent.height
                width: parent.width/2-10


                JoinDisplayTable{
                    id: table1
                }


            }

            Column{
                height: parent.height
                width: 40

                ListView{

                    id: relationListView
                    height: parent.height
                    width: parent.width
                    anchors.top: parent.top
                    anchors.topMargin: 40
                    anchors.left: parent.left
                    model:removeListModel



                    delegate:  Row{

                        height: 30
                        anchors.left: parent.left
                        anchors.leftMargin: 3

                        Text {
                            id: equal
                            text: qsTr("=")
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: Constants.fontCategoryHeader
                        }

                        Image {
                            anchors.left: equal.right
                            anchors.leftMargin: 5

                            anchors.verticalCenter: parent.verticalCenter

                            source: "/Images/icons/remove.png"
                            height: 12
                            width: 12

                            MouseArea{
                                anchors.fill: parent
                                onClicked: removeJoinItem(modelData)
                            }
                        }

                    }

                }
            }


            Column{

                height: parent.height
                width: parent.width/2 - 30

                JoinDisplayTable{
                    id: table2
                }
            }
        }
    }

    Row{
        id:doneBtn

        anchors.top: tables.bottom
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 10

        CustomButton{
            height: 80
            width: parent.width

            anchors.right: parent.right

            textValue: "Done"
            onClicked: onDoneClicked()

        }
    }

}
