#include "dsparamsmodel.h"

DSParamsModel::DSParamsModel(QObject *parent) : QObject(parent),counter(1)
{

//    db.LoadExtension<duckdb::ParquetExtension>();

    m_section = Constants::defaultTabSection;
    m_category = Constants::defaultCategory;
    m_subCategory = Constants::defaultSubCategory;
    m_mode = Constants::defaultMode;
    m_exclude = Constants::defaultExclude;
    m_includeNull = Constants::defaultIncludeNull;
    m_selectAll = Constants::defaultSelectAll;
    m_internalCounter = 0;
}

DSParamsModel::~DSParamsModel()
{

}

void DSParamsModel::resetDataModel()
{

    this->hideColumns.clear();
    this->joinBoxTableMap.clear();
    this->joinTypeMap.clear();
    this->joinIconMap.clear();
    this->joinMapList.clear();
    this->primaryJoinTable.clear();
    this->querySelectParamsList.clear();

    emit destroyLocalObjectsAndMaps();
}

bool DSParamsModel::saveDatasource(QString filename)
{
    QJsonObject jsonObject;
    QJsonDocument jsonDocument;

    // Filename resource uri to filepath
    QFile file(QUrl(filename).toLocalFile());

    // Check if file writable
    if (!file.open(QFile::WriteOnly))
    {
        qDebug() << " Could not open file for writing" << file.errorString();
        return false;
    }

    // Order of components to be written in the binary file

    // 1. DB Driver
    // 2. Type of connection - live/extract (.gads for live/ .gadse for extract)
    // 3. Type of Modeller - Query / Data Modeller
    // 4. For Query modeller -

    // Tmp sql
    // joinRelation
    // joinValue
    // joinRelationSlug
    // internalCounter
    // section
    // category
    // subCategory
    // tableName
    // colName
    // exclude
    // includeNull
    // selectAll
    // filterIndex
    // mode

    // 5. For Data modeller

    // hideColumns
    // joinBoxTableMap
    // joinTypeMap
    // joinIconMap
    // joinMapList
    // primaryJoinTable
    // querySelectParamsList
    // joinOrder
    // joinId

    // 6. Datasource publish information

    // dsName
    // dsType
    // displayRowsCount

    // 7. InMemory config parameters

    // schedulerId
    // isFullExtract
    // extractColName

    // 8. For Live - Login credentials (sans password). For Extract - Data

    QDataStream out(&file);

    // Write a header with a "magic number" and a version
    out << (quint32)0x785AA164;
    out << (qint32)101;

    out.setVersion(QDataStream::Qt_5_15);

    out << QString(Statics::currentDbStrType); // 1. DB Driver
    out << QString(this->dsType());            // 2. Type of connection
    out << this->currentTab();                 // 3. Type of Modeller

    // If query modeller
    // else data modeller
    if (this->currentTab() == 1)
    {

        // 4. For Query Modeller
        out << this->tmpSql(); // TmpSql
        out << this->joinRelation;
        out << this->joinValue;
        out << this->joinRelationSlug;
        out << this->internalCounter();
        out << this->section();
        out << this->category();
        out << this->subCategory();
        out << this->tableName();
        out << this->colName();
        out << this->exclude();
        out << this->includeNull();
        out << this->selectAll();
        out << this->filterIndex();
        out << this->mode();
    }
    else
    {

        // 4. For Data Modeller
        out << this->hideColumns;
        out << this->joinBoxTableMap;
        out << this->joinTypeMap;
        out << this->joinIconMap;
        out << this->joinMapList;
        out << this->primaryJoinTable;
        out << this->querySelectParamsList;
        out << this->joinOrder;
        out << this->joinId();
    }

    // 6. Datasource publish information

    out << this->dsName();
    out << this->dsType();
    out << this->displayRowsCount();

    // 7. InMemory config parameters
    out << this->schedulerId();
    out << this->isFullExtract();
    out << this->extractColName();

    // 8. For Live - Login credentials (sans password). For Extract - Data

    if (this->dsType() == "live")
    {

        QMap<QString, QString> credentials = this->datasourceCredentials();

        out << credentials.value("type");
        out << credentials.value("host");
        out << credentials.value("fileDB");
        out << credentials.value("port");
        out << credentials.value("username");
    }
    else
    {
    }

    file.flush();
    file.close();

    return true;
}

