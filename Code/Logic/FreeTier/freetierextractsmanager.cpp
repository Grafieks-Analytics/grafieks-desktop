#include "freetierextractsmanager.h"

FreeTierExtractsManager::FreeTierExtractsManager(QObject *parent) : QObject(parent)
{

}

void FreeTierExtractsManager::extractSizeLimit()
{
    QString extractPath = Statics::extractPath;
    int size = 0;
    int maxFreeExtractSize = Constants::freeTierExtractLimit; // This many bytes in a GB

    QFileInfo fileInfo(extractPath);
    size = fileInfo.size();

    QFile file(extractPath);
    file.open(QFile::ReadOnly);

    if(size > maxFreeExtractSize){
        file.remove(extractPath);
        Statics::freeLimitExtractSizeExceeded = true;
    }

}
