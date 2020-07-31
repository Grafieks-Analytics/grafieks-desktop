#ifndef FILTERLIST_H
#define FILTERLIST_H

#include <QVariant>
#include <QObject>

class FilterList : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int filterId READ filterId WRITE setFilterId NOTIFY filterIdChanged)
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)
    Q_PROPERTY(QString subCategory READ subCategory WRITE setSubCategory NOTIFY subCategoryChanged)
    Q_PROPERTY(QString tableName READ tableName WRITE setTableName NOTIFY tableNameChanged)
    Q_PROPERTY(QString columnName READ columnName WRITE setColumnName NOTIFY columnNameChanged)
    Q_PROPERTY(QString relation READ relation WRITE setRelation NOTIFY relationChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)


    int m_filterId;
    QString m_category;
    QString m_subCategory;
    QString m_tableName;
    QString m_columnName;
    QString m_relation;
    QVariant m_value;


public:
    explicit FilterList(const int & filterId, const QString & category, const QString & subcategory, const QString & tableName, const QString & columnName, const QString & relation, const QVariant & value, QObject *parent = nullptr);

    int filterId() const;
    QString category() const;
    QString subCategory() const;
    QString tableName() const;
    QString columnName() const;
    QString relation() const;
    QVariant value() const;





public slots:
    void setFilterId(int filterId);
    void setCategory(QString category);
    void setSubCategory(QString subCategory);
    void setTableName(QString tableName);
    void setColumnName(QString columnName);
    void setRelation(QString relation);
    void setValue(QVariant value);





signals:

    void filterIdChanged(int filterId);
    void categoryChanged(QString category);
    void subCategoryChanged(QString subCategory);
    void tableNameChanged(QString tableName);
    void columnNameChanged(QString columnName);
    void relationChanged(QString relation);
    void valueChanged(QVariant value);



};

#endif // FILTERLIST_H
