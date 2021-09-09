#include "venta.h"

Venta::Venta()
{

}

int Venta::id() const
{
    return m_id;
}

int Venta::id_cliente() const
{
    return m_id_cliente;
}

QDateTime Venta::fecha() const
{
    return m_fecha;
}

float Venta::precio_total() const
{
    return m_precio_total;
}

QString Venta::comentario() const
{
    return m_comentario;
}

QString Venta::estado() const
{
    return m_estado;
}

void Venta::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void Venta::setId_cliente(int id_cliente)
{
    if (m_id_cliente == id_cliente)
        return;

    m_id_cliente = id_cliente;
    emit id_clienteChanged(m_id_cliente);
}

void Venta::setFecha(QDateTime fecha)
{
    if (m_fecha == fecha)
        return;

    m_fecha = fecha;
    emit fechaChanged(m_fecha);
}

void Venta::setPrecio_total(float precio_total)
{
    if (qFuzzyCompare(m_precio_total, precio_total))
        return;

    m_precio_total = precio_total;
    emit precio_totalChanged(m_precio_total);
}

void Venta::setComentario(QString comentario)
{
    if (m_comentario == comentario)
        return;

    m_comentario = comentario;
    emit comentarioChanged(m_comentario);
}

void Venta::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(m_estado);
}