QVariantList DSParamsModel::readDatasource(QString filename)
{

    QVariantList fileReadStatus;

    QString dbDriver = "",
            typeOfConnection = "",
            tmpSql = "",
            section = "",
            category = "",
            subCategory = "",
            tableName = "",
            colName = "",
            mode = "",
            dsName = "",
            dsType = "",
            extractColName = "",
            dbDriverCredential = "",
            dbHostCredential = "",
            dbFileNameCredential = "",
            dbPortCredential = "",
            dbUsernameCredential = "";

    int modellerType = 0,
        internalCounter = 0,
        filterIndex = 0,
        joinId = 0,
        displayRowsCount = 0,
        schedulerId = 0;

    QVariantMap joinRelation, joinValue, joinRelationSlug;
    QStringList hideColumns;
    QMap<int, QStringList> joinBoxTableMap;
    QMap<int, QString> joinTypeMap;
    QMap<int, QString> joinIconMap;
    QMap<int, QMap<int, QStringList>> joinMapList;
    QMap<int, QString> primaryJoinTable;
    QStringList querySelectParamsList;
    QVariantList joinOrder;

    bool exclude = false,
         includeNull = false,
         selectAll = false,
         isFullExtract = false;

    // Filename resource uri to filepath
    QFile file(QUrl(filename).toLocalFile());

    // Check if file readable
    if (!file.open(QFile::ReadOnly))
    {
        qDebug() << " Could not open file for writing" << file.errorString();
        return fileReadStatus << Messages::FILE_READ_ERROR << Messages::fileReadError;
    }

    QDataStream in(&file); // read the data serialized from the file

    // Read and check the header
    quint32 magic;
    in >> magic;
    if (magic != 0x785AA164)
        return fileReadStatus << Messages::FILE_FORMAT_ERROR << Messages::fileFormatInvalid;

    // Read the version
    qint32 version;
    in >> version;

    if (version <= 100)
        return fileReadStatus << Messages::FILE_TOO_OLD << Messages::fileTooOld;

    if (version > 100)
        in.setVersion(QDataStream::Qt_5_15);

    in >> dbDriver;
    in >> typeOfConnection;
    in >> modellerType;

    if (modellerType == 1)
    {

        // 4. For Query Modeller
        in >> tmpSql;
        in >> joinRelation;
        in >> joinValue;
        in >> joinRelationSlug;
        in >> internalCounter;
        in >> section;
        in >> category;
        in >> subCategory;
        in >> tableName;
        in >> colName;
        in >> exclude;
        in >> includeNull;
        in >> selectAll;
        in >> filterIndex;
        in >> mode;
    }
    else
    {

        in >> hideColumns;
        in >> joinBoxTableMap;
        in >> joinTypeMap;
        in >> joinIconMap;
        in >> joinMapList;
        in >> primaryJoinTable;
        in >> querySelectParamsList;
        in >> joinOrder;
        in >> joinId;
    }

    in >> dsName;
    in >> dsType;
    in >> displayRowsCount;

    // 7. InMemory config parameters
    in >> schedulerId;
    in >> isFullExtract;
    in >> extractColName;

    // 8. For Live - Login credentials (sans password). For Extract - Data

    if (dsType == "live")
    {

        in >> dbDriverCredential;
        in >> dbHostCredential;
        in >> dbFileNameCredential;
        in >> dbPortCredential;
        in >> dbUsernameCredential;
    }
    else
    {
    }

    qDebug() << dbDriver << typeOfConnection << modellerType << "GENERAL PARAM";
    qDebug() << joinRelation << joinValue << joinRelationSlug << internalCounter << section << category << subCategory << tableName << colName << exclude << includeNull << selectAll << filterIndex << mode << "QUERY MODELLER PARAM";
    qDebug() << hideColumns << joinBoxTableMap << joinTypeMap << joinIconMap << joinMapList << querySelectParamsList << joinOrder << joinId << "DATA MODELLER PARAM";
    qDebug() << dsName << dsType << displayRowsCount << schedulerId << isFullExtract << extractColName << "OTHER PARAMS";
    qDebug() << dbDriverCredential << dbHostCredential << dbPortCredential << dbUsernameCredential << "CREDENTIAL PARAMS";

    return fileReadStatus << Messages::FILE_READ_SUCCESS << Messages::fileReadSuccess;
}

