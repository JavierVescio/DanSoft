#include "claseasistenciainfantil.h"

ClaseAsistenciaInfantil::ClaseAsistenciaInfantil()
{

}

int ClaseAsistenciaInfantil::id() const
{
    return m_id;
}

int ClaseAsistenciaInfantil::id_abono_infantil_compra() const
{
    return m_id_abono_infantil_compra;
}

int ClaseAsistenciaInfantil::id_danza_clase() const
{
    return m_id_danza_clase;
}

QDateTime ClaseAsistenciaInfantil::fecha() const
{
    return m_fecha;
}

QString ClaseAsistenciaInfantil::estado() const
{
    return m_estado;
}

QString ClaseAsistenciaInfantil::nombre_clase() const
{
    return m_nombre_clase;
}

QString ClaseAsistenciaInfantil::nombre_actividad() const
{
    return m_nombre_actividad;
}

void ClaseAsistenciaInfantil::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void ClaseAsistenciaInfantil::setId_abono_infantil_compra(int id_abono_infantil_compra)
{
    if (m_id_abono_infantil_compra == id_abono_infantil_compra)
        return;

    m_id_abono_infantil_compra = id_abono_infantil_compra;
    emit id_abono_infantil_compraChanged(m_id_abono_infantil_compra);
}

void ClaseAsistenciaInfantil::setId_danza_clase(int id_danza_clase)
{
    if (m_id_danza_clase == id_danza_clase)
        return;

    m_id_danza_clase = id_danza_clase;
    emit id_danza_claseChanged(m_id_danza_clase);
}

void ClaseAsistenciaInfantil::setFecha(QDateTime fecha)
{
    if (m_fecha == fecha)
        return;

    m_fecha = fecha;
    emit fechaChanged(m_fecha);
}

void ClaseAsistenciaInfantil::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(m_estado);
}

void ClaseAsistenciaInfantil::setNombre_clase(QString nombre_clase)
{
    if (m_nombre_clase == nombre_clase)
        return;

    m_nombre_clase = nombre_clase;
    emit nombre_claseChanged(m_nombre_clase);
}

void ClaseAsistenciaInfantil::setNombre_actividad(QString nombre_actividad)
{
    if (m_nombre_actividad == nombre_actividad)
        return;

    m_nombre_actividad = nombre_actividad;
    emit nombre_actividadChanged(m_nombre_actividad);
}
