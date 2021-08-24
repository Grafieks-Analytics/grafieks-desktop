#include "csvjsonquerymodel.h"

CSVJsonQueryModel::CSVJsonQueryModel(QObject *parent) : QAbstractTableModel(parent),
    categoricalFilter(nullptr), numericalFilter(nullptr), dateFilter(nullptr), totalFiltersCount(0)
{

}

void CSVJsonQueryModel::setHideParams(QString hideParams)
{
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

void CSVJsonQueryModel::receiveCsvJsonFilterQuery(QString query)
{
    qDebug() << "CSV JSON QUERY" << query;
}

bool CSVJsonQueryModel::filteredValue(QVariant currentValue, QString valueList, const QString slug)
{
    // **************************** //
    // Filter Relation Slugs
    // Please do not change the order
    // Defined in Constants.h

    QVector<QString> relationSlugs;
    relationSlugs.append(Constants::slugLikeRelation);  //0
    relationSlugs.append(Constants::slugNotLikeRelation); //1
    relationSlugs.append(Constants::slugInRelation); //
    relationSlugs.append(Constants::slugEqualRelation); //3
    relationSlugs.append(Constants::slugNotEqualRelation); //4
    relationSlugs.append(Constants::slugBetweenRelation); //5
    relationSlugs.append(Constants::slugGreaterThanRelation); //6
    relationSlugs.append(Constants::slugSmallerThanRelation); //7
    relationSlugs.append(Constants::slugSmallerThanEqualRelation); //8
    relationSlugs.append(Constants::slugGreaterThanEqualRelation); //9
    relationSlugs.append(Constants::slugContainingRelation); //10
    relationSlugs.append(Constants::slugEndsWithRelation); //11
    relationSlugs.append(Constants::slugDoesntStartWithRelation); //12
    relationSlugs.append(Constants::slugDoesntEndWithRelation); //13

    // Do not change the order

    bool output = false;

    //    qDebug() << currentValue << valueList << slug << "SWITCH";

    switch(relationSlugs.indexOf(slug)){

    case 0:
        break;

    case 1:
        break;

    case 2:{
        QStringList selectedValues = valueList.split(",");
        if(selectedValues.indexOf(currentValue.toString()) >= 0)
            output = true;
        break;
    }

    case 3:
        if(currentValue.toString().toLower() == valueList.toLower())
            output = true;
        break;

    case 4:
        if(currentValue.toDouble() != valueList.toDouble())
            output = true;
        break;

    case 5:
        if(currentValue.toDouble() <= valueList.toDouble())
            output = true;
        break;

    case 6:
        if(currentValue.toDouble() > valueList.toDouble())
            output = true;
        break;

    case 7:
        if(currentValue.toDouble() < valueList.toDouble())
            output = true;
        break;

    case 8:
        if(currentValue.toDouble() <= valueList.toDouble())
            output = true;
        break;

    case 9:
        if(currentValue.toDouble() >= valueList.toDouble())
            output = true;
        break;

    case 10:
        valueList = valueList.left(valueList.length() - 1);
        valueList = valueList.right(1);

        if(currentValue.toString().contains(valueList, Qt::CaseInsensitive))
            output = true;
        break;

    case 11:
        valueList = valueList.right(1);

        if(currentValue.toString().endsWith(valueList, Qt::CaseInsensitive))
            output = true;
        break;

    case 12:
        valueList = valueList.left(valueList.length() - 1);

        if(!currentValue.toString().startsWith(valueList, Qt::CaseInsensitive))
            output = true;
        break;

    case 13:
        valueList = valueList.right(1);

        if(!currentValue.toString().endsWith(valueList, Qt::CaseInsensitive))
            output = true;
        break;

    default:
        qDebug() << Q_FUNC_INFO << "Switch case not detected" << slug;
    }

    return output;
}

void CSVJsonQueryModel::updateModelValues(int previewRowCount)
{
    QFile file(Statics::csvJsonPath);
    file.open(QFile::ReadOnly | QFile::Text);

    QString delimiter = Statics::separator;
    bool firstLine = true;
    int readLine = 0;
    QVector<bool> truthList;
    QVector<int> rejectIds;

    this->resultData.clear();
    this->headerDataPreview.clear();

    beginResetModel();


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
                    rejectIds.append(i);
                }
            }

        } else {


            if(this->totalFiltersCount > 0){

                if(categoricalFilter != nullptr)
                    foreach(FilterCategoricalList *tmpCategoricalFilter, this->categoricalFilter->getFilters()){
                        int key = this->columnNamesMap.key(tmpCategoricalFilter->columnName());
                        bool returnVar = filteredValue(this->dataFinal.at(key), tmpCategoricalFilter->value(), tmpCategoricalFilter->slug());
                        truthList.append(returnVar);
                    }

                if(numericalFilter != nullptr){
                    foreach(FilterNumericalList *tmpNumericalFilter, this->numericalFilter->getFilters()){
                        int key = this->columnNamesMap.key(tmpNumericalFilter->columnName());
                        bool returnVar = filteredValue(this->dataFinal.at(key), tmpNumericalFilter->value(), tmpNumericalFilter->slug());
                        truthList.append(returnVar);
                    }
                }

                if(dateFilter != nullptr){
                    foreach(FilterDateList *tmpDateFilter, this->dateFilter->getFilters()){
                        int key = this->columnNamesMap.key(tmpDateFilter->columnName());
                        bool returnVar = filteredValue(this->dataFinal.at(key), tmpDateFilter->value(), tmpDateFilter->slug());
                        truthList.append(returnVar);
                    }
                }


                if(!truthList.contains(false)){
                    QStringList x;
                    int i = 0;
                    foreach(QByteArray a, this->dataFinal){
                        if(!rejectIds.contains(i))
                            x.append(a.toStdString().c_str());

                        i++;
                    }
                    this->resultData.append(x);
                }

                truthList.clear();
            } else {

                if(readLine == previewRowCount) break;

                QList<QByteArray> colData = line.split(*delimiter.toStdString().c_str());
                QStringList x;
                int i = 0;
                foreach(QByteArray a, colData){
                    if(!rejectIds.contains(i))
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


    if(this->resultData.count() > 0){
        qDebug() << "Row count" << this->resultData.count() << "Col count" << this->colCount;
        qDebug() << "Total filters" << this->totalFiltersCount;
        emit csvJsonHasData(true);
    } else{
        emit csvJsonHasData(false);
    }
    endResetModel();


    emit csvJsonHeaderDataChanged(this->headerDataPreview);
}
