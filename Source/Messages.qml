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
    property string msc_cpd_header : qsTr("Confirm Datasource Overwrite")
    property string msc_cpd_mainText : qsTr("Datasource name already exists. Confirm to publish and overwrite")

    // LeftMenuBar
    property string msc_lmb_dataDesignerText : qsTr("Data Designer")
    property string msc_lmb_dashboardDesignerText : qsTr("Dashboard Designer")

    // LoginCredentials
    property string msc_lcr_header : qsTr("Sign in to Grafieks Reporting Server")
    property string msc_lcr_username : qsTr("Username")
    property string msc_lcr_password : qsTr("Password")
    property string msc_lcr_pleaseWait : qsTr("Signing in. Please wait..")

    // LoginServer
    property string msc_lsr_header : qsTr("Sign in to Grafieks Reporting Server")
    property string msc_lsr_serverUrl : qsTr("Server URL")
    property string msc_lsr_connectBtn : qsTr("Connect")
    property string msc_lsr_hostNotFound : qsTr(". Host not found")

    // Logout
    property string msc_logt_header : qsTr("Sign in to Grafieks Reporting Server")
    property string msc_logt_pleaseWait : qsTr("Server URL")

    // PublishDatasource
    property string msc_pds_header: qsTr("Publish Data Source")
    property string msc_pds_dsName: qsTr("Datasource Name")
    property string msc_pds_description: qsTr("Description")
    property string msc_pds_uploadImage: qsTr("Upload Image")
    property string msc_pds_uploadImageDialogTxt: qsTr("Click to upload image (*.jpg *.jpeg *.png  only)")
    property string msc_pds_selectImageDialogTxt: qsTr("Select an image (*.jpg *.jpeg *.png  only)")
    property string msc_pds_selectImageNamedFiltersTxt: qsTr("Image files (*.jpg *.jpeg *.png  only)")
    property string msc_pds_publishBtn: qsTr("Publish")
    property string msc_pds_contactAdminTxt: qsTr("For Data Source access permission, contact Project Admin")
    property string msc_pds_dsExists: qsTr("Datasource name already exists")
    property string msc_pds_uploading: qsTr("Uploading Datasource ")
    property string msc_pds_uploadSuccess: qsTr("Datasource is published now. Please close this window")
    property string msc_pds_pleaseWait: qsTr("Datasource is published now. Please close this window")

    // PublishWorkbook
    property string msc_pwb_header: qsTr("Publish Workbook")
    property string msc_pwb_projectName: qsTr("Project Name")
    property string msc_pwb_workbookName: qsTr("Workbook Name")
    property string msc_pwb_description: qsTr("Description")
    property string msc_pwb_uploadImage: qsTr("Upload Image")
    property string msc_pwb_uploadImageDialogTxt: qsTr("Click to upload image (*.jpg *.jpeg *.png  only)")
    property string msc_pwb_selectImageDialogTxt: qsTr("Select an image (*.jpg *.jpeg *.png  only)")
    property string msc_pwb_selectImageNamedFiltersTxt: qsTr("Image files (*.jpg *.jpeg *.png  only)")
    property string msc_pwb_publishBtn: qsTr("Publish")
    property string msc_pwb_contactAdminTxt: qsTr("For Workbook access permission assignment, contact Admin or Project Admin")
    property string msc_pwb_uploading: qsTr("Uploading Workbook ")
    property string msc_pwb_uploadSuccess: qsTr("Workbook is published now. Please close this window")

    // SaveExtract
    property string msc_set_header_extract: qsTr("Save Extract File As")
    property string msc_set_header_live: qsTr("Save Live File As")

    // SaveWorkbook
    property string msc_swb_header: qsTr("Save Workbook As")

    // SearchBar
    property string msc_shb_header: qsTr("Search")

    // SessionExpired
    property string msc_sed_header : qsTr("Session Expired")
    property string msc_sed_mainText : qsTr("Your current session has expired. Sign in again")

    // UpdateApplication
    property string msc_uan_header : qsTr("Update Application")
    property string msc_uan_pleaseWait : qsTr("Logging out. Please wait..")

}
