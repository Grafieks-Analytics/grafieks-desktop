#ifndef SNOWFLAKECONVERSIONS_H
#define SNOWFLAKECONVERSIONS_H

#include <QObject>
#include <QString>

class SnowflakeConversions : public QObject
{
    Q_OBJECT
    QString queryString;

public:
    explicit SnowflakeConversions(QObject *parent = nullptr);
    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);


signals:

};

#endif // SNOWFLAKECONVERSIONS_H
