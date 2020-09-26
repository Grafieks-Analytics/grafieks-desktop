#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>

class QtTest2 : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString a READ a WRITE setA NOTIFY aChanged)

    QString m_a;

public:
    explicit QtTest2(QObject *parent = nullptr);
    QString a() const;

    QMap<QString, QVariant> testFunc();
    QVariantMap testFunc2();

public slots:
    void setA(QString a);

signals:
    void aChanged(QString a);
};

#endif // QTTEST2_H
