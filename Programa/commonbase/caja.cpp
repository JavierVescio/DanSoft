#include "caja.h"

Caja::Caja()
{

}

int Caja::id() const
{
    return m_id;
}

float Caja::monto_inicial() const
{
    return m_monto_inicial;
}

float Caja::monto_final() const
{
    return m_monto_final;
}

float Caja::monto_segun_sistema() const
{
    return m_monto_segun_sistema;
}

QString Caja::estado() const
{
    return m_estado;
}

float Caja::diferencia_monto() const
{
    return m_diferencia_monto;
}

QString Caja::comentario() const
{
    return m_comentario;
}

QDateTime Caja::fecha_inicio() const
{
    return m_fecha_inicio;
}

QDateTime Caja::fecha_cierre() const
{
    return m_fecha_cierre;
}

void Caja::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void Caja::setMonto_inicial(float monto_inicial)
{
    if (qFuzzyCompare(m_monto_inicial, monto_inicial))
        return;

    m_monto_inicial = monto_inicial;
    emit monto_inicialChanged(m_monto_inicial);
}

void Caja::setMonto_final(float monto_final)
{
    if (qFuzzyCompare(m_monto_final, monto_final))
        return;

    m_monto_final = monto_final;
    emit monto_finalChanged(m_monto_final);
}

void Caja::setMonto_segun_sistema(float monto_segun_sistema)
{
    if (qFuzzyCompare(m_monto_segun_sistema, monto_segun_sistema))
        return;

    m_monto_segun_sistema = monto_segun_sistema;
    emit monto_segun_sistemaChanged(m_monto_segun_sistema);
}

void Caja::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(m_estado);
}

void Caja::setFecha_inicio(QDateTime fecha_inicio)
{
    if (m_fecha_inicio == fecha_inicio)
        return;

    m_fecha_inicio = fecha_inicio;
    emit fecha_inicioChanged(m_fecha_inicio);
}

void Caja::setFecha_cierre(QDateTime fecha_cierre)
{
    if (m_fecha_cierre == fecha_cierre)
        return;

    m_fecha_cierre = fecha_cierre;
    emit fecha_cierreChanged(m_fecha_cierre);
}

void Caja::setComentario(QString comentario)
{
    if (m_comentario == comentario)
        return;

    m_comentario = comentario;
    emit comentarioChanged(m_comentario);
}


void Caja::setDiferencia_monto(float diferencia_monto)
{
    if (qFuzzyCompare(m_diferencia_monto, diferencia_monto))
        return;

    m_diferencia_monto = diferencia_monto;
    emit diferencia_montoChanged(m_diferencia_monto);
}