void DSParamsModel::resetFilter()
{
    this->setSection(Constants::defaultTabSection);
    this->setCategory(Constants::defaultCategory);
    this->setSubCategory(Constants::defaultSubCategory);
    this->setMode(Constants::defaultMode);
    this->setExclude(Constants::defaultExclude);
    this->setIncludeNull(Constants::defaultIncludeNull);
    this->setSelectAll(Constants::defaultSelectAll);
    this->setInternalCounter(0);

    this->joinValue.clear();
    this->joinRelation.clear();
    this->joinRelationSlug.clear();
}

void DSParamsModel::addToHideColumns(QString colName)
{
    this->hideColumns.append(colName);
    emit hideColumnsChanged(this->hideColumns);
}

void DSParamsModel::removeFromHideColumns(QString colName, bool removeAll)
{
    if (removeAll == true)
    {
        this->hideColumns.clear();
    }
    else
    {
        this->hideColumns.removeOne(colName);
    }
    emit hideColumnsChanged(this->hideColumns);
}

QStringList DSParamsModel::fetchHideColumns(QString searchKeyword)
{
    return this->hideColumns.filter(searchKeyword);
}

void DSParamsModel::addToJoinBoxTableMap(int refObjId, QString firstTable, QString secondTable)
{
    QStringList joinedTables;
    joinedTables << firstTable << secondTable;

    this->joinBoxTableMap.insert(refObjId, joinedTables);
}

void DSParamsModel::removeJoinBoxTableMap(int refObjId, bool removeAll)
{
    if (removeAll == true)
    {
        this->joinBoxTableMap.clear();
    }
    else
    {
        this->joinBoxTableMap.remove(refObjId);
    }
}

QVariantList DSParamsModel::fetchJoinBoxTableMap(int refObjId)
{
    QVariantList returnObj;
    returnObj << refObjId << this->joinBoxTableMap.value(refObjId).at(0) << this->joinBoxTableMap.value(refObjId).at(1);
    return returnObj;
}

void DSParamsModel::addToJoinTypeMap(int refObjId, QString joinType)
{
    QVariantList outData;
    outData << refObjId << joinType;

    this->joinTypeMap.insert(refObjId, joinType);
    emit joinTypeMapChanged(outData);
}

void DSParamsModel::updateJoinTypeMap(int refObjId, QString joinType)
{
    QVariantList outData;
    outData << refObjId << joinType;

    this->joinTypeMap[refObjId] = joinType;
    emit joinTypeMapChanged(outData);
}

void DSParamsModel::removeJoinTypeMap(int refObjId, bool removeAll)
{
    if (removeAll == true)
    {
        this->joinTypeMap.clear();
    }
    else
    {
        this->joinTypeMap.remove(refObjId);
    }
}

QString DSParamsModel::fetchJoinTypeMap(int refObjId)
{
    return this->joinTypeMap.value(refObjId);
}

void DSParamsModel::addToJoinIconMap(int refObjId, QString iconLink)
{
    QVariantList outData;
    outData << refObjId << iconLink;

    this->joinIconMap.insert(refObjId, iconLink);
    emit joinIconMapChanged(outData);
}

void DSParamsModel::updateJoinIconMap(int refObjId, QString iconLink)
{
    QVariantList outData;
    outData << refObjId << iconLink;

    this->joinIconMap[refObjId] = iconLink;
    emit joinIconMapChanged(outData);
}

void DSParamsModel::removeJoinIconMap(int refObjId, bool removeAll)
{
    if (removeAll == true)
    {
        this->joinIconMap.clear();
    }
    else
    {
        this->joinIconMap.remove(refObjId);
    }
}

