#include "csvjsonquerymodel.h"

CSVJsonQueryModel::CSVJsonQueryModel(GeneralParamsModel *gpm, QObject *parent) : QAbstractTableModel(parent),
    categoricalFilter(nullptr), numericalFilter(nullptr), dateFilter(nullptr), totalFiltersCount(0)
{
    this->generalParamsModel = gpm;
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

    SaveExtractCsvJsonWorker *saveExtractCsvJsonWorker = new SaveExtractCsvJsonWorker(this->categoricalFilter, this->numericalFilter, this->dateFilter, this->totalFiltersCount, this->hideParams, this->generalParamsModel->getChangedColumnTypes());
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

bool CSVJsonQueryModel::ifPublish() const
{
    return m_ifPublish;
}

void CSVJsonQueryModel::getAllFilters(FilterCategoricalListModel *categoricalFilter, FilterNumericalListModel *numericalFilter, FilterDateListModel *dateFilter)
{
    this->categoricalFilter = categoricalFilter;
    this->numericalFilter = numericalFilter;
    this->dateFilter = dateFilter;
    this->totalFiltersCount = 0;

    if(this->categoricalFilter != nullptr) this->totalFiltersCount += categoricalFilter->getFilters().count();
    if(this->numericalFilter != nullptr) this->totalFiltersCount += numericalFilter->getFilters().count();
    if(this->dateFilter != nullptr) this->totalFiltersCount += dateFilter->getFilters().count();

    emit clearTablePreview();
    this->updateModelValues(0);
}

void CSVJsonQueryModel::extractSaved(QString errorMessage)
{
    // Delete if the extract size is larger than the permissible limit
    // This goes using QTimer because, syncing files cannot be directly deleted

    if(errorMessage.length() == 0){
        QTimer::singleShot(Constants::timeDelayCheckExtractSize, this, &CSVJsonQueryModel::extractSizeLimit);
    } else {
        emit extractCreationError(errorMessage);
    }
}

void CSVJsonQueryModel::setIfPublish(bool ifPublish)
{
    if (m_ifPublish == ifPublish)
        return;

    m_ifPublish = ifPublish;
    emit ifPublishChanged(m_ifPublish);
}


void CSVJsonQueryModel::updateModelValues(int previewRowCount)
{
    emit clearTablePreview();

    QFile file(Statics::csvJsonPath);
    file.open(QFile::ReadOnly | QFile::Text);

    QString db = Statics::currentDbName;
    db = QFileInfo(db).baseName().toLower();
    db = db.remove(QRegularExpression("[^A-Za-z0-9]"));

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

        QByteArray line = file.readLine().simplified();
        QString lineAsString = QString(line);
        QRegularExpression rx(delimiter + "(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
        this->dataFinalList = lineAsString.split(rx);

        if(firstLine){

            firstLine = false;

//            if (this->dataFinalList.at(0).contains("\xEF\xBB\xBF")){
//                this->dataFinalList[0] =  this->dataFinalList.at(0).right(this->dataFinal.at(0).length() - 3);
//            }

            for(int i = 0; i < this->dataFinalList.length(); i++){
                if(!this->hideParams.contains(this->dataFinalList.at(i))){
                    this->headerDataPreview.append(db + "." + this->dataFinalList.at(i));
                } else {
                    this->rejectIds.append(i);
                }
                this->columnNamesMap.insert(i, this->dataFinalList.at(i));
            }



        } else {

            if(previewRowCount > 0)
                if(readLine == previewRowCount) break;


            if(this->totalFiltersCount > 0){


                if(categoricalFilter != nullptr)
                    foreach(FilterCategoricalList *tmpCategoricalFilter, this->categoricalFilter->getFilters()){
                        int key = this->columnNamesMap.key(tmpCategoricalFilter->columnName());
                        bool returnVar = filterCsvJson.filteredValue(this->dataFinalList.at(key), tmpCategoricalFilter->value(), tmpCategoricalFilter->slug());
                        truthList.append(returnVar);
                    }

                if(numericalFilter != nullptr){
                    foreach(FilterNumericalList *tmpNumericalFilter, this->numericalFilter->getFilters()){
                        int key = this->columnNamesMap.key(tmpNumericalFilter->columnName());
                        bool returnVar = filterCsvJson.filteredValue(this->dataFinalList.at(key), tmpNumericalFilter->value(), tmpNumericalFilter->slug());
                        truthList.append(returnVar);
                    }
                }

                if(dateFilter != nullptr){
                    foreach(FilterDateList *tmpDateFilter, this->dateFilter->getFilters()){
                        int key = this->columnNamesMap.key(tmpDateFilter->columnName());
                        bool returnVar = filterCsvJson.filteredValue(this->dataFinalList.at(key), tmpDateFilter->value(), tmpDateFilter->slug());
                        truthList.append(returnVar);
                    }
                }

                if(!truthList.contains(false)){
                    QStringList x;
                    int i = 0;
                    foreach(QString a, this->dataFinalList){
                        if(!this->rejectIds.contains(i)){
                            x.append(a);
                        }

                        i++;
                    }

                    this->resultData.append(x);
                    readLine++;
                }

                truthList.clear();
            } else {

                QRegularExpression rx( delimiter + "(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
                QStringList colData = lineAsString.split(rx);
                QStringList x;
                int i = 0;
                foreach(QString a, colData){
                    if(!this->rejectIds.contains(i)){
                        x.append(a);
                    }
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

    endResetModel();

    emit errorSignal("");
    emit csvJsonDataChanged(this->resultData);
    emit csvJsonHeaderDataChanged(this->headerDataPreview);
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
        if(!file.remove(extractPath))
            qDebug() << Q_FUNC_INFO << file.errorString();

        Statics::freeLimitExtractSizeExceeded = true;
        emit extractFileExceededLimit(true, m_ifPublish);
    } else {
        emit extractFileExceededLimit(false, m_ifPublish);
    }

    emit showSaveExtractWaitPopup();

    if(Statics::freeLimitExtractSizeExceeded == true){
        Statics::freeLimitExtractSizeExceeded = false;
    } else {
        emit generateExtractReports();
    }
}
