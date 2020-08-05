#include "querysplitter.h"

QuerySplitter::QuerySplitter(QObject *parent) : QObject(parent)
{

}

QString QuerySplitter::query() const
{
    return m_query;
}

void QuerySplitter::setQuery(QString query)
{
    if (m_query == query)
        return;

    // Remove whitespaces from ends
    // Also remove any spacing chars like \n \t, etc

    m_query = query.simplified();
    emit queryChanged(m_query);
}

QStringList QuerySplitter::getSelectParams()
{

    QStringList selectList;

    // Select params
    QRegularExpression selectListRegex(R"(SELECT\s+(.*?)\sFROM\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(m_query);
    selectList << selectIterator.captured(1).trimmed().replace("DISTINCT", "", Qt::CaseInsensitive).split(",");

    return selectList;
}

QString QuerySplitter::getWhereCondition()
{


    QString whereString;

    // Where params
    QRegularExpression whereListRegex(R"(\sWHERE\s+(.*?)(?:\s+(?:GROUP|ORDER|LIMIT)\b|\s*$))", QRegularExpression::CaseInsensitiveOption);

    QRegularExpressionMatch whereIterator = whereListRegex.match(m_query);
    whereString = whereIterator.captured(1).trimmed();

    return whereString;

}

QString QuerySplitter::getMainTable()
{

    QString tableMainString;

    // Table params
    QRegularExpression tableMainRegex(R"(\sFROM\s+(.*?)\s+(LEFT|RIGHT|FULL|INNER|JOIN|WHERE|GROUP|ORDER|LIMIT)\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch tableMainIterator = tableMainRegex.match(m_query);
    tableMainString = tableMainIterator.captured(1).trimmed();

    return tableMainString;

}

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

