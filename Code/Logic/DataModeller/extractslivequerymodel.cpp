#include "extractslivequerymodel.h"

ExtractsLiveQueryModel::ExtractsLiveQueryModel(QObject *parent) : QObject(parent)
{

}

void ExtractsLiveQueryModel::hideSaveDSPopup(){
    emit showSaveExtractWaitPopup();
}
