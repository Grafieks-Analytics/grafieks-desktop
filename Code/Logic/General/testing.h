#ifndef TESTING_H
#define TESTING_H

#include <QObject>


class Testing : public QObject
{
    Q_OBJECT
public:
    explicit Testing(QObject *parent = nullptr);

private:

};

#endif // TESTING_H
