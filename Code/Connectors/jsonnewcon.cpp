#include "jsonnewcon.h"

JsonNewCon::JsonNewCon(QObject *parent) : QObject(parent)
{

}

QHash<QString, QStringList> JsonNewCon::flatten_json_to_map(const njson &j)
{

    auto flattened_j = j.flatten();
    this->finalValueMap.clear();

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

            QStringList tmpValueList;

            if(this->finalValueMap.contains(key)){
                tmpValueList = this->finalValueMap.value(key);
            }

            tmpValueList.append(value);
            this->finalValueMap.insert(key, tmpValueList);
        }


            break;

            // use dump() for all other value types
        default:
            std::string stdKey = entry.key();
            std::string stdValue = entry.value().dump();

            QString key = stdKey.c_str();
            QString value = stdValue.c_str();

            QStringList tmpValueList;

            if(this->finalValueMap.contains(key)){
                tmpValueList = this->finalValueMap.value(key);
            }

            tmpValueList.append(value);
            this->finalValueMap.insert(key, tmpValueList);
            break;
        }
    }


    return this->finalValueMap;
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
    qDebug() << "JSON X" << jsonResponse.isEmpty();
    if(!jsonResponse.isEmpty()){
        njson j = njson::parse(jsonResponse.toJson());
        QHash<QString, QStringList> a =  flatten_json_to_map(j);

        qDebug() << a;
    } else {
        qWarning() << Q_FUNC_INFO << "Empty or bad JSON";
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
