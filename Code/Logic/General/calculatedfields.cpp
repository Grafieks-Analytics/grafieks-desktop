#include "calculatedfields.h"

CalculatedFields::CalculatedFields(QObject *parent) : QObject(parent)
{

}

bool CalculatedFields::addCalculatedField(QString name, QString query, QString source, QString mode)
{
    QStringList detailsList;
    if(!this->calculatedFields.contains(name)){

        QString masterSqlQuery = getSqlQuery(query);

        detailsList << name << this->columnName << this->columnType << query << source << masterSqlQuery;
        this->calculatedFields.insert(name, detailsList);

        // Identify source of the db (extract/live)
        // Add calculated column table with field, table names, query (for live)
        // Add table for calculated fields with single result or Add Column fields with same number of rows
        // Fill values

        if(Statics::dsType == Constants::extractType){
            //            saveCalculatedExtractFields(name, this->columnName, this->columnType, masterSqlQuery, source, mode);
            bool status = fetchCalculatedExtractValues(masterSqlQuery);
            if (!status){
                return false;
            }

            bool saveStatus = saveCalculatedExtractFields(name, this->columnName, this->columnType, masterSqlQuery, source, mode);

            if (!saveStatus){
                return false;
            }
        } else {

        }
    }

    qDebug() << "Calc" << this->calculatedFields;
    emit signalCalculatedFields(this->calculatedFields);
    return true;

}

void CalculatedFields::fetchCalculatedFields()
{
    qDebug() << "CALLED FETCH CALCULATED";
    emit signalCalculatedFields(this->calculatedFields);
}

void CalculatedFields::setCalculatedFieldName(QString columnName)
{
    this->columnName = columnName;
}

void CalculatedFields::setCalculatedFieldType(QString columnType)
{
    this->columnType = columnType;
}

void CalculatedFields::dispatchCalculatedField(duckdb::Connection *con)
{

    QString selectQuery = "SELECT * FROM " + Constants::masterCalculatedFieldsTable;
    auto data = con->Query(selectQuery.toStdString());

    if(data->error.empty()){
        int rows = data->collection.Count();


        for(int i = 0; i < rows; i++){
            QStringList values;
            QString key = data->GetValue(0, i).ToString().c_str();

            values.append( data->GetValue(0, i).ToString().c_str());
            values.append( data->GetValue(1, i).ToString().c_str());
            values.append( data->GetValue(2, i).ToString().c_str());
            values.append( data->GetValue(3, i).ToString().c_str());

            this->calculatedFields.insert(key, values);
        }
    } else{
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    }


    qDebug() << "CALLED FETCH CALCULATED SLOT";
    emit signalCalculatedFields(this->calculatedFields);
}

void CalculatedFields::dispatchCalculatedFieldsWithoutConnection()
{
    // Fetch data from duckdb
    QString extractPath = Statics::extractPath;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);
    this->dispatchCalculatedField(&con);
}

QString CalculatedFields::getSqlQuery(QString stdQuery)
{
    QString masterQuery = stdQuery;
    masterQuery.replace("[", "");
    masterQuery.replace("]", "");



    return masterQuery;

}

bool CalculatedFields::saveCalculatedExtractFields(QString name, QString colName, QString colType, QString masterSqlQuery, QString source, QString mode)
{
    QString extractPath = Statics::extractPath;

    try{
        duckdb::DuckDB db(extractPath.toStdString());
        duckdb::Connection con(db);

        QString queryCreateTable = "CREATE TABLE IF NOT EXISTS " + Constants::masterCalculatedFieldsTable + " (name VARCHAR, col_name VARCHAR, col_type VARCHAR, query_base64 VARCHAR, source VARCHAR)";

        auto createTable = con.Query(queryCreateTable.toStdString());
        if(!createTable->error.empty()){
            qDebug() << Q_FUNC_INFO << createTable->success << queryCreateTable << createTable->error.c_str();
            return false;
        }

        QString insertQuery = "INSERT INTO " + Constants::masterCalculatedFieldsTable + " VALUES ('" + name + "', '" + colName +"', '" + colType+ "','" + masterSqlQuery.toUtf8().toBase64() + "', '" + source +"')";

        auto insertQueryTable = con.Query(insertQuery.toStdString());
        if(!insertQueryTable->error.empty()){
            qDebug() << Q_FUNC_INFO << insertQueryTable->success << insertQuery << insertQueryTable->error.c_str();
            return false;
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
        return false;
    }

    return true;
}

bool CalculatedFields::fetchCalculatedExtractValues(QString masterCalculatedFieldsTable)
{
    QString extractPath = Statics::extractPath;
    try{
        duckdb::DuckDB db(extractPath.toStdString());
        duckdb::Connection con(db);


        auto queryTable = con.Query(masterCalculatedFieldsTable.toStdString());
        if(!queryTable->error.empty()){
            qDebug() << Q_FUNC_INFO << queryTable->success << masterCalculatedFieldsTable << queryTable->error.c_str();
            return false;
        }
        queryTable->Print();
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
        return false;
    }

    return true;
}

void CalculatedFields::listCalculatedFields()
{

}
