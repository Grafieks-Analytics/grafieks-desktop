#ifndef CSVCON_H
#define CSVCON_H

#include <QObject>
#include <QtDebug>
#include <QUrl>
#include <QFile>

#include "../constants.h"
#include "../Messages.h"
#include "../statics.h"

class CSVCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;

public:
    explicit CSVCon(QObject *parent = nullptr);
    QVariantMap CSVInstance(const QString & filepath);

    ~CSVCon();

signals:

};

#endif // CSVCON_H
