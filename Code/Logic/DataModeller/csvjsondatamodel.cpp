#include "csvjsondatamodel.h"

CSVJsonDataModel::CSVJsonDataModel(QObject *parent) : QObject(parent)
{

}

void CSVJsonDataModel::clearData()
{

}

CSVJsonDataModel::~CSVJsonDataModel()
{

}

void CSVJsonDataModel::columnData(QString col, QString tableName, QString options)
{

}

void CSVJsonDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{

}

QStringList CSVJsonDataModel::getTableList()
{
    QStringList output;
    output << Statics::currentDbName;
    return output;
}

QStringList CSVJsonDataModel::filterTableList(QString keyword)
{
    QStringList output;
    output << Statics::currentDbName;

    output.filter(keyword, Qt::CaseInsensitive);
    return output;
}
