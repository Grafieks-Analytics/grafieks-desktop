#ifndef GITHUBMODEL_H
#define GITHUBMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "githubds.h"

/*!
 * \brief Sets the Github API data to view in QtQuick
 * \details This class lists all the methods which interact with the view in QtQuick
 * \ingroup ConnectorScreen
 */
class GithubModel : QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(GithubDS * githubds READ githubds WRITE setGithubds);
public:
    explicit GithubModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    GithubDS * githubds() const;
    void setGithubds(GithubDS * githubds);

    enum DriveRoles{
        IdRole = Qt::UserRole +1,
        NameRole,
        KindRole,
        ModifiedTimeRole,
        ExtensionRole
    };

signals:
private:

    GithubDS * m_github;
    bool signalsConnected {false};

};

#endif // GITHUBMODEL_H
