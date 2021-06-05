#ifndef REPORTPARAMSMODEL_H
#define REPORTPARAMSMODEL_H

#include <QObject>
#include <QMap>
#include <QVariantMap>
#include<QDebug>


class ReportParamsModel: public QObject
{
    Q_OBJECT

    // Customize Report parameters
    QMap<QString, QMap<QString, QString>> reportsMap; // <<reportId, reportObj>>

    Q_PROPERTY(QString itemName READ itemName WRITE setItemName NOTIFY itemNameChanged)
    Q_PROPERTY(QString itemType READ itemType WRITE setItemType NOTIFY itemTypeChanged)
    Q_PROPERTY(bool xAxisActive READ xAxisActive WRITE setXAxisActive NOTIFY xAxisActiveChanged)
    Q_PROPERTY(bool yAxisActive READ yAxisActive WRITE setYAxisActive NOTIFY yAxisActiveChanged)
    Q_PROPERTY(bool colorByActive READ colorByActive WRITE setColorByActive NOTIFY colorByActiveChanged)
    Q_PROPERTY(QString lastDropped READ lastDropped WRITE setLastDropped NOTIFY lastDroppedChanged)
    Q_PROPERTY(QString calculatedFieldPopupStatus READ calculatedFieldPopupStatus WRITE setCalculatedFieldPopupStatus NOTIFY calculatedFieldPopupStatusChanged)

    Q_PROPERTY(QList<QString> dataValuesColumns READ dataValuesColumns WRITE setDataValuesColumns NOTIFY dataValuesChanged)

    Q_PROPERTY(QString pointerValue READ pointerValue WRITE setPointerValue NOTIFY pointerValueChanged)

    Q_PROPERTY(QList<QString> colorBy READ colorBy WRITE setColorBy NOTIFY colorByChanged)

    // Report Properties for generating graph
    Q_PROPERTY(QString chartType READ chartType WRITE setChartType NOTIFY chartTypeChanged)
    Q_PROPERTY(QString chartUrl READ chartUrl WRITE setChartUrl NOTIFY chartUrlChanged)
    Q_PROPERTY(QString reportId READ reportId WRITE setReportId NOTIFY reportIdChanged)
    Q_PROPERTY(QString reportTitle READ reportTitle WRITE setReportTitle NOTIFY reportTitleChanged)
    Q_PROPERTY(QString xAxisColumns READ xAxisColumns WRITE setXAxisColumns NOTIFY xAxisColumnsChanged)
    Q_PROPERTY(QString yAxisColumns READ yAxisColumns WRITE setYAxisColumns NOTIFY yAxisColumnsChanged)

    Q_PROPERTY(QString d3PropertiesConfig READ d3PropertiesConfig WRITE setD3PropertiesConfig NOTIFY d3PropertiesConfigChanged)


    QString m_itemName;
    QString m_itemType;

//    QMap<QString, QVariant> reportsData;
    QVariantMap reportsData;

    bool m_xAxisActive;
    bool m_yAxisActive;
    bool m_colorByActive;
    QString m_lastDropped;

    QString m_createFieldPopupStatus;
    QString m_xAxisColumns;

    QString m_yAxisColumns;

    QString m_chartType;

    QString m_reportId;

    QString m_reportTitle;

    QList<QString> m_dataValuesColumns;

    QString m_pointerValue;

    QList<QString> m_colorBy;

    QString m_d3PropertiesConfig;

    QString m_chartUrl;

public:
    ReportParamsModel();
    QString itemName() const;
    QString itemType() const;

    bool xAxisActive() const;
    bool yAxisActive() const;
    bool colorByActive() const;
    QString lastDropped() const;

    QString calculatedFieldPopupStatus() const;

    QString xAxisColumns() const;
    QString yAxisColumns() const;
    QString chartType() const;
    QString reportId() const;
    QString reportTitle() const;

    Q_INVOKABLE void addReport(QString reportId);
    Q_INVOKABLE QVariantMap getReportsList();

    QList<QString> dataValuesColumns() const;

    QString pointerValue() const;

    QList<QString> colorBy() const;

    QString d3PropertiesConfig() const;

    QString chartUrl() const;

public slots:

    void setItemName(QString itemName);
    void setItemType(QString itemType);

    void setXAxisActive(bool xAxisActive);
    void setYAxisActive(bool yAxisActive);

    void setColorByActive(bool colorByActive);
    void setLastDropped(QString lastDropped);
    void setCalculatedFieldPopupStatus(QString calculatedFieldPopupStatus);



    void setXAxisColumns(QString xAxisColumns);
    void setYAxisColumns(QString yAxisColumns);
    void setChartType(QString chartType);
    void setReportId(QString reportId);
    void setReportTitle(QString reportTitle);
    void setDataValuesColumns(QList<QString> dataValuesColumns);

    void setPointerValue(QString pointerValue);

    void setColorBy(QList<QString> colorBy);

    void setD3PropertiesConfig(QString d3PropertiesConfig);

    void setChartUrl(QString chartUrl);

signals:
    void itemNameChanged(QString itemName);
    void itemTypeChanged(QString itemType);

    void xAxisActiveChanged(bool xAxisActive);
    void yAxisActiveChanged(bool yAxisActive);
    void colorByActiveChanged(bool colorByActive);
    void lastDroppedChanged(QString lastDropped);
    void calculatedFieldPopupStatusChanged(QString calculatedFieldPopupStatus);

    void xAxisColumnsChanged(QString xAxisColumns);
    void yAxisColumnsChanged(QString yAxisColumns);
    void chartTypeChanged(QString chartType);
    void reportIdChanged(QString reportId);
    void reportTitleChanged(QString reportTitle);
    void dataValuesChanged(QList<QString> dataValuesColumns);
    void pointerValueChanged(QString pointerValue);
    void colorByChanged(QList<QString> colorBy);
    void d3PropertiesConfigChanged(QString d3PropertiesConfig);
    void chartUrlChanged(QString chartUrl);
};

#endif // REPORTPARAMSMODEL_H
