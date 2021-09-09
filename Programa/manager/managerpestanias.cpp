#include "managerpestanias.h"
#include <QDebug>

ManagerPestanias::ManagerPestanias(QObject * parent) : QObject(parent)
{
    listaDePestanias.clear();
}

void ManagerPestanias::nuevaPestania(QString tituloPestania, QString source, QString color, bool hayCambiosSinGuardar, bool sePuedeCerrar)
{
    int x=0;
    bool continuar = true;
    while (x < listaDePestanias.count() && continuar) {
        if (dynamic_cast<Pestania*>(listaDePestanias.at(x))->getSource() == source) {
            dynamic_cast<Pestania*>(listaDePestanias.at(x))->sig_mostrarme();
            continuar = false;
        }
        x++;
    }

    if (continuar) {
        Pestania * pestania = new Pestania(tituloPestania,source,color,hayCambiosSinGuardar,sePuedeCerrar);
        //QObject * objPestania = dynamic_cast<QObject*>(pestania);
        listaDePestanias.append(pestania);
        emit sig_nuevaPestania(pestania);
    }
}

bool ManagerPestanias::eliminarPestania(QObject * pestania) {
    return listaDePestanias.removeOne(pestania);
}
