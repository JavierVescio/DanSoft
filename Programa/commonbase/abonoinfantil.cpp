#include "abonoinfantil.h"

AbonoInfantil::AbonoInfantil()
{

}

int AbonoInfantil::id() const
{
    return m_id;
}


float AbonoInfantil::precio_actual() const
{
    return m_precio_actual;
}

int AbonoInfantil::clases_por_semana() const
{
    return m_clases_por_semana;
}

QDateTime AbonoInfantil::fecha_creacion() const
{
    return m_fecha_creacion;
}

QString AbonoInfantil::estado() const
{
    return m_estado;
}

void AbonoInfantil::setPrecio_actual(float precio_actual)
{

    if (qFuzzyCompare(m_precio_actual, precio_actual))
        return;

    m_precio_actual = precio_actual;
    emit precio_actualChanged(m_precio_actual);
}

void AbonoInfantil::setClases_por_semana(int clases_por_semana)
{
    if (m_clases_por_semana == clases_por_semana)
        return;

    m_clases_por_semana = clases_por_semana;
    emit clases_por_semanaChanged(m_clases_por_semana);
}

void AbonoInfantil::setFecha_creacion(QDateTime fecha_creacion)
{
    if (m_fecha_creacion == fecha_creacion)
        return;

    m_fecha_creacion = fecha_creacion;
    emit fecha_creacionChanged(m_fecha_creacion);
}

void AbonoInfantil::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(m_estado);
}

void AbonoInfantil::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

