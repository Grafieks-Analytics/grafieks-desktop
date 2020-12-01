#include "proxyfiltermodel.h"

ProxyFilterModel::ProxyFilterModel(QObject *parent) : QObject(parent)
{

}

void ProxyFilterModel::callQueryModels(QString tmpSql, FilterCategoricalListModel *categoryModel, FilterDateListModel *dateModel, FilterNumericalListModel *numericalModel)
{
    QString newQuery;
    QString newWhereConditions;
    QString existingWhereString;

    mQuerySplitter.setQuery(tmpSql);
    newWhereConditions = mQuerySplitter.getWhereCondition();

    QString tmpWhereConditions = newWhereConditions;

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
        newQuery = tmpSql + " WHERE " + newWhereConditions;
    }
    else{

        // Replace the WHERE condition with the new one
        QRegularExpression whereListRegex(R"(\sWHERE\s+(.*?)(?:\s+(?:GROUP|ORDER|LIMIT)\b|\s*$))", QRegularExpression::CaseInsensitiveOption);

        QRegularExpressionMatch whereIterator = whereListRegex.match(tmpSql);
        existingWhereString = whereIterator.captured(1).trimmed();
        newQuery = tmpSql.replace(existingWhereString, newWhereConditions);
    }


    qDebug() << newQuery << "FINAL QUERY";

    emit sendFilterQuery(newQuery);
}
