#include "filterfunctionsmodel.h"

FilterFunctionsModel::FilterFunctionsModel(QObject *parent) : QObject(parent)
{

}

/*!
 * \brief Calculates the sum of the numbers
 * \param numbers (QVariantlist of numbers)
 * \return float
 */
float FilterFunctionsModel::mSum(QVariantList numbers)
{
    float output = 0.0;
    int count = numbers.length();

    for(int i = 0; i < count; i++){
        output += numbers.at(i).toFloat();
    }
    return output;
}

/*!
 * \brief Calculates the average of the numbers
 * \param numbers (QVariantlist of numbers)
 * \return float
 */

float FilterFunctionsModel::mAverage(QVariantList numbers)
{
    float output = 0.0;
    int count = numbers.length();

    for(int i = 0; i < count; i++){
        output += numbers.at(i).toFloat();
    }
    return output/count;
}

/*!
 * \brief Calculates the median of numbers
 * \param numbers (QVariantlist of numbers)
 * \return float
 */

float FilterFunctionsModel::mMedian(QVariantList numbers)
{

    float output = 0.0;
    int length = numbers.length();
    int key = 0;

    std::sort(numbers.begin(), numbers.end());

    if(length % 2 == 0){
        key = length / 2 - 1;
        output = numbers.at(key).toFloat();

    } else{
        key = (length + 1) / 2 - 1;
        output = numbers.at(key).toFloat();
    }
    return output;

}

/*!
 * \brief Returns the count of numbers in the list
 * \param numbers (QVariantlist of numbers)
 * \return int
 */

int FilterFunctionsModel::mCount(QVariantList numbers)
{

    return numbers.length();
}

/*!
 * \brief Returns the distinct count of numbers in the list
 * \param numbers (QVariantlist of numbers)
 * \return int
 */

int FilterFunctionsModel::mCountdistinct(QVariantList numbers)
{

//    QSet<QVariant> set = QSet<QVariant>(numbers.begin(), numbers.end());
//    numbers = set.values();
//    std::sort(numbers.begin(),numbers.end());

//    return numbers.length();
    return 0;
}

/*!
 * \brief Returns the minimum number in the list
 * \param numbers (QVariantlist of numbers)
 * \return float
 */

float FilterFunctionsModel::mMinimum(QVariantList numbers)
{

    std::sort(numbers.begin(), numbers.end());
    float output = numbers.first().toFloat();
    return output;
}

/*!
 * \brief Returns the maximum number in the list
 * \param numbers (QVariantlist of numbers)
 * \return float
 */
float FilterFunctionsModel::mMaximum(QVariantList numbers)
{

    std::sort(numbers.begin(), numbers.end());
    float output = numbers.last().toFloat();
    return output;
}

/*!
 * \brief Returns the percentile of numbers in the list
 * \param numbers (QVariantlist of numbers)
 * \return float
 */
float FilterFunctionsModel::mPercentile(QVariantList numbers, QVariant targetNumber)
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



float FilterFunctionsModel::mvariance(QVariantList numbers)
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
