import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    id : somepageid

    Component.onCompleted: {
        SchedulersListDS.fetchSchedulersList()
    }

    ListView{
        id:x
        model : SchedulersListModel
        delegate: Row{

            Text{
                text: modelData
            }
        }
    }
}
