#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QByteArray>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

#include <QAbstractTableModel>


class QtTest2 : public QAbstractTableModel
{
    Q_OBJECT

    public:
        explicit QtTest2(QObject *parent = nullptr);
        Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
        int rowCount(const QModelIndex &parent = QModelIndex()) const override;
        int columnCount(const QModelIndex &parent = QModelIndex()) const override;
        QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;





};

#endif // QTTEST2_H
