#ifndef JSONTOCSV_H
#define JSONTOCSV_H

#include <QObject>
#include <QFile>
#include <QJsonDocument>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>

class JsonToCsv : public QObject
{
    Q_OBJECT
public:
    explicit JsonToCsv(QString &jsonPath, QObject *parent = nullptr);

signals:
    void jsonConverted(QString status);

};

#endif // JSONTOCSV_H
