#include "clienteasistenciasmovimientos.h"

ClienteAsistenciasMovimientos::ClienteAsistenciasMovimientos()
{

}

CMAlumno *ClienteAsistenciasMovimientos::alumno() const
{
    return m_alumno;
}

ListasConInformacion *ClienteAsistenciasMovimientos::listasConInformacion() const
{
    return m_listasConInformacion;
}

void ClienteAsistenciasMovimientos::setAlumno(CMAlumno *alumno)
{
    if (m_alumno == alumno)
        return;

    m_alumno = alumno;
    emit alumnoChanged(m_alumno);
}

void ClienteAsistenciasMovimientos::setListasConInformacion(ListasConInformacion *listasConInformacion)
{
    if (m_listasConInformacion == listasConInformacion)
        return;

    m_listasConInformacion = listasConInformacion;
    emit listasConInformacionChanged(m_listasConInformacion);
}
