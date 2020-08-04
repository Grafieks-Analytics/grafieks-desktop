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

QStringList QuerySplitter::getSelectParams(QString &query)
{

    QStringList selectList;

    // Select params
    QRegularExpression selectListRegex("SELECT\\ (.*?)\\ FROM\\ ", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(query);
    selectList << selectIterator.captured(1).trimmed().replace("DISTINCT", "", Qt::CaseInsensitive).split(",");

    return selectList;
}

QString QuerySplitter::getWhereCondition(QString &query)
{

    QString whereString;

    // Where params
    QRegularExpression whereListRegex("\\ WHERE\\ (.*?)\\ (GROUP\\ BY|HAVING|ORDER\\ BY|ASC|DESC|LIMIT)\\ ", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch whereIterator = whereListRegex.match(query);
    whereString = whereIterator.captured(1).trimmed();

    return whereString;

}

QString QuerySplitter::getMainTable(QString &query)
{

    QString tableMainString;

    // Table params
    QRegularExpression tableMainRegex("\\ FROM\\ (.*?)\\ (LEFT|RIGHT|INNER|JOIN|WHERE|GROUP\\ BY|HAVING|ORDER\\ BY|ASC|DESC|LIMIT)\\ ", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch tableMainIterator = tableMainRegex.match(query);
    tableMainString = tableMainIterator.captured(1).trimmed();

    return tableMainString;

}

QStringList QuerySplitter::getJoinTables(QString &query)
{

    QStringList joinTableList;

    // Join Tables params
    QRegularExpression joinTableRegex("\\ JOIN\\ (.*?)\\ ON\\ ", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatchIterator joinTableIterator = joinTableRegex.globalMatch(query);
    while (joinTableIterator.hasNext()) {
        QRegularExpressionMatch match = joinTableIterator.next();
        joinTableList << match.captured(1).trimmed();
    }

    return joinTableList;
}

