#include "workbookprocessor.h"

WorkbookProcessor::WorkbookProcessor(GeneralParamsModel *gpm, QObject *parent) : QObject(parent)
{
    this->generalParamsModel = gpm;
}

void WorkbookProcessor::setArguments(QString filePath)
{
    this->filePath = filePath;
}
