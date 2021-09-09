#ifndef MANAGERPESTANIAS_H
#define MANAGERPESTANIAS_H
#include <QObject>
#include "commonbase/pestania.h"

class ManagerPestanias : public QObject
{
    Q_OBJECT
public:
    explicit ManagerPestanias(QObject * parent = 0);
    Q_INVOKABLE void nuevaPestania(QString tituloPestania, QString source, QString color = "lightgrey", bool hayCambiosSinGuardar = false, bool sePuedeCerrar = true);
    Q_INVOKABLE bool eliminarPestania(QObject * pestania);

private:
    QList<QObject*> listaDePestanias;

signals:
    void sig_nuevaPestania(Pestania*arg);
    void sig_abrirPestania(QString arg);
public slots:

};

#endif // MANAGERPESTANIAS_H
