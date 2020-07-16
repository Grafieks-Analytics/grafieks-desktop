#ifndef TABLESCHEMAMODEL_H
#define TABLESCHEMAMODEL_H

#include <QObject>
#include <QDebug>

class TableSchemaModel : public QObject
{
    Q_OBJECT
public:
    explicit TableSchemaModel(QObject *parent = nullptr);
    Q_INVOKABLE QString showSchema(QString dbType = "");

signals:

private:


};

#endif // TABLESCHEMAMODEL_H
