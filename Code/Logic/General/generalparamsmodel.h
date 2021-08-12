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

    //! Return plain text from html
    Q_INVOKABLE QString returnPlainTextFromHtml(QString s);

    //! Application loading complete. To hide splash screen
    Q_INVOKABLE void loadingComplete();

    //! Current selected left side menu
    int menuType() const;    

    //! Current screen selector for highlighting the left menu
    int currentScreen() const;

public slots:

    //! Set the current highlighted left menu
    void setMenuType(int menuType);

    //! Set current screen to highlight the respective left menu
    void setCurrentScreen(int currentScreen);

signals:

    void menuTypeChanged(int menuType);
    void currentScreenChanged(int currentScreen);
    void hideSplash();
};

#endif // GENERALPARAMSMODEL_H
