#ifndef DUCKDATA_H
#define DUCKDATA_H

#include <QObject>
#include <QMap>
#include <QList>
#include <QUrl>
#include <QDir>
#include <QDebug>

#include "../Connectors/duckcrud.h"

class DuckData : public QObject
{
    Q_OBJECT
    DuckCRUD *duckCRUD;

public:
    explicit DuckData(QObject *parent = nullptr);
    explicit DuckData(DuckCRUD *duckCRUD, QObject *parent = nullptr);

signals:

private:
    QMap<QString,int> colIndex;

};

#endif // DUCKDATA_H
