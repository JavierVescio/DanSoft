#ifndef ABONOINFANTILCOMPRA_H
#define ABONOINFANTILCOMPRA_H

#include <QObject>
#include <QDateTime>

class AbonoInfantilCompra: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int id_cliente READ id_cliente WRITE setId_cliente NOTIFY id_clienteChanged)
    Q_PROPERTY(int id_abono_infantil READ id_abono_infantil WRITE setId_abono_infantil NOTIFY id_abono_infantilChanged)
    Q_PROPERTY(QDateTime fecha_compra READ fecha_compra WRITE setFecha_compra NOTIFY fecha_compraChanged)
    Q_PROPERTY(float precio_abono READ precio_abono WRITE setPrecio_abono NOTIFY precio_abonoChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)
    Q_PROPERTY(int clases_por_semana READ clases_por_semana WRITE setClases_por_semana NOTIFY clases_por_semanaChanged)

public:
    AbonoInfantilCompra();

    int id() const;
    int id_cliente() const;
    int id_abono_infantil() const;
    QDateTime fecha_compra() const;
    float precio_abono() const;
    QString estado() const;

    int clases_por_semana() const;

public slots:
    void setId(int id);
    void setId_cliente(int id_cliente);
    void setId_abono_infantil(int id_abono_infantil);
    void setFecha_compra(QDateTime fecha_compra);
    void setPrecio_abono(float precio_abono);
    void setEstado(QString estado);

    void setClases_por_semana(int clases_por_semana);

signals:
    void idChanged(int id);
    void id_clienteChanged(int id_cliente);
    void id_abono_infantilChanged(int id_abono_infantil);
    void fecha_compraChanged(QDateTime fecha_compra);
    void precio_abonoChanged(float precio_abono);
    void estadoChanged(QString estado);

    void clases_por_semanaChanged(int clases_por_semana);

private:
    int m_id;
    int m_id_cliente;
    int m_id_abono_infantil;
    QDateTime m_fecha_compra;
    float m_precio_abono;
    QString m_estado;
    int m_clases_por_semana;
};

#endif // ABONOINFANTILCOMPRA_H
