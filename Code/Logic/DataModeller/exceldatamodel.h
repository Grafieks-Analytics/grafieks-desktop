#ifndef EXCELDATAMODEL_H
#define EXCELDATAMODEL_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>

#include <QFile>
#include <QAxObject>
#include <QDir>

#include "../../constants.h"
#include "../../Messages.h"
#include "../../statics.h"


class ExcelDataModel : public QObject
{
    Q_OBJECT
    QMap<int, QString> sheetNamesMap;
public:
    explicit ExcelDataModel(QObject *parent = nullptr);
    Q_INVOKABLE void clearData();
    ~ExcelDataModel();


    Q_INVOKABLE void columnData(QString col, QString tableName, QString options);
    Q_INVOKABLE void columnSearchData(QString col, QString tableName, QString searchString, QString options);
    Q_INVOKABLE QStringList getTableList();
    Q_INVOKABLE QStringList filterTableList(QString keyword);
    Q_INVOKABLE QStringList getDbList();

private:
    QString getQueryJoiner();
    QStringList getTableListQAXObject();

signals:

};

#endif // EXCELDATAMODEL_H
