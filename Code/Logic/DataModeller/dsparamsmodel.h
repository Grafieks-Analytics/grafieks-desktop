#ifndef DSPARAMSMODEL_H
#define DSPARAMSMODEL_H

#include <QVariant>
#include <QDebug>
#include <QObject>

#include "../../constants.h"

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

    // Standalone variables
    QStringList hideColumns;
    QMap<int, QStringList> joinBoxTableMap;
    QMap<int, QString> joinTypeMap;
    QMap<int, QString> joinIconMap;
    QMap<int, QMap<int, QStringList>> joinMapList;
    QMap<int, QString> primaryJoinTable;



    // Q_PROPERTY variables

    Q_PROPERTY(QString dsName READ dsName WRITE setDsName NOTIFY dsNameChanged)
    Q_PROPERTY(QString dsType READ dsType WRITE setDsType NOTIFY dsTypeChanged)
    Q_PROPERTY(bool isFullExtract READ isFullExtract WRITE setIsFullExtract NOTIFY isFullExtractChanged)
    Q_PROPERTY(QString extractColName READ extractColName WRITE setExtractColName NOTIFY extractColNameChanged)
    Q_PROPERTY(int schedulerId READ schedulerId WRITE setSchedulerId NOTIFY schedulerIdChanged)
    Q_PROPERTY(int displayRowsCount READ displayRowsCount WRITE setDisplayRowsCount NOTIFY displayRowsCountChanged)

    // For Data Modeller
    Q_PROPERTY(int joinId READ joinId WRITE setJoinId NOTIFY joinIdChanged)

    // For Filters
    Q_PROPERTY(QString section READ section WRITE setSection NOTIFY sectionChanged)
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)
    Q_PROPERTY(QString subCategory READ subCategory WRITE setSubCategory NOTIFY subCategoryChanged)
    Q_PROPERTY(QString tableName READ tableName WRITE setTableName NOTIFY tableNameChanged)
    Q_PROPERTY(QString colName READ colName WRITE setColName NOTIFY colNameChanged)
    Q_PROPERTY(QString relation READ relation WRITE setRelation NOTIFY relationChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(bool exclude READ exclude WRITE setExclude NOTIFY excludeChanged)
    Q_PROPERTY(bool includeNull READ includeNull WRITE setIncludeNull NOTIFY includeNullChanged)
    Q_PROPERTY(bool selectAll READ selectAll WRITE setSelectAll NOTIFY selectAllChanged)
    Q_PROPERTY(int filterIndex READ filterIndex WRITE setFilterIndex NOTIFY filterIndexChanged)
    Q_PROPERTY(QString mode READ mode WRITE setMode NOTIFY modeChanged) // Create/Edit mode

    QString m_dsName;
    QString m_dsType;
    bool m_isFullExtract;
    QString m_extractColName;
    int m_schedulerId;
    int m_displayRowsCount;

    // For Data Modeller
    int m_joinId;

    // For Filters
    QString m_section;
    QString m_category;
    QString m_subCategory;
    QString m_colName;
    QString m_tableName;
    QString m_relation;
    QVariant m_value;
    bool m_exclude;
    bool m_includeNull;
    bool m_selectAll;
    int m_filterIndex;
    QString m_mode;


public:
    explicit DSParamsModel(QObject *parent = nullptr);

    Q_INVOKABLE void resetFilter();
    Q_INVOKABLE void addToHideColumns(QString colName);
    Q_INVOKABLE void removeFromHideColumns(QString colName);
    Q_INVOKABLE QStringList fetchHideColumns(QString searchKeyword = "");

    Q_INVOKABLE void addToJoinBoxTableMap(int refObjId, QString firstTable, QString secondTable);
    Q_INVOKABLE void removeJoinBoxTableMap(int refObjId = 0);
    Q_INVOKABLE QVariantList fetchJoinBoxTableMap(int refObjId = 0);

    Q_INVOKABLE void addToJoinTypeMap(int refObjId, QString joinType = "");
    Q_INVOKABLE void updateJoinTypeMap(int refObjId, QString joinType = "");
    Q_INVOKABLE void removeJoinTypeMap(int refObjId = 0);
    Q_INVOKABLE QString fetchJoinTypeMap(int refObjId = 0);

    Q_INVOKABLE void addToJoinIconMap(int refObjId, QString iconLink = "");
    Q_INVOKABLE void updateJoinIconMap(int refObjId, QString iconLink = "");
    Q_INVOKABLE void removeJoinIconMap(int refObjId = 0);
    Q_INVOKABLE QString fetchJoinIconMap(int refObjId = 0);

    Q_INVOKABLE void addToJoinMapList(int refObjId, int internalCounter, QString leftParam = "", QString rightParam = "");
    Q_INVOKABLE void removeJoinMapList(int refObjId = 0, int internalCounter = 0);
    Q_INVOKABLE QVariantMap fetchJoinMapList(int refObjId = 0);

    Q_INVOKABLE void addToPrimaryJoinTable(int refObjId, QString tableName);
    Q_INVOKABLE void removePrimaryJoinTable(int refObjId = 0);
    Q_INVOKABLE QString fetchPrimaryJoinTable(int refObjId = 0);

    QString dsName() const;
    QString dsType() const;
    bool isFullExtract() const;
    QString extractColName() const;
    int schedulerId() const;
    int displayRowsCount() const;

    // For Data Modeller
    int joinId() const;

    // For Filters
    QString section() const;
    QString category() const;
    QString subCategory() const;
    QString colName() const;
    QString tableName() const;
    QString relation() const;
    QVariant value() const;
    bool exclude() const;
    bool includeNull() const;
    bool selectAll() const;
    int filterIndex() const;
    QString mode() const;





public slots:
    void setDsName(QString dsName);
    void setDsType(QString dsType);
    void setIsFullExtract(bool isFullExtract);
    void setExtractColName(QString extractColName);
    void setSchedulerId(int schedulerId);
    void setDisplayRowsCount(int displayRowsCount);

    // For Data Modeller
    void setJoinId(int joinId);

    // For Filters
    void setSection(QString section);
    void setCategory(QString category);
    void setSubCategory(QString subCategory);
    void setColName(QString colName);
    void setTableName(QString tableName);
    void setRelation(QString relation);
    void setValue(QVariant value);
    void setExclude(bool exclude);
    void setIncludeNull(bool includeNull);
    void setFilterIndex(int filterIndex);
    void setSelectAll(bool selectAll);
    void setMode(QString mode);




signals:

    void hideColumnsChanged(QStringList hideColumns);
    void joinTypeMapChanged(QVariantList joinTypeData);
    void joinIconMapChanged(QVariantList joinIconData);

    void dsNameChanged(QString dsName);
    void dsTypeChanged(QString dsType);
    void isFullExtractChanged(bool isFullExtract);
    void extractColNameChanged(QString extractColName);
    void schedulerIdChanged(int schedulerId);
    void displayRowsCountChanged(int displayRowsCount);

    // For Data Modeller
    void joinIdChanged(int joinId);

    // For Filters
    void sectionChanged(QString section);
    void categoryChanged(QString category);
    void subCategoryChanged(QString subCategory);
    void colNameChanged(QString colName);
    void tableNameChanged(QString tableName);
    void relationChanged(QString relation);
    void valueChanged(QVariant value);
    void excludeChanged(bool exclude);
    void includeNullChanged(bool includeNull);
    void selectAllChanged(bool selectAll);
    void filterIndexChanged(int filterIndex);
    void modeChanged(QString mode);


};

#endif // DSPARAMSMODEL_H
