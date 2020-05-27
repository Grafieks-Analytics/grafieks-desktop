#ifndef DBLIST_H
#define DBLIST_H

#include <QObject>

class DBList : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int dbId READ dbId WRITE setDbId NOTIFY dbIdChanged)
    Q_PROPERTY(QString dbName READ dbName WRITE setDbName NOTIFY dbNameChanged)

    QString m_dbName;
    int m_dbId;

public:
    explicit DBList(QObject *parent = nullptr);
    DBList(const int &id, const QString &name, QObject * parent = nullptr);

    QString dbName() const;
    int dbId() const;

public slots:
    void setDbName(QString dbName);
    void setDbId(int dbId);

signals:
    void dbNameChanged(QString dbName);
    void dbIdChanged(int dbId);
};

#endif // DBLIST_H
