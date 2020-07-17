import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    id : somepageid

    Connections{
        target: ConnectorsLoginModel

        onMysqlLoginStatus:{
            if(status.status === true){
                // Call functions
                TableSchemaModel.showSchema("SELECT users.id, profiles.email FROM users INNER JOIN profiles ON profiles.user_id = users.id");
            }
        }
    }

//    Text{
//        text: TableSchemaModel.showSchema();
//    }
}
