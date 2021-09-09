#ifndef RESUMENMES_H
#define RESUMENMES_H

#include <QObject>
#include <QDate>

class ResumenMes: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int id_cliente READ id_cliente WRITE setId_cliente NOTIFY id_clienteChanged)
    Q_PROPERTY(QDate fecha READ fecha WRITE setFecha NOTIFY fechaChanged)
    Q_PROPERTY(float ultimo_saldo_parcial_mes READ ultimo_saldo_parcial_mes WRITE setUltimo_saldo_parcial_mes NOTIFY ultimo_saldo_parcial_mesChanged)
    Q_PROPERTY(float ultimo_saldo_acumulado_mes READ ultimo_saldo_acumulado_mes WRITE setUltimo_saldo_acumulado_mes NOTIFY ultimo_saldo_acumulado_mesChanged)

    ///El acumulado del mes M es el parcial del mes M - 1.

public:
    ResumenMes();

    int id() const;
    int id_cliente() const;
    QDate fecha() const;
    float ultimo_saldo_parcial_mes() const;
    float ultimo_saldo_acumulado_mes() const;

public slots:
    void setId(int id);
    void setId_cliente(int id_cliente);
    void setFecha(QDate fecha);
    void setUltimo_saldo_parcial_mes(float ultimo_saldo_parcial_mes);
    void setUltimo_saldo_acumulado_mes(float ultimo_saldo_acumulado_mes);

signals:
    void idChanged(int id);
    void id_clienteChanged(int id_cliente);
    void fechaChanged(QDate fecha);
    void ultimo_saldo_parcial_mesChanged(float ultimo_saldo_parcial_mes);
    void ultimo_saldo_acumulado_mesChanged(float ultimo_saldo_acumulado_mes);

private:
    int m_id;
    int m_id_cliente;
    QDate m_fecha;
    float m_ultimo_saldo_parcial_mes;
    float m_ultimo_saldo_acumulado_mes;
};

#endif // RESUMENMES_H
