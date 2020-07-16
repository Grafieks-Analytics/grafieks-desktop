#ifndef FILTERRESULTMODEL_H
#define FILTERRESULTMODEL_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QSqlDatabase>
#include <QDebug>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

class FilterResultModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit FilterResultModel(QObject *parent = nullptr);
    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void callQuery(QString queryString = "");

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;

};

#endif // FILTERRESULTMODEL_H
