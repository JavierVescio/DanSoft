#include "abonoinfantilcompra.h"

AbonoInfantilCompra::AbonoInfantilCompra()
{

}

int AbonoInfantilCompra::id() const
{
    return m_id;
}

int AbonoInfantilCompra::id_cliente() const
{
    return m_id_cliente;
}

int AbonoInfantilCompra::id_abono_infantil() const
{
    return m_id_abono_infantil;
}

QDateTime AbonoInfantilCompra::fecha_compra() const
{
    return m_fecha_compra;
}

float AbonoInfantilCompra::precio_abono() const
{
    return m_precio_abono;
}

QString AbonoInfantilCompra::estado() const
{
    return m_estado;
}

int AbonoInfantilCompra::clases_por_semana() const
{
    return m_clases_por_semana;
}

void AbonoInfantilCompra::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void AbonoInfantilCompra::setId_cliente(int id_cliente)
{
    if (m_id_cliente == id_cliente)
        return;

    m_id_cliente = id_cliente;
    emit id_clienteChanged(m_id_cliente);
}

void AbonoInfantilCompra::setId_abono_infantil(int id_abono_infantil)
{
    if (m_id_abono_infantil == id_abono_infantil)
        return;

    m_id_abono_infantil = id_abono_infantil;
    emit id_abono_infantilChanged(m_id_abono_infantil);
}

void AbonoInfantilCompra::setFecha_compra(QDateTime fecha_compra)
{
    if (m_fecha_compra == fecha_compra)
        return;

    m_fecha_compra = fecha_compra;
    emit fecha_compraChanged(m_fecha_compra);
}

void AbonoInfantilCompra::setPrecio_abono(float precio_abono)
{

    if (qFuzzyCompare(m_precio_abono, precio_abono))
        return;

    m_precio_abono = precio_abono;
    emit precio_abonoChanged(m_precio_abono);
}

void AbonoInfantilCompra::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(m_estado);
}

void AbonoInfantilCompra::setClases_por_semana(int clases_por_semana)
{
    if (m_clases_por_semana == clases_por_semana)
        return;

    m_clases_por_semana = clases_por_semana;
    emit clases_por_semanaChanged(m_clases_por_semana);
}
