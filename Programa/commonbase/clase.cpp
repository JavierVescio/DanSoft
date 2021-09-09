#include "clase.h"

Clase::Clase()
{

}

int Clase::id() const
{
    return m_id;
}

QString Clase::nombre() const
{
    return m_nombre;
}

QString Clase::estado() const
{
    return m_estado;
}

QDateTime Clase::blame_timestamp() const
{
    return m_blame_timestamp;
}

QString Clase::categoria() const
{
    return m_categoria;
}

QString Clase::dias_semana() const
{
    return m_dias_semana;
}

int Clase::id_danza() const
{
    return m_id_danza;
}

void Clase::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(id);
}

void Clase::setNombre(QString nombre)
{
    if (m_nombre == nombre)
        return;

    m_nombre = nombre;
    emit nombreChanged(nombre);
}

void Clase::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(estado);
}

void Clase::setBlame_timestamp(QDateTime blame_timestamp)
{
    if (m_blame_timestamp == blame_timestamp)
        return;

    m_blame_timestamp = blame_timestamp;
    emit blame_timestampChanged(blame_timestamp);
}

void Clase::setCategoria(QString categoria)
{
    if (m_categoria == categoria)
        return;

    m_categoria = categoria;
    emit categoriaChanged(m_categoria);
}

void Clase::setDias_semana(QString dias_semana)
{
    if (m_dias_semana == dias_semana)
        return;

    m_dias_semana = dias_semana;
    emit dias_semanaChanged(m_dias_semana);
}

void Clase::setId_danza(int id_danza)
{
    if (m_id_danza == id_danza)
        return;

    m_id_danza = id_danza;
    emit id_danzaChanged(id_danza);
}
