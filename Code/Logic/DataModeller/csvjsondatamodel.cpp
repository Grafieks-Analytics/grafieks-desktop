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
    bool firstLine = true;
    QString delimiter = Statics::separator;
    int columnNumber = 0;

    QFile file(Statics::csvJsonPath);
    file.open(QFile::ReadOnly | QFile::Text);

    if(!file.isOpen()){
        qDebug() << "Cannot open file" << file.errorString();
    } else{

        while(!file.atEnd()){
            const QByteArray line = file.readLine().simplified();
            if(firstLine){

                firstLine = false;
                this->headerDataFinal = line.split(*delimiter.toStdString().c_str());

                if (this->headerDataFinal.at(0).contains("\xEF\xBB\xBF")){
                    this->headerDataFinal[0] =  this->headerDataFinal.at(0).right(this->headerDataFinal.at(0).length() - 3);
                }

                columnNumber = this->headerDataFinal.indexOf(col.toUtf8().constData());
            } else {
                QString colData = line.split(*delimiter.toStdString().c_str()).at(columnNumber);

                if(!this->output.contains(colData)){
                    this->output.append(colData);
                }
            }
        }
    }

    emit columnListModelDataChanged(output, options);
}

void CSVJsonDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{
    QStringList out;
    for(int i = 0; i < this->output.length(); i++){
        if(this->output.at(i).contains(searchString, Qt::CaseInsensitive)){
            out.append(this->output.at(i));
        }
    }

    emit columnListModelDataChanged(out, options);
}

QStringList CSVJsonDataModel::getTableList()
{
    QStringList output;
    QString db = Statics::currentDbName;
    this->fileName       = QFileInfo(db).baseName().toLower();
    this->fileName = this->fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    output.append(this->fileName);
    return output;
}

QStringList CSVJsonDataModel::filterTableList(QString keyword)
{
    QStringList output;
    output << this->fileName;

    output.filter(keyword, Qt::CaseInsensitive);
    return output;
}

