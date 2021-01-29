#ifndef ORACLECONVERSIONS_H
#define ORACLECONVERSIONS_H

#include <QObject>
#include <QString>


class OracleConversions : public QObject
{
    Q_OBJECT
    QString queryString;

public:
    explicit OracleConversions(QObject *parent = nullptr);

    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);


signals:

};

#endif // ORACLECONVERSIONS_H
