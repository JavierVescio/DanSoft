#include "evento.h"

Evento::Evento() {

}

Evento::Evento(QDate fecha, QString descripcion) {
    this->m_fecha = fecha;
    this->m_descripcion = descripcion;
}

int Evento::id() const{
    return m_id;
}

QDate Evento::getFecha(){
    return m_fecha;
}

QString Evento::descripcion() const {
    return m_descripcion;
}
