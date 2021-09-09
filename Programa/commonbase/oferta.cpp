#include "oferta.h"

Oferta::Oferta()
{

}



int Oferta::id() const
{
    return m_id;
}

QString Oferta::nombre() const
{
    return m_nombre;
}

QString Oferta::descripcion() const
{
    return m_descripcion;
}

QString Oferta::tipo() const
{
    return m_tipo;
}

float Oferta::precio() const
{
    return m_precio;
}

int Oferta::stock() const
{
    return m_stock;
}

bool Oferta::uno_por_alumno() const
{
    return m_uno_por_alumno;
}

QDateTime Oferta::fecha_creacion() const
{
    return m_fecha_creacion;
}

QDateTime Oferta::fecha_vigente_desde() const
{
    return m_fecha_vigente_desde;
}

QDateTime Oferta::fecha_vigente_hasta() const
{
    return m_fecha_vigente_hasta;
}

QString Oferta::estado() const
{
    return m_estado;
}

void Oferta::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void Oferta::setNombre(QString nombre)
{
    if (m_nombre == nombre)
        return;

    m_nombre = nombre;
    emit nombreChanged(m_nombre);
}

void Oferta::setDescripcion(QString descripcion)
{
    if (m_descripcion == descripcion)
        return;

    m_descripcion = descripcion;
    emit descripcionChanged(m_descripcion);
}

void Oferta::setTipo(QString tipo)
{
    if (m_tipo == tipo)
        return;

    m_tipo = tipo;
    emit tipoChanged(m_tipo);
}

void Oferta::setPrecio(float precio)
{
    //qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(m_precio, precio))
        return;

    m_precio = precio;
    emit precioChanged(m_precio);
}

void Oferta::setStock(int stock)
{
    if (m_stock == stock)
        return;

    m_stock = stock;
    emit stockChanged(m_stock);
}

void Oferta::setUno_por_alumno(bool uno_por_alumno)
{
    if (m_uno_por_alumno == uno_por_alumno)
        return;

    m_uno_por_alumno = uno_por_alumno;
    emit uno_por_alumnoChanged(m_uno_por_alumno);
}

void Oferta::setFecha_creacion(QDateTime fecha_creacion)
{
    if (m_fecha_creacion == fecha_creacion)
        return;

    m_fecha_creacion = fecha_creacion;
    emit fecha_creacionChanged(m_fecha_creacion);
}

void Oferta::setFecha_vigente_desde(QDateTime fecha_vigente_desde)
{
    if (m_fecha_vigente_desde == fecha_vigente_desde)
        return;

    m_fecha_vigente_desde = fecha_vigente_desde;
    emit fecha_vigente_desdeChanged(m_fecha_vigente_desde);
}

void Oferta::setFecha_vigente_hasta(QDateTime fecha_vigente_hasta)
{
    if (m_fecha_vigente_hasta == fecha_vigente_hasta)
        return;

    m_fecha_vigente_hasta = fecha_vigente_hasta;
    emit fecha_vigente_hastaChanged(m_fecha_vigente_hasta);
}

void Oferta::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(m_estado);
}
