#include "freelimitsmanager.h"

FreeLimitsManager::FreeLimitsManager(QObject *parent) : QObject(parent)
{

}

bool FreeLimitsManager::extractSizeLimit(QString extractPath)
{
    int size = 0;
    int maxFreeExtractSize = 1024; // This many bytes in a GB
    bool deleted = false;

    QFileInfo fileInfo(extractPath);
    size = fileInfo.size();

    qDebug() << size << maxFreeExtractSize << "SIZE SET";

    QFile file(extractPath);
    file.open(QFile::ReadOnly);

    if(size > maxFreeExtractSize){
        file.remove(extractPath);
        deleted = true;
    }

    return deleted;
}
