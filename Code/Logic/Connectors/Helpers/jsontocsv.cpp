#include "jsontocsv.h"

JsonToCsv::JsonToCsv(QObject *parent) : QObject(parent)
{
    QString path = "C:\\Users\\chill\\Projects\\build-GrafieksDesktop-Desktop_Qt_5_15_2_MSVC2019_64bit-Debug\\debug\\1.json";

    QFile jsonFile;
    jsonFile.setFileName(path);
    jsonFile.open(QIODevice::ReadOnly | QIODevice::Text);
    QString input = jsonFile.readAll();
    jsonFile.close();

    QJsonDocument jsonResponse = QJsonDocument::fromJson(input.toUtf8());
    ojson j = ojson::parse(jsonResponse.toJson());
    std::string output;
    csv::encode_csv(j, output);


    QFile csvFile;
    QString outPath = "C:\\Users\\chill\\Desktop\\last.csv";
    csvFile.setFileName(outPath);
    if( csvFile.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        QTextStream stream(&csvFile);
        stream << output.c_str();

        csvFile.close();
        qDebug() << "Writing finished";
    }

}
