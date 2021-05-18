#ifndef DSPARAMSMODEL_H
#define DSPARAMSMODEL_H

#include <QVariant>
#include <QFile>
#include <QUrl>
#include <QDebug>
#include <QObject>
#include <QDataStream>
#include <QJsonObject>
#include <QJsonDocument>
#include <QElapsedTimer>
#include <QFileInfo>

#include "../../constants.h"
#include "../../Messages.h"
#include "../../statics.h"

/*!
 * \brief Sets all the temporary variables for DataModeller
 * \details This class saves all the temporary variables for the class DataModeller. Mainly, it contains Getter/Setter methods for the variables
 * This include variables for filters as well.
 * Details of the Class won't be explained here
 * \ingroup DataModeller
 */
class DSParamsModel : public QObject
{
    Q_OBJECT

    // Standalone variables for Data Modeller
    QStringList hideColumns;                       // List of columns not available for join conditions in any given table
    QMap<int, QStringList> joinBoxTableMap;        // holds the name of tables against a join id. Called when clicking a join box to show related tables
    QMap<int, QString> joinTypeMap;                // left join, inner join, right join, full outer join
    QMap<int, QString> joinIconMap;                // icon for various type of joins for joinTypeMap
    QMap<int, QMap<int, QStringList>> joinMapList; // relation between columns for given two tables
    QMap<int, QString> primaryJoinTable;           // Set the primary table in a join. ie, parameter will be on left side of relation in a join
    QStringList querySelectParamsList;             // select parameters of the query created by data modeller
    QVariantList joinOrder;                        // Order of join elements in sql query
    QMap<int, QVariant>  existingTables;           // List of tables mapped to their ids
    QMap<int, QVariant> rectangles;                // Created rectangles object
    QMap<int, QVariant> frontRectangleCoordinates; // Rectangle front coordinates
    QMap<int, QVariant> rearRectangleCoordinates;  // Rectangle rear coordinates
    QMap<int, QVariant> newConnectingLine;         // Connecting line object
    QMap<int, QVariant> frontLineMap;              // Line front coordinates
    QMap<int, QVariant> rearLineMap;               // Line rear coordinates
    QMap<int, QVariant> newJoinBox;                // Join box between 2 rectangles

    // Standalone variables for Filters
    QVariantMap joinRelation;                   // Condition link between parameter and value in a query. eg, =, !=, LIKE, etc
    QVariantMap joinValue;                      // Right side parameter of the comparison (the actual value)
    QVariantMap joinRelationSlug;               // Single syllable entity for human readable entity. eg, in Categorical-Wildcard, Slug for `Ends With` is `endswith` and `Equal To` is `equalto`
    QMap<int, bool> excludeMap;                 // Map for exclude all checks, QMap<filterId, bool>
    QMap<int, bool> includeNullMap;             // Map for include nulls, QMap<filterId, bool>
    QMap<int, bool> selectAllMap;               // Map for select alls, QMap<filterId, bool>
    QStringList tmpSelectedValues;              // Tmp selected values in a filter list - used in categorical filter list
    QVector<int> tmpFilterIndex;                // Tmp created filter index - used in categorical filter wildcard
    QMap<int, int> dateFormatMap;               // Date selected format QMap<filterId, formatId>
    QMap<int, QString> actualDateValues;        // For dates like This year, last 10 years, quarter, etc, the original values are stored in this variable

    // Q_PROPERTY variables

    // General
    Q_PROPERTY(int currentTab READ currentTab WRITE setCurrentTab NOTIFY currentTabChanged) // 0.Data modeller / 1.Query modeller
    Q_PROPERTY(QString fileExtension READ fileExtension WRITE setFileExtension NOTIFY fileExtensionChanged)

