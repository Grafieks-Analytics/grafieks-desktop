#include "csvjsonquerymodel.h"

CSVJsonQueryModel::CSVJsonQueryModel(QObject *parent) : QAbstractTableModel(parent)
{

}

void CSVJsonQueryModel::setSelectParams(QString selectParams)
{
    qDebug() << "SELPARK" << selectParams;
}

void CSVJsonQueryModel::setPreviewQuery(int previewRowCount)
{
    QFile file(Statics::csvJsonPath);
    file.open(QFile::ReadOnly | QFile::Text);
    int readLine = 0;
    bool firstLine = true;
    QString delimiter = Statics::separator;

    beginResetModel();

    if(file.isOpen()){

        while(!file.atEnd()){

            if(readLine == previewRowCount){
                break;
            }

            const QByteArray line = file.readLine().simplified();
            if(firstLine){
                QList<QByteArray> tmpHeaderData;

                firstLine = false;
                tmpHeaderData = line.split(*delimiter.toStdString().c_str());

                if (tmpHeaderData.at(0).contains("\xEF\xBB\xBF")){
                    tmpHeaderData[0] =  tmpHeaderData.at(0).right(tmpHeaderData.at(0).length() - 3);
                }

                foreach(QByteArray a, tmpHeaderData){
                    this->headerDataFinal.append(a.toStdString().c_str());
                }

            } else {
                QList<QByteArray> colData = line.split(*delimiter.toStdString().c_str());
                QStringList x;
                foreach(QByteArray a, colData){
                    x.append(a.toStdString().c_str());
                }
                this->resultData.append(x);

            }
            readLine++;


        }
    }

    qDebug() << readLine << previewRowCount << "COUNTEREE";
    this->previewRowCount = readLine - 1;

    if(readLine > 0){
        emit csvJsonHasData(true);
    } else{
        emit csvJsonHasData(false);
    }

    endResetModel();
    emit csvJsonHeaderDataChanged(this->headerDataFinal);
}

int CSVJsonQueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->previewRowCount;
}

int CSVJsonQueryModel::columnCount(const QModelIndex &) const
{
    return this->headerDataFinal.count();
}

QVariant CSVJsonQueryModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    return QVariant();
}

QVariant CSVJsonQueryModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->resultData[index.row()][index.column()];
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> CSVJsonQueryModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}
