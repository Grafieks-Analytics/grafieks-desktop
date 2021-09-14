#ifndef SAVEWORKBOOKWORKER_H
#define SAVEWORKBOOKWORKER_H

#include <QObject>
#include <QThread>
#include <QJsonDocument>

class SaveWorkbookWorker : public QThread
{
    Q_OBJECT
public:
    explicit SaveWorkbookWorker(QString &path, QJsonDocument mainObj);
    void saveWorkbooks();

protected:
    void run() override;

signals:

};

#endif // SAVEWORKBOOKWORKER_H
