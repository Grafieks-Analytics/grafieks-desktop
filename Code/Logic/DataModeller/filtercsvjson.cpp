#include "filtercsvjson.h"

FilterCsvJson::FilterCsvJson(QObject *parent) : QObject(parent)
{

}

bool FilterCsvJson::filteredValue(QVariant currentValue, QString valueList, const QString slug)
{
    // **************************** //
    // Filter Relation Slugs
    // Please do not change the order
    // Defined in Constants.h

    QVector<QString> relationSlugs;
    relationSlugs.append(Constants::slugLikeRelation);  //0
    relationSlugs.append(Constants::slugNotLikeRelation); //1
    relationSlugs.append(Constants::slugInRelation); //
    relationSlugs.append(Constants::slugEqualRelation); //3
    relationSlugs.append(Constants::slugNotEqualRelation); //4
    relationSlugs.append(Constants::slugBetweenRelation); //5
    relationSlugs.append(Constants::slugGreaterThanRelation); //6
    relationSlugs.append(Constants::slugSmallerThanRelation); //7
    relationSlugs.append(Constants::slugSmallerThanEqualRelation); //8
    relationSlugs.append(Constants::slugGreaterThanEqualRelation); //9
    relationSlugs.append(Constants::slugContainingRelation); //10
    relationSlugs.append(Constants::slugEndsWithRelation); //11
    relationSlugs.append(Constants::slugDoesntStartWithRelation); //12
    relationSlugs.append(Constants::slugDoesntEndWithRelation); //13

    // Do not change the order

    bool output = false;

    //    qDebug() << currentValue << valueList << slug << "SWITCH";

    switch(relationSlugs.indexOf(slug)){

    case 0:
        break;

    case 1:
        break;

    case 2:{
        QStringList selectedValues = valueList.split(",");
        if(selectedValues.indexOf(currentValue.toString()) >= 0)
            output = true;
        break;
    }

    case 3:
        if(currentValue.toString().toLower() == valueList.toLower())
            output = true;
        break;

    case 4:
        if(currentValue.toDouble() != valueList.toDouble())
            output = true;
        break;

    case 5:
        if(currentValue.toDouble() <= valueList.toDouble())
            output = true;
        break;

    case 6:
        if(currentValue.toDouble() > valueList.toDouble())
            output = true;
        break;

    case 7:
        if(currentValue.toDouble() < valueList.toDouble())
            output = true;
        break;

    case 8:
        if(currentValue.toDouble() <= valueList.toDouble())
            output = true;
        break;

    case 9:
        if(currentValue.toDouble() >= valueList.toDouble())
            output = true;
        break;

    case 10:
        valueList = valueList.left(valueList.length() - 1);
        valueList = valueList.right(1);

        if(currentValue.toString().contains(valueList, Qt::CaseInsensitive))
            output = true;
        break;

    case 11:
        valueList = valueList.right(1);

        if(currentValue.toString().endsWith(valueList, Qt::CaseInsensitive))
            output = true;
        break;

    case 12:
        valueList = valueList.left(valueList.length() - 1);

        if(!currentValue.toString().startsWith(valueList, Qt::CaseInsensitive))
            output = true;
        break;

    case 13:
        valueList = valueList.right(1);

        if(!currentValue.toString().endsWith(valueList, Qt::CaseInsensitive))
            output = true;
        break;

    default:
        qDebug() << Q_FUNC_INFO << "Switch case not detected" << slug;
    }

    return output;
}