QString DSParamsModel::fetchJoinIconMap(int refObjId)
{
    return this->joinIconMap.value(refObjId);
}

void DSParamsModel::addToJoinMapList(int refObjId, int internalCounter, QString leftParam, QString rightParam)
{
    QMap<int, QStringList> joinParamMap;
    QStringList params;

    params << leftParam << rightParam;

    if (!this->joinMapList[refObjId].isEmpty())
        joinParamMap = this->joinMapList[refObjId];

    joinParamMap[internalCounter] = params;
    this->joinMapList[refObjId] = joinParamMap;
}

void DSParamsModel::removeJoinMapList(int refObjId, int internalCounter, bool deleteMainMap)
{

    if (refObjId > 0 || internalCounter > 0)
    {

        if (deleteMainMap == false)
        {
            QMap<int, QStringList> joinParamMap;

            joinParamMap = this->joinMapList.value(refObjId);
            joinParamMap.remove(internalCounter);

            this->joinMapList[refObjId] = joinParamMap;
        }
        else
        {
            this->joinMapList.remove(refObjId);
        }
    }
}

QVariantMap DSParamsModel::fetchJoinMapList(int refObjId)
{
    QStringList params;
    QVariantMap output;

    QString leftParam, rightParam;

    for (auto key : this->joinMapList.value(refObjId).keys())
    {

        leftParam = this->joinMapList.value(refObjId).value(key).value(0);
        rightParam = this->joinMapList.value(refObjId).value(key).value(1);

        params << leftParam << rightParam;

        output[QString::number(key)] = params;
        params.clear();
    }

    return output;
}

void DSParamsModel::addToPrimaryJoinTable(int refObjId, QString tableName)
{
    this->primaryJoinTable[refObjId] = tableName;
}

void DSParamsModel::removePrimaryJoinTable(int refObjId, bool removeAll)
{
    if (removeAll == true)
    {
        this->primaryJoinTable.clear();
    }
    else
    {
        this->primaryJoinTable.remove(refObjId);
    }
}

QString DSParamsModel::fetchPrimaryJoinTable(int refObjId)
{
    return this->primaryJoinTable.value(refObjId);
}

void DSParamsModel::addToQuerySelectParamsList(QString selectParam)
{
    this->querySelectParamsList.append(selectParam);
}

void DSParamsModel::removeQuerySelectParamsList(QString refObjName)
{

    if (refObjName != "")
        this->querySelectParamsList.removeOne(refObjName);
}

QStringList DSParamsModel::fetchQuerySelectParamsList()
{

    return this->querySelectParamsList;
}

void DSParamsModel::addToJoinOrder(int joinOrderId)
{
    this->joinOrder.append(joinOrderId);
}

void DSParamsModel::removeJoinOrder(int joinOrderId)
{
    this->joinOrder.removeOne(joinOrderId);
}

QVariantList DSParamsModel::fetchJoinOrder()
{
    return this->joinOrder;
}

void DSParamsModel::addToJoinRelation(int refObjId, QString relation)
{
    this->joinRelation.insert(QString::number(refObjId), relation);
}

void DSParamsModel::removeJoinRelation(int refObjId, bool removeAll)
{

    if (removeAll == true)
    {
        this->joinRelation.clear();
    }
    else
    {
        this->joinRelation.remove(QString::number(refObjId));
    }
}

QVariantMap DSParamsModel::fetchJoinRelation(int refObjId, bool fetchAll)
{

    QVariantMap output;

    if (fetchAll == false)
    {
        QVariant val;

        val = this->joinRelation.value(QString::number(refObjId));
        output.insert(QString::number(refObjId), val);
    }
    else
    {
        output = this->joinRelation;
    }

    return output;
}

void DSParamsModel::addToJoinValue(int refObjId, QString value)
{
    this->joinValue.insert(QString::number(refObjId), value);
}

void DSParamsModel::removeJoinValue(int refObjId, bool removeAll)
{

    if (removeAll == true)
    {
        this->joinValue.clear();
    }
    else
    {
        this->joinValue.remove(QString::number(refObjId));
    }
}

