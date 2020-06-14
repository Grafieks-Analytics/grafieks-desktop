#ifndef DROPBOXDS_H
#define DROPBOXDS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>

#include "dropbox.h"

class DropboxDS : public QObject
{
    Q_OBJECT
public:
    explicit DropboxDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatasources(QString path);
    Q_INVOKABLE QString goingBack(QString path,QString name);

    void addDataSource(Dropbox * dropbox);

    Q_INVOKABLE void addDataSource(const QString & id,const QString & tag,const QString & name,const QString & pathLower,const QString & clientModified,const QString & extension);

//    Q_INVOKABLE void removeDatasource(int index);
    QList<Dropbox *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();
    void preItemRemoved(int index);
    void postItemRemoved();
    void preReset();
    void postReset();

private slots:
    void resetDatasource();
    void dataReadyRead();
    void dataReadFinished();
//    void datadeleteFinished();

public slots:

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Dropbox*> m_dropbox;
};

#endif // DROPBOXDS_H
