#ifndef FREETIEREXTRACTSMANAGER_H
#define FREETIEREXTRACTSMANAGER_H

#include <QObject>
#include <QFile>
#include <QFileInfo>
#include <QDebug>

#include "../../statics.h"
#include "../../constants.h"

class FreeTierExtractsManager : public QObject
{
    Q_OBJECT
public:
    explicit FreeTierExtractsManager(QObject *parent = nullptr);

    void extractSizeLimit();

signals:

};

#endif // FREETIEREXTRACTSMANAGER_H
