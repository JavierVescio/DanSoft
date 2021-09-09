#include "abonoadulto.h"

AbonoAdulto::AbonoAdulto()
{

}

int AbonoAdulto::id() const
{
    return m_id;
}

float AbonoAdulto::precio_actual() const
{
    return m_precio_actual;
}

int AbonoAdulto::total_clases() const
{
    return m_total_clases;
}

QDateTime AbonoAdulto::fecha_creacion() const
{
    return m_fecha_creacion;
}

QString AbonoAdulto::estado() const
{
    return m_estado;
}

void AbonoAdulto::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void AbonoAdulto::setPrecio_actual(float precio_actual)
{
    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(m_precio_actual, precio_actual))
        return;

    m_precio_actual = precio_actual;
    emit precio_actualChanged(m_precio_actual);
}

void AbonoAdulto::setTotal_clases(int total_clases)
{
    if (m_total_clases == total_clases)
        return;

    m_total_clases = total_clases;
    emit total_clasesChanged(m_total_clases);
}

void AbonoAdulto::setFecha_creacion(QDateTime fecha_creacion)
{
    if (m_fecha_creacion == fecha_creacion)
        return;

    m_fecha_creacion = fecha_creacion;
    emit fecha_creacionChanged(m_fecha_creacion);
}

void AbonoAdulto::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(m_estado);
}
