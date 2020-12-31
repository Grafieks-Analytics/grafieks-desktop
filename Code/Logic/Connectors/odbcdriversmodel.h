#ifndef ODBCDRIVERSMODEL_H
#define ODBCDRIVERSMODEL_H

#include <QObject>
#include <QDebug>
#include <QSettings>
#include <QtGlobal>

class ODBCDriversModel : public QObject
{
    Q_OBJECT
public:
    explicit ODBCDriversModel(QObject *parent = nullptr);

    Q_INVOKABLE QStringList fetchOdbcDrivers(QString &db);

signals:

private:
    QStringList fetchWindowsODBCDrivers();
    QStringList fetchMacODBCDrivers();

};

#endif // ODBCDRIVERSMODEL_H
