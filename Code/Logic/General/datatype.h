#ifndef DATATYPE_H
#define DATATYPE_H

#include <QObject>
#include <QDate>
#include <QDateTime>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

class DataType : public QObject
{
    Q_OBJECT
public:
    explicit DataType(QObject *parent = nullptr);

    //! return datatype - categorical/numerical/date
    //! for classification only
    QString dataType(QString parameter);


    //! Get variable type classification from value
    //! for extract data type
    QStringList variableType(QString inputVariable);

    //! Get variable type classification from QSqlRecord field type (QVariant)
    //! for extract data type
    QString qVariantType(QString inputVariable);

    // TO CHANGE - MAKE PRIVATE
    bool checkNumberType(QString inputVariable);
    QVariantList checkDateTimeType(QString inputVariable);

private:



signals:

};

#endif // DATATYPE_H
