#ifndef POSTGRESCONVERSIONS_H
#define POSTGRESCONVERSIONS_H

#include <QObject>
#include <QString>

class PostgresConversions : public QObject
{
    Q_OBJECT
    QString queryString;
public:
    explicit PostgresConversions(QObject *parent = nullptr);

    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);

signals:

};

#endif // POSTGRESCONVERSIONS_H
