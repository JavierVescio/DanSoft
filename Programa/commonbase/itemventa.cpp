#include "itemventa.h"

ItemVenta::ItemVenta()
{

}

int ItemVenta::id_oferta() const
{
    return m_id_oferta;
}

int ItemVenta::id_venta() const
{
    return m_id_venta;
}

int ItemVenta::cantidad() const
{
    return m_cantidad;
}

float ItemVenta::precio_subtotal() const
{
    return m_precio_subtotal;
}

void ItemVenta::setId_oferta(int id_oferta)
{
    if (m_id_oferta == id_oferta)
        return;

    m_id_oferta = id_oferta;
    emit id_ofertaChanged(m_id_oferta);
}

void ItemVenta::setId_venta(int id_venta)
{
    if (m_id_venta == id_venta)
        return;

    m_id_venta = id_venta;
    emit id_ventaChanged(m_id_venta);
}

void ItemVenta::setCantidad(int cantidad)
{
    if (m_cantidad == cantidad)
        return;

    m_cantidad = cantidad;
    emit cantidadChanged(m_cantidad);
}

void ItemVenta::setPrecio_subtotal(float precio_subtotal)
{
    if (qFuzzyCompare(m_precio_subtotal, precio_subtotal))
        return;

    m_precio_subtotal = precio_subtotal;
    emit precio_subtotalChanged(m_precio_subtotal);
}
