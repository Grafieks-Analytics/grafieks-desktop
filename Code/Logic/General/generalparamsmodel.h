#ifndef GENERALPARAMSMODEL_H
#define GENERALPARAMSMODEL_H

#include <QObject>
#include <QCoreApplication>
#include <QSettings>
#include <QDebug>

#include "../../statics.h"

class GeneralParamsModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int menuType READ menuType WRITE setMenuType NOTIFY menuTypeChanged)

    int m_menuType;

public:
    explicit GeneralParamsModel(QObject *parent = nullptr);

    Q_INVOKABLE QString getFileToken();
    Q_INVOKABLE QString getTmpPath();
    Q_INVOKABLE QString getDbClassification();

    int menuType() const;

public slots:
    void setMenuType(int menuType);

signals:

    void menuTypeChanged(int menuType);
};

#endif // GENERALPARAMSMODEL_H
