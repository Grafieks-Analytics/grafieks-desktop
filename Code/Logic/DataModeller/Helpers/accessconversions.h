#ifndef ACCESSCONVERSIONS_H
#define ACCESSCONVERSIONS_H

#include <QObject>
#include <QString>


class AccessConversions : public QObject
{
    Q_OBJECT
    QString queryString;
public:
    explicit AccessConversions(QObject *parent = nullptr);
    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);

signals:

};

#endif // ACCESSCONVERSIONS_H
