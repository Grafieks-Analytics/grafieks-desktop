#ifndef QUERYMODELLER_H
#define QUERYMODELLER_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>

#include "../../Connectors/allconnectors.h"
#include "../../constants.h"

class QueryModel : public QSqlQueryModel
{
    Q_OBJECT

    // For Partial query in DataQueryModeller.qml (TextEdit)
    Q_PROPERTY(QString tmpSql READ tmpSql WRITE setTmpSql NOTIFY tmpSqlChanged)

public:
    explicit QueryModel(QObject *parent = 0);

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void callSql();
    QString tmpSql() const;

public slots:
    void setTmpSql(QString tmpSql);

signals:
    void tmpSqlChanged(QString tmpSql);

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;
    QString m_tmpSql;
};

#endif // QUERYMODELLER_H
