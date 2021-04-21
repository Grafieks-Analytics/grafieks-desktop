#include "csvcon.h"

CSVCon::CSVCon(QObject *parent) : QObject(parent)
{

}

QVariantMap CSVCon::CSVInstance(const QString &filepath)
{
    QVariantMap outputStatus;
    QFile file(filepath);

    if (!file.open(QIODevice::ReadOnly)) {

            outputStatus.insert("status", false);
            outputStatus.insert("msg", file.errorString());

            file.close();
    }
    else{

        outputStatus.insert("status", true);
        outputStatus.insert("msg", Messages::GeneralSuccessMsg);
    }


    return outputStatus;
}

void CSVCon::closeConnection()
{

    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = -1;
    Statics::currentDbStrType = "";
}

CSVCon::~CSVCon()
{
}


