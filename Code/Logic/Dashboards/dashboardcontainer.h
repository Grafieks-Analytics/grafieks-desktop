#ifndef DASHBOARDCONTAINER_H
#define DASHBOARDCONTAINER_H

#include <QObject>

class DashboardContainer: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString lastContainerType READ lastContainerType WRITE setLastContainerType NOTIFY lastContainerTypeChanged)
    Q_PROPERTY(int positionX READ positionX WRITE setPositionX NOTIFY positionXChanged)
    Q_PROPERTY(int positionY READ positionY WRITE setPositionY NOTIFY positionYChanged)

    QString m_lastContainerType;

    int m_positionY;

    int m_positionX;

public:
    explicit DashboardContainer(QObject *parent = nullptr);

    QString lastContainerType() const;
    int positionY() const;

    int positionX() const;

public slots:
    void setLastContainerType(QString lastContainerType);

    void setPositionY(int positionY);

    void setPositionX(int positionX);

signals:
    void lastContainerTypeChanged(QString lastContainerType);

    void positionYChanged(int positionY);
    void positionXChanged(int positionX);
};

#endif // DASHBOARDCONTAINER_H
