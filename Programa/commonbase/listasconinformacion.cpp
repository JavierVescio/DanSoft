#include "listasconinformacion.h"

ListasConInformacion::ListasConInformacion()
{

}

QList<QObject *> ListasConInformacion::listaAsistencias() const
{
    return m_listaAsistencias;
}

QList<QObject *> ListasConInformacion::listaMovimientos() const
{
    return m_listaMovimientos;
}

void ListasConInformacion::setListaAsistencias(QList<QObject *> listaAsistencias)
{
    if (m_listaAsistencias == listaAsistencias)
        return;

    m_listaAsistencias = listaAsistencias;
    emit listaAsistenciasChanged(m_listaAsistencias);
}

void ListasConInformacion::setListaMovimientos(QList<QObject *> listaMovimientos)
{
    if (m_listaMovimientos == listaMovimientos)
        return;

    m_listaMovimientos = listaMovimientos;
    emit listaMovimientosChanged(m_listaMovimientos);
}
