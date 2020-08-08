#ifndef FILTERLIST_H
#define FILTERLIST_H

#include <QVariant>
#include <QObject>

class FilterList : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int filterId READ filterId WRITE setFilterId NOTIFY filterIdChanged)
    Q_PROPERTY(QString section READ section WRITE setSection NOTIFY sectionChanged)
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)
    Q_PROPERTY(QString subCategory READ subCategory WRITE setSubCategory NOTIFY subCategoryChanged)
    Q_PROPERTY(QString tableName READ tableName WRITE setTableName NOTIFY tableNameChanged)
    Q_PROPERTY(QString columnName READ columnName WRITE setColumnName NOTIFY columnNameChanged)
    Q_PROPERTY(QString relation READ relation WRITE setRelation NOTIFY relationChanged)
    Q_PROPERTY(QString value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(bool includeNull READ includeNull WRITE setIncludeNull NOTIFY includeNullChanged)
    Q_PROPERTY(bool exclude READ exclude WRITE setExclude NOTIFY excludeChanged)


    int m_filterId;
    QString m_section;
    QString m_category;
    QString m_subCategory;
    QString m_tableName;
    QString m_columnName;
    QString m_relation;
    QString m_value;
    bool m_includeNull;
    bool m_exclude;

public:
    explicit FilterList(const int & filterId, const QString & section, const QString & category, const QString & subcategory, const QString & tableName, const QString & columnName, const QString & relation, const QString & value, const bool & includeNull, const bool & exclude, QObject *parent = nullptr);

    int filterId() const;
    QString section() const;
    QString category() const;
    QString subCategory() const;
    QString tableName() const;
    QString columnName() const;
    QString relation() const;
    QString value() const;
    bool includeNull() const;
    bool exclude() const;

public slots:
    void setFilterId(int filterId);
    void setSection(QString section);
    void setCategory(QString category);
    void setSubCategory(QString subCategory);
    void setTableName(QString tableName);
    void setColumnName(QString columnName);
    void setRelation(QString relation);
    void setValue(QString value);
    void setIncludeNull(bool includeNull);
    void setExclude(bool exclude);

signals:

    void filterIdChanged(int filterId);
    void sectionChanged(QString section);
    void categoryChanged(QString category);
    void subCategoryChanged(QString subCategory);
    void tableNameChanged(QString tableName);
    void columnNameChanged(QString columnName);
    void relationChanged(QString relation);
    void valueChanged(QString value);
    void includeNullChanged(bool includeNull);
    void excludeChanged(bool exclude);
};

#endif // FILTERLIST_H
