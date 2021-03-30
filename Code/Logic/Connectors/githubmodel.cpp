#include "githubmodel.h"

GithubModel::GithubModel(QObject *parent) : QAbstractListModel(parent)
{

}

int GithubModel::rowCount(const QModelIndex &parent) const
{

    Q_UNUSED(parent);
    return m_github->dataItems().count();
}

QVariant GithubModel::data(const QModelIndex &index, int role) const
{

    if(index.row() < 0 || index.row() >= m_github->dataItems().count()){
        return QVariant();
    }
    Github * drive = m_github->dataItems().at(index.row());
    if(role == IdRole)
        return drive->id();
    if(role == NameRole)
        return drive->name();
    if(role == KindRole)
        return drive->kind();
    if(role == ModifiedTimeRole)
        return drive->modifiedTime();
    if(role == ExtensionRole)
        return drive->extension();
    if(role == UrlRole)
        return drive->url();


    return QVariant();
}

bool GithubModel::setData(const QModelIndex &index, const QVariant &value, int role)
{

    Github * drive = m_github->dataItems().at(index.row());
    bool somethingChanged = false;
    switch(role){
        case IdRole:
        if(drive->id() != value.toString()){
            drive->setId(value.toString());
            somethingChanged = true;
        }
        break;
    case NameRole:
        if(drive->name() != value.toString()){
            drive->setName(value.toString());
            somethingChanged = true;
        }
        break;
    case KindRole:
        if(drive->kind() != value.toString()){
            drive->setKind(value.toString());
            somethingChanged = true;
        }
    case ModifiedTimeRole:
        if(drive->modifiedTime() != value.toString()){
            drive->setModifiedTime(value.toString());
            somethingChanged = true;
        }
        break;
    case ExtensionRole:
        if(drive->extension() != value.toString()){
            drive->setExtension(value.toString());
            somethingChanged= true;
        }
        break;
    case UrlRole:
        if(drive->url() != value.toString()){
            drive->setUrl(value.toString());
            somethingChanged= true;
        }
        break;


    }
    if(somethingChanged){
        emit dataChanged(index,index,QVector<int> () << role);
        return true;
    }
    return false;
}

Qt::ItemFlags GithubModel::flags(const QModelIndex &index) const
{

    if(!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> GithubModel::roleNames() const
{

    QHash<int, QByteArray> roles;

    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[KindRole] = "kind";
    roles[ModifiedTimeRole] = "modifiedTime";
    roles[ExtensionRole] = "extension";
    roles[UrlRole] = "url";

    return roles;
}

GithubDS *GithubModel::githubds() const
{

    return m_github;
}

void GithubModel::setGithubds(GithubDS *github)
{

    beginResetModel();
    if(m_github && signalsConnected)
        m_github->disconnect(this);

    m_github = github;

    connect(m_github,&GithubDS::preItemAdded,this,[=](){
        const int index = m_github->dataItems().count();
        beginInsertRows(QModelIndex(),index,index);
    });

    connect(m_github,&GithubDS::postItemAdded,this,[=](){
        endInsertRows();
    });

    connect(m_github,&GithubDS::preReset,this,[=](){
        beginResetModel();
    });

    connect(m_github,&GithubDS::postReset,this,[=](){
        endResetModel();
    });

    endResetModel();
}
