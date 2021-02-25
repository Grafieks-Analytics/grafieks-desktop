#include "jsontocsv.h"

JsonToCsv::JsonToCsv(QString &jsonPath, QObject *parent) : QObject(parent)
{

    QFile file(jsonPath);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QJsonObject jsonDoc = QJsonDocument::fromJson(file.readAll()).object();

    qDebug() << jsonDoc << "JSON DOC";
    file.close();



}
