#ifndef REPORTPARAMSMODEL_H
#define REPORTPARAMSMODEL_H

#include <QObject>
#include <QMap>
#include <QVariantMap>
#include<QDebug>

class ReportParamsModel: public QObject
{
    Q_OBJECT

// Customize Report parameters
    QVariantMap reportsMap;           // <<reportId, reportObj>>
    QVariantMap reportsData;
    QVariantList dashboardReportInstances; 

    // Filter specific variables
    QVector<int> categoricalFilters;                            // Id List of categorical filters
    QVector<int> dateFilters;                                   // Id List of date filters
    QVector<int> numericalFilters;                              // Id List of numerical filters
    QMap<int, QString> filterColumnMap;                         // filter id - column name map
    QMap<int, QVariantList> filterValueMap;                     // filter id - value list map
    QMap<int, QString> filterRelationMap;                       // filter id - relation map
    QMap<int, bool> includeExcludeMap;                          // filter id - include exclude map
    QMap<int, bool> includeNullMap;                             // filter id - include null map
    QMap<int, QString> filterSectionMap;                        // filter id - section map
    QMap<int, QString> filterCategoryMap;                       // filter id - category map
    QMap<int, QString> filterSubCategoryMap;                    // filter id - sub category map

    // General properties
    Q_PROPERTY(QString itemName READ itemName WRITE setItemName NOTIFY itemNameChanged)
    Q_PROPERTY(QString itemType READ itemType WRITE setItemType NOTIFY itemTypeChanged)
    Q_PROPERTY(bool xAxisActive READ xAxisActive WRITE setXAxisActive NOTIFY xAxisActiveChanged)
    Q_PROPERTY(bool yAxisActive READ yAxisActive WRITE setYAxisActive NOTIFY yAxisActiveChanged)
    Q_PROPERTY(bool colorByActive READ colorByActive WRITE setColorByActive NOTIFY colorByActiveChanged)
    Q_PROPERTY(QString lastDropped READ lastDropped WRITE setLastDropped NOTIFY lastDroppedChanged)
    Q_PROPERTY(QString calculatedFieldPopupStatus READ calculatedFieldPopupStatus WRITE setCalculatedFieldPopupStatus NOTIFY calculatedFieldPopupStatusChanged)
    Q_PROPERTY(QList<QString> dataValuesColumns READ dataValuesColumns WRITE setDataValuesColumns NOTIFY dataValuesChanged)
    Q_PROPERTY(QString pointerValue READ pointerValue WRITE setPointerValue NOTIFY pointerValueChanged)
    Q_PROPERTY(QList<QString> colorBy READ colorBy WRITE setColorBy NOTIFY colorByChanged)

    // Report Properties for generating graph
    Q_PROPERTY(QString chartType READ chartType WRITE setChartType NOTIFY chartTypeChanged)
    Q_PROPERTY(QString chartTitle READ chartTitle WRITE setChartTitle NOTIFY chartTitleChanged)
    Q_PROPERTY(QString chartUrl READ chartUrl WRITE setChartUrl NOTIFY chartUrlChanged)
    Q_PROPERTY(QString reportId READ reportId WRITE setReportId NOTIFY reportIdChanged)
    Q_PROPERTY(QString reportTitle READ reportTitle WRITE setReportTitle NOTIFY reportTitleChanged)
    Q_PROPERTY(QString xAxisColumns READ xAxisColumns WRITE setXAxisColumns NOTIFY xAxisColumnsChanged)
    Q_PROPERTY(QString yAxisColumns READ yAxisColumns WRITE setYAxisColumns NOTIFY yAxisColumnsChanged)
    Q_PROPERTY(QString d3PropertiesConfig READ d3PropertiesConfig WRITE setD3PropertiesConfig NOTIFY d3PropertiesConfigChanged)
    Q_PROPERTY(QString colorByDataColoumns READ colorByDataColoumns WRITE setColorByDataColoumns NOTIFY colorByDataColoumnsChanged)

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

