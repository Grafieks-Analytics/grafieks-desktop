#include "jsonnewcon.h"

JsonNewCon::JsonNewCon(QObject *parent) : QObject(parent)
{
    this->finalValueMap.clear();
}

QMultiHash<QString, QString> JsonNewCon::flatten_json_to_map(const njson &j)
{
    QMultiHash<QString, QString> result;

    auto flattened_j = j.flatten();

    for (auto entry : flattened_j.items())
    {
        switch (entry.value().type())
        {
        // avoid escaping string value
        case njson::value_t::string:{
            std::string stdKey = entry.key();
            std::string stdValue = entry.value();

            QString key = stdKey.c_str();
            QString value = stdValue.c_str();

            result.insert(key, value);
        }


            break;

            // use dump() for all other value types
        default:
            std::string stdKey = entry.key();
            std::string stdValue = entry.value().dump();

            QString key = stdKey.c_str();
            QString value = stdValue.c_str();

            result.insert(key, value);
            break;
        }
    }
    return result;
}

void JsonNewCon::closeConnection()
{
    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = -1;
    Statics::currentDbStrType = "";
}

QVariantMap JsonNewCon::JsonInstance(const QString &filepath)
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

        this->convertJsonToCsv(filepath);
    }

    return outputStatus;
}

void JsonNewCon::convertJsonToCsv(QString filepath)
{
    QString jsonPath = filepath;
    QFile jsonFile;
    jsonFile.setFileName(jsonPath);
    jsonFile.open(QIODevice::ReadOnly | QIODevice::Text);


    QJsonDocument jsonResponse = QJsonDocument::fromJson(jsonFile.readAll());

    if(!jsonResponse.isEmpty()){
        njson j = njson::parse(jsonResponse.toJson());
        QMultiHash<QString, QString> finalOutput =  flatten_json_to_map(j);

        qDebug() << finalOutput;
    } else {
        qWarning() << Q_FUNC_INFO << "Empty or bad json";
    }


//    ojson j = ojson::parse(jsonResponse.toJson());

//    std::string output;
//    csv::encode_csv(j, output);


//    QFile csvFile;
//    QFileInfo fi(jsonPath);

//    QString outPath = QDir::tempPath() + "/" + fi.completeBaseName();
//    csvFile.setFileName(outPath);
//    if( csvFile.open(QIODevice::WriteOnly | QIODevice::Text))
//    {
//        QTextStream stream(&csvFile);
//        stream << output.c_str();

//        csvFile.close();
//    }

//    jsonFile.close();
//    emit convertedJsonPaths(outPath);
}
