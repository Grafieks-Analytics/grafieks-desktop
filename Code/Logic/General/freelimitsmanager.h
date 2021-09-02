#ifndef FREELIMITSMANAGER_H
#define FREELIMITSMANAGER_H

#include <QObject>
#include <QFile>
#include <QFileInfo>
#include <QDebug>

class FreeLimitsManager : public QObject
{
    Q_OBJECT
public:
    explicit FreeLimitsManager(QObject *parent = nullptr);

    bool extractSizeLimit(QString extractPath);

signals:

};

#endif // FREELIMITSMANAGER_H
