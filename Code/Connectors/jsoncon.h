#ifndef JSONCON_H
#define JSONCON_H

#include <QObject>
#include <QtDebug>
#include <QUrl>
#include <QFile>
#include <QJsonDocument>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>
#include <QDir>

#include <jsoncons/json.hpp>
#include <jsoncons_ext/csv/csv.hpp>

#include "../constants.h"
#include "../Messages.h"
#include "../statics.h"

using namespace jsoncons;
using namespace jsoncons::csv;


class JsonCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;

public:
    explicit JsonCon(QObject *parent = nullptr);
    void closeConnection();
    ~JsonCon();

    QVariantMap JsonInstance(const QString & filepath);

public slots:
    void convertJsonToCsv(QString &jsonPath);

signals:
    void jsonConverted(QString status);

};

#endif // JSONCON_H
