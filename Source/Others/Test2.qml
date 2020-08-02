import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page {

    id : somepageid


    ListView{
        id: x
        model: FilterListModel
        delegate: Row{
            Text{
                text: section + "-"+category+"-"+subCategory+"-"+tableName+"-"+columnName+"-"+relation+"-"+value+"-"+includeNull+"-"+exclude
                // section + "" + subCategory
            }
        }
    }
}