    QString m_itemName;
    QString m_itemType;
    bool m_xAxisActive;
    bool m_yAxisActive;
    bool m_colorByActive;
    QString m_lastDropped;
    QString m_createFieldPopupStatus;
    QList<QString> m_dataValuesColumns;
    QString m_pointerValue;
    QList<QString> m_colorBy;

    QString m_chartType;
    QString m_chartUrl;
    QString m_reportId;
    QString m_reportTitle;
    QString m_xAxisColumns;
    QString m_yAxisColumns;
    QString m_d3PropertiesConfig;

    int m_internalCounter;
    QString m_section;
    QString m_category;
    QString m_subCategory;
    QString m_tableName;
    QString m_colName;
    int m_filterIndex;
    QString m_mode;
    int m_filterModelIndex;

    QString m_chartTitle;

    QString m_colorByDataColoumns;

public:
    ReportParamsModel();

    // General properties
    QString itemName() const;
    QString itemType() const;
    bool xAxisActive() const;
    bool yAxisActive() const;
    bool colorByActive() const;
    QString lastDropped() const;
    QString calculatedFieldPopupStatus() const;
    QList<QString> dataValuesColumns() const;
    QString pointerValue() const;
    QList<QString> colorBy() const;

    // Report Properties for generating graph
    QString chartType() const;
    QString chartUrl() const;
    QString reportId() const;
    QString reportTitle() const;
    QString xAxisColumns() const;
    QString yAxisColumns() const;
    QString d3PropertiesConfig() const;
    QString chartTitle() const;
    QString colorByDataColoumns() const;

    // For Filters
    int internalCounter() const;
    QString section() const;
    QString category() const;
    QString subCategory() const;
    QString tableName() const;
    QString colName() const;
    int filterIndex() const;
    QString mode() const;
    int filterModelIndex() const;

    Q_INVOKABLE void addReport(QString reportId);
    Q_INVOKABLE QVariant getReport(QString reportId);
    Q_INVOKABLE QVariantMap getReportsList();

    // Filter specific invokable functions
    Q_INVOKABLE void addToCategoricalFilters(int filterId);
    Q_INVOKABLE QVector<int> fetchCategoricalFilters();
    Q_INVOKABLE void removeCategoricalFilters(int filterId);

    Q_INVOKABLE void addToDateFilters(int filterId);
    Q_INVOKABLE QVector<int> fetchDateFilters();
    Q_INVOKABLE void removeDateFilters(int filterId);

    Q_INVOKABLE void addToNumericalFilters(int filterId);
    Q_INVOKABLE QVector<int> fetchNumericalFilters();
    Q_INVOKABLE void removeNumericalFilters(int filterId);

    Q_INVOKABLE void addToFilterColumnMap(int filterId, QString value);
    Q_INVOKABLE QStringList fetchFilterColumnMap(int filterId = 0, bool fetchAll = false);
    Q_INVOKABLE void removeFilterColumnMap(int filterId);

    Q_INVOKABLE void addToFilterValueMap(int filterId, QVariant value);
    Q_INVOKABLE QVariantMap fetchFilterValueMap(int filterId = 0, bool fetchAll = false);
    Q_INVOKABLE void removeFilterValueMap(int filterId);

    Q_INVOKABLE void addToFilterRelationMap(int filterId, QString relation);
    Q_INVOKABLE QStringList fetchFilterRelationMap(int filterId = 0, bool fetchAll = false);
    Q_INVOKABLE void removeFilterRelationMap(int filterId);

    Q_INVOKABLE void addToIncludeExcludeMap(int filterId, bool includeExclude);
    Q_INVOKABLE QVector<bool> fetchIncludeExcludeMap(int filterId = 0, bool fetchAll = false);
    Q_INVOKABLE void removeIncludeExcludeMap(int filterId);

    Q_INVOKABLE void addToIncludeNullMap(int filterId, bool includeNull);
    Q_INVOKABLE QVector<bool> fetchIncludeNullMap(int filterId = 0, bool fetchAll = false);
    Q_INVOKABLE void removeIncludeNullMap(int filterId);

