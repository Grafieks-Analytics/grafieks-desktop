#ifndef HIVECONVERSIONS_H
#define HIVECONVERSIONS_H

#include <QObject>
#include <QString>

class HiveConversions : public QObject
{
    Q_OBJECT
    QString queryString;
public:
    explicit HiveConversions(QObject *parent = nullptr);
    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);


signals:

};

#endif // HIVECONVERSIONS_H
