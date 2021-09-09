#include "puntografico.h"

PuntoGrafico::PuntoGrafico()
{

}

QString PuntoGrafico::nombre() const
{
    return m_nombre;
}

QDateTime PuntoGrafico::fecha() const
{
    return m_fecha;
}

int PuntoGrafico::valor() const
{
    return m_valor;
}

void PuntoGrafico::setNombre(QString nombre)
{
    if (m_nombre == nombre)
        return;

    m_nombre = nombre;
    emit nombreChanged(m_nombre);
}

void PuntoGrafico::setFecha(QDateTime fecha)
{
    if (m_fecha == fecha)
        return;

    m_fecha = fecha;
    emit fechaChanged(m_fecha);
}

void PuntoGrafico::setValor(int valor)
{
    if (m_valor == valor)
        return;

    m_valor = valor;
    emit valorChanged(m_valor);
}
