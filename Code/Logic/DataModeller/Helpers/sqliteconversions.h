#ifndef SQLITECONVERSIONS_H
#define SQLITECONVERSIONS_H

#include <QObject>
#include <QString>

class SqliteConversions : public QObject
{
    Q_OBJECT
    QString queryString;

public:
    explicit SqliteConversions(QObject *parent = nullptr);

    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);

signals:

};

#endif // SQLITECONVERSIONS_H
