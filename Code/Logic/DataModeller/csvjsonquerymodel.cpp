#include "csvjsonquerymodel.h"

CSVJsonQueryModel::CSVJsonQueryModel(QObject *parent) : QAbstractTableModel(parent),
    categoricalFilter(nullptr), numericalFilter(nullptr), dateFilter(nullptr), totalFiltersCount(0)
{

}

void CSVJsonQueryModel::setHideParams(QString hideParams)
{
    emit clearTablePreview();
    this->hideParams = hideParams.split(",");
    for(int i = 0; i < this->hideParams.length(); i++){
        if(this->hideParams.at(i).contains(".")){
            QStringList tmpHideParam = this->hideParams.at(i).split(".");
            this->hideParams[i] = tmpHideParam.at(1);
        }
    }
}

void CSVJsonQueryModel::setPreviewQuery(int previewRowCount)
{
    this->updateModelValues(previewRowCount);
}

void CSVJsonQueryModel::saveExtractData()
{

    SaveExtractCsvJsonWorker *saveExtractCsvJsonWorker = new SaveExtractCsvJsonWorker(this->categoricalFilter, this->numericalFilter, this->dateFilter, this->totalFiltersCount, this->hideParams);
    connect(saveExtractCsvJsonWorker, &SaveExtractCsvJsonWorker::saveExtractComplete, this, &CSVJsonQueryModel::extractSaved, Qt::QueuedConnection);
    connect(saveExtractCsvJsonWorker, &SaveExtractCsvJsonWorker::finished, saveExtractCsvJsonWorker, &SaveExtractCsvJsonWorker::deleteLater, Qt::QueuedConnection);

    saveExtractCsvJsonWorker->start();
}

int CSVJsonQueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->previewRowCount;
}