    // Publish datasource
    Q_PROPERTY(QString dsName READ dsName WRITE setDsName NOTIFY dsNameChanged)                                     // Data source name in publish DS
    Q_PROPERTY(QString dsType READ dsType WRITE setDsType NOTIFY dsTypeChanged)                                     // DataSource Type: live/extract
    Q_PROPERTY(bool isFullExtract READ isFullExtract WRITE setIsFullExtract NOTIFY isFullExtractChanged)            // DS full extract orincremental extract
    Q_PROPERTY(QString extractColName READ extractColName WRITE setExtractColName NOTIFY extractColNameChanged)     // If incremental, then col name
    Q_PROPERTY(int schedulerId READ schedulerId WRITE setSchedulerId NOTIFY schedulerIdChanged)                     // Scheduler id (fetched from API) selected
    Q_PROPERTY(int displayRowsCount READ displayRowsCount WRITE setDisplayRowsCount NOTIFY displayRowsCountChanged) //Number of rows to display in sql preview

    // For Data Modeller
    Q_PROPERTY(int joinId READ joinId WRITE setJoinId NOTIFY joinIdChanged) // Current selected joinId in data modeller
    Q_PROPERTY(QString queryJoiner READ queryJoiner WRITE setQueryJoiner NOTIFY queryJoinerChanged)

    // For Query Modeller
    Q_PROPERTY(QString tmpSql READ tmpSql WRITE setTmpSql NOTIFY tmpSqlChanged)

    // For Filters
    Q_PROPERTY(int internalCounter READ internalCounter WRITE setInternalCounter NOTIFY internalCounterChanged) // Counter for categorical-wildcard
    Q_PROPERTY(QString section READ section WRITE setSection NOTIFY sectionChanged)                             // Categorical/Numerical/Date/Group filters
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)                         // Inner sub classifications of the section
    Q_PROPERTY(QString subCategory READ subCategory WRITE setSubCategory NOTIFY subCategoryChanged)             // selection type of categories like multi/single select in categorical tab
    Q_PROPERTY(QString tableName READ tableName WRITE setTableName NOTIFY tableNameChanged)                     // sql table name of the selection
    Q_PROPERTY(QString colName READ colName WRITE setColName NOTIFY colNameChanged)                             // sql column name
    Q_PROPERTY(int filterIndex READ filterIndex WRITE setFilterIndex NOTIFY filterIndexChanged)                 // Unique id given to each join type (filter type)
    Q_PROPERTY(QString mode READ mode WRITE setMode NOTIFY modeChanged)                                         // Set Create/Edit mode in a filter
    Q_PROPERTY(int filterModelIndex READ filterModelIndex WRITE setFilterModelIndex NOTIFY filterModelIndexChanged)

    int m_currentTab;

    QString m_dsName;
    QString m_dsType;
    bool m_isFullExtract;
    QString m_extractColName;
    int m_schedulerId;
    int m_displayRowsCount;

    // For Data Modeller
    int m_joinId;
    QString m_queryJoiner;

    // For Query Modeller
    QString m_tmpSql;

    // For Filters
    int m_internalCounter;
    QString m_section;
    QString m_category;
    QString m_subCategory;
    QString m_colName;
    QString m_tableName;
    int m_filterIndex;
    QString m_mode;
    int m_filterModelIndex;

