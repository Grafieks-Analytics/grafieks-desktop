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

QStringList CSVJsonDataModel::getColumnList(QString tableName, char delimiter, QString moduleName)
{
    QFile file(tableName);
    QList<QStringList> allColumns;
    QStringList allColumnsA;

    if(!file.open(QFile::ReadOnly | QFile::Text)) {
        qDebug() << "Cannot open file" << file.errorString();
    } else {
        int lineCounter = 0;
        while(lineCounter < 2){
            const QByteArray line = file.readLine().simplified();
            qDebug() << "LINE COUNTER" << lineCounter<< line;

            if(lineCounter == 0){
                qDebug() << "SETTING HEADERS";
                setHeaders(line, delimiter);
            } else {
                qDebug() << "DETECTING DATA TYPES";
                allColumns = detectHeaderTypes(line, delimiter);
            }
            lineCounter++;
        }
    }

    emit columnListObtained(allColumns, tableName, moduleName);

    file.close();

    return allColumnsA;
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

void CSVJsonDataModel::setHeaders(const QByteArray line, char delimiter)
{
    QList<QByteArray> headerData = line.split(delimiter);
    this->headerLength = headerData.at(1).toInt();

    this->headerDataFinal =  headerData.at(0).split(',');
    if (this->headerDataFinal.at(0).contains("\xEF\xBB\xBF")){
        this->headerDataFinal[0] =  this->headerDataFinal.at(0).right(this->headerDataFinal.at(0).length() - 3);
    }

    qDebug() << this->headerDataFinal << this->headerLength;
}

QList<QStringList> CSVJsonDataModel::detectHeaderTypes(const QByteArray line, char delimiter)
{
    QList<QByteArray> lineData = line.split(delimiter);

    QStringList output;
    QString fieldName;
    QString fieldType;
    QStringList outputDataList;
    QList<QStringList> allColumns;

    for(int i = 0; i < this->headerLength; i++){
        fieldName = this->headerDataFinal.at(i);
        fieldType = dataType.variableType(QString(lineData.at(i)));

        outputDataList << fieldName << fieldType;

        // Append all data type to allList as well
        allColumns.append(outputDataList);
        outputDataList.clear();
    }

    return allColumns;
}
