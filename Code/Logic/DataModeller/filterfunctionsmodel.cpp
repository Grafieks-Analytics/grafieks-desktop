#include "filterfunctionsmodel.h"

FilterFunctionsModel::FilterFunctionsModel(QObject *parent) : QObject(parent)
{

}

//bool FilterFunctionsModel::mSum(QVariantList numbers, float *output)
//{

//}

//float FilterFunctionsModel::mSum(QVariantList numbers)
//{


//}

float FilterFunctionsModel::mAverage(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

float FilterFunctionsModel::mMedian(QVariantList numbers)
{
    Q_UNUSED(numbers);
    return 0.0;

}

float FilterFunctionsModel::mCount(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

float FilterFunctionsModel::mCountdistinct(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

float FilterFunctionsModel::mMinimum(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

float FilterFunctionsModel::mMaximum(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

float FilterFunctionsModel::mPercentile(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

float FilterFunctionsModel::mStddev(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

float FilterFunctionsModel::mStddevpop(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

float FilterFunctionsModel::mvariance(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

float FilterFunctionsModel::mVariancepop(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

int FilterFunctionsModel::sCount(QStringList strings)
{

    Q_UNUSED(strings);
    return 0;
}

int FilterFunctionsModel::sCountdistinct(QStringList strings)
{

    Q_UNUSED(strings);
    return 0;
}

int FilterFunctionsModel::sMinimum(QStringList strings)
{

    Q_UNUSED(strings);
    return 0;
}

int FilterFunctionsModel::sMaximum(QStringList strings)
{

    Q_UNUSED(strings);
    return 0;
}
