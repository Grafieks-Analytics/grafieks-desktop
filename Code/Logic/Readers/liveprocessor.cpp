#include "liveprocessor.h"

LiveProcessor::LiveProcessor(GeneralParamsModel *gpm, DSParamsModel *dsp, QObject *parent) : QObject(parent)
{
    this->generalParamsModel = gpm;
    this->dsParamsModel = dsp;
}

void LiveProcessor::setArguments(QString filePath)
{
    this->filePath = filePath;
}
