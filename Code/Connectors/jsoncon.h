#ifndef JSONCON_H
#define JSONCON_H

#include <QObject>
#include <QtDebug>
#include <QUrl>
#include <QFile>

#include "../constants.h"
#include "../Messages.h"
#include "../statics.h"

class JsonCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;

public:
    explicit JsonCon(QObject *parent = nullptr);
    QVariantMap JsonInstance(const QString & filepath);

signals:

};

#endif // JSONCON_H
