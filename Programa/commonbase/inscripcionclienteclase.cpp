#include "inscripcionclienteclase.h"

InscripcionClienteClase::InscripcionClienteClase()
{

}

int InscripcionClienteClase::id_cliente() const
{
    return m_id_cliente;
}

int InscripcionClienteClase::id_danza_clase() const
{
    return m_id_danza_clase;
}

QDateTime InscripcionClienteClase::fecha_inscripcion() const
{
    return m_fecha_inscripcion;
}

QDateTime InscripcionClienteClase::fecha_vencimiento() const
{
    return m_fecha_vencimiento;
}

QString InscripcionClienteClase::estado() const
{
    return m_estado;
}

QString InscripcionClienteClase::nombre_clase() const
{
    return m_nombre_clase;
}

QString InscripcionClienteClase::nombre_actividad() const
{
    return m_nombre_actividad;
}

void InscripcionClienteClase::setId_cliente(int id_cliente)
{
    if (m_id_cliente == id_cliente)
        return;

    m_id_cliente = id_cliente;
    emit id_clienteChanged(m_id_cliente);
}

void InscripcionClienteClase::setId_danza_clase(int id_danza_clase)
{
    if (m_id_danza_clase == id_danza_clase)
        return;

    m_id_danza_clase = id_danza_clase;
    emit id_danza_claseChanged(m_id_danza_clase);
}

void InscripcionClienteClase::setFecha_inscripcion(QDateTime fecha_inscripcion)
{
    if (m_fecha_inscripcion == fecha_inscripcion)
        return;

    m_fecha_inscripcion = fecha_inscripcion;
    emit fecha_inscripcionChanged(m_fecha_inscripcion);
}

void InscripcionClienteClase::setFecha_vencimiento(QDateTime fecha_vencimiento)
{
    if (m_fecha_vencimiento == fecha_vencimiento)
        return;

    m_fecha_vencimiento = fecha_vencimiento;
    emit fecha_vencimientoChanged(m_fecha_vencimiento);
}

void InscripcionClienteClase::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(m_estado);
}

void InscripcionClienteClase::setNombre_clase(QString nombre_clase)
{
    if (m_nombre_clase == nombre_clase)
        return;

    m_nombre_clase = nombre_clase;
    emit nombre_claseChanged(m_nombre_clase);
}

void InscripcionClienteClase::setNombre_actividad(QString nombre_actividad)
{
    if (m_nombre_actividad == nombre_actividad)
        return;

    m_nombre_actividad = nombre_actividad;
    emit nombre_actividadChanged(m_nombre_actividad);
}
