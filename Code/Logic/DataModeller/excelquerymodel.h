#ifndef EXCELQUERYMODEL_H
#define EXCELQUERYMODEL_H

#include <QObject>
#include <QAbstractTableModel>

class ExcelQueryModel : public QAbstractTableModel
{
    Q_OBJECT
public:
    explicit ExcelQueryModel(QObject *parent = nullptr);

signals:

};

#endif // EXCELQUERYMODEL_H
