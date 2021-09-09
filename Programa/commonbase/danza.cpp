#include "danza.h"

Danza::Danza()
{

}

int Danza::id() const
{
    return m_id;
}

QString Danza::nombre() const
{
    return m_nombre;
}

QString Danza::estado() const
{
    return m_estado;
}

QDateTime Danza::blame_timestamp() const
{
    return m_blame_timestamp;
}

void Danza::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(id);
}

void Danza::setNombre(QString nombre)
{
    if (m_nombre == nombre)
        return;

    m_nombre = nombre;
    emit nombreChanged(nombre);
}

void Danza::setEstado(QString estado)
{
    if (m_estado == estado)
        return;

    m_estado = estado;
    emit estadoChanged(estado);
}

void Danza::setBlame_timestamp(QDateTime blame_timestamp)
{
    if (m_blame_timestamp == blame_timestamp)
        return;

    m_blame_timestamp = blame_timestamp;
    emit blame_timestampChanged(blame_timestamp);
}
