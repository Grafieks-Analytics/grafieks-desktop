#ifndef FILTERFUNCTIONSMODEL_H
#define FILTERFUNCTIONSMODEL_H

#include <QVariant>
#include <QObject>

class FilterFunctionsModel : public QObject
{
    Q_OBJECT
public:
    explicit FilterFunctionsModel(QObject *parent = nullptr);

    // Mathematical functions

//    Q_INVOKABLE bool mSum(QVariantList numbers, int * output);
//    Q_INVOKABLE bool mSum(QVariantList numbers, float * output);
    Q_INVOKABLE float mAverage(QVariantList numbers);
    Q_INVOKABLE float mMedian(QVariantList numbers);
    Q_INVOKABLE float mCount(QVariantList numbers);
    Q_INVOKABLE float mCountdistinct(QVariantList numbers);
    Q_INVOKABLE float mMinimum(QVariantList numbers);
    Q_INVOKABLE float mMaximum(QVariantList numbers);
    Q_INVOKABLE float mPercentile(QVariantList numbers);
    Q_INVOKABLE float mStddev(QVariantList numbers);
    Q_INVOKABLE float mStddevpop(QVariantList numbers);
    Q_INVOKABLE float mvariance(QVariantList numbers);
    Q_INVOKABLE float mVariancepop(QVariantList numbers);

    // String functions
    Q_INVOKABLE int sCount(QStringList strings);
    Q_INVOKABLE int sCountdistinct(QStringList strings);
    Q_INVOKABLE int sMinimum(QStringList strings); // doubt
    Q_INVOKABLE int sMaximum(QStringList strings); // doubt

signals:

};

#endif // FILTERFUNCTIONSMODEL_H
