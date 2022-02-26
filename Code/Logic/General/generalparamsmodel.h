#ifndef GENERALPARAMSMODEL_H
#define GENERALPARAMSMODEL_H

#include <QObject>
#include <QCoreApplication>
#include <QSettings>
#include <QTextDocument>
#include <QDebug>
#include <QUrl>
#include <QRandomGenerator>
#include <QProcess>

#include "../../statics.h"
#include "../../constants.h"

class GeneralParamsModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int menuType READ menuType WRITE setMenuType NOTIFY menuTypeChanged)
    Q_PROPERTY(int currentScreen READ currentScreen WRITE setCurrentScreen NOTIFY currentScreenChanged)

    int m_menuType;
    int m_currentScreen;
    QVariantMap changedHeaderTypes; // QMap<tableName.columnName, newColumnType>

    bool setForLiveFile;
    bool setForLiveQuery;

public:
    explicit GeneralParamsModel(QObject *parent = nullptr);

    Q_INVOKABLE QString getFileToken();
    Q_INVOKABLE QString getTmpPath();
    Q_INVOKABLE QString getDbClassification();
    Q_INVOKABLE QString getCurrentDB();
    Q_INVOKABLE bool isWorkbookInEditMode();
    Q_INVOKABLE void openNewGrafieksInstance();

    Q_INVOKABLE QVariantMap getAppInfo();

    Q_INVOKABLE int getOnlineStorageType();

    //! Return plain text from html
    Q_INVOKABLE QString returnPlainTextFromHtml(QString s);

    //! Application loading complete. To hide splash screen
    Q_INVOKABLE void loadingComplete();

    //! Current selected left side menu
    int menuType() const;    

    //! Current screen selector for highlighting the left menu
    int currentScreen() const;

    //! Set Static Extracts Path
    Q_INVOKABLE void setExtractPath(QString extractsPath);

    //! Get Live Path
    Q_INVOKABLE QString getLivePath();

    //! Set Static Live Path
    Q_INVOKABLE void setLivePath(QString livePath);

    //! Get Extract Path
    Q_INVOKABLE QString getExtractPath();

    //! Change column types
    Q_INVOKABLE void changeColumnTypes(QString columnName, QString tableName, QString newColumnType);
    Q_INVOKABLE QVariantMap getChangedColumnTypes();

    Q_INVOKABLE QString urlToFilePath(QUrl url);

    Q_INVOKABLE void setFromLiveFile(bool setForLiveFile);
    Q_INVOKABLE bool getFromLiveFile();

    Q_INVOKABLE void setFromLiveQuery(bool setForLiveQuery);
    Q_INVOKABLE bool getFromLiveQuery();

    Q_INVOKABLE QStringList getCredentials();

    Q_INVOKABLE void setAPISwitch(bool apiSwitch);

    QString randomStringGenerator();

public slots:

    //! Set the current highlighted left menu
    void setMenuType(int menuType);

    //! Set current screen to highlight the respective left menu
    void setCurrentScreen(int currentScreen);

signals:

    void menuTypeChanged(int menuType);
    void currentScreenChanged(int currentScreen);
    void hideSplash();
    void colTypeChanged();
    void showSaveExtractWaitPopup();
};

#endif // GENERALPARAMSMODEL_H
