#ifndef SQLREPORTSDS_H
#define SQLREPORTSDS_H

#include <QObject>

class SqlReportsDS : public QObject
{
    Q_OBJECT
public:
    explicit SqlReportsDS(QObject *parent = nullptr);

signals:

};

#endif // SQLREPORTSDS_H
