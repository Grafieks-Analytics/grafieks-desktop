#ifndef MONGOCONVERSIONS_H
#define MONGOCONVERSIONS_H

#include <QObject>
#include <QString>

class MongoConversions : public QObject
{
    Q_OBJECT
    QString queryString;
public:
    explicit MongoConversions(QObject *parent = nullptr);

    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);


signals:

};

#endif // MONGOCONVERSIONS_H
