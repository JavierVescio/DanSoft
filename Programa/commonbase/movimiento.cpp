#include "movimiento.h"

Movimiento::Movimiento()
{

}

int Movimiento::id() const
{
    return m_id;
}

int Movimiento::id_estado_operacion() const
{
    return m_id_estado_operacion;
}

int Movimiento::id_cuenta_cliente() const
{
    return m_id_cuenta_cliente;
}

float Movimiento::monto() const
{
    return m_monto;
}

QDateTime Movimiento::fecha_movimiento() const
{
    return m_fecha_movimiento;
}

QString Movimiento::descripcion() const
{
    return m_descripcion;
}

float Movimiento::credito_cuenta() const
{
    return m_credito_cuenta;
}

QString Movimiento::codigo_oculto() const
{
    return m_codigo_oculto;
}

QString Movimiento::descripcion_tipo_operacion() const
{
    return m_descripcion_tipo_operacion;
}

void Movimiento::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void Movimiento::setId_estado_operacion(int id_estado_operacion)
{
    if (m_id_estado_operacion == id_estado_operacion)
        return;

    m_id_estado_operacion = id_estado_operacion;
    emit id_estado_operacionChanged(m_id_estado_operacion);
}

void Movimiento::setId_cuenta_cliente(int id_cuenta_cliente)
{
    if (m_id_cuenta_cliente == id_cuenta_cliente)
        return;

    m_id_cuenta_cliente = id_cuenta_cliente;
    emit id_cuenta_clienteChanged(m_id_cuenta_cliente);
}

void Movimiento::setMonto(float monto)
{
    
    if (qFuzzyCompare(m_monto, monto))
        return;

    m_monto = monto;
    emit montoChanged(m_monto);
}

void Movimiento::setFecha_movimiento(QDateTime fecha_movimiento)
{
    if (m_fecha_movimiento == fecha_movimiento)
        return;

    m_fecha_movimiento = fecha_movimiento;
    emit fecha_movimientoChanged(m_fecha_movimiento);
}

void Movimiento::setDescripcion(QString descripcion)
{
    if (m_descripcion == descripcion)
        return;

    m_descripcion = descripcion;
    emit descripcionChanged(m_descripcion);
}

void Movimiento::setCredito_cuenta(float credito_cuenta)
{
    
    if (qFuzzyCompare(m_credito_cuenta, credito_cuenta))
        return;

    m_credito_cuenta = credito_cuenta;
    emit credito_cuentaChanged(m_credito_cuenta);
}

void Movimiento::setCodigo_oculto(QString codigo_oculto)
{
    if (m_codigo_oculto == codigo_oculto)
        return;

    m_codigo_oculto = codigo_oculto;
    emit codigo_ocultoChanged(m_codigo_oculto);
}

void Movimiento::setDescripcion_tipo_operacion(QString descripcion_tipo_operacion)
{
    if (m_descripcion_tipo_operacion == descripcion_tipo_operacion)
        return;

    m_descripcion_tipo_operacion = descripcion_tipo_operacion;
    emit descripcion_tipo_operacionChanged(m_descripcion_tipo_operacion);
}
