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

/*!
 * \brief Sql query Setter method
 * \param query (sql query)
 */
void QuerySplitter::setQuery(QString query)
{
    if (m_query == query)
        return;

    // Remove whitespaces from ends
    // Also remove any spacing chars like \n \t, etc

    m_query = query.simplified();
    emit queryChanged(m_query);
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
    QRegularExpression tableMainRegex(R"(\sFROM\s+(.*?)\s+(LEFT|RIGHT|FULL|INNER|JOIN|WHERE|GROUP|ORDER|LIMIT)\s)", QRegularExpression::CaseInsensitiveOption);
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

