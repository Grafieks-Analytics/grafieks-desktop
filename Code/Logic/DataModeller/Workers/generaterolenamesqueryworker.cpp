#include "generaterolenamesqueryworker.h"



GenerateRoleNamesQueryWorker::GenerateRoleNamesQueryWorker(QSqlQueryModel *queryModel)
{
    this->queryModel = queryModel;
}

void GenerateRoleNamesQueryWorker::run()
{

    QStringList colInfo;
    QVariant fieldType;
    DataType dataType;

    QStringList tableHeaders;
    QMap<int, QStringList> sqlChartHeader;
    QHash<int, QByteArray> roleNames;

    for( int i = 0; i < this->queryModel->record().count(); i ++) {

        roleNames.insert(Qt::UserRole + i + 1, this->queryModel->record().fieldName(i).toUtf8());
        fieldType = this->queryModel->record().field(i).value();
        colInfo << this->queryModel->record().fieldName(i) << dataType.dataType(fieldType.typeName())  << this->queryModel->record().field(i).tableName();

        sqlChartHeader.insert(i, colInfo);
        tableHeaders.append(this->queryModel->record().field(i).tableName() + "." + this->queryModel->record().fieldName(i));
        colInfo.clear();
    }

    emit signalGenerateRoleNames(tableHeaders, sqlChartHeader);
}
