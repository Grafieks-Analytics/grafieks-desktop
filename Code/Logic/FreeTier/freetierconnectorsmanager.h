#ifndef FREETIERCONNECTORSMANAGER_H
#define FREETIERCONNECTORSMANAGER_H

#include <QObject>
#include <QMap>

class FreeTierConnectorsManager : public QObject
{
    Q_OBJECT
    QMap<QString, QString> freeTierConnectors;


public:
    explicit FreeTierConnectorsManager(QObject *parent = nullptr);
    QMap<QString, QString> fetchFreeTierConnectors();

signals:

};

#endif // FREETIERCONNECTORSMANAGER_H
