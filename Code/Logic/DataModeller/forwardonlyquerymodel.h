#ifndef FORWARDONLYQUERYMODEL_H
#define FORWARDONLYQUERYMODEL_H

#include <QObject>
#include<QAbstractTableModel>

#include "../../statics.h"
#include "../../constants.h"

#include "../General/datatype.h"
#include "../General/querysplitter.h"

class ForwardOnlyQueryModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit ForwardOnlyQueryModel(QObject *parent = nullptr);
    ~ForwardOnlyQueryModel();

    Q_INVOKABLE void setQuery(QString query);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void getQueryStats();
    Q_INVOKABLE void removeTmpChartData();

private:
    void generateRoleNames();
    void setQueryResult();
    void setChartHeader(int index, QStringList colInfo);
    QString returnDatatypeQuery(QString tableName);
    QString returnConnectionName();
    QMap<QString, QString> returnColumnList(QString tableName);

    QHash<int, QByteArray> m_roleNames;
    QList<QStringList> resultData;
    int internalRowCount;
    int internalColCount;

    QString query;
    QuerySplitter querySplitter;

    // Data variables for Charts
    QMap<int, QStringList*> forwardOnlyChartData;
    QMap<int, QStringList> forwardOnlyChartHeader;
    QStringList tableHeaders;

signals:
    void chartDataChanged(QMap<int, QStringList*> chartData);
    void chartHeaderChanged(QMap<int, QStringList> chartHeader);
    void forwardOnlyHeaderDataChanged(QStringList tableHeaders);
    void forwardOnlyHasData(bool hasData);
    void clearTablePreview();

};

#endif // FORWARDONLYQUERYMODEL_H
