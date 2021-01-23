#ifndef TYPECHECK_H
#define TYPECHECK_H

#include <QObject>
#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

class TypeCheck : public QObject
{
    Q_OBJECT
public:
    explicit TypeCheck(QObject *parent = nullptr);

signals:

};

#endif // TYPECHECK_H
