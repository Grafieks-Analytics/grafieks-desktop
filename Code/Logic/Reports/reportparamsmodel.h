#ifndef REPORTPARAMSMODEL_H
#define REPORTPARAMSMODEL_H

#include <QObject>
#include <QMap>

class ReportParamsModel: public QObject
{
    Q_OBJECT

    // Customize Report parameters
    QMap<int, QMap<QString, QString>> reportsMap; // <<reportId, reportObj>>

    Q_PROPERTY(QString itemName READ itemName WRITE setItemName NOTIFY itemNameChanged)
    Q_PROPERTY(QString itemType READ itemType WRITE setItemType NOTIFY itemTypeChanged)
    Q_PROPERTY(bool xAxisActive READ xAxisActive WRITE setXAxisActive NOTIFY xAxisActiveChanged)
    Q_PROPERTY(bool yAxisActive READ yAxisActive WRITE setYAxisActive NOTIFY yAxisActiveChanged)
    Q_PROPERTY(bool colorByActive READ colorByActive WRITE setColorByActive NOTIFY colorByActiveChanged)
    Q_PROPERTY(QString lastDropped READ lastDropped WRITE setLastDropped NOTIFY lastDroppedChanged)
    Q_PROPERTY(QString calculatedFieldPopupStatus READ calculatedFieldPopupStatus WRITE setCalculatedFieldPopupStatus NOTIFY calculatedFieldPopupStatusChanged)
    Q_PROPERTY(QList<QString> xAxisColumns READ xAxisColumns WRITE setXAxisColumns NOTIFY xAxisColumnsChanged)
    Q_PROPERTY(QList<QString> yAxisColumns READ yAxisColumns WRITE setYAxisColumns NOTIFY yAxisColumnsChanged)
    Q_PROPERTY(QList<QString> dataValuesColumns READ dataValuesColumns WRITE setDataValuesColumns NOTIFY dataValuesChanged)

    Q_PROPERTY(QString pointerValue READ pointerValue WRITE setPointerValue NOTIFY pointerValueChanged)

    Q_PROPERTY(QString chartType READ chartType WRITE setChartType NOTIFY chartTypeChanged)
    Q_PROPERTY(QString reportId READ reportId WRITE setReportId NOTIFY reportIdChanged)
    Q_PROPERTY(QString reportTitle READ reportTitle WRITE setReportTitle NOTIFY reportTitleChanged)

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

    QString m_reportId;

    QString m_reportTitle;

    QList<QString> m_dataValuesColumns;

    QString m_pointerValue;

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
    QString reportId() const;
    QString reportTitle() const;

    Q_INVOKABLE void addReport(int reportId);

    QList<QString> dataValuesColumns() const;

    QString pointerValue() const;

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

    void setReportId(QString reportId);

    void setReportTitle(QString reportTitle);

    void setDataValuesColumns(QList<QString> dataValuesColumns);

    void setPointerValue(QString pointerValue);

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
    void reportIdChanged(QString reportId);
    void reportTitleChanged(QString reportTitle);
    void dataValuesChanged(QList<QString> dataValuesColumns);
    void pointerValueChanged(QString pointerValue);
};

#endif // REPORTPARAMSMODEL_H
