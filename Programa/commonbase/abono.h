#ifndef ABONO_H
#define ABONO_H
#include <QObject>
#include <QDate>
#include <QDateTime>

class Abono: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int id_cliente READ id_cliente WRITE setId_cliente NOTIFY id_clienteChanged)
    Q_PROPERTY(int id_abono_adulto READ id_abono_adulto WRITE setId_abono_adulto NOTIFY id_abono_adultoChanged)
    Q_PROPERTY(float precio_abono READ precio_abono WRITE setPrecio_abono NOTIFY precio_abonoChanged)
    Q_PROPERTY(QDate fecha_vigente READ fecha_vigente WRITE setFecha_vigente NOTIFY fecha_vigenteChanged)
    Q_PROPERTY(QDate fecha_vencimiento READ fecha_vencimiento WRITE setFecha_vencimiento NOTIFY fecha_vencimientoChanged)
    Q_PROPERTY(QString tipo READ tipo WRITE setTipo NOTIFY tipoChanged)
    Q_PROPERTY(int cantidad_clases READ cantidad_clases WRITE setCantidad_clases NOTIFY cantidad_clasesChanged)
    Q_PROPERTY(int cantidad_restante READ cantidad_restante WRITE setCantidad_restante NOTIFY cantidad_restanteChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)
    Q_PROPERTY(QDateTime fecha_compra READ fecha_compra WRITE setFecha_compra NOTIFY fecha_compraChanged)
    Q_PROPERTY(QDateTime blame_timestamp READ blame_timestamp WRITE setBlame_timestamp NOTIFY blame_timestampChanged)
    Q_PROPERTY(int cantidad_comprada READ cantidad_comprada WRITE setCantidad_comprada NOTIFY cantidad_compradaChanged)

public:
    Abono();
    int id() const;
    int id_cliente() const;
    int id_abono_adulto() const;
    float precio_abono() const;
    QDate fecha_vigente() const;
    QDate fecha_vencimiento() const;
    QString tipo() const;
    int cantidad_clases() const;
    int cantidad_restante() const;
    QString estado() const;
    QDateTime fecha_compra() const;
    QDateTime blame_timestamp() const;
    int cantidad_comprada() const;

public slots:
    void setId(int arg);
    void setId_cliente(int arg);
    void setId_abono_adulto(int id_abono_adulto);
    void setPrecio_abono(float precio_abono);
    void setFecha_vigente(QDate arg);
    void setFecha_vencimiento(QDate arg);
    void setTipo(QString arg);
    void setCantidad_clases(int arg);
    void setCantidad_restante(int arg);
    void setEstado(QString arg);
    void setFecha_compra(QDateTime arg);
    void setBlame_timestamp(QDateTime arg);
    void setCantidad_comprada(int arg);

signals:
    void idChanged(int arg);
    void id_clienteChanged(int arg);
    void id_abono_adultoChanged(int id_abono_adulto);
    void precio_abonoChanged(float precio_abono);
    void fecha_vigenteChanged(QDate arg);
    void fecha_vencimientoChanged(QDate arg);
    void tipoChanged(QString arg);
    void cantidad_clasesChanged(int arg);
    void cantidad_restanteChanged(int arg);
    void estadoChanged(QString arg);
    void fecha_compraChanged(QDateTime arg);
    void blame_timestampChanged(QDateTime arg);
    void cantidad_compradaChanged(int arg);

private:
    int m_id;
    int m_id_cliente;
    int m_id_abono_adulto;
    float m_precio_abono;
    QDate m_fecha_vigente;
    QDate m_fecha_vencimiento;
    QString m_tipo;
    int m_cantidad_clases;
    int m_cantidad_restante;
    QString m_estado;
    QDateTime m_fecha_compra;
    QDateTime m_blame_timestamp;
    int m_cantidad_comprada;
};

#endif // ABONO_H
