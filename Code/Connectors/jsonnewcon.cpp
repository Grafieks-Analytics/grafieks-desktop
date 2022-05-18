#include "jsonnewcon.h"

JsonNewCon::JsonNewCon(QObject *parent) : QObject(parent)
{


    // create JSON value
//    njson j =R"({
//"problems": [{
//    "Diabetes":[{
//        "medications":[{
//            "medicationsClasses":[{
//                "className":[{
//                    "associatedDrug":[{
//                        "name":"asprin",
//                        "dose":"",
//                        "strength":"500 mg"
//                    }],
//                    "associatedDrug#2":[{
//                        "name":"somethingElse",
//                        "dose":"",
//                        "strength":"500 mg"
//                    }]
//                }],
//                "className2":[{
//                    "associatedDrug":[{
//                        "name":"asprin",
//                        "dose":"",
//                        "strength":"500 mg"
//                    }],
//                    "associatedDrug#2":[{
//                        "name":"somethingElse",
//                        "dose":"",
//                        "strength":"500 mg"
//                    }]
//                }]
//            }]
//        }],
//        "labs":[{
//            "missing_field": "missing_value"
//        }]
//    }],
//    "Asthma":[{}]
//}]})"_json;

//    QHash<QString, QString> a =  flatten_json_to_map(j);

//    qDebug() << a;
}

QHash<QString, QString> JsonNewCon::flatten_json_to_map(const njson &j)
{
    QHash<QString, QString> result;

    auto flattened_j = j.flatten();

    for (auto entry : flattened_j.items())
    {
        switch (entry.value().type())
        {
        // avoid escaping string value
        case njson::value_t::string:{
            std::string x =  entry.value();
            result.insert(entry.key().c_str(), x.c_str());
        }


            break;

            // use dump() for all other value types
        default:
            result[entry.key().c_str()] = entry.value().dump().c_str();
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
    njson j = njson::parse(jsonResponse.toJson());
    QHash<QString, QString> a =  flatten_json_to_map(j);

    qDebug() << a;

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
