#include "abono.h"

Abono::Abono()
{

}

int Abono::id() const
{
    return m_id;
}

int Abono::id_cliente() const
{
    return m_id_cliente;
}

QDate Abono::fecha_vigente() const
{
    return m_fecha_vigente;
}

QDate Abono::fecha_vencimiento() const
{
    return m_fecha_vencimiento;
}

QString Abono::tipo() const
{
    return m_tipo;
}

int Abono::cantidad_clases() const
{
    return m_cantidad_clases;
}

int Abono::cantidad_restante() const
{
    return m_cantidad_restante;
}

QString Abono::estado() const
{
    return m_estado;
}

QDateTime Abono::fecha_compra() const
{
    return m_fecha_compra;
}

QDateTime Abono::blame_timestamp() const
{
    return m_blame_timestamp;
}

int Abono::cantidad_comprada() const
{
    return m_cantidad_comprada;
}

int Abono::id_abono_adulto() const
{
    return m_id_abono_adulto;
}

float Abono::precio_abono() const
{
    return m_precio_abono;
}

void Abono::setId(int arg)
{
    if (m_id == arg)
        return;

    m_id = arg;
    emit idChanged(arg);
}

void Abono::setId_cliente(int arg)
{
    if (m_id_cliente == arg)
        return;

    m_id_cliente = arg;
    emit id_clienteChanged(arg);
}

void Abono::setFecha_vigente(QDate arg)
{
    if (m_fecha_vigente == arg)
        return;

    m_fecha_vigente = arg;
    emit fecha_vigenteChanged(arg);
}

void Abono::setFecha_vencimiento(QDate arg)
{
    if (m_fecha_vencimiento == arg)
        return;

    m_fecha_vencimiento = arg;
    emit fecha_vencimientoChanged(arg);
}

void Abono::setTipo(QString arg)
{
    if (m_tipo == arg)
        return;

    m_tipo = arg;
    emit tipoChanged(arg);
}

void Abono::setCantidad_clases(int arg)
{
    if (m_cantidad_clases == arg)
        return;

    m_cantidad_clases = arg;
    emit cantidad_clasesChanged(arg);
}

void Abono::setCantidad_restante(int arg)
{
    if (m_cantidad_restante == arg)
        return;

    m_cantidad_restante = arg;
    emit cantidad_restanteChanged(arg);
}

void Abono::setEstado(QString arg)
{
    if (m_estado == arg)
        return;

    m_estado = arg;
    emit estadoChanged(arg);
}

void Abono::setFecha_compra(QDateTime arg)
{
    if (m_fecha_compra == arg)
        return;

    m_fecha_compra = arg;
    emit fecha_compraChanged(arg);
}

void Abono::setBlame_timestamp(QDateTime arg)
{
    if (m_blame_timestamp == arg)
        return;

    m_blame_timestamp = arg;
    emit blame_timestampChanged(arg);
}

void Abono::setCantidad_comprada(int arg)
{
    if (m_cantidad_comprada == arg)
        return;

    m_cantidad_comprada = arg;
    emit cantidad_compradaChanged(arg);
}

void Abono::setId_abono_adulto(int id_abono_adulto)
{
    if (m_id_abono_adulto == id_abono_adulto)
        return;

    m_id_abono_adulto = id_abono_adulto;
    emit id_abono_adultoChanged(m_id_abono_adulto);
}

void Abono::setPrecio_abono(float precio_abono)
{
    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(m_precio_abono, precio_abono))
        return;

    m_precio_abono = precio_abono;
    emit precio_abonoChanged(m_precio_abono);
}
