#ifndef EXCELTOCSV_H
#define EXCELTOCSV_H

#include <QObject>

class ExcelToCsv : public QObject
{
    Q_OBJECT
public:
    explicit ExcelToCsv(QString &jsonPath, QObject *parent = nullptr);

signals:
    void excelConverted(QString status);
};

#endif // EXCELTOCSV_H
