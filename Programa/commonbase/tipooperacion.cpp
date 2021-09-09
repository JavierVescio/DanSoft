#include "tipooperacion.h"

TipoOperacion::TipoOperacion()
{

}

int TipoOperacion::id() const
{
    return m_id;
}

QString TipoOperacion::descripcion() const
{
    return m_descripcion;
}

void TipoOperacion::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void TipoOperacion::setDescripcion(QString descripcion)
{
    if (m_descripcion == descripcion)
        return;

    m_descripcion = descripcion;
    emit descripcionChanged(m_descripcion);
}
