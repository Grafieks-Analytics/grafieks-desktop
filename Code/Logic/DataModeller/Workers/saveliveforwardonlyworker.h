#ifndef SAVELIVEFORWARDONLYWORKER_H
#define SAVELIVEFORWARDONLYWORKER_H

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

class SaveLiveForwardOnlyWorker : public QThread
{
    Q_OBJECT
    bool ifSavePassword;

public:
    explicit SaveLiveForwardOnlyWorker(bool ifSavePassword = false);

protected:
    void run() override;

signals:

};

#endif // SAVELIVEFORWARDONLYWORKER_H
