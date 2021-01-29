#ifndef REDSHIFTCONVERSIONS_H
#define REDSHIFTCONVERSIONS_H

#include <QObject>
#include <QString>

class RedshiftConversions : public QObject
{
    Q_OBJECT
    QString queryString;
public:
    explicit RedshiftConversions(QObject *parent = nullptr);

    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);


signals:

};

#endif // REDSHIFTCONVERSIONS_H
