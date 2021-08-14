#ifndef DATATYPE_H
#define DATATYPE_H

#include <QObject>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

class DataType : public QObject
{
    Q_OBJECT
public:
    explicit DataType(QObject *parent = nullptr);
    QString dataType(QString parameter);
    QString duckNumericType(QString parameter);

    QString variableType(QString inputVariable);

private:
    bool checkNumberType(QString inputVariable);
    bool checkDateTimeType(QString inputVariable);


signals:

};

#endif // DATATYPE_H