QVariantMap DSParamsModel::fetchJoinValue(int refObjId, bool fetchAll)
{

    QVariantMap output;

    if (fetchAll == false)
    {
        QVariant val;

        val = this->joinValue.value(QString::number(refObjId));
        output.insert(QString::number(refObjId), val);
    }
    else
    {
        output = this->joinValue;
    }
    return output;
}

void DSParamsModel::addToJoinRelationSlug(int refObjId, QString value)
{
    this->joinRelationSlug.insert(QString::number(refObjId), value);
}

void DSParamsModel::removeJoinRelationSlug(int refObjId, bool removeAll)
{

    if (removeAll == true)
    {
        this->joinRelationSlug.clear();
    }
    else
    {
        this->joinRelationSlug.remove(QString::number(refObjId));
    }
}

QVariantMap DSParamsModel::fetchJoinRelationSlug(int refObjId, bool fetchAll)
{

    QVariantMap output;

    if (fetchAll == false)
    {
        QVariant val;

        val = this->joinRelationSlug.value(QString::number(refObjId));
        output.insert(QString::number(refObjId), val);
    }
    else
    {
        output = this->joinRelationSlug;
    }
    return output;
}

void DSParamsModel::setValueFormat(QString value, QString format)
{
    this->dateFormatMap.insert(value, format);
}

void DSParamsModel::removeValueFormat(QString key)
{
    this->dateFormatMap.remove(key);
}

QVariantMap DSParamsModel::getDateFormatMap()
{
    QVariantMap output;
    output = this->dateFormatMap;
    return output;
}

void DSParamsModel::setTimeFrame(QString dummy, QString actual)
{
    this->timeFrameMap.insert(dummy, actual);
}

void DSParamsModel::removeTimeFrame(QString key)
{
    this->timeFrameMap.remove(key);
}

QVariantMap DSParamsModel::getTimeFrameMap()
{
    QVariantMap output;
    output = this->timeFrameMap;
    return output;
}

void DSParamsModel::parseCsv(QUrl pathToCsv)
{

//    QString msg;
//    QElapsedTimer timer;
//    timer.start();

//    QFileInfo fileInfo(pathToCsv.toString());
//    QString fileName = fileInfo.fileName();
//    QString fileNameWithoutExt = fileName.section(".", 0, 0);

//    QString queryString = "CREATE TABLE " + fileNameWithoutExt + " AS SELECT * FROM read_csv_auto('" + pathToCsv.toLocalFile() + "')";
//    auto result = con.Query(queryString.toStdString());
//    result->Print();

//    if (!result->success)
//    {
//        msg = QString::fromStdString(result->error);
//    }
//    else
//    {
//        msg = "Success";
//    }
//    qDebug() << msg << "CSV Reading";

//    emit csvReadComplete(timer.elapsed(), result->success, msg);
}

void DSParamsModel::parseParquet(QUrl pathToParquet)
{

//    QString msg;
//    QElapsedTimer timer;
//    timer.start();

//    QFileInfo fileInfo(pathToParquet.toString());
//    QString fileName = fileInfo.fileName();
//    QString fileNameWithoutExt = fileName.section(".", 0, 0);

//    QString queryString = "CREATE TABLE " + fileNameWithoutExt + " AS SELECT * FROM PARQUET_SCAN('" + pathToParquet.toLocalFile() + "')";
//    qDebug() << queryString << "QSTRING";
//    auto result = con.Query(queryString.toStdString());
//    result->Print();

//    if (!result->success)
//    {
//        msg = QString::fromStdString(result->error);
//    }
//    else
//    {
//        msg = "Success";
//    }

//    emit parquetReadComplete(timer.elapsed(), result->success, msg);
}

void DSParamsModel::exportExtractData(QString pathToExtract)
{
//    QString msg;
//    QElapsedTimer timer;
//    timer.start();

//    QString queryString = "EXPORT DATABASE '" + pathToExtract + "' (FORMAT PARQUET)";
//    auto result = con.Query(queryString.toStdString());

//    emit exportDataComplete(timer.elapsed(), result->success, msg);
}

