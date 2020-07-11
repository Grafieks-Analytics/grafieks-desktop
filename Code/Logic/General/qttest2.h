#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>

#include "../../Connectors/mysqlcon.h"



class QtTest2 : public QSqlQueryModel
{
    Q_OBJECT

public:
    explicit QtTest2(QObject *parent = nullptr);

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const {	return m_roleNames;	}

    Q_INVOKABLE void callSql();

private :
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;

};

#endif // QTTEST2_H
