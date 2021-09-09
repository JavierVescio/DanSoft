#include "cuentaalumno.h"

CuentaAlumno::CuentaAlumno()
{

}

int CuentaAlumno::id_cliente() const
{
    return m_id_cliente;
}

float CuentaAlumno::credito_actual() const
{
    return m_credito_actual;
}

int CuentaAlumno::id() const
{
    return m_id;
}



void CuentaAlumno::setId_cliente(int id_cliente)
{
    if (m_id_cliente == id_cliente)
        return;

    m_id_cliente = id_cliente;
    emit id_clienteChanged(m_id_cliente);
}

void CuentaAlumno::setCredito_actual(float credito_actual)
{
    if (m_credito_actual == credito_actual)
        return;

    m_credito_actual = credito_actual;
    emit credito_actualChanged(m_credito_actual);
}

void CuentaAlumno::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

