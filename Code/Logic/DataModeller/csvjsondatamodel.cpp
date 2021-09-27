#include "csvjsondatamodel.h"

CSVJsonDataModel::CSVJsonDataModel(QObject *parent) : QAbstractTableModel(parent)
{
    this->totalColCount = 1;
}


CSVJsonDataModel::~CSVJsonDataModel()
{

}

int CSVJsonDataModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->totalRowCount;
}

int CSVJsonDataModel::columnCount(const QModelIndex &) const
{
    return this->totalColCount;
}

QVariant CSVJsonDataModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    return QVariant();
}

QVariant CSVJsonDataModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->modelOutput[index.row()];
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> CSVJsonDataModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
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

                for(int i = 0; i < this->headerDataFinal.length(); i++){
                    this->m_roleNames.insert(i, this->headerDataFinal.at(i));
                }

                columnNumber = this->headerDataFinal.indexOf(col.toUtf8().constData());
                this->m_roleNames.insert(0, col.toUtf8());
            } else {
                QString colData = line.split(*delimiter.toStdString().c_str()).at(columnNumber);

                if(!this->masterResultData.contains(colData)){
                    this->masterResultData.append(colData);
                }
            }
        }
    }
    this->modelOutput.clear();
    this->modelOutput = this->masterResultData;
    this->totalRowCount = this->masterResultData.length();

    emit columnListModelDataChanged(options);
}

void CSVJsonDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{
    this->modelOutput.clear();
    QStringList output = this->masterResultData.filter(searchString, Qt::CaseInsensitive);
    this->modelOutput = output;
    this->totalRowCount = output.length();
    emit columnListModelDataChanged(options);
}

QStringList CSVJsonDataModel::getTableList()
{

    QString db = Statics::currentDbName;
    this->fileName       = QFileInfo(db).baseName().toLower();
    this->fileName = this->fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    this->output.append(this->fileName);
    return this->output;
}

QStringList CSVJsonDataModel::filterTableList(QString keyword)
{

    return this->output.filter(keyword, Qt::CaseInsensitive);
}

QStringList CSVJsonDataModel::getDateColumnData()
{
    return this->modelOutput;
}

