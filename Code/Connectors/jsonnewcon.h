#ifndef JSONNEWCON_H
#define JSONNEWCON_H

#include <QObject>
#include <QtDebug>
#include <QUrl>
#include <QFile>
#include <QJsonDocument>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>
#include <QDir>
#include <QDir>
#include <QHash>



#include "../constants.h"
#include "../Messages.h"
#include "../statics.h"
#include "../json.hpp"

using njson =  nlohmann::json;

class JsonNewCon : public QObject
{
    Q_OBJECT
    QMultiHash<QString, QString> finalValueMap;

public:
    explicit JsonNewCon(QObject *parent = nullptr);
    QMultiHash<QString, QString> flatten_json_to_map(const njson& j);
    void closeConnection();

    QVariantMap JsonInstance(const QString &filepath);

public slots:
    void convertJsonToCsv(QString filepath);

signals:
    void convertedJsonPaths(QString path);
};

#endif // JSONNEWCON_H
