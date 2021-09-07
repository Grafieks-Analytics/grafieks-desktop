#ifndef OSENTRIES_H
#define OSENTRIES_H

#include <QObject>
#include <QSettings>
#include <QDebug>

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
