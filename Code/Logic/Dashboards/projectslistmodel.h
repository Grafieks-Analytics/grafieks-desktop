#ifndef PROJECTSLISTMODEL_H
#define PROJECTSLISTMODEL_H

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include <QObject>

class ProjectsListModel : public QObject
{
    Q_OBJECT

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QVariantMap projects;

public:
    explicit ProjectsListModel(QObject *parent = nullptr);
    Q_INVOKABLE void fetchProjectList();

public slots:
    void dataReadyRead();
    void dataReadFinished();

signals:
    void signalProjectList(QVariantMap projects);

};

#endif // PROJECTSLISTMODEL_H
