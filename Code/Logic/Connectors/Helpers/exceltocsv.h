#ifndef EXCELTOCSV_H
#define EXCELTOCSV_H

#include <QObject>
#include <QAxObject>
#include <QDebug>
#include <QFile>
#include <QDir>

class ExcelToCsv : public QObject
{
    Q_OBJECT
public:
    explicit ExcelToCsv(QObject *parent = nullptr);
    QStringList convertExcelToCsv(QString &excelPath);

signals:
    void excelConverted(QString status);
};

#endif // EXCELTOCSV_H
