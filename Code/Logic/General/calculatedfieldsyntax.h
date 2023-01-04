#ifndef CALCULATEDFIELDSYNTAX_H
#define CALCULATEDFIELDSYNTAX_H

#include <QObject>
#include <QDebug>

#include "../../constants.h"
#include "../../statics.h"

#include "queryjoiner.h"

class CalculatedFieldSyntax : public QObject
{
    Q_OBJECT
    QueryJoiner queryJoiner;
public:
    explicit CalculatedFieldSyntax(QObject *parent = nullptr);

    QString CaseCondition(QString uniformQuery, QString dsType);

signals:

};

#endif // CALCULATEDFIELDSYNTAX_H
