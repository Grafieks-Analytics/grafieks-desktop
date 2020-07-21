#ifndef TABLECOLUMNMODEL_H
#define TABLECOLUMNMODEL_H

#include <QObject>

class TableColumnModel : public QObject
{
    Q_OBJECT
public:
    explicit TableColumnModel(QObject *parent = nullptr);

signals:

};

#endif // TABLECOLUMNMODEL_H
