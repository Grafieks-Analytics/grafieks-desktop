#ifndef GENERALPARAMSMODEL_H
#define GENERALPARAMSMODEL_H

#include <QObject>

class GeneralParamsModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int menuType READ menuType WRITE setMenuType NOTIFY menuTypeChanged)
    int m_menuType;

public:
    explicit GeneralParamsModel(QObject *parent = nullptr);

    int menuType() const;

public slots:
    void setMenuType(int menuType);

signals:

    void menuTypeChanged(int menuType);
};

#endif // GENERALPARAMSMODEL_H
