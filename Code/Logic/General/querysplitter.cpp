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

    qDebug() << "SELECT" << selectList;

    return selectList;
}

QString QuerySplitter::getWhereCondition()
{


    QString whereString;

    // Where params
    QRegularExpression whereListRegex(R"(\sWHERE\s+(.*?)(?:\s+(?:GROUP\s+BY|HAVING|ORDER\s+BY|ASC|DESC|LIMIT)\b|\s*$))", QRegularExpression::CaseInsensitiveOption);

    QRegularExpressionMatch whereIterator = whereListRegex.match(m_query);
    whereString = whereIterator.captured(1).trimmed();

    qDebug() << "WHERE" << whereString;

    return whereString;

}

QString QuerySplitter::getMainTable()
{

    QString tableMainString;

    // Table params
    QRegularExpression tableMainRegex(R"(\sFROM\s+(.*?)\s+(LEFT|RIGHT|INNER|JOIN|WHERE|GROUP\sBY|HAVING|ORDER\sBY|ASC|DESC|LIMIT)\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch tableMainIterator = tableMainRegex.match(m_query);
    tableMainString = tableMainIterator.captured(1).trimmed();

    qDebug() << "MAIN TABLE" << tableMainString;

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

    qDebug() << "JOIN" << joinTableList;

    return joinTableList;
}

