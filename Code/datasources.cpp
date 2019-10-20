#include "Headers/datasources.h"

Datasources::Datasources(QObject *parent) : QObject(parent)
{

}

int Datasources::saveDataSources(int my_datasource_id, QString source_type, QString datasource_name, QString description, QString image_link, QString owner_name)
{

    int returnVar, connectionsInsertId;
    QSqlQuery query;

    query.prepare("INSERT INTO datasources (my_datasource_id, source_type, datasource_name, description, image_link, owner_name) VALUES (?, ?, ?, ?, ?, ?)");

    query.addBindValue(my_datasource_id);
    query.addBindValue(source_type);
    query.addBindValue(datasource_name);
    query.addBindValue(description);
    query.addBindValue(image_link);
    query.addBindValue(owner_name);

    if(query.exec()){
        returnVar = query.lastInsertId().toInt();

        // Save to Connections
        connectionsInsertId = this->saveConnections();

        // Save to Datasource Connections Map
        this->saveMappings(returnVar, connectionsInsertId);

    }
    else{
        returnVar = 0;
    }

    return returnVar;
}

bool Datasources::saveMappings(int datasource_id, int connection_id)
{
    bool returnVar;
    QSqlQuery query;
    query.prepare("INSERT INTO datasource_connections (datasource_id, connection_id) VALUES (?, ?)");

    query.addBindValue(datasource_id);
    query.addBindValue(connection_id);


    if(query.exec()){
        returnVar = true;
    }
    else{
        returnVar = false;
    }

    return returnVar;
}

int Datasources::saveConnections()
{
    int returnVar;
    QSqlQuery query;
    QString database_type, connection_string;

    query.exec("SELECT * FROM temp_connections WHERE id=1");
    while(query.next()){

        database_type = query.value(1).toString();
        connection_string = query.value(2).toString();
    }

    query.exec("INSERT INTO connections (database_type, connection_string) VALUES (?, ?)");

    query.addBindValue(database_type);
    query.addBindValue(connection_string);


    if(query.exec()){

        returnVar = query.lastInsertId().toInt();

    }
    else{
        returnVar = 0;
    }

    return returnVar;
}

QVariantList Datasources::fetchDatasources()
{
    QVariantList returnVar;
    QVariantMap queryResults;
    QSqlQuery query;

    query.exec("SELECT * FROM datasources");

    while(query.next())
    {
        queryResults.insert("source_type", query.value(2).toString());
        queryResults.insert("datasource_name", query.value(3).toString());
        queryResults.insert("description", query.value(4).toString());
        queryResults.insert("image_link", query.value(5).toString());
        queryResults.insert("owner_name", query.value(6).toString());

        returnVar.append(queryResults);
        queryResults.clear();
    }

    return returnVar;
}

QString Datasources::dsName() const
{
    return m_dsName;
}

QString Datasources::dsDescription() const
{
    return m_dsDescription;
}

QString Datasources::dsImage() const
{
    return m_dsImage;
}

QString Datasources::dsOwner() const
{
    return m_dsOwner;
}

QString Datasources::sourceType() const
{
    return m_sourceType;
}

void Datasources::setDsName(QString dsName)
{
    if (m_dsName == dsName)
        return;

    m_dsName = dsName;
    emit dsNameChanged(m_dsName);
}

void Datasources::setDsDescription(QString dsDescription)
{
    if (m_dsDescription == dsDescription)
        return;

    m_dsDescription = dsDescription;
    emit dsDescriptionChanged(m_dsDescription);
}

void Datasources::setDsImage(QString dsImage)
{
    if (m_dsImage == dsImage)
        return;

    m_dsImage = dsImage;
    emit dsImageChanged(m_dsImage);
}

void Datasources::setDsOwner(QString dsOwner)
{
    if (m_dsOwner == dsOwner)
        return;

    m_dsOwner = dsOwner;
    emit dsOwnerChanged(m_dsOwner);
}

void Datasources::setSourceType(QString sourceType)
{
    if (m_sourceType == sourceType)
        return;

    m_sourceType = sourceType;
    emit sourceTypeChanged(m_sourceType);
}
