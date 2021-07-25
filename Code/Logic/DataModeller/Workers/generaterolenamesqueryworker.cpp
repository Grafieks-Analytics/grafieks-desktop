#include "generaterolenamesqueryworker.h"



GenerateRoleNamesQueryWorker::GenerateRoleNamesQueryWorker(QSqlRecord record)
{
    this->record = record;
}

void GenerateRoleNamesQueryWorker::run()
{

    QStringList colInfo;
    QVariant fieldType;
    DataType dataType;

    QStringList tableHeaders;
    QMap<int, QStringList> sqlChartHeader;
    QHash<int, QByteArray> roleNames;

    for( int i = 0; i < this->record.count(); i ++) {

        roleNames.insert(Qt::UserRole + i + 1, this->record.fieldName(i).toUtf8());
        fieldType = this->record.field(i).value();
        colInfo << this->record.fieldName(i) << dataType.dataType(fieldType.typeName())  << this->record.field(i).tableName();

        sqlChartHeader.insert(i, colInfo);
        tableHeaders.append(this->record.fieldName(i));
        colInfo.clear();
    }

    emit signalGenerateRoleNames(tableHeaders, sqlChartHeader);
}
