#ifndef QUERYSPLITTER_H
#define QUERYSPLITTER_H

#include <QObject>

class QuerySplitter : public QObject
{
    Q_OBJECT
public:
    explicit QuerySplitter(QObject *parent = nullptr);

    void setQuery(QString & query);

signals:

};

#endif // QUERYSPLITTER_H