void DSParamsModel::importExtractData(QString pathToExtract)
{

//    QString msg;
//    QElapsedTimer timer;
//    timer.start();

//    QString queryString = "IMPORT DATABASE '" + pathToExtract + "'";
//    auto result = con.Query(queryString.toStdString());

//    emit importDataComplete(timer.elapsed(), result->success, msg);
}

void DSParamsModel::resetInputFields()
{
    emit resetInput();
}

int DSParamsModel::currentTab() const
{
    return m_currentTab;
}

QString DSParamsModel::fileExtension() const
{
    return m_fileExtension;
}

QString DSParamsModel::dsName() const
{
    return m_dsName;
}

QString DSParamsModel::dsType() const
{
    return m_dsType;
}

bool DSParamsModel::isFullExtract() const
{
    return m_isFullExtract;
}

QString DSParamsModel::extractColName() const
{
    return m_extractColName;
}

int DSParamsModel::schedulerId() const
{
    return m_schedulerId;
}

int DSParamsModel::displayRowsCount() const
{
    return m_displayRowsCount;
}

int DSParamsModel::joinId() const
{
    return m_joinId;
}

QString DSParamsModel::tmpSql() const
{
    return m_tmpSql;
}

int DSParamsModel::internalCounter() const
{
    return m_internalCounter;
}

QString DSParamsModel::section() const
{
    return m_section;
}

QString DSParamsModel::colName() const
{
    return m_colName;
}

QString DSParamsModel::tableName() const
{
    return m_tableName;
}

bool DSParamsModel::exclude() const
{
    return m_exclude;
}

bool DSParamsModel::includeNull() const
{
    return m_includeNull;
}

bool DSParamsModel::selectAll() const
{
    return m_selectAll;
}

int DSParamsModel::filterIndex() const
{
    return m_filterIndex;
}

QString DSParamsModel::mode() const
{
    return m_mode;
}

void DSParamsModel::processDataModellerQuery()
{
    emit processQuery();
}

void DSParamsModel::setCurrentTab(int currentTab)
{
    if (m_currentTab == currentTab)
        return;

    m_currentTab = currentTab;
    emit currentTabChanged(m_currentTab);
}

void DSParamsModel::setFileExtension(QString fileExtension)
{
    if (m_fileExtension == fileExtension)
        return;

    m_fileExtension = fileExtension;
    emit fileExtensionChanged(m_fileExtension);
}

QString DSParamsModel::category() const
{
    return m_category;
}

QString DSParamsModel::subCategory() const
{
    return m_subCategory;
}

void DSParamsModel::setDsName(QString dsName)
{
    if (m_dsName == dsName)
        return;

    m_dsName = dsName;
    emit dsNameChanged(m_dsName);
}

void DSParamsModel::setDsType(QString dsType)
{
    if (m_dsType == dsType)
        return;

    m_dsType = dsType;
    emit dsTypeChanged(m_dsType);
}

void DSParamsModel::setIsFullExtract(bool isFullExtract)
{
    if (m_isFullExtract == isFullExtract)
        return;

    m_isFullExtract = isFullExtract;
    emit isFullExtractChanged(m_isFullExtract);
}

void DSParamsModel::setExtractColName(QString extractColName)
{
    if (m_extractColName == extractColName)
        return;

    m_extractColName = extractColName;
    emit extractColNameChanged(m_extractColName);
}

void DSParamsModel::setSchedulerId(int schedulerId)
{
    if (m_schedulerId == schedulerId)
        return;

    m_schedulerId = schedulerId;
    emit schedulerIdChanged(m_schedulerId);
}

void DSParamsModel::setDisplayRowsCount(int displayRowsCount)
{
    if (m_displayRowsCount == displayRowsCount)
        return;

    m_displayRowsCount = displayRowsCount;
    emit displayRowsCountChanged(m_displayRowsCount);
}

void DSParamsModel::setJoinId(int joinId)
{
    if (m_joinId == joinId)
        return;

    m_joinId = joinId;
    emit joinIdChanged(m_joinId);
}

