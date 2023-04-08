#include "calculatedfieldsyntax.h"

CalculatedFieldSyntax::CalculatedFieldSyntax(QObject *parent) : QObject(parent)
{

}

QString CalculatedFieldSyntax::CaseCondition(QString uniformQuery, QString dsType)
{
    QString output;
    QString queryJoinerString;
    qDebug() << "UNIFORM" << Statics::currentDbIntType << Statics::currentDbClassification << dsType <<  queryJoiner.getQueryJoiner(Statics::currentDbIntType) << uniformQuery;

//        if [FIELD] < 6000 THEN "A" elseif [FIELD]  >= 6000 and [FIELD] < 9000 THEN "B" else "C" endif

    if(dsType == Constants::extractType){
        queryJoinerString = "\"";
    } else {
        queryJoinerString = queryJoiner.getQueryJoiner(Statics::currentDbIntType);
    }

    output = uniformQuery.replace("[", queryJoinerString)
            .replace("]", queryJoinerString)
            .replace(" elseif ", " WHEN ")
            .replace("if ", " SELECT CASE WHEN ")
            .replace("endif", " END");
    qDebug() << output;


    return output;


}
