#ifndef MYSQLLOGINMODEL_H
#define MYSQLLOGINMODEL_H

#include <QObject>
#include <QtDebug>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

/*!
 * \brief Initiates connection to a datasource from the view
 * \details Accepts login credentials from the view and calls the Connectors class
 * \ingroup ConnectorScreen
 */
class ConnectorsLoginModel : public QObject
{
    Q_OBJECT


public:
    explicit ConnectorsLoginModel(QObject *parent = nullptr);
    Q_INVOKABLE void mysqlLogin(QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void sqliteLogin(QString filename, QString username = "", QString password = "");


public slots:


signals:
    void mysqlLoginStatus(QVariantMap status);
    void sqliteLoginStatus(QVariantMap status);

};

#endif // MYSQLLOGINMODEL_H
