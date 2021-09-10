#ifndef OSENTRIES_H
#define OSENTRIES_H

#include <QObject>
#include <QSettings>
#include <QDebug>

#include "../statics.h"

class OsEntries : public QObject
{
    Q_OBJECT
public:
    explicit OsEntries(QObject *parent = nullptr);

    void witeToWindowsRegistry();
    void writeToMacRegistry();
    void writeToLinuxRegistry();

signals:

};

#endif // OSENTRIES_H
