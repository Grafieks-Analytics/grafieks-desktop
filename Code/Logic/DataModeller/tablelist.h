#ifndef TABLELIST_H
#define TABLELIST_H

#include <QObject>

class TableList : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString tableName READ tableName WRITE setTableName NOTIFY tableNameChanged)

    QString m_tableName;

public:
    explicit TableList(QObject *parent = nullptr);
    TableList(const QString &name, QObject * parent = nullptr);

    QString tableName() const;

public slots:
    void setTableName(QString tableName);

signals:
    void tableNameChanged(QString tableName);
};

#endif // TABLELIST_H
