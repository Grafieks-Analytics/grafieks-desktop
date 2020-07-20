#ifndef DSPARAMSMODEL_H
#define DSPARAMSMODEL_H

#include <QObject>

class DSParamsModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString dsName READ dsName WRITE setDsName NOTIFY dsNameChanged)
    Q_PROPERTY(QString dsType READ dsType WRITE setDsType NOTIFY dsTypeChanged)


    QString m_dsName;
    QString m_dsType;

public:
    explicit DSParamsModel(QObject *parent = nullptr);

    QString dsName() const;
    QString dsType() const;

public slots:
    void setDsName(QString dsName);
    void setDsType(QString dsType);

signals:

    void dsNameChanged(QString dsName);
    void dsTypeChanged(QString dsType);
};

#endif // DSPARAMSMODEL_H
