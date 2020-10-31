#ifndef REPORTPARAMSMODEL_H
#define REPORTPARAMSMODEL_H

#include <QObject>

class ReportParamsModel: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString itemName READ itemName WRITE setItemName NOTIFY itemNameChanged)
    Q_PROPERTY(QString itemType READ itemType WRITE setItemType NOTIFY itemTypeChanged)
    Q_PROPERTY(bool xAxisActive READ xAxisActive WRITE setXAxisActive NOTIFY xAxisActiveChanged)
    Q_PROPERTY(bool yAxisActive READ yAxisActive WRITE setYAxisActive NOTIFY yAxisActiveChanged)
    Q_PROPERTY(bool colorByActive READ colorByActive WRITE setColorByActive NOTIFY colorByActiveChanged)

    QString m_itemName;
    QString m_itemType;

    bool m_xAxisActive;

    bool m_yAxisActive;

    bool m_colorByActive;

public:
    ReportParamsModel();
    QString itemName() const;
    QString itemType() const;

    bool xAxisActive() const;

    bool yAxisActive() const;

    bool colorByActive() const;

public slots:
    void setItemName(QString itemName);
    void setItemType(QString itemType);

    void setXAxisActive(bool xAxisActive);
    void setYAxisActive(bool yAxisActive);

    void setColorByActive(bool colorByActive);

signals:
    void itemNameChanged(QString itemName);
    void itemTypeChanged(QString itemType);

    void xAxisActiveChanged(bool xAxisActive);
    void yAxisActiveChanged(bool yAxisActive);
    void colorByActiveChanged(bool colorByActive);
};

#endif // REPORTPARAMSMODEL_H
