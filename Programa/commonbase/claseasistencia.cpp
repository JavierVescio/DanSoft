#include "claseasistencia.h"

ClaseAsistencia::ClaseAsistencia()
{
    m_nombre_cliente = "";
    m_credencial_firmada = "";
}

int ClaseAsistencia::id() const
{
    return m_id;
}

int ClaseAsistencia::id_cliente() const
{
    return m_id_cliente;
}

int ClaseAsistencia::id_clase_horario() const
{
    return m_id_clase_horario;
}

QDateTime ClaseAsistencia::fecha() const
{
    return m_fecha;
}

QString ClaseAsistencia::clase_debitada() const
{
    return m_clase_debitada;
}

QString ClaseAsistencia::nombre_cliente() const
{
    return m_nombre_cliente;
}

QString ClaseAsistencia::credencial_firmada() const
{
    return m_credencial_firmada;
}

QString ClaseAsistencia::nombre_actividad() const
{
    return m_nombre_actividad;
}

QString ClaseAsistencia::nombre_clase() const
{
    return m_nombre_clase;
}

QString ClaseAsistencia::estado() const
{
    return m_estado;
}

void ClaseAsistencia::setId(int arg)
{
    if (m_id == arg)
        return;

    m_id = arg;
    emit idChanged(arg);
}

void ClaseAsistencia::setId_cliente(int arg)
{
    if (m_id_cliente == arg)
        return;

    m_id_cliente = arg;
    emit id_clienteChanged(arg);
}

void ClaseAsistencia::setId_clase_horario(int arg)
{
    if (m_id_clase_horario == arg)
        return;

    m_id_clase_horario = arg;
    emit id_clase_horarioChanged(arg);
}

void ClaseAsistencia::setFecha(QDateTime arg)
{
    if (m_fecha == arg)
        return;

    m_fecha = arg;
    emit fechaChanged(arg);
}

void ClaseAsistencia::setClase_debitada(QString arg)
{
    if (m_clase_debitada == arg)
        return;

    m_clase_debitada = arg;
    emit clase_debitadaChanged(arg);
}

void ClaseAsistencia::setNombre_cliente(QString arg)
{
    if (m_nombre_cliente == arg)
        return;

    m_nombre_cliente = arg;
    emit nombre_clienteChanged(arg);
}

void ClaseAsistencia::setCredencial_firmada(QString arg)
{
    if (m_credencial_firmada == arg)
        return;

    m_credencial_firmada = arg;
    emit credencial_firmadaChanged(arg);
}

void ClaseAsistencia::setNombre_actividad(QString nombre_actividad)
{
    if (m_nombre_actividad == nombre_actividad)
        return;

    m_nombre_actividad = nombre_actividad;
    emit nombre_actividadChanged(nombre_actividad);
}

void ClaseAsistencia::setNombre_clase(QString nombre_clase)
{
    if (m_nombre_clase == nombre_clase)
        return;

    m_nombre_clase = nombre_clase;
    emit nombre_claseChanged(nombre_clase);
}

void ClaseAsistencia::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(m_estado);
}
