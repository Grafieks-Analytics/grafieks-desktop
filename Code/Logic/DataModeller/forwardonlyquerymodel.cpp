#include "forwardonlyquerymodel.h"

ForwardOnlyQueryModel::ForwardOnlyQueryModel(QObject *parent) : QAbstractTableModel(parent)
{

}

ForwardOnlyQueryModel::~ForwardOnlyQueryModel()
{

    this->forwardOnlyChartHeader.clear();
    this->forwardOnlyChartData.clear();
}

void ForwardOnlyQueryModel::setQuery(QString query)
{

    this->resultData.clear();
    this->query = query.simplified();
    querySplitter.setQueryForClasses(this->query);

    this->generateRoleNames();
    this->setQueryResult();

}

int ForwardOnlyQueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->internalRowCount;
}

int ForwardOnlyQueryModel::columnCount(const QModelIndex &) const
{
    return this->internalColCount;
}

QVariant ForwardOnlyQueryModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    emit headerDataChanged(Qt::Horizontal, 1, this->internalColCount);
    return QVariant();
}

QVariant ForwardOnlyQueryModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->resultData[index.row()][index.column()];
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> ForwardOnlyQueryModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void ForwardOnlyQueryModel::getQueryStats()
{
    // TBD
}

void ForwardOnlyQueryModel::removeTmpChartData()
{
    this->~ForwardOnlyQueryModel();
}

