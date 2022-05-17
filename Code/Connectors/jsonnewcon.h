#ifndef JSONNEWCON_H
#define JSONNEWCON_H

#include <QObject>
#include <QDebug>
#include <QVariantMap>

#include "../json.hpp"

using njson =  nlohmann::json;

class JsonNewCon : public QObject
{
    Q_OBJECT
public:
    explicit JsonNewCon(QObject *parent = nullptr);

    QVariantMap flatten_json_to_map(const njson& j);

signals:

};

#endif // JSONNEWCON_H
