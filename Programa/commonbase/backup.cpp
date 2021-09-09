#include "backup.h"

BackUp::BackUp()
{

}

int BackUp::id() const
{
    return m_id;
}

QString BackUp::ruta1() const
{
    return m_ruta1;
}

QString BackUp::ruta2() const
{
    return m_ruta2;
}

bool BackUp::al_cerrar_caja() const
{
    return m_al_cerrar_caja;
}

bool BackUp::al_cerrar_sistema() const
{
    return m_al_cerrar_sistema;
}

void BackUp::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void BackUp::setRuta1(QString ruta1)
{
    if (m_ruta1 == ruta1)
        return;

    m_ruta1 = ruta1;
    emit ruta1Changed(m_ruta1);
}

void BackUp::setRuta2(QString ruta2)
{
    if (m_ruta2 == ruta2)
        return;

    m_ruta2 = ruta2;
    emit ruta2Changed(m_ruta2);
}

void BackUp::setAl_cerrar_caja(bool al_cerrar_caja)
{
    if (m_al_cerrar_caja == al_cerrar_caja)
        return;

    m_al_cerrar_caja = al_cerrar_caja;
    emit al_cerrar_cajaChanged(m_al_cerrar_caja);
}

void BackUp::setAl_cerrar_sistema(bool al_cerrar_sistema)
{
    if (m_al_cerrar_sistema == al_cerrar_sistema)
        return;

    m_al_cerrar_sistema = al_cerrar_sistema;
    emit al_cerrar_sistemaChanged(m_al_cerrar_sistema);
}