void ForwardOnlyQueryModel::generateRoleNames()
{
    QString colListQuery, conType, fieldName, fieldType, tmpTableName, tmpFieldName;
    DataType dataType;
    QStringList colInfo, tablesList, output;
    QMap<QString, QString> colTypeMap;

    m_roleNames.clear();
    this->tableHeaders.clear();


    QRegularExpression selectListRegex(R"(SELECT\s+(.*?)\sFROM\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(this->query);
    QString containsStar = selectIterator.captured(1);

    if(containsStar.contains("*", Qt::CaseInsensitive) == true){
        tablesList << querySplitter.getMainTable();
        tablesList << querySplitter.getJoinTables();

        foreach(QString tableName, tablesList){

            QString conQuery = this->returnDatatypeQuery(tableName);
            QString conName = this->returnConnectionName();

            QSqlDatabase dbForward = QSqlDatabase::database(conName);
            QSqlQuery q(conQuery, dbForward);

            if(q.lastError().type() == QSqlError::NoError){
                int i = 0;

                while(q.next()){
                    fieldName = q.value(0).toString().trimmed();
                    fieldType = q.value(1).toString().trimmed();
                    colInfo << fieldName << dataType.dataType(fieldType) << tableName;

                    qDebug() << "TERADATA IF " << colInfo;

                    m_roleNames.insert(i, fieldName.toUtf8());
                    this->setChartHeader(i, colInfo);

                    this->tableHeaders.append(fieldName);
                    this->internalColCount++;
                }
            } else{
                qWarning() << Q_FUNC_INFO << q.lastError();
            }
        }

    } else{
        output = querySplitter.getSelectParams();
        tablesList << querySplitter.getMainTable();
        tablesList << querySplitter.getJoinTables();

        this->internalColCount = output.length();

        for(int i =0; i < output.length(); i++){
            fieldName = output[i].remove(QRegularExpression("[\"`']+")).trimmed();

            // If fieldname contains a dot(.), then probably it might have joins
            // Else for sure it doesnt contain a join
            if(fieldName.contains(".")){
                foreach(QString tableName, tablesList){

                    if(Statics::currentDbIntType == Constants::teradataIntType){
                        tableName.remove("\"" + Statics::currentDbName + "\".");
                        tableName.remove(Statics::currentDbName + ".");
                        tableName.remove("\"");
                    }

                    if(tmpTableName != tableName){
                        colTypeMap = this->returnColumnList(tableName);
                    }

                    if(fieldName.contains(tableName)){

                        try{
                            tmpFieldName = fieldName;
                            fieldName.remove(tableName + ".");
                            fieldType = colTypeMap.value(fieldName);
                            colInfo << fieldName << dataType.dataType(fieldType.left(fieldType.indexOf("("))) << tableName;

                            qDebug() << "TERADATA ELSE 1" << colInfo;
                        } catch(std::exception &e){
                            qDebug() << e.what();
                        }
                    }
                    tmpTableName = tableName;

                }
            } else{

                if(tmpTableName != tablesList.at(0)){
                    colTypeMap = this->returnColumnList(tablesList.at(0));
                }
                tmpTableName = tablesList.at(0);

                fieldType = colTypeMap.value(fieldName);
                colInfo << fieldName << dataType.dataType(fieldType.left(fieldType.indexOf("("))) << tablesList.at(0);
            }


            try{
                m_roleNames.insert(i, fieldName.toUtf8());
                this->setChartHeader(i, colInfo);
                this->tableHeaders.append(fieldName);
            }catch(std::exception &er){
                qDebug() << er.what();
            }

            colInfo.clear();

        }

    }

    // Emit signals for reports
    emit forwardOnlyHeaderDataChanged(this->tableHeaders);
    emit chartHeaderChanged(this->forwardOnlyChartHeader);

}

void ForwardOnlyQueryModel::setQueryResult()
{

    beginResetModel();

    // Tmp
    QStringList list;

    QString connectionName = this->returnConnectionName();

    QSqlDatabase dbForward = QSqlDatabase::database(connectionName);
    QSqlQuery q(this->query, dbForward);
    if(q.lastError().type() != QSqlError::NoError)
        qWarning() << Q_FUNC_INFO << q.lastError();


    // this->setChartData(result);

    int totalRowCount = 0;
    while(q.next()){

        try{
            for(int i = 0; i < this->internalColCount; i++){
                list << q.value(i).toString();

                // Add to chart data
                if(totalRowCount == 0){
                    this->forwardOnlyChartData[i] = new QStringList(q.value(i).toString());
                } else{
                    this->forwardOnlyChartData.value(i)->append(q.value(i).toString());
                    this->forwardOnlyChartData[i] = forwardOnlyChartData.value(i);
                }
            }
            this->resultData.append(list);
        } catch(std::exception &e){
            qWarning() << Q_FUNC_INFO << e.what();
        }

        list.clear();

        totalRowCount++;
    }
    // Set the internalRowCount for the QAbstractListModel rowCount method
    this->internalRowCount = totalRowCount;

    if(this->internalRowCount > 0){
        emit forwardOnlyHasData(true);

    } else{
        emit forwardOnlyHasData(false);
    }
    emit chartDataChanged(this->forwardOnlyChartData);
    endResetModel();
}


void ForwardOnlyQueryModel::setChartHeader(int index, QStringList colInfo)
{
    this->forwardOnlyChartHeader.insert(index, colInfo);
}

QString ForwardOnlyQueryModel::returnDatatypeQuery(QString tableName)
{
    QString colListQuery;

    switch(Statics::currentDbIntType){
    case Constants::redshiftIntType:
        colListQuery = "select \"column\", type from pg_table_def where tablename = '" + tableName  + "'";
        break;

    case Constants::snowflakeIntType:
        colListQuery = "desc table " + tableName;
        break;

    case Constants::teradataIntType:
        tableName.remove("\"" + Statics::currentDbName + "\".");
        tableName.remove(Statics::currentDbName + ".");
        tableName.remove("\"");
        colListQuery = "SELECT ColumnName, ColumnType FROM DBC.Columns WHERE DatabaseName = '" + Statics::currentDbName + "' AND TableName = '" + tableName + "'";
        break;

    }

    return colListQuery;
}

QString ForwardOnlyQueryModel::returnConnectionName()
{

    QString conType;

    switch(Statics::currentDbIntType){

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        break;

    case Constants::teradataIntType:
        conType = Constants::teradataOdbcStrType;
        break;
    }

    return conType;
}

QMap<QString, QString> ForwardOnlyQueryModel::returnColumnList(QString tableName)
{

    QString conQuery = this->returnDatatypeQuery(tableName);
    QString conName = this->returnConnectionName();
    QMap<QString, QString>colTypeMap;

    QSqlDatabase dbForward = QSqlDatabase::database(conName);
    QSqlQuery q(conQuery, dbForward);

    if(q.lastError().type() == QSqlError::NoError){
        while(q.next()){
            QString fieldName = q.value(0).toString().trimmed();
            QString fieldType = q.value(1).toString().trimmed();
            colTypeMap.insert(fieldName, fieldType);
        }
    } else{
        qWarning() << Q_FUNC_INFO << q.lastError();
    }

    return colTypeMap;
}
