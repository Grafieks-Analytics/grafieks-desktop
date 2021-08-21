#ifndef EXCELQUERYMODEL_H
#define EXCELQUERYMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QSqlDatabase>
#include <QSqlField>
#include <QSqlRecord>

#include "../../statics.h"
#include "../../constants.h"
#include "../Connectors/duckcon.h"

#include "../General/datatype.h"
#include "../General/querysplitter.h"
#include "./Workers/generaterolenamesduckworker.h"
#include "./Workers/setchartdataduckworker.h"

class ExcelQueryModel : public QAbstractTableModel
{
    Q_OBJECT

    int previewRowCount;
    QList<QStringList> resultData;
    QString query;
    int internalColCount;
    QuerySplitter querySplitter;

    QHash<int, QByteArray> m_roleNames;

    QStringList selectParams;
    QStringList tableParams;
    QStringList whereParams;

public:
    explicit ExcelQueryModel(QObject *parent = nullptr);

    Q_INVOKABLE void setQuery(QString query);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void getQueryStats();
    Q_INVOKABLE void removeTmpChartData();

public slots:
    void receiveCsvFilterQuery(QString query);
    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount);
    void slotSetChartData(bool success);

private:
    void generateRoleNames();
    void setQueryResult();
    QMap<QString, QString> returnColumnList(QString tableName);
    void setChartHeader(int index, QStringList colInfo);

signals:
    void chartDataChanged(QMap<int, QStringList*> chartData);
    void chartHeaderChanged(QMap<int, QStringList> chartHeader);
    void excelHeaderDataChanged(QStringList tableHeaders);
    void excelHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);
    void signalGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader);

};

#endif // EXCELQUERYMODEL_H