public:
    explicit DSParamsModel(QObject *parent = nullptr);
    void closeModel();
    ~DSParamsModel();

    Q_INVOKABLE void resetDataModel();
    Q_INVOKABLE bool saveDatasource(QString filename);
    Q_INVOKABLE QVariantList readDatasource(QString filename);

    Q_INVOKABLE void addToHideColumns(QString colName);
    Q_INVOKABLE void removeFromHideColumns(QString colName, bool removeAll = false);
    Q_INVOKABLE QStringList fetchHideColumns(QString searchKeyword = "");

    Q_INVOKABLE void addToJoinBoxTableMap(int refObjId, QString firstTable, QString secondTable);
    Q_INVOKABLE void removeJoinBoxTableMap(int refObjId = 0, bool removeAll = false);
    Q_INVOKABLE QVariantList fetchJoinBoxTableMap(int refObjId = 0);

    Q_INVOKABLE void addToJoinTypeMap(int refObjId, QString joinType = "");
    Q_INVOKABLE void updateJoinTypeMap(int refObjId, QString joinType = "");
    Q_INVOKABLE void removeJoinTypeMap(int refObjId = 0, bool removeAll = false);
    Q_INVOKABLE QString fetchJoinTypeMap(int refObjId = 0);

    Q_INVOKABLE void addToJoinIconMap(int refObjId, QString iconLink = "");
    Q_INVOKABLE void updateJoinIconMap(int refObjId, QString iconLink = "");
    Q_INVOKABLE void removeJoinIconMap(int refObjId = 0, bool removeAll = false);
    Q_INVOKABLE QString fetchJoinIconMap(int refObjId = 0);

    Q_INVOKABLE void addToJoinMapList(int refObjId, int internalCounter, QString leftParam = "", QString rightParam = "");
    Q_INVOKABLE void removeJoinMapList(int refObjId = 0, int internalCounter = 0, bool deleteMainMap = false);
    Q_INVOKABLE QVariantMap fetchJoinMapList(int refObjId = 0);

    Q_INVOKABLE void addToPrimaryJoinTable(int refObjId, QString tableName);
    Q_INVOKABLE void removePrimaryJoinTable(int refObjId = 0, bool removeAll = false);
    Q_INVOKABLE QString fetchPrimaryJoinTable(int refObjId = 0);

    Q_INVOKABLE void addToQuerySelectParamsList(QString selectParam);
    Q_INVOKABLE void removeQuerySelectParamsList(QString refObjName = "", bool deleteAllMatching = false);
    Q_INVOKABLE QStringList fetchQuerySelectParamsList();

    Q_INVOKABLE void addToJoinOrder(int joinOrderId);
    Q_INVOKABLE void removeJoinOrder(int joinOrderId);
    Q_INVOKABLE QVariantList fetchJoinOrder();

    Q_INVOKABLE void addToExistingTables(int refObjId, QString tableName);
    Q_INVOKABLE void removeExistingTables(int refObjId = 0);
    Q_INVOKABLE QVariant fetchExistingTables(int refObjId = 0);
    Q_INVOKABLE int existingTablesSize();

    Q_INVOKABLE void addToRectangles(int refObjId, const QVariant &rectangleObject);
    Q_INVOKABLE void removeRectangles(int refObjId = 0);
    Q_INVOKABLE QVariant fetchRectangles(int refObjId = 0);
    Q_INVOKABLE QVariantMap fetchAllRectangles();
    Q_INVOKABLE QVector<int> fetchAllRectangleKeys();
    Q_INVOKABLE int rectanglesSize();

    Q_INVOKABLE void addToFrontRectangleCoordinates(int refObjId, QVariant rectangleCoordinates);
    Q_INVOKABLE void removeFrontRectangleCoordinates(int refObjId = 0);
    Q_INVOKABLE QVariant fetchFrontRectangleCoordinates(int refObjId = 0);

    Q_INVOKABLE void addToRearRectangleCoordinates(int refObjId, QVariant rectangleCoordinates);
    Q_INVOKABLE void removeRearRectangleCoordinates(int refObjId = 0);
    Q_INVOKABLE QVariant fetchRearRectangleCoordinates(int refObjId = 0);
    Q_INVOKABLE QVariantMap fetchAllRearRectangleCoordinates();

    Q_INVOKABLE void addToNewConnectingLine(int refObjId, const QVariant &lineObject);
    Q_INVOKABLE void removeNewConnectingLine(int refObjId = 0);
    Q_INVOKABLE QVariant fetchNewConnectingLine(int refObjId = 0);
    Q_INVOKABLE QVector<int> fetchAllLineKeys();
    Q_INVOKABLE int linesSize();

    Q_INVOKABLE void addToFrontLineMap(int refObjId, QVariant lineObject);
    Q_INVOKABLE void removeFrontLineMap(int refObjId = 0);
    Q_INVOKABLE QVariant fetchFrontLineMap(int refObjId = 0);

    Q_INVOKABLE void addToRearLineMap(int refObjId, QVariant lineObject);
    Q_INVOKABLE void removeRearLineMap(int refObjId = 0);
    Q_INVOKABLE QVariant fetchRearLineMap(int refObjId = 0);

    Q_INVOKABLE void addToNewJoinBox(int refObjId, const QVariant &joinBoxObject);
    Q_INVOKABLE void removeNewJoinBox(int refObjId = 0);
    Q_INVOKABLE QVariant fetchNewJoinBox(int refObjId = 0);

    // Filters

    Q_INVOKABLE void resetFilter();

    Q_INVOKABLE void addToJoinRelation(int refObjId, QString relation = "");
    Q_INVOKABLE void removeJoinRelation(int refObjId = 0, bool removeAll = false);
    Q_INVOKABLE QVariantMap fetchJoinRelation(int refObjId = 0, bool fetchAll = false);

    Q_INVOKABLE void addToJoinValue(int refObjId, QString value = "");
    Q_INVOKABLE void removeJoinValue(int refObjId = 0, bool removeAll = false);
    Q_INVOKABLE QVariantMap fetchJoinValue(int refObjId = 0, bool fetchAll = false);

    Q_INVOKABLE void addToJoinRelationSlug(int refObjId, QString value = "");
    Q_INVOKABLE void removeJoinRelationSlug(int refObjId = 0, bool removeAll = false);
    Q_INVOKABLE QVariantMap fetchJoinRelationSlug(int refObjId = 0, bool fetchAll = false);

    Q_INVOKABLE void setValueFormat(int refObjId, int formatId);
    Q_INVOKABLE void removeValueFormat(int refObjId = 0, bool removeAll = false);
    Q_INVOKABLE int getDateFormatMap(int refObjId);

    Q_INVOKABLE void setActualDateValues(int refObjId, QString value);
    Q_INVOKABLE void removeActualDateValues(int refObjId, bool removeAll = false);
    Q_INVOKABLE QString getActualDateValues(int refObjId);

    Q_INVOKABLE void setExcludeMap(int refObjId, bool value = false);
    Q_INVOKABLE void removeExcludeMap(int refObjId);
    Q_INVOKABLE QVariantMap getExcludeMap(int refObjId = 0, bool fetchAll = false);

    Q_INVOKABLE void setIncludeNullMap(int refObjId, bool value = false);
    Q_INVOKABLE void removeIncludeNullMap(int refObjId);
    Q_INVOKABLE QVariantMap getIncludeNullMap(int refObjId = 0, bool fetchAll = false);

    Q_INVOKABLE void setSelectAllMap(bool refObjId, bool value = false);
    Q_INVOKABLE void removeSelectAllMap(int refObjId);
    Q_INVOKABLE QVariantMap getSelectAllMap(int refObjId = 0, bool fetchAll = false);

    Q_INVOKABLE void setTmpSelectedValues(QString value);
    Q_INVOKABLE void removeTmpSelectedValues(int refObjId, bool removeAll = false);
    Q_INVOKABLE QStringList getTmpSelectedValues(int refObjId = 0, bool fetchAll = false);
    Q_INVOKABLE int searchTmpSelectedValues(QString keyword);

    Q_INVOKABLE void setTmpFilterIndex(int value);
    Q_INVOKABLE void removeTmpFilterIndex(int refObjId, bool removeAll = false);
    Q_INVOKABLE QVector<int> getTmpFilterIndex(int refObjId = 0, bool fetchAll = false);

    // Datasource Read/Write
    Q_INVOKABLE void parseCsv(QUrl pathToCsv);
    Q_INVOKABLE void parseParquet(QUrl pathToParquet);
    Q_INVOKABLE void exportExtractData(QString pathToExtract);
    Q_INVOKABLE void importExtractData(QString pathToExtract);
    Q_INVOKABLE void resetInputFields();

    int currentTab() const;
    QString fileExtension() const;
    QString dsName() const;
    QString dsType() const;
    bool isFullExtract() const;
    QString extractColName() const;
    int schedulerId() const;
    int displayRowsCount() const;

    // For Data Modeller
    int joinId() const;
    QString queryJoiner() const;

    // For Query Modeller
    QString tmpSql() const;

    // For Filters
    int internalCounter() const;
    QString section() const;
    QString category() const;
    QString subCategory() const;
    QString colName() const;
    QString tableName() const;
    int filterIndex() const;
    QString mode() const;
    int filterModelIndex() const;

