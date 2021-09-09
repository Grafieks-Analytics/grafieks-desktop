#include "liveprocessor.h"

LiveProcessor::LiveProcessor(GeneralParamsModel *gpm, QObject *parent) : QObject(parent)
{
    this->generalParamsModel = gpm;
}

void LiveProcessor::setArguments(QString filePath)
{
    this->filePath = filePath;
}
