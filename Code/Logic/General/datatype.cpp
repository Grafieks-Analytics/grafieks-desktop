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


    categorical << "varchar" << "char" << "text" << "tinytext" << "mediumtext" << "longtext" << "boolean" ;
    numerical << "int" << "tinyint" << "smallint" << "mediumint" << "bigint" << "decimal" << "float" << "double" << "real";
    dateformat << "date" << "datetime" << "timestamp" << "time" << "year";

    // Match the incoming parameter and determine filter type

    if(categorical.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::categoricalType;
    } else if(numerical.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::numericalType;
    } else if(dateformat.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::dateType;
    } else{
        output =  Constants::otherType;
    }

    return output;

}
