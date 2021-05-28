import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "./MiniSubComponents"

Item {
    height: parent.height
    width: parent.width
    property alias intermidiateComponentName

    Component.onCompleted: {
        ld.sourceComponent = loaderComponent
    }


    Loader {
        id: ld
        active: false
        anchors.fill: parent
    }


    Component{
        id: loaderFilterDataList
        FilterDataList{
            componentName: intermidiateComponentName
        }
    }

    Component{
        id: loaderFilterDataMultiDropdown
        FilterDataList{
            componentName: intermidiateComponentName
        }
    }

    Component{
        id: loaderFilterDataSingleDropdown
        FilterDataList{
            componentName: intermidiateComponentName
        }
    }
}
