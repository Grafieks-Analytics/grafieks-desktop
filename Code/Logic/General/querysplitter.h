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

    QStringList getSelectParams();
    QString getWhereCondition();
    QString getMainTable();
    QStringList getJoinTables();

    QString query() const;

public slots:
    void setQuery(QString query);

private:


    QString m_query;

signals:

void queryChanged(QString query);
};

#endif // QUERYSPLITTER_H
