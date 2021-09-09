#include "resumenmes.h"

ResumenMes::ResumenMes()
{

}

int ResumenMes::id() const
{
    return m_id;
}

int ResumenMes::id_cliente() const
{
    return m_id_cliente;
}

QDate ResumenMes::fecha() const
{
    return m_fecha;
}

float ResumenMes::ultimo_saldo_parcial_mes() const
{
    return m_ultimo_saldo_parcial_mes;
}

float ResumenMes::ultimo_saldo_acumulado_mes() const
{
    return m_ultimo_saldo_acumulado_mes;
}

void ResumenMes::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void ResumenMes::setId_cliente(int id_cliente)
{
    if (m_id_cliente == id_cliente)
        return;

    m_id_cliente = id_cliente;
    emit id_clienteChanged(m_id_cliente);
}

void ResumenMes::setFecha(QDate fecha)
{
    if (m_fecha == fecha)
        return;

    m_fecha = fecha;
    emit fechaChanged(m_fecha);
}

void ResumenMes::setUltimo_saldo_parcial_mes(float ultimo_saldo_parcial_mes)
{
    
    if (qFuzzyCompare(m_ultimo_saldo_parcial_mes, ultimo_saldo_parcial_mes))
        return;

    m_ultimo_saldo_parcial_mes = ultimo_saldo_parcial_mes;
    emit ultimo_saldo_parcial_mesChanged(m_ultimo_saldo_parcial_mes);
}

void ResumenMes::setUltimo_saldo_acumulado_mes(float ultimo_saldo_acumulado_mes)
{
    
    if (qFuzzyCompare(m_ultimo_saldo_acumulado_mes, ultimo_saldo_acumulado_mes))
        return;

    m_ultimo_saldo_acumulado_mes = ultimo_saldo_acumulado_mes;
    emit ultimo_saldo_acumulado_mesChanged(m_ultimo_saldo_acumulado_mes);
}
