#include "datatype.h"

DataType::DataType(QObject *parent) : QObject(parent)
{

}


/*!
 * \brief Returns custom datatype of the queried column name
 * \param parameter (table column type)
 * \return QString
 */
QString DataType::dataType(QString parameter)
{

    QString output;
    QStringList categorical, numerical, dateformat;


    categorical << "varchar" << "char" << "text" << "tinytext" << "mediumtext" << "longtext" << "boolean" <<"character varying" << "nvarchar" << "character"
                << "varying character" << "nchar" << "native character" << "clob" << "ntext" << "varchar2" << "nvarchar2" << "nclob"
                << "urowid" << "rowid" << "string" << "symbol" << "bpchar"
                << "memo" << "yes/no" << "hyperlink" << "short text" << "long text"
                << "QString" << "CF" << "CV";

    numerical   << "int" << "tinyint" << "smallint" << "mediumint" << "bigint" << "decimal" << "float" << "double" << "real" << "integer" << "serial" << "bigserial"
                << "double precision" << "numeric" << "smallserial" << "unsigned big int" << "int2" << "int8" << "dec" << "bit" << "smallmoney" << "money"
                << "binary_float" << "binary_double" << "int1" << "int2" << "short" << "float4" << "int4" << "signed" << "float8" << "long" << "int8"
                << "large number" << "autonumber" << "number"
                << "I8" << "I1" << "D" << "F" << "I" << "N" << "D" << "I2"
                << "uint" << "ushort" << "ulong";

    dateformat << "date" << "datetime" << "timestamp" << "time" << "year"
               << "timestamp without time zone" << "timestamp with time zone"
               << "time without time zone" << "time with time zone" << "interval"
               << "datetimeoffset" << "smalldatetime" << "datetime2" << "timestamp with time zone" << "timestamp with local timezone"
               << "interval year" << "interval day"
               << "date/time" << "date/time extended"
               << "DA" << "DY" << "DH" << "DM" << "DS" << "HR" << "HM" << "HS" << "MI" << "MS" << "MO" << "SC" << "YR" << "YM" << "PD" << "PZ" << "PT" << "PS" << "PM" << "AT" << "TS" << "TZ" << "SZ"
               << "QDateTime";

    // Match the incoming parameter and determine filter type

    if(categorical.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::categoricalType;
    } else if(numerical.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::numericalType;
    } else if(dateformat.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::dateType;
    } else{
        qDebug() << "INPUT PARAM OTHER TYPE" << parameter;
        output =  Constants::otherType;
    }

    return output;

}
