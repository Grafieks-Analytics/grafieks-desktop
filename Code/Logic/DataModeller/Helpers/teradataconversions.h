#ifndef TERADATACONVERSIONS_H
#define TERADATACONVERSIONS_H

#include <QObject>
#include <QString>


class TeradataConversions : public QObject
{
    Q_OBJECT
    QString queryString;

public:
    explicit TeradataConversions(QObject *parent = nullptr);
    QString convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value);


signals:

};

#endif // TERADATACONVERSIONS_H
