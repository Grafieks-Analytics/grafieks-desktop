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


    // Q_PROPERTY variables

    Q_PROPERTY(QString dsName READ dsName WRITE setDsName NOTIFY dsNameChanged)
    Q_PROPERTY(QString dsType READ dsType WRITE setDsType NOTIFY dsTypeChanged)
    Q_PROPERTY(bool isFullExtract READ isFullExtract WRITE setIsFullExtract NOTIFY isFullExtractChanged)
    Q_PROPERTY(QString extractColName READ extractColName WRITE setExtractColName NOTIFY extractColNameChanged)
    Q_PROPERTY(int schedulerId READ schedulerId WRITE setSchedulerId NOTIFY schedulerIdChanged)
    Q_PROPERTY(int displayRowsCount READ displayRowsCount WRITE setDisplayRowsCount NOTIFY displayRowsCountChanged)

    // For Data Modeller
    Q_PROPERTY(QString joinType READ joinType WRITE setJoinType NOTIFY joinTypeChanged)
    Q_PROPERTY(QString joinIcon READ joinIcon WRITE setJoinIcon NOTIFY joinIconChanged)
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
    QString m_joinType;
    QString m_joinIcon;
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
    Q_INVOKABLE QStringList fetchHideColumns();

    QString dsName() const;
    QString dsType() const;
    bool isFullExtract() const;
    QString extractColName() const;
    int schedulerId() const;
    int displayRowsCount() const;

    // For Data Modeller
    QString joinType() const;
    QString joinIcon() const;
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
    void setJoinType(QString joinType);
    void setJoinIcon(QString joinIcon);
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

    void dsNameChanged(QString dsName);
    void dsTypeChanged(QString dsType);
    void isFullExtractChanged(bool isFullExtract);
    void extractColNameChanged(QString extractColName);
    void schedulerIdChanged(int schedulerId);
    void displayRowsCountChanged(int displayRowsCount);

    // For Data Modeller
    void joinTypeChanged(QString joinType);
    void joinIconChanged(QString joinIcon);
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
