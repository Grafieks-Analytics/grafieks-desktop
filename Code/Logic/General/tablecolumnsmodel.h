#ifndef TABLECOLUMNSMODEL_H
#define TABLECOLUMNSMODEL_H

#include <QObject>


/*!
 * \class TableColumnsModel
 * \brief Lists column names and data types for a given sql table
 * \ingroup General
 */
class TableColumnsModel : public QObject
{
    Q_OBJECT
public:
    explicit TableColumnsModel(QObject *parent = nullptr);

signals:

};

#endif // TABLECOLUMNSMODEL_H
