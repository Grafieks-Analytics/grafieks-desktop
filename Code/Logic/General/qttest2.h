#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QDebug>
#include <QAbstractTableModel>


class QtTest2 : public QAbstractTableModel
{
    Q_OBJECT
    QMap<int, QString> m_map;
    QHash<int, QByteArray> m_roles;

public:
    explicit QtTest2(QObject *parent = nullptr);

    int rowCount(const QModelIndex & = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;


public slots:

signals:

private:
    QList<QString> contactNames;
    QList<QString> contactPhoneNums;

};

#endif // QTTEST2_H