    Q_INVOKABLE void addToFilterSectionMap(int filterId, QString section);
    Q_INVOKABLE QStringList fetchFilterSectionMap(int filterId = 0, bool fetchAll = false);
    Q_INVOKABLE void removeFilterSectionMap(int filterId);

    Q_INVOKABLE void addToFilterCategoryMap(int filterId, QString category);
    Q_INVOKABLE QStringList fetchFilterCategoryMap(int filterId = 0, bool fetchAll = false);
    Q_INVOKABLE void removeFilterCategoryMap(int filterId);

    Q_INVOKABLE void addToFilterSubCategoryMap(int filterId, QString subCategory);
    Q_INVOKABLE QStringList fetchFilterSubCategoryMap(int filterId = 0, bool fetchAll = false);
    Q_INVOKABLE void removeFilterSubCategoryMap(int filterId);

    // Instances of dropped reports in dashboards
    Q_INVOKABLE void addDashboardReportInstance(QVariant newReportInstance);
    Q_INVOKABLE QVariant getDashboardReportInstance(int reportInstanceIndex);
    Q_INVOKABLE QVariant getAllDashboardReportInstances();


public slots:

    // General properties
    void setItemName(QString itemName);
    void setItemType(QString itemType);
    void setXAxisActive(bool xAxisActive);
    void setYAxisActive(bool yAxisActive);
    void setColorByActive(bool colorByActive);
    void setLastDropped(QString lastDropped);
    void setCalculatedFieldPopupStatus(QString calculatedFieldPopupStatus);
    void setDataValuesColumns(QList<QString> dataValuesColumns);
    void setPointerValue(QString pointerValue);
    void setColorBy(QList<QString> colorBy);

    // Report Properties for generating graph
    void setChartType(QString chartType);
    void setChartUrl(QString chartUrl);
    void setReportId(QString reportId);
    void setReportTitle(QString reportTitle);
    void setXAxisColumns(QString xAxisColumns);
    void setYAxisColumns(QString yAxisColumns);
    void setD3PropertiesConfig(QString d3PropertiesConfig);
    void setChartTitle(QString chartTitle);
    void setColorByDataColoumns(QString colorByDataColoumns);

    // For Filters
    void setInternalCounter(int internalCounter);
    void setSection(QString section);
    void setCategory(QString category);
    void setSubCategory(QString subCategory);
    void setTableName(QString tableName);
    void setColName(QString colName);
    void setFilterIndex(int filterIndex);
    void setMode(QString mode);
    void setFilterModelIndex(int filterModelIndex);


signals:
    // General properties
    void itemNameChanged(QString itemName);
    void itemTypeChanged(QString itemType);
    void xAxisActiveChanged(bool xAxisActive);
    void yAxisActiveChanged(bool yAxisActive);
    void colorByActiveChanged(bool colorByActive);
    void lastDroppedChanged(QString lastDropped);
    void calculatedFieldPopupStatusChanged(QString calculatedFieldPopupStatus);
    void dataValuesChanged(QList<QString> dataValuesColumns);
    void pointerValueChanged(QString pointerValue);
    void colorByChanged(QList<QString> colorBy);

    // Report Properties for generating graph
    void chartTypeChanged(QString chartType);
    void chartUrlChanged(QString chartUrl);
    void reportIdChanged(QString reportId);
    void reportTitleChanged(QString reportTitle);
    void xAxisColumnsChanged(QString xAxisColumns);
    void yAxisColumnsChanged(QString yAxisColumns);
    void d3PropertiesConfigChanged(QString d3PropertiesConfig);
    void chartTitleChanged(QString chartTitle);
    void colorByDataColoumnsChanged(QString colorByDataColoumns);

    // For Filters
    void internalCounterChanged(int internalCounter);
    void sectionChanged(QString section);
    void categoryChanged(QString category);
    void subCategoryChanged(QString subCategory);
    void tableNameChanged(QString tableName);
    void colNameChanged(QString colName);
    void filterIndexChanged(int filterIndex);
    void modeChanged(QString mode);
    void filterModelIndexChanged(int filterModelIndex);

    // For Dashboard Reports
    void reportListChanged();

};

#endif // REPORTPARAMSMODEL_H
