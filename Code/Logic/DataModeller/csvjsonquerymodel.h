#ifndef CSVJSONQUERYMODEL_H
#define CSVJSONQUERYMODEL_H

#include <QObject>
#include <QFile>
#include <QDebug>

#include "../../duckdb.hpp"

class CSVJsonQueryModel : public QObject
{
    Q_OBJECT
public:
    explicit CSVJsonQueryModel(QObject *parent = nullptr);

signals:

};

#endif // CSVJSONQUERYMODEL_H