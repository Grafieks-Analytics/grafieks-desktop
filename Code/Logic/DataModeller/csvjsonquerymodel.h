#ifndef CSVJSONQUERYMODEL_H
#define CSVJSONQUERYMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QFile>
#include <QDebug>
#include <QString>
#include <QTimer>
#include <QRegExp>

#include "../../duckdb.hpp"
#include "../../constants.h"
#include "../../statics.h"

#include "../General/datatype.h"
#include "../General/generalparamsmodel.h"

#include "./filtercategoricallistmodel.h"
#include "./filterdatelistmodel.h"
#include "./filternumericallistmodel.h"
#include "./filtercsvjson.h"


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
    QStringList dataFinalList;
    QStringList hideParams;

    QMap<int, QString> columnNamesMap;
    int previewRowCount;
    int colCount;

    int totalFiltersCount;
    QMap<int, QString> columnStringTypes;
    QVector<int> rejectIds;
    QMap<int, QString> matchedDateFormats;

    bool m_ifPublish;

public:
    explicit CSVJsonQueryModel(GeneralParamsModel *gpm, QObject *parent = nullptr);
    Q_PROPERTY(bool ifPublish READ ifPublish WRITE setIfPublish NOTIFY ifPublishChanged);

    Q_INVOKABLE void setHideParams(QString hideParams);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);
    Q_INVOKABLE void saveExtractData();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    bool ifPublish() const;

public slots:
    void getAllFilters(FilterCategoricalListModel *categoricalFilter = nullptr, FilterNumericalListModel *numericalFilter = nullptr, FilterDateListModel *dateFilter = nullptr);
    void extractSaved(QString errorMessage);
    void setIfPublish(bool ifPublish);

private:

    void updateModelValues(int previewRowCount = 0);
    void extractSizeLimit();

signals:
    void csvJsonHeaderDataChanged(QStringList tableHeaders);
    void csvJsonDataChanged(QList<QStringList> resultData);
    void csvJsonHasData(bool hasData);
    void generateExtractReports();
    void errorSignal(QString errMsg);
    void clearTablePreview();
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit, bool ifPublish);
    void extractCreationError(QString errorMessage);

    void ifPublishChanged(bool ifPublish);
};

#endif // CSVJSONQUERYMODEL_H
