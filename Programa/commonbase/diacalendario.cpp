#include "diacalendario.h"

DiaCalendario::DiaCalendario()
{
    m_estado = "pasado";
}

DiaCalendario::DiaCalendario(QDate fecha, QString estado)
{
    this->fecha = fecha;
    m_estado = estado;
}


void DiaCalendario::setFecha(QDate fecha) {
    this->fecha = fecha;
    emit fechaChanged();
}

QDate DiaCalendario::getFecha() {
    return fecha;
}

QString DiaCalendario::getEstado() const
{
    return m_estado;
}

void DiaCalendario::setEstado(QString estado)
{
    m_estado = estado;
    emit estadoChanged();
}
