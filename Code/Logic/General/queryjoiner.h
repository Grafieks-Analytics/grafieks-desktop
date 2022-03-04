#ifndef QUERYJOINER_H
#define QUERYJOINER_H

#include <QObject>

#include "../../constants.h"

class QueryJoiner : public QObject
{
    Q_OBJECT
public:
    explicit QueryJoiner(QObject *parent = nullptr);
    QString getQueryJoiner(int dbType);

signals:

};

#endif // QUERYJOINER_H
