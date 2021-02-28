#include "jsoncon.h"

JsonCon::JsonCon(QObject *parent) : QObject(parent)
{

}

QVariantMap JsonCon::JsonInstance(const QString &filepath)
{
    QVariantMap outputStatus;
    QFile file(filepath);

    if (!file.open(QIODevice::ReadOnly)) {

            outputStatus.insert("status", false);
            outputStatus.insert("msg", file.errorString());
    }
    else{

        outputStatus.insert("status", true);
        outputStatus.insert("msg", Messages::GeneralSuccessMsg);
    }

    return outputStatus;

}
