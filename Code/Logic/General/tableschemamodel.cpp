#include "tableschemamodel.h"

TableSchemaModel::TableSchemaModel(QObject *parent) : QObject(parent)
{

}

QString TableSchemaModel::showSchema(QString dbType)
{
    Q_UNUSED(dbType);

    QString bingo = "bingo";

    qDebug() << bingo;
    return bingo;

}
