#ifndef REPORTPARAMSMODEL_H
#define REPORTPARAMSMODEL_H

#include <QObject>

class ReportParamsModel: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString itemName READ itemName WRITE setItemName NOTIFY itemNameChanged)
    Q_PROPERTY(QString itemType READ itemType WRITE setItemType NOTIFY itemTypeChanged)

    QString m_itemName;
    QString m_itemType;

public:
    ReportParamsModel();
    QString itemName() const;
    QString itemType() const;

public slots:
    void setItemName(QString itemName);
    void setItemType(QString itemType);

signals:
    void itemNameChanged(QString itemName);
    void itemTypeChanged(QString itemType);

};

#endif // REPORTPARAMSMODEL_H
