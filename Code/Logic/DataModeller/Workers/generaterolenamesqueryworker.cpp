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
    QString tableName;
    QString fieldName;

    QStringList tableHeaders;
    QMap<int, QStringList> sqlChartHeader;
    QHash<int, QByteArray> roleNames;

    for( int i = 0; i < this->queryModel->record().count(); i ++) {

        roleNames.insert(Qt::UserRole + i + 1, this->queryModel->record().fieldName(i).toUtf8());
        fieldType = this->queryModel->record().field(i).value();
        tableName = this->queryModel->record().field(i).tableName().toStdString().c_str();
        fieldName = this->queryModel->record().fieldName(i).toStdString().c_str();
        colInfo << fieldName << dataType.dataType(fieldType.typeName())  << tableName ;

        sqlChartHeader.insert(i, colInfo);

        tableHeaders.append(tableName + "." + fieldName);
        colInfo.clear();
    }

    qDebug() << tableHeaders << sqlChartHeader << "CONTRA";

    emit signalGenerateRoleNames(tableHeaders, sqlChartHeader);
}
