#include "jsonnewcon.h"

JsonNewCon::JsonNewCon(QObject *parent) : QObject(parent)
{

    // create JSON value
    njson j =R"({
"problems": [{
    "Diabetes":[{
        "medications":[{
            "medicationsClasses":[{
                "className":[{
                    "associatedDrug":[{
                        "name":"asprin",
                        "dose":"",
                        "strength":"500 mg"
                    }],
                    "associatedDrug#2":[{
                        "name":"somethingElse",
                        "dose":"",
                        "strength":"500 mg"
                    }]
                }],
                "className2":[{
                    "associatedDrug":[{
                        "name":"asprin",
                        "dose":"",
                        "strength":"500 mg"
                    }],
                    "associatedDrug#2":[{
                        "name":"somethingElse",
                        "dose":"",
                        "strength":"500 mg"
                    }]
                }]
            }]
        }],
        "labs":[{
            "missing_field": "missing_value"
        }]
    }],
    "Asthma":[{}]
}]})"_json;

    //    json flattened = j.flatten();
    QVariantMap a =  flatten_json_to_map(j);

    qDebug() << a;
}

QVariantMap JsonNewCon::flatten_json_to_map(const njson &j)
{
    QVariantMap result;

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
