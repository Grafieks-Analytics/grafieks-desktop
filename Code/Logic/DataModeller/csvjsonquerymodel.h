#ifndef CSVJSONQUERYMODEL_H
#define CSVJSONQUERYMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QFile>
#include <QDebug>
#include <QString>
#include <QTimer>

#include "../../duckdb.hpp"
#include "../../constants.h"
#include "../../statics.h"

#include "../General/datatype.h"
#include "../General/generalparamsmodel.h"

#include "./filtercategoricallistmodel.h"
#include "./filterdatelistmodel.h"
#include "./filternumericallistmodel.h"
#include "./filtercsvjson.h"
#include "../FreeTier/freetierextractsmanager.h"


#include "./Workers/saveextractcsvjsonworker.h"

class CSVJsonQueryModel : public QAbstractTableModel
{
    Q_OBJECT
    FilterCategoricalListModel *categoricalFilter;
    FilterNumericalListModel *numericalFilter;
    FilterDateListModel *dateFilter;
    FilterCsvJson filterCsvJson;
    DataType dataType;
    GeneralParamsModel *generalParamsModel;

    QStringList headerDataPreview;
    QHash<int, QByteArray> m_roleNames;
    QList<QStringList> resultData;
    QList<QByteArray> dataFinal;
    QStringList hideParams;

    QMap<int, QString> columnNamesMap;
    int previewRowCount;
    int colCount;

    int totalFiltersCount;
    QMap<int, QString> columnStringTypes;
    QVector<int> rejectIds;
    QMap<int, QString> matchedDateFormats;

public:
    explicit CSVJsonQueryModel(GeneralParamsModel *gpm, QObject *parent = nullptr);

    Q_INVOKABLE void setHideParams(QString hideParams);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);
    Q_INVOKABLE void saveExtractData();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;


public slots:
    void getAllFilters(FilterCategoricalListModel *categoricalFilter = nullptr, FilterNumericalListModel *numericalFilter = nullptr, FilterDateListModel *dateFilter = nullptr);
    void extractSaved(QString errorMessage);

private:

    void updateModelValues(int previewRowCount = 0);
    void extractSizeLimit();

signals:
    void csvJsonHeaderDataChanged(QStringList tableHeaders);
    void csvJsonHasData(bool hasData);
    void generateReports();
    void errorSignal(QString errMsg);
    void clearTablePreview();
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit);
    void extractCreationError(QString errorMessage);

};

#endif // CSVJSONQUERYMODEL_H
