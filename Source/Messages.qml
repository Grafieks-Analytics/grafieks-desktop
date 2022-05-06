pragma Singleton
import QtQuick 2.15

QtObject {

    /****************************************************/
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    // GENERAL STRINGS
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    /****************************************************/

    property string applicationName : qsTr("Grafieks")
    property string signInText : qsTr("Sign In")
    property string signOutText : qsTr("Sign Out")
    property string emptyString : qsTr("")
    property string search : qsTr("Search")
    property string warningTitle : qsTr("Warning")

    property string publishBtnTxt: qsTr("Publish")
    property string confirmBtnTxt : qsTr("Confirm")
    property string updateBtnTxt : qsTr("Update")
    property string addBtnTxt : qsTr("Add")
    property string applyBtnTxt : qsTr("Apply")
    property string resetBtnTxt : qsTr("Reset")
    property string cancelBtnTxt : qsTr("Cancel")
    property string closeBtnTxt : qsTr("Close")

    property string da_sub_dc_edit : qsTr("Edit")
    property string da_sub_dc_delete : qsTr("Delete")

    property string openFileText : qsTr("Open")
    property string selectFile : qsTr("Select a file")
    property string selectImage : qsTr("Select an image")
    property string noSelectedFile : qsTr("No file selected")

    property string filterCategorical : qsTr("Categorical")
    property string filterDate : qsTr("Date")
    property string filterNumerical : qsTr("Numerical")

    property string filterList : qsTr("List")
    property string filterWildcard : qsTr("Wildcard")
    property string filterCalendar : qsTr("Calendar")
    property string filterTimeframe : qsTr("Timeframe")

    property string filterMultiSelect : qsTr("Multi Select")
    property string filterSingleSelect : qsTr("Single Select")
    property string filterAll : qsTr("All")
    property string filterIncludeNull : qsTr("Include Null")
    property string filterExclude : qsTr("Exclude")
    property string filterInclude : qsTr("Include")

    property string mo_mini_cfwc_header : qsTr("Select Wildcard")
    property string mo_mini_cfwc_addWildcard : qsTr("Add Wildcard")
    property string mo_mini_cfwc_enterValue : qsTr("Enter Value")

    property string filterDateRange: qsTr("Date Range")
    property string filterFrom: qsTr("From")
    property string filterTo: qsTr("To")
    property string filterBy: qsTr("By")
    property string filterDefaultDateFormat : qsTr("dd/mm/yyyy")

    property string filterAddCharacter : qsTr("Add Character")
    property string filterConditionText : qsTr("Condition")

    /****************************************************/
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    // Module/Screen specific
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    /****************************************************/


    /****************************************************/
    // Main SubComponents
    /****************************************************/

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
    property string msc_pwb_contactAdminTxt: qsTr("For Workbook access permission assignment, contact Admin or Project Admin")
    property string msc_pwb_uploading: qsTr("Uploading Workbook ")
    property string msc_pwb_uploadSuccess: qsTr("Workbook is published now. Please close this window")

    // SaveExtract
    property string msc_set_header_extract: qsTr("Save Extract File As")
    property string msc_set_header_live: qsTr("Save Live File As")

    // SaveWorkbook
    property string msc_swb_header: qsTr("Save Workbook As")

    // SessionExpired
    property string msc_sed_header : qsTr("Session Expired")
    property string msc_sed_mainText : qsTr("Your current session has expired. Sign in again")

    // UpdateApplication
    property string msc_uan_header : qsTr("Update Application")
    property string msc_uan_pleaseWait : qsTr("Logging out. Please wait..")



    /****************************************************/
    // Others
    /****************************************************/

    // About
    property string oth_abt_header : qsTr("Desktop")
    property string oth_abt_version : qsTr("Free Edition 1.0.3 (x64)")
    property string oth_abt_learn : qsTr("Grafieks is a Self-Service Analytics Platform.<a href=\"https://grafieks.com/\">Learn More</a> ")
    property string oth_abt_license : qsTr("End User License Agreement")
    property string oth_abt_copyright : qsTr("Copyright © 2022 Grafieks Analytics Ltd. All rights reserved.")

    // License
    property string oth_lic_mainText : qsTr(`<p>End User License Agreement (&ldquo;EULA&rdquo;)</p> <p>The terms and conditions of this End User License Agreement (&ldquo;EULA&rdquo;) apply to licensee&rsquo;s (&ldquo;You&rdquo; or &ldquo;Your&rdquo;) use, access, copy and download, and the license and delivery of Software by Grafieks Analytics Ltd (&ldquo;Company,&rdquo; &ldquo;we,&rdquo; &ldquo;us&rdquo; or &ldquo;our&rdquo;).</p> <p>PLEASE READ THIS AGREEMENT CAREFULLY. IT CONTAINS IMPORTANT TERMS THAT AFFECT YOU AND YOUR USE OF THE SOFTWARE. BY INSTALLING, COPYING OR USING THE SOFTWARE, YOU AGREE TO BE BOUND BY THE TERMS OF THIS AGREEMENT. IF YOU DO NOT AGREE TO THESE TERMS, DO NOT INSTALL, COPY, OR USE THE SOFTWARE. IF YOU ARE ACCESSING OR USING THE SOFTWARE ON BEHALF OF ANY ENTITY OR OTHERWISE IN PERFORMANCE OF SERVICES FOR ANY ENTITY, YOU REPRESENT AND WARRANT THAT YOU ARE AUTHORIZED TO ACCEPT THIS AGREEMENT ON SUCH ENTITY'S BEHALF, THAT ACCEPTANCE OF THIS AGREEMENT AND USE OF THIS SOFTWARE WILL NOT VIOLATE ANY AGREEMENT YOU HAVE WITH SUCH ENTITY, AND THAT SUCH ENTITY AGREES TO INDEMNIFY YOU AND COMPANY FOR VIOLATIONS OF THIS AGREEMENT.</p> <p>&nbsp;</p> <ol> <p>1. Software License</p> </ol> <p>Subject to the terms and conditions of this Agreement and during the term of this Agreement, the Company hereby grants you a non-exclusive, non-sublicensable, non-transferable license to [install and use] [stream, access, download and use] one copy of the Software in object code form only on a single [personal computing device] [network server] solely to use the services made available by Company (the &ldquo;<strong><em>Company Services</em></strong>&rdquo;) for your own personal or internal business use (the &ldquo;<strong><em>Permitted Purpose</em></strong>&rdquo;). Any Software that updates, supplements or replaces the original Software is governed by this Agreement unless separate license terms accompany such update, supplement or replacement, in which case such separate terms will govern in the event of a conflict with this Agreement or as otherwise provided in such separate terms.</p> <p>&nbsp;</p> <ol start="2"> <p>2. License Limitations</p> </ol> <p>Section 1 states the entirety of your rights with respect to the Software, and we reserve all rights not expressly granted to you in this Agreement. Without limiting the foregoing, you will not do, or authorize or permit any third party to do, any of the following: (a) distribute, sub-license, sell, assign, or otherwise transfer or make available the Software; (b) use the Software for any purpose other than the Permitted Purpose; (c) reverse engineer, decompile, disassemble or otherwise attempt to discover or re-create the source code for the Software; (d) modify, adapt, alter, improve or create any derivative works of the Software; (e) connect the Software with any other online services or use the Software in conjunction with other software or services not provided by or permitted by Company [in connection with the Company Services]; (f) remove, circumvent or create or use any workaround to any copy protection or security feature in or relating to the Software; or (g) remove, alter or obscure any copyright, trademark or other proprietary rights notice on or in the Software.</p> <p>&nbsp;</p> <ol start="3"> <p>3. Ownership and Confidentiality</p> </ol> <p>The Software is licensed, not sold, to you. We or our licensors own all right, title and interest in and to the Software, including all copyright, patent and other intellectual property or other proprietary rights in the Software. No title to or ownership of the Software or any associated intellectual property or proprietary rights are transferred to you by this Agreement. You also acknowledge that when you download, install or use the Software, we have the right to automatically collect information on your use of the Software. We may also require that you provide information regarding yourself in order to download, install or use the Software or certain features. All information collected from you in connection with the Software may be used by us in compliance with our Privacy Policy. By your using, installing, downloading or providing information, you consent to the Privacy Policy and our use of your information in compliance thereof. [YOU ARE EXPRESSLY PROHIBITED FROM DISCLOSING THE SOFTWARE TO ANY PERSON OR ENTITY OR PERMITTING ANY PERSON OR ENTITY ACCESS TO OR USE OF THE SOFTWARE OTHER THAN IN ACCORDANCE WITH THIS AGREEMENT.</p> <p>&nbsp;</p> <ol start="4"> <p>4. Disclaimers</p> </ol> <p>THE SOFTWARE IS PROVIDED TO YOU ON AN &ldquo;AS IS&rdquo; BASIS AND WITH ALL FAULTS AND DEFECTS WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. COMPANY AND ITS LICENSORS DISCLAIM ALL OTHER WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. COMPANY DOES NOT REPRESENT OR WARRANT THAT THE SOFTWARE IS FREE OF BUGS, ERRORS, VIRUSES OR OTHER DEFECTS OR THAT THE SOFTWARE WILL TRANSMIT DATA IN A SECURE MANNER. COMPANY AND ITS LICENSORS SHALL HAVE NO LIABILITY OF ANY KIND FOR THE USE OF OR INABILITY TO USE THE SOFTWARE. COMPANY AND ITS LICENSORS PROVIDES ANY WARRANTY OR REPRESENTATIONS OF ANY KIND THAT THE SOFTWARE WILL OPERATE WITHOUT INTERRUPTION, MEET ANY PERFORMANCE OR RELIABILITY STANDARDS, ACHIEVE ANY KIND OF INTENDED PURPOSE, BE COMPATIBLE WITH ANY OTHER SOFTWARE OR SYSTEM, OR HAVE ERRORS THAT CAN BE CORRECTED.</p> <p>Some jurisdictions do not allow the exclusion of implied warranties or limitations on how long an implied warranty may last. To the extent that those laws apply to this Agreement, the exclusions and limitations set forth above may not apply.</p> <p>&nbsp;</p> <ol start="5"> <p>5. Indemnification</p> </ol> <p>You will defend, indemnify and hold harmless Company and its affiliates, independent contractors, service providers, suppliers, partners, resellers, distributors and consultants, and their respective directors, officers, employees and agents (collectively, the &ldquo;<strong><em>Company Parties</em></strong>&rdquo;) from and against any third party claims, suits or actions and any resulting damages, costs, liabilities and expenses (including, but not limited to, reasonable attorneys' fees) arising out of or related to: (a) your use of, or inability to use, the Software; or (b) your violation of any terms of this Agreement.</p> <p>&nbsp;</p> <ol start="6"> <p>6. Limitation of Liability</p> </ol> <p>IN NO EVENT SHALL ANY OF THE COMPANY PARTIES BE LIABLE FOR ANY DIRECT, SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY OTHER DAMAGES OF ANY KIND, INCLUDING BUT NOT LIMITED TO LOSS OF USE, LOSS OF PROFITS OR LOSS OF DATA, WHETHER IN AN ACTION IN CONTRACT, TORT (INCLUDING BUT NOT LIMITED TO NEGLIGENCE) OR OTHERWISE, ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF A COMPANY PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. IN NO EVENT SHALL THE AGGREGATE LIABILITY OF THE COMPANY PARTIES, WHETHER IN CONTRACT, WARRANTY, TORT (INCLUDING NEGLIGENCE, WHETHER ACTIVE, PASSIVE OR IMPUTED), PRODUCT LIABILITY, STRICT LIABILITY OR OTHER THEORY, ARISING OUT OF OR RELATING TO THIS AGREEMENT OR THE SOFTWARE EXCEED THE COMPENSATION YOU HAVE PAID, IF ANY, TO COMPANY FOR THE SOFTWARE.</p> <p>Some jurisdictions do not allow the exclusion or limitation of certain damages. To the extent that those laws apply to this Agreement, the exclusions and limitations set forth above may not apply.</p> <p>&nbsp;</p> <ol start="7"> <p>7. Termination</p> </ol> <p>Company may terminate this Agreement at any time, with or without cause, immediately upon notice to you. [Company may also discontinue the Company Services with which the Software is used, in which case this Agreement will terminate automatically without notice to you]. You may terminate this Agreement [by cancelling your Company Services account opened in connection with your use of the Software and] deleting all copies of the Software in your possession or control. In the event of the termination of this Agreement for any reason: (a) the license granted to you in this Agreement will terminate; (b) you must immediately cease all use of the Software and destroy or erase all copies of the Software in your possession or control; and (c) Sections 3 (Ownership), 4 (Disclaimers), 5 (Indemnification), 6 (Limitation of Liability), 7 (Termination), 8 (Governing Law; Jurisdiction) and 9 (General) will survive any such termination. [Further, in the event the agreement governing your use of the Company Services with which the Software is used is terminated for any reason, this Agreement will terminate automatically without notice to you].</p> <p>&nbsp;</p> <ol start="8"> <p>8. Evaluation and Feedback</p> </ol> <p>You will at your own risk and expense use reasonable efforts to provide Company with reasonable information and feedback (including, without limitation, questions, comments, suggestions, or the like) regarding the performance, features, functionality and your overall experience using the Software (&ldquo;Feedback&rdquo;) and will make yourself available to Company on a reasonable basis for this purpose. You will not provide any such Feedback to any third party without Company&rsquo;s prior written consent in each instance. You hereby grant to Company an exclusive, royalty-free, irrevocable, perpetual worldwide right and license to reproduce, use, disclose, exhibit, display, transform, create derivative works and distribute any such Feedback without limitation. Further, we will be free to use any ideas, concepts, know-how or techniques contained in such Feedback for any purpose whatsoever, including, without limitation, developing, making, marketing, distributing and selling products and services incorporating such Feedback. We will have no obligation to consider, use, return or preserve any Feedback you provide to us. Any Feedback you provide to us may or may not be treated confidentially by us, and we will have no obligation or liability to you for the use or disclosure of any Feedback. You should not expect any compensation of any kind from us with respect to your Feedback.</p> <p>&nbsp;</p> <ol start="9"> <p>9. Governing Law; Jurisdiction</p> </ol> <p>This agreement and any dispute or claim arising out of or in connection with it or its subject matter or formation (including non-contractual disputes or claims) shall be governed by and construed in accordance with the laws of Ireland. Each party irrevocably agrees that the courts of Ireland shall have exclusive jurisdiction to settle any dispute or claim arising out of or in connection with this agreement or its subject matter or formation (including non-contractual disputes or claims).</p> <p>&nbsp;</p> <ol start="10"> <p>10. General</p> </ol> <p>(a) Severability. If any provision of this Agreement is held by a court of competent jurisdiction to be invalid, illegal, or unenforceable, the remainder of this Agreement will remain in full force and effect, and the remaining provisions will be amended to achieve as closely as possible the effect of the original term and all other provisions of this Agreement will continue in full force.</p> <p>&nbsp;</p> <p>(d) Assignment. You may not assign or otherwise transfer this Agreement, or assign, sublicense or otherwise transfer any of your rights under this Agreement without the prior written consent of Company, and any attempted assignment without such consent will be void.</p> <p>&nbsp;</p> <p>(e) Attorney's Fees. In any action or proceeding to enforce rights under this Agreement, the prevailing party will be entitled to recover costs and reasonable attorney's fees.</p> <p>&nbsp;</p> <p>(f) Entire Agreement. This Agreement, our Privacy Policy sets forth our entire agreement with respect to the Software and supersedes all prior and contemporaneous understandings and agreements with respect to the Software whether written or oral.</p> <p>&nbsp;</p> <p>&nbsp;</p>`)



    /****************************************************/
    // Datasources
    /****************************************************/

    // Datasources
    property string ds_ds_create : qsTr("Create Datasource")
    property string ds_ds_grid : qsTr("Grid View")
    property string ds_ds_list : qsTr("List View")
    property string ds_ds_server : qsTr("Server Address")
    property string ds_ds_name : qsTr("Datasource name")
    property string ds_ds_notSelected : qsTr("Not selected")


    // Subcomponents/ConnectionError
    property string ds_sub_cer_header : qsTr("Permission Denied")
    property string ds_sub_cer_mainText : qsTr("You do not have permission to connect to this Datasource")

    // Subcomponents/DataSourcesGrid
    property string ds_sub_dsg_description : qsTr("Description")
    property string ds_sub_dsg_publishedBy : qsTr("Published by")
    property string ds_sub_dsg_liveExtract : qsTr("Live/Extract")

    // Subcomponents/DataSourcesList
    property var ds_sub_dsl_headers : [qsTr("Data Source Name"), qsTr("Published By"), qsTr("Live/Extract"), qsTr("Published On"), qsTr("Last Refreshed")]



    /****************************************************/
    // Connectors
    /****************************************************/

    // SelectConnection
    property string cn_sel_headers : qsTr("Data Connectors")
    property string cn_sel_selectFile : qsTr("Select a file")
    property string cn_sel_processFile : qsTr("Processing file")
    property string cn_sel_pleaseWait : qsTr("Please wait. We are processing your input file. Hit Ok to continue")


    // SubComponents

    // SubComponents/Common
    property string cn_sub_common_driver : qsTr("Driver")
    property string cn_sub_common_server : qsTr("Server")
    property string cn_sub_common_port : qsTr("Port")
    property string cn_sub_common_db : qsTr("Database")
    property string cn_sub_common_username : qsTr("Username")
    property string cn_sub_common_password : qsTr("Password")
    property string cn_sub_common_allow : qsTr("Allow")
    property string cn_sub_common_afterAuthMsg : qsTr("Once you authorize this connection you will be returned to this page.")

    // SubComponents/AccessConnection
    property string cn_sub_access_header : qsTr("Select a Microsoft Access file")
    property string cn_sub_access_subHeader : qsTr("Microsoft Access Connection")
    property string cn_sub_access_selFile : qsTr("Select a Microsoft Access file")
    property string cn_sub_access_namedFilter : qsTr("Access files (*.mdb *.accdb )")
    property string cn_sub_access_missingDriver : qsTr("Microsoft Excel Driver missing")
    property string cn_sub_access_driverDownload : qsTr("You don't have Microsoft Access driver. Download Microsoft Access to enable this")


    // SubComponents/BoxConnection
    property string cn_sub_box_header : qsTr("Connect to Box")
    property string cn_sub_box_allowReqMsg : qsTr(" wants to access to your Box")
    property string cn_sub_box_allowAuthMsg : qsTr("Click the allow button above to open the Box authorization page on a separate window.")


    // SubComponents/CSVConnection
    property string cn_sub_csv_header : qsTr("Select a CSV file")
    property string cn_sub_csv_subHeader : qsTr("CSV Connection")
    property string cn_sub_csv_csvName : qsTr("File Name")
    property string cn_sub_csv_separator : qsTr("Separator")
    property string cn_sub_csv_importErr : qsTr("CSV import Error")
    property string cn_sub_csv_namedFilter : qsTr("CSV files (*.csv)")


    // SubComponents/DriveConnection
    property string cn_sub_drive_header : qsTr("Connect to Google Drive")
    property string cn_sub_drive_allowReqMsg : qsTr(" wants to access to your Google Drive")
    property string cn_sub_drive_allowAuthMsg : qsTr("Click the allow button above to open the Google Drive authorization page on a separate window.")


    // SubComponents/DropboxConnection
    property string cn_sub_dropbox_header : qsTr("Connect to Dropbox")
    property string cn_sub_dropbox_allowReqMsg : qsTr(" wants to access to your Dropbox")
    property string cn_sub_dropbox_allowAuthMsg : qsTr("Click the allow button above to open the Dropbox authorization page on a separate window.")


    // SubComponents/ExcelOdbcConnection
    // SubComponents/ExcelConnection
    property string cn_sub_excodbc_header : qsTr("Select an Excel file")
    property string cn_sub_excodbc_subHeader : qsTr("Excel Connection")
    property string cn_sub_excodbc_importErr : qsTr("Excel import Error")
    property string cn_sub_excodbc_namedFilter : qsTr("Excel files (*.xls *.xlsx)")
    property string cn_sub_excodbc_missingDriver : qsTr("Microsoft Excel Driver missing")
    property string cn_sub_excodbc_driverDownload : qsTr("You don't have Excel driver. Download Microsoft Excel to enable this")


    // SubComponents/GithubConnection
    property string cn_sub_github_header : qsTr("Connect to Github")
    property string cn_sub_github_allowReqMsg : qsTr(" wants to access to your Github account")
    property string cn_sub_github_allowAuthMsg : qsTr("Click the allow button above to open the Github authorization page on a separate window.")

    // SubComponents/HiveConnection
    property string cn_sub_hive_header : qsTr("Sign In to Apache Hive Server")
    property string cn_sub_hive_subHeader : qsTr("Apache Hive Connection")
    property string cn_sub_hive_missingDriver : qsTr("Apache Hive ODBC Driver missing")
    property string cn_sub_hive_driverDownload : qsTr("You don't have Apache Hive ODBC driver.Click Ok to Download")

    // SubComponents/ImpalaConnection
    property string cn_sub_impala_header : qsTr("Sign In to Impala Server")
    property string cn_sub_impala_subHeader : qsTr("Impala Connection")
    property string cn_sub_impala_missingDriver : qsTr("Impala ODBC Driver missing")
    property string cn_sub_impala_driverDownload : qsTr("You don't have Impala ODBC driver.Click Ok to Download")

    // SubComponents/JsonConnection
    property string cn_sub_json_header : qsTr("Select a Json file")
    property string cn_sub_json_subHeader : qsTr("Json Connection")
    property string cn_sub_json_importErr : qsTr("Json import Error")
    property string cn_sub_json_namedFilter : qsTr("Json files (*.json)")

    // SubComponents/MongoConnection
    property string cn_sub_mongodb_header : qsTr("Sign In to MongoDb Server")
    property string cn_sub_mongodb_subHeader : qsTr("MongoDb Connection")
    property string cn_sub_mongodb_missingDriver : qsTr("MongoDb ODBC Driver missing")
    property string cn_sub_mongodb_driverDownload : qsTr("You don't have MongoDb ODBC driver.Click Ok to Download")

    // SubComponents/MSSqlConnection
    property string cn_sub_mssql_header : qsTr("Sign In to Microsoft SQL Server")
    property string cn_sub_mssql_subHeader : qsTr("Microsoft SQL Connection")
    property string cn_sub_mssql_missingDriver : qsTr("Microsoft SQL ODBC Driver missing")
    property string cn_sub_mssql_driverDownload : qsTr("You don't have Microsoft SQL ODBC driver.Click Ok to Download")

    // SubComponents/MySqlConnection
    property string cn_sub_mysql_header : qsTr("Sign In to MySql Server")
    property string cn_sub_mysql_subHeader : qsTr("MySql Connection")
    property string cn_sub_mysql_missingDriver : qsTr("MySql ODBC Driver missing")
    property string cn_sub_mysql_driverDownload : qsTr("You don't have MySql ODBC driver.Click Ok to Download")

    // SubComponents/OracleConnection
    property string cn_sub_oracle_header : qsTr("Sign In to Oracle Server")
    property string cn_sub_oracle_subHeader : qsTr("Oracle Connection")
    property string cn_sub_oracle_missingDriver : qsTr("Oracle ODBC Driver missing")
    property string cn_sub_oracle_driverDownload : qsTr("You don't have Oracle ODBC driver.Click Ok to Download")

    // SubComponents/PostgresConnection
    property string cn_sub_postgres_header : qsTr("Sign In to Postgres Server")
    property string cn_sub_postgres_subHeader : qsTr("Postgres Connection")
    property string cn_sub_postgres_missingDriver : qsTr("Postgres ODBC Driver missing")
    property string cn_sub_postgres_driverDownload : qsTr("You don't have Postgres ODBC driver.Click Ok to Download")

    // SubComponents/RedshiftConnection
    property string cn_sub_redshift_header : qsTr("Sign In to Redshift Server")
    property string cn_sub_redshift_subHeader : qsTr("Redshift Connection")
    property string cn_sub_redshift_missingDriver : qsTr("Redshift ODBC Driver missing")
    property string cn_sub_redshift_driverDownload : qsTr("You don't have Redshift ODBC driver.Click Ok to Download")

    // SubComponents/SheetConnection
    property string cn_sub_sheet_header : qsTr("Connect to Google sheets")
    property string cn_sub_sheet_allowReqMsg : qsTr(" wants to access to your Google sheets")
    property string cn_sub_sheet_allowAuthMsg : qsTr("Click the allow button above to open the Google Sheet authorization page on a separate window.")

    // SubComponents/SnowflakeConnection
    property string cn_sub_snowflake_header : qsTr("Sign In to Snowflake Server")
    property string cn_sub_snowflake_subHeader : qsTr("Snowflake Connection")
    property string cn_sub_snowflake_missingDriver : qsTr("Snowflake ODBC Driver missing")
    property string cn_sub_snowflake_driverDownload : qsTr("You don't have Snowflake ODBC driver.Click Ok to Download")

    // SubComponents/SqliteConnection
    property string cn_sub_sqlite_header : qsTr("Open Sqlite file")
    property string cn_sub_sqlite_subHeader : qsTr("Sqlite Connection")
    property string cn_sub_sqlite_selFile : qsTr("Select an sqlite file")
    property string cn_sub_sqlite_namedFilter : qsTr("Sqlite files (*.sqlite *.db)")

    // SubComponents/TeradataConnenction
    property string cn_sub_teradata_header : qsTr("Sign In to Teradata Server")
    property string cn_sub_teradata_subHeader : qsTr("Teradata Connection")
    property string cn_sub_teradata_missingDriver : qsTr("Teradata ODBC Driver missing")
    property string cn_sub_teradata_driverDownload : qsTr("You don't have Teradata ODBC driver.Click Ok to Download")

    /****************************************************/
    // Modelers
    /****************************************************/

    // DataQueryModeller
    property string mo_dqm_dataTabName : qsTr("Data Modeler")
    property string mo_dqm_dataTabDesc : qsTr("Use GUI interface to generate dataset from Datasource")
    property string mo_dqm_queryTabName : qsTr("Query Editor")
    property string mo_dqm_queryTabDesc : qsTr("Write SQL query to generate dataset")
    property string mo_dqm_inmemoryDesc : qsTr("Configure Extract parameters")

    property string mo_dqm_filterName : qsTr("Filter")
    property string mo_dqm_filterDesc : qsTr("Apply filters to the SQL query")
    property string mo_dqm_extractName : qsTr("Extract")
    property string mo_dqm_extractDesc : qsTr("Save datasource offline and process as an Extract database")
    property string mo_dqm_liveName : qsTr("Live")
    property string mo_dqm_liveDesc : qsTr("Save datasource for a live connection")

    property string mo_dqm_dsNamePlaceholder : qsTr("Data Source Name")
    property string mo_dqm_publishDs : qsTr("Publish Datasource")
    property string mo_dqm_createDashboard : qsTr("Create Dashboard")
    property string mo_dqm_connectedTo : qsTr("Connected To ")
    property string mo_dqm_connectedDb : qsTr("Current connected database: ")
    property string mo_dqm_disconnect : qsTr("Disconnect")
    property string mo_dqm_showHideTables : qsTr("Hide/Show database tables")

    property string mo_dqm_warningQueryLoss : qsTr("Your query will be lost. Are you sure you want to proceed?")
    property string mo_dqm_warningModelLoss : qsTr("Your diagram will be lost. Are you sure you want to proceed?")
    property string mo_dqm_mandatoryDSName : qsTr("Datasource name is mandatory")
    property string mo_dqm_freeExtractSizeLimit : qsTr("Free users cannot create extracts more than 1 GB")
    property string mo_dqm_extractCreateErr : qsTr("Extract create error")
    property string mo_dqm_timeElapsed : qsTr("Time elapsed: ")
    property string mo_dqm_waitCreateExtract : qsTr("Creating extract. Please wait..")


    // SubComponents

    // SubComponents/Common
    property string mo_sub_common_header : qsTr("Data Source Filter")

    // SubComponents/DataModeller
    property string mo_sub_dmr_joinIncomplete : qsTr("JOIN is not complete")
    property string mo_sub_dmr_queryErr : qsTr("Query Error")
    property string mo_sub_dmr_selPrimaryTable : qsTr("Select Primary table")

    // SubComponents/InfoTable
    property string mo_sub_inft_sqlSuccesMsg : qsTr("SQL query succesfully executed")
    property string mo_sub_inft_dataFetchSuccess : qsTr("Data fetched successfully")
    property string mo_sub_inft_displayLimitText : qsTr("Display limited to top ")
    property string mo_sub_inft_selectQueriesOnly : qsTr("Only SELECT (without Common Table Expressions) query allowed")
    property string mo_sub_inft_messageHead : qsTr("Message")
    property string mo_sub_inft_actionOut : qsTr("Action Output")
    property string mo_sub_inft_queryPerformance : qsTr("SQL query performance result")
    property string mo_sub_inft_dataPreview : qsTr("Data Preview")
    property string mo_sub_inft_queryLimit : qsTr("Limit SQL result data preview")
    property string mo_sub_inft_runsql : qsTr("Run SQL")
    property string mo_sub_inft_minimize : qsTr("Minimize panel")

    // SubComponents/InMemory
    property string mo_sub_inm_dataExtract : qsTr("Data Extract")
    property string mo_sub_inm_fullExtract : qsTr("Full Extract")
    property string mo_sub_inm_incrementalExtract : qsTr("Incremental Extract")
    property string mo_sub_inm_incrExtractCol : qsTr("Select the column for incremental extract")
    property string mo_sub_inm_selSchedule : qsTr("Select schedule for data extraction")
    property string mo_sub_inm_showFieldMsg : qsTr("Above field will show all data extract schedule that is set up in GRS")

    // SubComponents/TestQueryResultsTable
    property string mo_sub_tqrt_duration : qsTr("Duration")
    property string mo_sub_tqrt_action : qsTr("Action")
    property string mo_sub_tqrt_message : qsTr("Message")


    // MiniComponents

    // MiniComponents/DroppedRectangle
    property string mo_mini_drect_rename : qsTr("Rename")
    property string mo_mini_drect_convertTo : qsTr("Convert To")
    property string mo_mini_drect_remove : qsTr("Remove")

    // MiniComponents/JoinBox
    property string mo_mini_jbox_joinType : qsTr("Click to see join between columns and change the join type")
    property string mo_mini_jbox_deleteJoin : qsTr("Delete join between tables")

    // MiniComponents/JoinPopup
    property string mo_mini_jpopup_relationship : qsTr("Relationship")
    property string mo_mini_jpopup_innerJoin : qsTr("Inner Join")
    property string mo_mini_jpopup_leftJoin : qsTr("Left Join")
    property string mo_mini_jpopup_rightJoin : qsTr("Right Join")
    property string mo_mini_jpopup_fullOuterJoin : qsTr("Full Outer Join")
    property string mo_mini_jpopup_addKey : qsTr("Add Key")



    /****************************************************/
    // Dashboards
    /****************************************************/

    // NewDashboard
    property string da_nd_addKey : qsTr("Sorry, your current plan allows upto ")
    property string da_nd_deleteDashboard : qsTr("Delete")
    property string da_nd_addFilter : qsTr("Filter")
    property string da_nd_dashboardCustomize : qsTr("Customize")
    property string da_nd_publishDashboard : qsTr("Publish Dashboard")
    property string da_nd_createReport : qsTr("Create Report")
    property string da_nd_stagePlaceholder : qsTr("Add Reports and Widgets Here")
    property string da_nd_dashboardCustomizeLabel : qsTr("Customize Dashboard")



    // SubComponents


    // SubComponents/DashboardFilters
    property string da_sub_df_header: qsTr("Select Filter")

    // SubComponents/DashboardFiltersAdd
    property string da_sub_dfa_header: qsTr("Add Filter")

    // SubComponents/SaveWorkbookPopup
    property string da_sub_swp_header: qsTr("Save Workbook Options")
    property string da_sub_swp_publishDs: qsTr("Save & Publish Datasource")
    property string da_sub_swp_publishWb: qsTr("Save & Publish Workbook")


    // MiniComponents

    // MiniComponents/CustomizeCanvasSizeMenu
    property string da_sub_ccsm_width: qsTr("Width")
    property string da_sub_ccsm_height: qsTr("Height")


    // MiniComponents/CustomizeGeneralMenu
    property string da_sub_cgm_header: qsTr("Dashboard Name")

    // MiniComponents/CustomizeReportGeneralMenu
    property string da_sub_crgm_header: qsTr("Report Name")

    // MiniComponents/CustomizeReportStyleMenu
    property string da_sub_crsm_bgcolor: qsTr("Background Color")
    property string da_sub_crsm_linecolor: qsTr("Line Color")

    // MiniComponents/CustomizeStyleMenu
    property string da_sub_csm_bgcolor: qsTr("Background Color")

    // MiniComponents/DroppedImage
    property string da_sub_di_selectImageDialogTxt: qsTr("Select an image (*.jpg *.jpeg *.png  only)")
    property string da_sub_di_selectImageNamedFiltersTxt: qsTr("Image files (*.jpg *.jpeg *.png  only)")

    // MiniComponents/DroppedText
    property string da_sub_dt_editTextPlaceholder: qsTr("Edit text")

    // MiniComponents/FilterCustomize
    property string da_sub_fc_filterText: qsTr("Filter")
    property string da_sub_fc_propertyText: qsTr("Property")
    property string da_sub_fc_filterTypeText: qsTr("Filter Type")
    property string da_sub_fc_valueText: qsTr("Value")
    property string da_sub_fc_renameText: qsTr("Rename")

    // MiniComponents/FilterCustomizeCategorical
    property string da_sub_fcc_listText: qsTr("List")
    property string da_sub_fcc_singleValue: qsTr("Single Value")
    property string da_sub_fcc_multiValue: qsTr("Multiple Value")
    property string da_sub_fcc_dropdown: qsTr("Drop Down")
    property string da_sub_fcc_renameText: qsTr("Rename")

    // MiniComponents/FilterCustomizeNumerical
    // Common to some other files as well
    property string da_sub_fcn_rangeText: qsTr("Range")
    property string da_sub_fcn_conditionText: qsTr("Condition")
    property string da_sub_fcn_equal: qsTr("Equal To")
    property string da_sub_fcn_notequal: qsTr("Not Equal To")
    property string da_sub_fcn_smaller: qsTr("Smaller Than")
    property string da_sub_fcn_greater: qsTr("Greater Than")
    property string da_sub_fcn_equalorsmaller: qsTr("Equal or Smaller Than")
    property string da_sub_fcn_equalorgreater: qsTr("Equal or Greater Than")
    property string da_sub_fcn_between: qsTr("Between")
    property string da_sub_fcn_and: qsTr("And")

    // MiniComponents/WidgetTextEditor
    property string da_sub_wte_header: qsTr("Edit Text")




    // Reports

    // NewReport
    property string re_nr_header: qsTr("Add Report Title")
    property string re_nr_customize: qsTr("Customize")


    // SubComponents

    // SubComponents/Common
    property string re_sub_common_header : qsTr("Data Source Filter")

    // SubComponents/EditColorPopup
    property string re_sub_ecp_selDataItem : qsTr("Select Data Item")
    property string re_sub_ecp_selColorScheme : qsTr("Select Color Scheme")

    // SubComponents/ReportCustomizations
    property string re_sub_rc_chooseColor : qsTr("Please choose a color")
    property string re_sub_rc_filter : qsTr("Filter [0]")

    // SubComponents/YAxisSettingPopup
    property string re_sub_yasp_filter : qsTr("Axis")


    // MiniComponents

    // MiniComponents/Common
    property string re_mini_common_xAxis : qsTr("X Axis")
    property string re_mini_common_yAxis : qsTr("Y Axis")
    property string re_mini_common_label : qsTr("Label")
    property string re_mini_common_name : qsTr("Name: ")
    property string re_mini_common_font : qsTr("Font: ")
    property string re_mini_common_fontFamily : qsTr("Font Family: ")
    property string re_mini_common_fontsize : qsTr("Font Size: ")
    property string re_mini_common_B : qsTr("B")
    property string re_mini_common_I : qsTr("I")
    property string re_mini_common_Bold : qsTr("Bold")
    property string re_mini_common_Italic : qsTr("Italic")
    property string re_mini_common_Underline : qsTr("Underline")
    property string re_mini_common_fontColor : qsTr("Font Color: ")
    property string re_mini_common_tickMark : qsTr("Tick Mark")

    // MiniComponents/CategoricalFilterListContent
    property string re_mini_cflc_xAxis : qsTr("X Axis")

    // MiniComponents/CustomizeLegend
    property string re_mini_cl_showLegend : qsTr("Show Legend")
    property string re_mini_cl_showLegendLeft : qsTr("Left")
    property string re_mini_cl_showLegendRight : qsTr("Right")
    property string re_mini_cl_showLegendTop : qsTr("Top")
    property string re_mini_cl_showLegendBottom : qsTr("Bottom")

    // MiniComponents/CustomizeReferenceLine
    property string re_mini_crl_header : qsTr("Add Reference Line")

    // MiniComponents/CustomizeTotal
    property string re_mini_ct_rowTotal : qsTr("Row Total")
    property string re_mini_ct_grandTotal : qsTr("Grand Total")
    property string re_mini_ct_subTotal : qsTr("Sub Total")
    property string re_mini_ct_exportReport : qsTr("Export Report")

    // MiniComponents/DataPaneMenu
    property string re_mini_dpm_rename : qsTr("Rename")
    property string re_mini_dpm_create : qsTr("Create")
    property string re_mini_dpm_convertTo : qsTr("Convert To")

    // MiniComponents/DataPaneSubMenu
    property string re_mini_dpsm_calculatedField : qsTr("Calculated Field")
    property string re_mini_dpsm_group : qsTr("Group")
    property string re_mini_dpsm_date : qsTr("Date")
    property string re_mini_dpsm_number : qsTr("Number")

    // MiniComponents/KPICustomization
    property string re_mini_kpic_dataValue : qsTr("Data Value")
    property string re_mini_kpic_dataLabel : qsTr("Data Label")

    // MiniComponents/LabelPopup
    property string re_mini_lp_dataLabel : qsTr("Data Label")

    // MiniComponents/LineTypePopup
    property string re_mini_ltp_header : qsTr("Select Line")

    // MiniComponents/MarkerShapePopup
    property string re_mini_msp_markerShapeNone : qsTr("None")

    // MiniComponents/MultipleAxisSettings
    property string re_mini_mas_series : qsTr("Series")
    property string re_mini_mas_comboOptions : qsTr("Combo Options")

    // MiniComponents/PivotThemesPopup
    property string re_mini_ptp_header : qsTr("Select Theme")

    // MiniComponents/PropertiesFilter
    property string re_mini_ptp_colorBy : qsTr("Color By")
    property string re_mini_ptp_toolTip : qsTr("Tool Tip")
    property string re_mini_ptp_size : qsTr("Size")
    property string re_mini_ptp_markerShape : qsTr("Marker Shape")
    property string re_mini_ptp_dataLabel : qsTr("Data Label")
    property string re_mini_ptp_lineType : qsTr("Line Type")
    property string re_mini_ptp_themes : qsTr("Themes")
    property string re_mini_ptp_gridLine : qsTr("Grid Line")
    property string re_mini_ptp_dynamicHeight : qsTr("Dynamic Height")
    property string re_mini_ptp_bottomPinch : qsTr("Bottom Pinch")

    // MiniComponents/TableCustomization
    property string re_mini_tc_alternateRows : qsTr("Alternate Rows")
    property string re_mini_tc_cellBorders : qsTr("Cell Borders")
    property string re_mini_tc_hoverStatus : qsTr("Hover Status")
    property string re_mini_tc_compactStatus : qsTr("Compact Status")
}
