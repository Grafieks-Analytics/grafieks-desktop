#ifndef COLUMNLISTMODEL_H
#define COLUMNLISTMODEL_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QDebug>

#include "./Helpers/mysqlconversions.h"
#include "./Helpers/sqliteconversions.h"
#include "./Helpers/postgresconversions.h"
#include "./Helpers/mssqlconversions.h"
#include "./Helpers/oracleconversions.h"
#include "./Helpers/mongoconversions.h"
#include "./Helpers/impalaconversions.h"
#include "./Helpers/hiveconversions.h"
#include "./Helpers/snowflakeconversions.h"
#include "./Helpers/teradataconversions.h"
#include "./Helpers/accessconversions.h"

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

/*!
 * \brief Selects distinct values for a given column in sql
 * \details Select distinct values from a given table and column name. Allows to select as well as search the table
 * \ingroup DataModeller
 */
class ColumnListModel : public QSqlQueryModel
{
    Q_OBJECT
    MysqlConversions mysqlDateConversion;
    SqliteConversions sqliteDateConversion;
    PostgresConversions postgresDateConversion;
    MssqlConversions mssqlDateConversion;
    OracleConversions oracleDateConversion;
    MongoConversions mongoDateConversion;
    ImpalaConversions impalaDateConversion;
    HiveConversions hiveDateConversion;
    SnowflakeConversions snowflakeDateConversion;
    TeradataConversions teradataDateConversion;
    AccessConversions accessDateConversion;

public:
    explicit ColumnListModel(QObject *parent = nullptr);
    ~ColumnListModel();

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void likeColumnQuery(QString columnName, QString tableName, QString searchString = "");
    Q_INVOKABLE void columnQuery(QString columnName, QString tableName, int pageNo = 0);
    Q_INVOKABLE void columnEditQuery(QString columnName, QString tableName, QString fieldNames, QString category);
    Q_INVOKABLE void columnDateFormatQuery(QString columnName, QString tableName, int value , int pageNo = 0);

public slots:

signals:
    void editCalled();


private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;
};

#endif // COLUMNLISTMODEL_H
