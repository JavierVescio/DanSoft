#ifndef ITEMVENTA_H
#define ITEMVENTA_H

#include <QObject>

class ItemVenta: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id_oferta READ id_oferta WRITE setId_oferta NOTIFY id_ofertaChanged)
    Q_PROPERTY(int id_venta READ id_venta WRITE setId_venta NOTIFY id_ventaChanged)
    Q_PROPERTY(int cantidad READ cantidad WRITE setCantidad NOTIFY cantidadChanged)
    Q_PROPERTY(float precio_subtotal READ precio_subtotal WRITE setPrecio_subtotal NOTIFY precio_subtotalChanged)

public:
    ItemVenta();

    int id_oferta() const;

    int id_venta() const;

    int cantidad() const;

    float precio_subtotal() const;

public slots:
    void setId_oferta(int id_oferta);

    void setId_venta(int id_venta);

    void setCantidad(int cantidad);

    void setPrecio_subtotal(float precio_subtotal);

signals:
    void id_ofertaChanged(int id_oferta);

    void id_ventaChanged(int id_venta);

    void cantidadChanged(int cantidad);

    void precio_subtotalChanged(float precio_subtotal);

private:
    int m_id_oferta;
    int m_id_venta;
    int m_cantidad;
    float m_precio_subtotal;
};

#endif // ITEMVENTA_H
