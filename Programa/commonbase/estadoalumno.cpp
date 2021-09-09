#include "estadoalumno.h"

EstadoAlumno::EstadoAlumno()
{

}

int EstadoAlumno::id_alumno() const
{
    return m_id_alumno;
}

int EstadoAlumno::id_cuenta() const
{
    return m_id_cuenta;
}

float EstadoAlumno::credito() const
{
    return m_credito;
}

QString EstadoAlumno::nombre_cliente() const
{
    return m_nombre_cliente;
}

void EstadoAlumno::setId_alumno(int id_alumno)
{
    if (m_id_alumno == id_alumno)
        return;

    m_id_alumno = id_alumno;
    emit id_alumnoChanged(m_id_alumno);
}

void EstadoAlumno::setId_cuenta(int id_cuenta)
{
    if (m_id_cuenta == id_cuenta)
        return;

    m_id_cuenta = id_cuenta;
    emit id_cuentaChanged(m_id_cuenta);
}

void EstadoAlumno::setCredito(float credito)
{
    if (qFuzzyCompare(m_credito, credito))
        return;

    m_credito = credito;
    emit creditoChanged(m_credito);
}

void EstadoAlumno::setNombre_cliente(QString nombre_cliente)
{
    if (m_nombre_cliente == nombre_cliente)
        return;

    m_nombre_cliente = nombre_cliente;
    emit nombre_clienteChanged(m_nombre_cliente);
}
