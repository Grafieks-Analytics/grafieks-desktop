#ifndef SAVEEXTRACTCSVJSONWORKER_H
#define SAVEEXTRACTCSVJSONWORKER_H

#include <QObject>
#include <QThread>
#include <QDebug>

#include "../../General/datatype.h"
#include "../filtercategoricallistmodel.h"
#include "../filternumericallistmodel.h"
#include "../filterdatelistmodel.h"
#include "../filtercsvjson.h"

#include "../../../duckdb.hpp"
#include "../../../statics.h"
#include "../../../constants.h"

class SaveExtractCsvJsonWorker : public QThread
{
    Q_OBJECT

    FilterCategoricalListModel *categoricalFilter;
    FilterNumericalListModel *numericalFilter;
    FilterDateListModel *dateFilter;
    FilterCsvJson filterCsvJson;
    DataType dataType;

    int totalFiltersCount;
    QStringList hideParams;

    QMap<int, QString> columnNamesMap;
    QList<QByteArray> dataFinal;
    QVector<int> rejectIds;
    QMap<int, QString> columnStringTypes;
    QMap<int, QString> matchedDateFormats;


public:
    explicit SaveExtractCsvJsonWorker(FilterCategoricalListModel *categoricalFilter = nullptr, FilterNumericalListModel *numericalFilter = nullptr, FilterDateListModel *dateFilter = nullptr, int totalFiltersCount = 0, QStringList hideParams = QStringList());

private:
    void appendExtractData(duckdb::Appender *appender);
    void createExtractDb(QFile *file, QString fileName, duckdb::Connection con);
protected:
    void run() override;

signals:
    void saveExtractComplete(duckdb::Connection *con);

};

#endif // SAVEEXTRACTCSVJSONWORKER_H
