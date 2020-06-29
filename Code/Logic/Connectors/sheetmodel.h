#ifndef SHEETMODEL_H
#define SHEETMODEL_H
#include <QAbstractListModel>
#include <QObject>

#include "sheetds.h"

class SheetModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(SheetDS * sheetds READ sheetds WRITE setSheetds);

public:
    explicit SheetModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    SheetDS * sheetds() const;
    void setSheetds(SheetDS * sheetds);

    enum SheetRoles{
        IdRole = Qt::UserRole +1,
        NameRole,
        KindRole,
        ModifiedTimeRole,
        ExtensionRole
    };

signals:

private:
    SheetDS * m_sheet;
    bool signalsConnected {false};


};

#endif // SHEETMODEL_H
