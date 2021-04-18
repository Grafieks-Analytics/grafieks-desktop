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
public:
    explicit NewTableListModel(QObject *parent = nullptr);
    Q_INVOKABLE QStringList getTableList();

private:

signals:

};

#endif // NEWTABLELISTMODEL_H
