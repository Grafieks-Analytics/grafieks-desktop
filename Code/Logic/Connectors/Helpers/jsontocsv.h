#ifndef JSONTOCSV_H
#define JSONTOCSV_H

#include <QObject>
#include <QFile>
#include <QJsonDocument>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>

#include <jsoncons/json.hpp>
#include <jsoncons_ext/csv/csv.hpp>

using namespace jsoncons;
using namespace jsoncons::csv;

class JsonToCsv : public QObject
{
    Q_OBJECT
public:
    explicit JsonToCsv(QObject *parent = nullptr);

signals:
    void jsonConverted(QString status);

};

#endif // JSONTOCSV_H
