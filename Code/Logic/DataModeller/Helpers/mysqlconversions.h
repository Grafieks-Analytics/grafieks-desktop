#ifndef MYSQLCONVERSIONS_H
#define MYSQLCONVERSIONS_H

#include <QObject>
#include <QString>

class MysqlConversions : public QObject
{
    Q_OBJECT
    QString queryString;
public:
    explicit MysqlConversions(QObject *parent = nullptr);

    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);

signals:

};

#endif // MYSQLCONVERSIONS_H
