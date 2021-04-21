#ifndef NEWTABLELISTMODEL_H
#define NEWTABLELISTMODEL_H

#include <QObject>
#include <QSqlDatabase>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

class NewTableListModel : public QObject
{
    Q_OBJECT
    QStringList tables;
public:
    explicit NewTableListModel(QObject *parent = nullptr);
    Q_INVOKABLE QStringList getTableList();
    Q_INVOKABLE QStringList filterTableList(QString keyword);

private:

signals:

};

#endif // NEWTABLELISTMODEL_H
