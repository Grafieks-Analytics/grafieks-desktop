#ifndef REPORTSLISTMODEL_H
#define REPORTSLISTMODEL_H


#include <QObject>

#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"

class ReportsListModel : public QObject
{
    Q_OBJECT
    QStringList reportsList;

public:
    explicit ReportsListModel(QObject *parent = nullptr);
    ~ReportsListModel();

    Q_INVOKABLE void fetchReports(QStringList);

signals:
    void reportsListData(QStringList reportsList);

};

#endif // REPORTSLISTMODEL_H