void DSParamsModel::setTmpSql(QString tmpSql)
{
    // Only select queries to be accepted
    bool isSqlSelect = tmpSql.toUpper().startsWith("SELECT");

    if (m_tmpSql == tmpSql && !isSqlSelect)
        return;

    m_tmpSql = tmpSql;
    emit tmpSqlChanged(m_tmpSql);
}

void DSParamsModel::setInternalCounter(int internalCounter)
{
    if (m_internalCounter == internalCounter)
        return;

    m_internalCounter = internalCounter;
    emit internalCounterChanged(m_internalCounter);
}

void DSParamsModel::setSection(QString section)
{
    if (m_section == section)
        return;

    m_section = section;
    emit sectionChanged(m_section);
}

void DSParamsModel::setColName(QString colName)
{
    if (m_colName == colName)
        return;

    m_colName = colName;
    emit colNameChanged(m_colName);
}

void DSParamsModel::setTableName(QString tableName)
{
    if (m_tableName == tableName)
        return;

    m_tableName = tableName;
    emit tableNameChanged(m_tableName);
}

void DSParamsModel::setExclude(bool exclude)
{
    if (m_exclude == exclude)
        return;

    m_exclude = exclude;
    emit excludeChanged(m_exclude);
}

void DSParamsModel::setIncludeNull(bool includeNull)
{
    if (m_includeNull == includeNull)
        return;

    m_includeNull = includeNull;
    emit includeNullChanged(m_includeNull);
}

void DSParamsModel::setFilterIndex(int filterIndex)
{
    if (m_filterIndex == filterIndex)
        return;

    m_filterIndex = filterIndex;
    emit filterIndexChanged(m_filterIndex);
}

void DSParamsModel::setSelectAll(bool selectAll)
{
    if (m_selectAll == selectAll)
        return;

    m_selectAll = selectAll;
    emit selectAllChanged(m_selectAll);
}

void DSParamsModel::setMode(QString mode)
{
    if (m_mode == mode)
        return;

    m_mode = mode;
    emit modeChanged(m_mode);
}

QMap<QString, QString> DSParamsModel::datasourceCredentials()
{
    QMap<QString, QString> credentials;

    switch (Statics::currentDbIntType)
    {

    case Constants::mysqlIntType:

        credentials.insert("type", Statics::currentDbStrType);
        credentials.insert("host", Statics::myHost);
        credentials.insert("fileDB", Statics::myDb);
        credentials.insert("port", QString::number(Statics::myPort));
        credentials.insert("username", Statics::myUsername);
        credentials.insert("password", Statics::myPassword);
        break;

    case Constants::sqliteIntType:
        credentials.insert("type", Statics::currentDbStrType);
        credentials.insert("host", "");
        credentials.insert("fileDB", Statics::sqliteFile);
        credentials.insert("port", "");
        credentials.insert("username", Statics::sqliteUsername);
        credentials.insert("password", Statics::sqlitePassword);
        break;

    case Constants::postgresIntType:
        credentials.insert("type", Statics::currentDbStrType);
        credentials.insert("host", Statics::postgresHost);
        credentials.insert("fileDB", Statics::postgresDb);
        credentials.insert("port", QString::number(Statics::postgresPort));
        credentials.insert("username", Statics::postgresUsername);
        credentials.insert("password", Statics::postgresPassword);
        break;
    }

    return credentials;
}

void DSParamsModel::insertOne()
{
}

void DSParamsModel::updateOne()
{
}

void DSParamsModel::deleteOne()
{
}

void DSParamsModel::fetchOne()
{
}

void DSParamsModel::insertMany()
{
}

void DSParamsModel::updateMany()
{
}

void DSParamsModel::deleteMany()
{
}

void DSParamsModel::fetchMany()
{
}

void DSParamsModel::setCategory(QString category)
{
    if (m_category == category)
        return;

    m_category = category;
    emit categoryChanged(m_category);
}

void DSParamsModel::setSubCategory(QString subCategory)
{
    if (m_subCategory == subCategory)
        return;

    m_subCategory = subCategory;
    emit subCategoryChanged(m_subCategory);
}