int CSVJsonQueryModel::columnCount(const QModelIndex &) const
{
    return this->colCount;
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

void CSVJsonQueryModel::getAllFilters(FilterCategoricalListModel *categoricalFilter, FilterNumericalListModel *numericalFilter, FilterDateListModel *dateFilter)
{
    this->categoricalFilter = categoricalFilter;
    this->numericalFilter = numericalFilter;
    this->dateFilter = dateFilter;

    if(this->categoricalFilter != nullptr) this->totalFiltersCount += categoricalFilter->getFilters().count();
    if(this->numericalFilter != nullptr) this->totalFiltersCount += numericalFilter->getFilters().count();
    if(this->dateFilter != nullptr) this->totalFiltersCount += dateFilter->getFilters().count();

    this->updateModelValues(0);
}

void CSVJsonQueryModel::extractSaved()
{
    // Delete if the extract size is larger than the permissible limit
    // This goes using QTimer because, syncing files cannot be directly deleted

    FreeLimitsManager freeLimitsManager;
    QTimer::singleShot(1000, this, &CSVJsonQueryModel::extractSizeLimit);

    emit showSaveExtractWaitPopup();

    if(Statics::freeLimitExtractSizeExceeded == true){
        Statics::freeLimitExtractSizeExceeded = false;
    } else {
        emit generateReports();
    }
}

void CSVJsonQueryModel::receiveCsvJsonFilterQuery(QString query)
{
    qDebug() << "CSV JSON QUERY" << query;
}


void CSVJsonQueryModel::updateModelValues(int previewRowCount)
{
    QFile file(Statics::csvJsonPath);
    file.open(QFile::ReadOnly | QFile::Text);

    QString delimiter = Statics::separator;
    bool firstLine = true;
    int readLine = 0;
    QVector<bool> truthList;

    beginResetModel();

    this->resultData.clear();
    this->columnNamesMap.clear();
    this->headerDataPreview.clear();
    this->rejectIds.clear();

    while(!file.atEnd()){

        const QByteArray line = file.readLine().simplified();
        this->dataFinal = line.split(*delimiter.toStdString().c_str());

        if(firstLine){

            firstLine = false;

            if (this->dataFinal.at(0).contains("\xEF\xBB\xBF")){
                this->dataFinal[0] =  this->dataFinal.at(0).right(this->dataFinal.at(0).length() - 3);
            }

            for(int i = 0; i < this->dataFinal.length(); i++){
                if(!this->hideParams.contains(this->dataFinal.at(i).toStdString().c_str())){
                    this->columnNamesMap.insert(i, this->dataFinal.at(i).toStdString().c_str());
                    this->headerDataPreview.append(this->dataFinal.at(i).toStdString().c_str());
                } else {
                    this->rejectIds.append(i);
                }
            }

        } else {

            if(previewRowCount > 0){
                if(readLine == previewRowCount) break;
            }

            if(this->totalFiltersCount > 0){

                if(categoricalFilter != nullptr)
                    foreach(FilterCategoricalList *tmpCategoricalFilter, this->categoricalFilter->getFilters()){
                        int key = this->columnNamesMap.key(tmpCategoricalFilter->columnName());
                        bool returnVar = filterCsvJson.filteredValue(this->dataFinal.at(key), tmpCategoricalFilter->value(), tmpCategoricalFilter->slug());
                        truthList.append(returnVar);
                    }

                if(numericalFilter != nullptr){
                    foreach(FilterNumericalList *tmpNumericalFilter, this->numericalFilter->getFilters()){
                        int key = this->columnNamesMap.key(tmpNumericalFilter->columnName());
                        bool returnVar = filterCsvJson.filteredValue(this->dataFinal.at(key), tmpNumericalFilter->value(), tmpNumericalFilter->slug());
                        truthList.append(returnVar);
                    }
                }

                if(dateFilter != nullptr){
                    foreach(FilterDateList *tmpDateFilter, this->dateFilter->getFilters()){
                        int key = this->columnNamesMap.key(tmpDateFilter->columnName());
                        bool returnVar = filterCsvJson.filteredValue(this->dataFinal.at(key), tmpDateFilter->value(), tmpDateFilter->slug());
                        truthList.append(returnVar);
                    }
                }


                if(!truthList.contains(false)){
                    QStringList x;
                    int i = 0;
                    foreach(QByteArray a, this->dataFinal){
                        if(!this->rejectIds.contains(i))
                            x.append(a.toStdString().c_str());

                        i++;
                    }
                    this->resultData.append(x);
                }

                truthList.clear();
            } else {


                QList<QByteArray> colData = line.split(*delimiter.toStdString().c_str());
                QStringList x;
                int i = 0;
                foreach(QByteArray a, colData){
                    if(!this->rejectIds.contains(i))
                        x.append(a.toStdString().c_str());
                    i++;
                }
                this->resultData.append(x);

                readLine++;
            }
        }
    }

    this->colCount = this->headerDataPreview.count();
    this->previewRowCount = this->resultData.count();
    file.close();


    this->resultData.count() > 0 ? emit csvJsonHasData(true) : emit csvJsonHasData(false);


    emit errorSignal("");
    emit csvJsonHeaderDataChanged(this->headerDataPreview);

    endResetModel();
}



void CSVJsonQueryModel::extractSizeLimit()
{
    QString extractPath = Statics::extractPath;
    int size = 0;
    int maxFreeExtractSize = Constants::freeTierExtractLimit; // This many bytes in a GB

    QFile fileInfo(extractPath);
    fileInfo.open(QFile::ReadWrite);
    fileInfo.setPermissions(QFileDevice::WriteUser | QFileDevice::ReadUser | QFileDevice::ExeUser);

    size = fileInfo.size();
    fileInfo.close();

    QFile file(extractPath);
    if(size > maxFreeExtractSize){
        if(!file.remove(extractPath)){
            qDebug() << Q_FUNC_INFO << file.errorString();
        } else {
            Statics::freeLimitExtractSizeExceeded = true;
        }
        emit extractFileExceededLimit(true);
    } else {
        emit extractFileExceededLimit(false);
    }
}
