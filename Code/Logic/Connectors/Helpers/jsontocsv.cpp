#include "jsontocsv.h"

JsonToCsv::JsonToCsv(QObject *parent) : QObject(parent)
{

}

QString JsonToCsv::convertJsonToCsv(QString &jsonPath)
{

    QFile jsonFile;
    jsonFile.setFileName(jsonPath);
    jsonFile.open(QIODevice::ReadOnly | QIODevice::Text);
    QString input = jsonFile.readAll();
    jsonFile.close();

    QJsonDocument jsonResponse = QJsonDocument::fromJson(input.toUtf8());
    ojson j = ojson::parse(jsonResponse.toJson());
    std::string output;
    csv::encode_csv(j, output);


    QFile csvFile;
    QFileInfo fi(jsonPath);

    QString outPath = QDir::tempPath() + fi.completeBaseName();
    csvFile.setFileName(outPath);
    if( csvFile.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        QTextStream stream(&csvFile);
        stream << output.c_str();

        csvFile.close();
    }

    return outPath;
}
