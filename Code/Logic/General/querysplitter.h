#ifndef QUERYSPLITTER_H
#define QUERYSPLITTER_H

#include <QRegularExpression>
#include <QObject>
#include <QDebug>

/*!
 * \brief This class splits an Sql query into components
 * \ingroup General
 */
class QuerySplitter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)


public:
    explicit QuerySplitter(QObject *parent = nullptr);

    QStringList getSelectParams();
    QString getWhereCondition();
    QString getMainTable();
    QStringList getJoinTables();
    QString getJoinConditions();
    QString getAliasName(QString columnString);

    QString query() const;

    void setQueryForClasses(QString query); // Set query using C++

public slots:
    void setQuery(QString query); // Set query using QML

private:


    QString m_query;
    void setInternalQuery(QString query);

signals:

void queryChanged(QString query);
};

#endif // QUERYSPLITTER_H
