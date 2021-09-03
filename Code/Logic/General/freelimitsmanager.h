#ifndef FREELIMITSMANAGER_H
#define FREELIMITSMANAGER_H

#include <QObject>
#include <QFile>
#include <QFileInfo>
#include <QDebug>

#include "../../statics.h"

class FreeLimitsManager : public QObject
{
    Q_OBJECT
public:
    explicit FreeLimitsManager(QObject *parent = nullptr);

    void extractSizeLimit();

signals:

};

#endif // FREELIMITSMANAGER_H
