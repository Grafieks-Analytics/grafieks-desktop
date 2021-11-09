#ifndef SAVELIVEQUERYWORKER_H
#define SAVELIVEQUERYWORKER_H

#include <QObject>
#include <QThread>
#include <QFile>
#include <QFileInfo>
#include <QRegularExpression>
#include <QSqlDatabase>
#include <QDateTime>

#include "../../General/generalparamsmodel.h"

#include "../../../constants.h"
#include "../../../statics.h"
#include "../../../duckdb.hpp"

class SaveLiveQueryWorker : public QThread
{
    Q_OBJECT
    bool ifSavePassword;

public:
    explicit SaveLiveQueryWorker(bool ifSavePassword = false);

protected:
    void run() override;

signals:

};

#endif // SAVELIVEQUERYWORKER_H
