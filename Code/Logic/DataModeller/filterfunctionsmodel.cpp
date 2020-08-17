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

/*!
 * \brief Calculates the average of the numbers
 * \param numbers (QVariantlist of numbers)
 * \return float
 */

float FilterFunctionsModel::mAverage(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

/*!
 * \brief Calculates the median of numbers
 * \param numbers (QVariantlist of numbers)
 * \return float
 */

float FilterFunctionsModel::mMedian(QVariantList numbers)
{
    Q_UNUSED(numbers);
    return 0.0;

}

/*!
 * \brief Returns the count of numbers in the list
 * \param numbers (QVariantlist of numbers)
 * \return int
 */

int FilterFunctionsModel::mCount(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0;
}

/*!
 * \brief Returns the distinct count of numbers in the list
 * \param numbers (QVariantlist of numbers)
 * \return int
 */

int FilterFunctionsModel::mCountdistinct(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0;
}

/*!
 * \brief Returns the minimum number in the list
 * \param numbers (QVariantlist of numbers)
 * \return float
 */

float FilterFunctionsModel::mMinimum(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

/*!
 * \brief Returns the maximum number in the list
 * \param numbers (QVariantlist of numbers)
 * \return float
 */
float FilterFunctionsModel::mMaximum(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

/*!
 * \brief Returns the percentile of numbers in the list
 * \param numbers (QVariantlist of numbers)
 * \return float
 */
float FilterFunctionsModel::mPercentile(QVariantList numbers)
{

    Q_UNUSED(numbers);
    return 0.0;
}

/*!
 * \brief Returns the standard deviation of numbers in the list
 * \param numbers (QVariantlist of numbers)
 * \return float
 */
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
