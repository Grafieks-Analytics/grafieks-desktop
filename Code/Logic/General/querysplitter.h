#ifndef QUERYSPLITTER_H
#define QUERYSPLITTER_H

#include <QRegularExpression>
#include <QObject>
#include <QDebug>

class QuerySplitter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)


public:
    explicit QuerySplitter(QObject *parent = nullptr);

    QString query() const;

public slots:
    void setQuery(QString query);

private:
    QStringList getSelectParams(QString & query);
    QString getWhereCondition(QString & query);
    QString getMainTable(QString & query);
    QStringList getJoinTables(QString & query);

    QString m_query;

signals:

void queryChanged(QString query);
};

#endif // QUERYSPLITTER_H
