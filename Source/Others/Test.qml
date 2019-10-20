import QtQuick 2.11
import QtQuick.Controls 2.4

Column{

    id: col1
    spacing: 10
    width: implicitWidth

    Component.onCompleted: {
        Datasources.fetchDatasources()
    }

}
