#ifndef MSSQLCONVERSIONS_H
#define MSSQLCONVERSIONS_H

#include <QObject>
#include <QString>

class MssqlConversions : public QObject
{
    Q_OBJECT
    QString queryString;

public:
    explicit MssqlConversions(QObject *parent = nullptr);

    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);

signals:

};

#endif // MSSQLCONVERSIONS_H
