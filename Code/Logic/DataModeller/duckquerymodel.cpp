#include "duckquerymodel.h"

DuckQueryModel::DuckQueryModel(QObject *parent) : QAbstractListModel(parent)
{

}

DuckQueryModel::DuckQueryModel(DuckCon *duckCon, QObject *parent)
{
    this->duckCon = duckCon;
}


void DuckQueryModel::setQuery(QString query)
{
    this->query = query;
    querySplitter.setQueryForClasses(this->query);

    this->setQueryResult();
    //    this->setData();
    this->generateRoleNames();
}

int DuckQueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->resultData.size();
    //    return 5;
}

bool DuckQueryModel::setData(const QModelIndex &index, const QVariant &value, int role)
{

    bool somethingChanged = false;

        qDebug() << index << value << role << "HEXA";

//    this->resultData[index.row()][role] = value;
    somethingChanged = true;

    if( somethingChanged){
        emit dataChanged(index,index,QVector<int>() << role);
        return true;
    }
    return false;
}


QVariant DuckQueryModel::data(const QModelIndex &index, int role) const
{
    QVariant value;

    if(role < Qt::UserRole) {
        return QVariant();
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        value = this->resultData.at(index.row()).at(columnIdx);
        qDebug() << value << "Cork";
    }
    return value;
}

QHash<int, QByteArray> DuckQueryModel::roleNames() const
{
//    return this->m_roleNames;
    QHash<int, QByteArray> roles;
    foreach(auto x, m_roleNames){
        qDebug() << x << "COCOC";
//        roles.insert(1, "asdsad");
    }
    return {{Qt::DisplayRole, "display"}};
}


void DuckQueryModel::generateRoleNames()
{
    QStringList output;
    m_roleNames.clear();


    output = querySplitter.getSelectParams();

    QRegularExpression selectListRegex(R"(SELECT\s+(.*?)\sFROM\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(this->query);
    QString containsStar = selectIterator.captured(1);

    if(containsStar.contains("*", Qt::CaseInsensitive) == true){
        QStringList tablesList;
        tablesList << querySplitter.getMainTable();
        tablesList << querySplitter.getJoinTables();

        QString tableName;
        foreach(tableName, tablesList){
            auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
            int rows = data->collection.Count();
            QString fieldName;

            for(int i = 0; i < rows; i++){
                fieldName =  data->GetValue(1, i).ToString().c_str();
                m_roleNames.insert(Qt::UserRole + i + 1, fieldName.toUtf8());

            }
        }

    } else{
        for(int i =0; i < output.length(); i++){
            m_roleNames.insert(Qt::UserRole + i + 1, output[i].toUtf8());
        }
    }
}

void DuckQueryModel::setQueryResult()
{
    QList<QVector<duckdb::Value>> output;
    std::vector<duckdb::Value> stdData;
    std::vector<duckdb::Value> stdData2;
    QVector<duckdb::Value> convertedData;




    // Tmp
    QStringList list;

    auto result = duckCon->con.Query(this->query.toStdString());
    int colCount = result->collection.ColumnCount();
    stdData2 = result->collection.GetRow(0);

    for(auto a: stdData2){
       qDebug()<< a.str_value.c_str();
    }

    // Set the internalRowCount for the QAbstractListModel rowCount method
    this->internalRowCount = result->collection.Count();

    //    You can iterate through a column value like this
    //    auto a = result->collection.GetRow(0);

    //    for(auto b: a){
    //        qDebug() << b.ToString().c_str();
    //    }

    for(int i = 0; i < colCount; i++){

        stdData = result->collection.GetRow(i);

        // Convert std::Vector to QVector
        // convertedData =  QVector<duckdb::Value>(stdData.begin(), stdData.end());

        for(auto data: stdData){
            list << data.ToString().c_str();
        }

        const int index = this->resultData.size();
        beginInsertRows(QModelIndex(),index,index);
        this->resultData.push_back(list);
        endInsertRows();
        list.clear();
    }
}

void DuckQueryModel::getQueryStats()
{
    auto result = duckCon->con.Query("PRAGMA profiling_output");
    result->Print();
}
