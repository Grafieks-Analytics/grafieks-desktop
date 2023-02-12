#include "querysplitter.h"

/*!
 * \brief Constructor function
 * \param parent
 */
QuerySplitter::QuerySplitter(QObject *parent) : QObject(parent)
{

}

/*!
 * \brief Query getter function
 * \return QString
 */
QString QuerySplitter::query() const
{
    return m_query;
}

void QuerySplitter::setQueryForClasses(QString query)
{
    this->setInternalQuery(query);
}

/*!
 * \brief Sql query Setter method
 * \param query (sql query)
 */
void QuerySplitter::setQuery(QString query)
{
    this->setInternalQuery(query);
    emit queryChanged(query.simplified());
}

void QuerySplitter::setInternalQuery(QString query)
{
    if (m_query == query)
        return;

    m_query = query.simplified();
}

/*!
 * \brief Returns column names selected in a query
 * \return QStringList (query column names)
 */
QStringList QuerySplitter::getSelectParams()
{

    QStringList selectList;

    // Select params
    QRegularExpression selectListRegex(R"(SELECT\s+(.*?)\sFROM\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(m_query);
    selectList << selectIterator.captured(1).trimmed().replace("DISTINCT", "", Qt::CaseInsensitive).split(",");
//    selectList.sort(Qt::CaseInsensitive);
    return selectList;
}
/*!
 * \brief Returns Sql query Where conditions
 * \return QString (Where conditions in sql query)
 */
QString QuerySplitter::getWhereCondition()
{


    QString whereString;

    // Where params
    QRegularExpression whereListRegex(R"(\sWHERE\s+(.*?)(?:\s+(?:GROUP|ORDER|LIMIT)\b|\s*$))", QRegularExpression::CaseInsensitiveOption);

    QRegularExpressionMatch whereIterator = whereListRegex.match(m_query);
    whereString = whereIterator.captured(1).trimmed();

    return whereString;

}

/*!
 * \brief Get the name of the main table queried
 * \return QString (table name)
 */
QString QuerySplitter::getMainTable()
{

    QString tableMainString;

    // Table params
    QRegularExpression tableMainRegex(R"(\sFROM\s+(.*?)(;|$|\s+(LEFT|RIGHT|FULL|INNER|JOIN|WHERE|GROUP|ORDER|LIMIT)\s))", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch tableMainIterator = tableMainRegex.match(m_query);
    tableMainString = tableMainIterator.captured(1).trimmed();

    return tableMainString;

}

/*!
 * \brief Get the names of joined tables in the sql query
 * \return QStringList (joined table names)
 */
QStringList QuerySplitter::getJoinTables()
{

    QStringList joinTableList;

    // Join Tables params
    QRegularExpression joinTableRegex(R"(\sJOIN\s+(.*?)\sON\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatchIterator joinTableIterator = joinTableRegex.globalMatch(m_query);
    while (joinTableIterator.hasNext()) {
        QRegularExpressionMatch match = joinTableIterator.next();
        joinTableList << match.captured(1).trimmed();
    }

    return joinTableList;
}

QString QuerySplitter::getJoinConditions()
{
    QString joinConditions;


    QRegularExpression joinConditionsRegex(R"(\s(?:INNER|LEFT|RIGHT|FULL)\s+(.*?)(?:\s+(?:WHERE|GROUP|ORDER|LIMIT)\b|\s*$))", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch joinConditionsIterator = joinConditionsRegex.match(m_query);

    joinConditions = joinConditionsIterator.captured(0);
    if(joinConditions.contains(" WHERE ", Qt::CaseInsensitive)){
        joinConditions.replace(" WHERE ", "", Qt::CaseInsensitive);
    }
    if(joinConditions.contains(" ORDER ", Qt::CaseInsensitive)){
        joinConditions.replace(" ORDER ", "", Qt::CaseInsensitive);
    }
    if(joinConditions.contains(" LIMIT ", Qt::CaseInsensitive)){
        joinConditions.replace(" LIMIT ", "", Qt::CaseInsensitive);
    }

    return joinConditions.trimmed();
}

QString QuerySplitter::getAliasName(QString columnString)
{
    QStringList list;
//    QRegularExpression separator("\\sas\\s", QRegularExpression.CaseInsensitiveOption);
    QRegularExpression separator("\\sas\\s");

    if(columnString.contains(separator)){
        list = columnString.split(separator);
    }

    return list[1];
}

