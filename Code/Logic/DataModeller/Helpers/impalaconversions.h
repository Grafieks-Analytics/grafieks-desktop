#ifndef IMPALACONVERSIONS_H
#define IMPALACONVERSIONS_H

#include <QObject>
#include <QString>


class ImpalaConversions : public QObject
{
    Q_OBJECT
    QString queryString;
public:
    explicit ImpalaConversions(QObject *parent = nullptr);
    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);


signals:

};

#endif // IMPALACONVERSIONS_H
