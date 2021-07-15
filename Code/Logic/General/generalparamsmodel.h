#ifndef GENERALPARAMSMODEL_H
#define GENERALPARAMSMODEL_H

#include <QObject>
#include <QCoreApplication>
#include <QSettings>
#include <QTextDocument>
#include <QDebug>

#include "../../statics.h"

class GeneralParamsModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int menuType READ menuType WRITE setMenuType NOTIFY menuTypeChanged)
    Q_PROPERTY(int currentScreen READ currentScreen WRITE setCurrentScreen NOTIFY currentScreenChanged)

    int m_menuType;
    int m_currentScreen;

public:
    explicit GeneralParamsModel(QObject *parent = nullptr);

    Q_INVOKABLE QString getFileToken();
    Q_INVOKABLE QString getTmpPath();
    Q_INVOKABLE QString getDbClassification();
    Q_INVOKABLE QString getCurrentDB();
    Q_INVOKABLE int getOnlineStorageType();
    Q_INVOKABLE QString returnPlainTextFromHtml(QString s);
    Q_INVOKABLE void loadingComplete();

    int menuType() const;    
    int currentScreen() const;

public slots:
    void setMenuType(int menuType);
    void setCurrentScreen(int currentScreen);

signals:

    void menuTypeChanged(int menuType);
    void currentScreenChanged(int currentScreen);
    void hideSplash();
};

#endif // GENERALPARAMSMODEL_H
