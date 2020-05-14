#ifndef DATASOURCEMODEL_H
#define DATASOURCEMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "datasourceds.h"

class DatasourceModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(DatasourceDS * datasourceds READ datasourceds WRITE setDatasourceds)



public:
    explicit DatasourceModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const; //Allows to expose our custom roles( names,favoritecolor,age) to a qml ListView

    DatasourceDS *datasourceds() const;
    void setDatasourceds(DatasourceDS * datasourceds);

    enum DatasourceRoles{
        DatasourceIdRole = Qt::UserRole + 1,
        ConnectedWorkbooksCountRole,
        DSProfileIDRole,
        ConnectionTypeRole,
        DatasourceNameRole,
        DescriptionRole,
        SourceTypeRole,
        ImageLinkRole,
        DatasourceLinkRole,
        CreatedDateRole,
        FirstnameRole,
        LastnameRole

    };

signals:

private :
    DatasourceDS * m_datasource;
    bool signalsConnected {false};

};

#endif // DATASOURCEMODEL_H
