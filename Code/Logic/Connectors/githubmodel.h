#ifndef GITHUBMODEL_H
#define GITHUBMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "githubds.h"

class GithubModel : public QObject
{
    Q_OBJECT
public:
    explicit GithubModel(QObject *parent = nullptr);

signals:

};

#endif // GITHUBMODEL_H
