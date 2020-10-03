#ifndef DASHBOARDCONTAINER_H
#define DASHBOARDCONTAINER_H

#include <QObject>

class DashboardContainerModel: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString lastContainerType READ lastContainerType WRITE setLastContainerType NOTIFY lastContainerTypeChanged)
    Q_PROPERTY(int positionX READ positionX WRITE setPositionX NOTIFY positionXChanged)
    Q_PROPERTY(int positionY READ positionY WRITE setPositionY NOTIFY positionYChanged)
    Q_PROPERTY(int zIndex READ zIndex WRITE setZIndex NOTIFY zIndexChanged)

    QString m_lastContainerType;
    int m_positionY;
    int m_positionX;

    int m_zIndex;

public:
    explicit DashboardContainerModel(QObject *parent = nullptr);

    QString lastContainerType() const;
    int positionY() const;
    int positionX() const;

    int zIndex() const;

public slots:
    void setLastContainerType(QString lastContainerType);
    void setPositionY(int positionY);
    void setPositionX(int positionX);

    void setZIndex(int zIndex);

signals:
    void lastContainerTypeChanged(QString lastContainerType);
    void positionYChanged(int positionY);
    void positionXChanged(int positionX);
    void zIndexChanged(int zIndex);
};

#endif // DASHBOARDCONTAINER_H
