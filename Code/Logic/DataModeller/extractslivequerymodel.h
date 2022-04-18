#ifndef EXTRACTSLIVEQUERYMODEL_H
#define EXTRACTSLIVEQUERYMODEL_H

#include <QObject>

class ExtractsLiveQueryModel : public QObject
{
    Q_OBJECT
public:
    explicit ExtractsLiveQueryModel(QObject *parent = nullptr);
    Q_INVOKABLE void hideSaveDSPopup();

signals:
    void showSaveExtractWaitPopup();

};

#endif // EXTRACTSLIVEQUERYMODEL_H
