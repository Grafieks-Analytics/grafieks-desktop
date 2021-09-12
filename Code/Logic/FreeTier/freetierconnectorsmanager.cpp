#include "freetierconnectorsmanager.h"

FreeTierConnectorsManager::FreeTierConnectorsManager(QObject *parent) : QObject(parent)
{
    this->freeTierConnectors.insert("Dropbox", "/Images/icons/dropbox-2.png");
    this->freeTierConnectors.insert("Google Drive", "/Images/icons/dropbox-2.png");
    this->freeTierConnectors.insert("Google Sheets", "/Images/icons/dropbox-2.png");
    this->freeTierConnectors.insert("Json", "/Images/icons/dropbox-2.png");
    this->freeTierConnectors.insert("Microsoft Access", "/Images/icons/dropbox-2.png");
    this->freeTierConnectors.insert("Mysql", "/Images/icons/dropbox-2.png");
    this->freeTierConnectors.insert("CSV", "/Images/icons/dropbox-2.png");
    this->freeTierConnectors.insert("Postgres", "/Images/icons/dropbox-2.png");
}

QMap<QString, QString> FreeTierConnectorsManager::fetchFreeTierConnectors()
{
    return this->freeTierConnectors;
}
