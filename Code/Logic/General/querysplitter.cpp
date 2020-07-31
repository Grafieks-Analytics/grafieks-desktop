#include "querysplitter.h"

QuerySplitter::QuerySplitter(QObject *parent) : QObject(parent)
{

}

void QuerySplitter::setQuery(QString &query)
{
    Q_UNUSED(query);
}
