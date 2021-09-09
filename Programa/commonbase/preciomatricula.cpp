#include "preciomatricula.h"

PrecioMatricula::PrecioMatricula()
{

}

int PrecioMatricula::id() const
{
    return m_id;
}

QString PrecioMatricula::tipo() const
{
    return m_tipo;
}

float PrecioMatricula::precio() const
{
    return m_precio;
}

QDateTime PrecioMatricula::fecha_creacion() const
{
    return m_fecha_creacion;
}

void PrecioMatricula::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void PrecioMatricula::setTipo(QString tipo)
{
    if (m_tipo == tipo)
        return;

    m_tipo = tipo;
    emit tipoChanged(m_tipo);
}

void PrecioMatricula::setPrecio(float precio)
{
    if (qFuzzyCompare(m_precio, precio))
        return;

    m_precio = precio;
    emit precioChanged(m_precio);
}

void PrecioMatricula::setFecha_creacion(QDateTime fecha_creacion)
{
    if (m_fecha_creacion == fecha_creacion)
        return;

    m_fecha_creacion = fecha_creacion;
    emit fecha_creacionChanged(m_fecha_creacion);
}
