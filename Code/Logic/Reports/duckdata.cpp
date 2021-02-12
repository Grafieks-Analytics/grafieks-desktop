#include "duckdata.h"

DuckData::DuckData(QObject *parent) : QObject(parent)
{

}

DuckData::DuckData(DuckCRUD *duckCRUD, QObject *parent)
{
    Q_UNUSED(parent);
    this->duckCRUD = duckCRUD;
}


