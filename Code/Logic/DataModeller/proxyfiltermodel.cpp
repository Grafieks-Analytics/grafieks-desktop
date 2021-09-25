#include "proxyfiltermodel.h"

ProxyFilterModel::ProxyFilterModel( QObject *parent) : QObject(parent)
{
}

void ProxyFilterModel::callQueryModels(QString tmpSql, FilterCategoricalListModel *categoryModel, FilterDateListModel *dateModel, FilterNumericalListModel *numericalModel)
{
    QString newQuery;
    QString newWhereConditions;
    QString existingWhereString;
    QString joiner = this->getQueryJoiner();

    mQuerySplitter.setQuery(tmpSql);
    newWhereConditions = mQuerySplitter.getWhereCondition();
    QString tmpWhereConditions = newWhereConditions;

    switch (Statics::currentDbIntType) {

    case Constants::jsonIntType:
    case Constants::csvIntType:{

        emit sendModels(categoryModel, numericalModel, dateModel);
        break;
    }

    case Constants::excelIntType: {

        if(categoryModel->rowCount() > 0){
            QString tempWhereConditions = categoryModel->callQueryModel();
            newWhereConditions += tempWhereConditions;
        }
        if(dateModel->rowCount() > 0){
            QString tempWhereConditions = dateModel->callQueryModel();
            newWhereConditions += tempWhereConditions;
        }
        if(numericalModel->rowCount() > 0){
            QString tempWhereConditions = numericalModel->callQueryModel();
            newWhereConditions += tempWhereConditions;
        }

        if(tmpWhereConditions == ""){

            newWhereConditions = newWhereConditions.remove(0, 4);
            if(newWhereConditions != ""){
                newQuery = tmpSql + " WHERE " + newWhereConditions;
            } else{
                newQuery = tmpSql;
            }
        }
        else{

            // Replace the WHERE condition with the new one
            QRegularExpression whereListRegex(R"(\sWHERE\s+(.*?)(?:\s+(?:GROUP|ORDER|LIMIT)\b|\s*$))", QRegularExpression::CaseInsensitiveOption);

            QRegularExpressionMatch whereIterator = whereListRegex.match(tmpSql);
            existingWhereString = whereIterator.captured(1).trimmed();
            newQuery = tmpSql.replace(existingWhereString, newWhereConditions);
        }

        emit sendExcelFilterQuery(newQuery);

        break;
    }

    default:

        if(categoryModel->rowCount() > 0){
            QString tempWhereConditions = categoryModel->callQueryModel();
            newWhereConditions += tempWhereConditions;
        }
        if(dateModel->rowCount() > 0){
            QString tempWhereConditions = dateModel->callQueryModel();
            newWhereConditions += tempWhereConditions;
        }
        if(numericalModel->rowCount() > 0){
            QString tempWhereConditions = numericalModel->callQueryModel();
            newWhereConditions += tempWhereConditions;
        }

        if(tmpWhereConditions == ""){

            newWhereConditions = newWhereConditions.remove(0, 4);
            if(newWhereConditions != ""){
                newQuery = tmpSql + " WHERE " + newWhereConditions;
            } else{
                newQuery = tmpSql;
            }
        }
        else{

            // Replace the WHERE condition with the new one
            QRegularExpression whereListRegex(R"(\sWHERE\s+(.*?)(?:\s+(?:GROUP|ORDER|LIMIT)\b|\s*$))", QRegularExpression::CaseInsensitiveOption);

            QRegularExpressionMatch whereIterator = whereListRegex.match(tmpSql);
            existingWhereString = whereIterator.captured(1).trimmed();
            newQuery = tmpSql.replace(existingWhereString, newWhereConditions);
        }

        qDebug() << "EMITTING WHERE" << newQuery;

        emit sendFilterQuery(newQuery);
        break;
    }

}

QString ProxyFilterModel::getQueryJoiner()
{

    QString joiner;

    switch(Statics::currentDbIntType){
    case Constants::mysqlIntType:
        joiner = "`";
        break;

    case Constants::mongoIntType:
        joiner = "\"";
        break;

    case Constants::postgresIntType:
        joiner = "\"";
        break;

    case Constants::oracleIntType:
        joiner = "'";
        break;

    case Constants::mssqlIntType:
        joiner = "\"";
        break;

    case Constants::accessIntType:
        joiner = "\"";
        break;
    case Constants::sqliteIntType:
        joiner = "`";
        break;

    case Constants::redshiftIntType:
        joiner = "\"";
        break;

    case Constants::snowflakeIntType:
        joiner = "\"";
        break;

    case Constants::teradataIntType:
        joiner = "\"";
        break;

    case Constants::jsonIntType:
    case Constants::csvIntType:
    case Constants::excelIntType:
        joiner = "\"";
        break;
    }

    return joiner;
}