public slots:

    // General Slots
    void processDataModellerQuery();

    // Publish Datasource
    void setCurrentTab(int currentTab);
    void setFileExtension(QString fileExtension);
    void setDsName(QString dsName);
    void setDsType(QString dsType);
    void setIsFullExtract(bool isFullExtract);
    void setExtractColName(QString extractColName);
    void setSchedulerId(int schedulerId);
    void setDisplayRowsCount(int displayRowsCount);

    // For Data Modeller
    void setJoinId(int joinId);
    void setQueryJoiner(QString queryJoiner);

    // For Query Modeller
    void setTmpSql(QString tmpSql);

    // For Filters
    void setInternalCounter(int internalCounter);
    void setSection(QString section);
    void setCategory(QString category);
    void setSubCategory(QString subCategory);
    void setColName(QString colName);
    void setTableName(QString tableName);
    void setFilterIndex(int filterIndex);
    void setMode(QString mode);
    void setFilterModelIndex(int filterModelIndex);

signals:

    // General
    void currentTabChanged(int currentTab);
    void fileExtensionChanged(QString fileExtension);
    void processQuery();

    // Publish Datasource
    void dsNameChanged(QString dsName);
    void dsTypeChanged(QString dsType);
    void isFullExtractChanged(bool isFullExtract);
    void extractColNameChanged(QString extractColName);
    void schedulerIdChanged(int schedulerId);
    void displayRowsCountChanged(int displayRowsCount);

    // For Data Modeller
    void joinIdChanged(int joinId);
    void destroyLocalObjectsAndMaps();
    void hideColumnsChanged(QStringList hideColumns);
    void joinTypeMapChanged(QVariantList joinTypeData);
    void joinIconMapChanged(QVariantList joinIconData);

    // For Query Modeller
    void tmpSqlChanged(QString tmpSql);
    void queryJoinerChanged(QString queryJoiner);

    // For Filters
    void internalCounterChanged(int internalCounter);
    void sectionChanged(QString section);
    void categoryChanged(QString category);
    void subCategoryChanged(QString subCategory);
    void colNameChanged(QString colName);
    void tableNameChanged(QString tableName);
    void relationChanged(QString relation);
    void valueChanged(QVariant value);
    void filterIndexChanged(int filterIndex);
    void modeChanged(QString mode);
    void tmpSelectedValuesChanged(QStringList values);

    // For Datasource Read/Write
    void dataReadComplete(uint time, bool status, QString msg);
    void csvReadComplete(uint time, bool status, QString msg);
    void parquetReadComplete(uint time, bool status, QString msg);
    void exportDataComplete(uint time, bool status, QString msg);
    void importDataComplete(uint time, bool status, QString msg);

    void resetInput();


    void filterModelIndexChanged(int filterModelIndex);

private:
    QMap<QString, QString> datasourceCredentials();
    QString m_fileExtension;
    int counter;


    // Read Write Data source file
    void insertOne();
    void updateOne();
    void deleteOne();
    void fetchOne();

    void insertMany();
    void updateMany();
    void deleteMany();
    void fetchMany();

};

#endif // DSPARAMSMODEL_H
