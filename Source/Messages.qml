pragma Singleton
import QtQuick 2.15

QtObject {


    // General Strings

    property string applicationName : qsTr("Grafieks")
    property string signInText : qsTr("Sign In")
    property string signOutText : qsTr("Sign Out")
    property string openFileText : qsTr("Open")

    property string confirmBtnTxt : qsTr("Confirm")
    property string cancelBtnTxt : qsTr("Cancel")



    // Module/Screen specific

    // Main SubComponents

    // ConfirmPublishDS
    property string cpd_header : qsTr("Confirm Datasource Overwrite")
    property string cpd_mainText : qsTr("Datasource name already exists. Confirm to publish and overwrite")

    // LoginCredentials
    property string lcr_header : qsTr("Sign in to Grafieks Reporting Server")
    property string lcr_username : qsTr("Username")
    property string lcr_password : qsTr("Password")
    property string lcr_pleaseWait : qsTr("Signing in. Please wait..")

    // LoginServer
    property string lsr_header : qsTr("Sign in to Grafieks Reporting Server")
    property string lsr_serverUrl : qsTr("Server URL")
    property string lsr_connectBtn : qsTr("Connect")
    property string lsr_hostNotFound : qsTr("Host not found")

    // Logout
    property string logt_header : qsTr("Sign in to Grafieks Reporting Server")
    property string logt_pleaseWait : qsTr("Server URL")

    // PublishDatasource
    property string pds_header: qsTr("Publish Data Source")
    property string pds_dsName: qsTr("Datasource Name")
    property string pds_description: qsTr("Description")
    property string pds_uploadImage: qsTr("Upload Image")
    property string pds_uploadImageDialogTxt: qsTr("Click to upload image (*.jpg *.jpeg *.png  only)")
    property string pds_selectImageDialogTxt: qsTr("Select an image (*.jpg *.jpeg *.png  only)")
    property string pds_selectImageNamedFiltersTxt: qsTr("Image files (*.jpg *.jpeg *.png  only)")
    property string pds_publishBtn: qsTr("Publish")
    property string pds_contactAdminTxt: qsTr("For Data Source access permission, contact Project Admin")
    property string pds_dsExists: qsTr("Datasource name already exists")
    property string pds_uploading: qsTr("Uploading Datasource")
    property string pds_uploadSuccess: qsTr("Datasource is published now. Please close this window")
    property string pds_pleaseWait: qsTr("Datasource is published now. Please close this window")

    // LeftMenuBar
    property string lmb_dataDesignerText : qsTr("Data Designer")
    property string lmb_dashboardDesignerText : qsTr("Dashboard Designer")
}
