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
    Q_PROPERTY(QString lastDropped READ lastDropped WRITE setLastDropped NOTIFY lastDroppedChanged)
    Q_PROPERTY(QString calculatedFieldPopupStatus READ calculatedFieldPopupStatus WRITE setCalculatedFieldPopupStatus NOTIFY calculatedFieldPopupStatusChanged)
    Q_PROPERTY(QList<QString> xAxisColumns READ xAxisColumns WRITE setXAxisColumns NOTIFY xAxisColumnsChanged)
    Q_PROPERTY(QList<QString> yAxisColumns READ yAxisColumns WRITE setYAxisColumns NOTIFY yAxisColumnsChanged)
    Q_PROPERTY(QString chartType READ chartType WRITE setChartType NOTIFY chartTypeChanged)

    QString m_itemName;
    QString m_itemType;

    bool m_xAxisActive;

    bool m_yAxisActive;

    bool m_colorByActive;

    QString m_lastDropped;

    QString m_createFieldPopupStatus;

    QList<QString> m_xAxisColumns;

    QList<QString> m_yAxisColumns;

    QString m_chartType;

public:
    ReportParamsModel();
    QString itemName() const;
    QString itemType() const;

    bool xAxisActive() const;

    bool yAxisActive() const;

    bool colorByActive() const;

    QString lastDropped() const;

    QString calculatedFieldPopupStatus() const;



    QList<QString> xAxisColumns() const;

    QList<QString> yAxisColumns() const;

    QString chartType() const;

public slots:
    void setItemName(QString itemName);
    void setItemType(QString itemType);

    void setXAxisActive(bool xAxisActive);
    void setYAxisActive(bool yAxisActive);

    void setColorByActive(bool colorByActive);

    void setLastDropped(QString lastDropped);

    void setCalculatedFieldPopupStatus(QString calculatedFieldPopupStatus);



    void setXAxisColumns(QList<QString> xAxisColumns);

    void setYAxisColumns(QList<QString> yAxisColumns);

    void setChartType(QString chartType);

signals:
    void itemNameChanged(QString itemName);
    void itemTypeChanged(QString itemType);

    void xAxisActiveChanged(bool xAxisActive);
    void yAxisActiveChanged(bool yAxisActive);
    void colorByActiveChanged(bool colorByActive);
    void lastDroppedChanged(QString lastDropped);
    void calculatedFieldPopupStatusChanged(QString calculatedFieldPopupStatus);

    void xAxisColumnsChanged(QList<QString> xAxisColumns);
    void yAxisColumnsChanged(QList<QString> yAxisColumns);
    void chartTypeChanged(QString chartType);
};

#endif // REPORTPARAMSMODEL_H
