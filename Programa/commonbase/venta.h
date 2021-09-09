#ifndef VENTA_H
#define VENTA_H

#include <QObject>
#include <QDateTime>

class Venta: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int id_cliente READ id_cliente WRITE setId_cliente NOTIFY id_clienteChanged)
    Q_PROPERTY(QDateTime fecha READ fecha WRITE setFecha NOTIFY fechaChanged)
    Q_PROPERTY(float precio_total READ precio_total WRITE setPrecio_total NOTIFY precio_totalChanged)
    Q_PROPERTY(QString comentario READ comentario WRITE setComentario NOTIFY comentarioChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)

public:
    Venta();

    int id() const;

    int id_cliente() const;

    QDateTime fecha() const;

    float precio_total() const;

    QString comentario() const;

    QString estado() const;

public slots:
    void setId(int id);

    void setId_cliente(int id_cliente);

    void setFecha(QDateTime fecha);

    void setPrecio_total(float precio_total);

    void setComentario(QString comentario);

    void setEstado(QString estado);

signals:
    void idChanged(int id);

    void id_clienteChanged(int id_cliente);

    void fechaChanged(QDateTime fecha);

    void precio_totalChanged(float precio_total);

    void comentarioChanged(QString comentario);

    void estadoChanged(QString estado);

private:

    int m_id;
    int m_id_cliente;
    QDateTime m_fecha;
    float m_precio_total;
    QString m_comentario;
    QString m_estado;
};

#endif // VENTA_H
