#ifndef DBLIST_H
#define DBLIST_H

#include <QObject>

class DBList : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString dbName READ dbName WRITE setDbName NOTIFY dbNameChanged)

    QString m_dbName;

public:
    explicit DBList(QObject *parent = nullptr);
    DBList(const QString &name, QObject * parent = nullptr);

    QString dbName() const;

public slots:
    void setDbName(QString dbName);

signals:
    void dbNameChanged(QString dbName);
};

#endif // DBLIST_H
