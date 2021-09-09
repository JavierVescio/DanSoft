#include "resumenmovimientosalumno.h"

ResumenMovimientosAlumno::ResumenMovimientosAlumno()
{
    m_total_pagado = 0;
}

int ResumenMovimientosAlumno::id_alumno() const
{
    return m_id_alumno;
}

QString ResumenMovimientosAlumno::apellido() const
{
    return m_apellido;
}

QString ResumenMovimientosAlumno::primer_nombre() const
{
    return m_primer_nombre;
}

QString ResumenMovimientosAlumno::segundo_nombre() const
{
    return m_segundo_nombre;
}

QJsonArray ResumenMovimientosAlumno::detalles() const
{
    return m_detalles;
}

void ResumenMovimientosAlumno::agregar_detalle(QJsonObject jsonObj)
{
    m_detalles.append(jsonObj);
    double monto = jsonObj.value("monto").toDouble();
    if (monto > 0){
        m_total_pagado += monto;
    }
}

float ResumenMovimientosAlumno::total_pagado() const
{
    return m_total_pagado;
}

QDate ResumenMovimientosAlumno::fecha_nacimiento() const
{
    return m_fecha_nacimiento;
}

void ResumenMovimientosAlumno::setId_alumno(int id_alumno)
{
    if (m_id_alumno == id_alumno)
        return;

    m_id_alumno = id_alumno;
    emit id_alumnoChanged(m_id_alumno);
}

void ResumenMovimientosAlumno::setApellido(QString apellido)
{
    if (m_apellido == apellido)
        return;

    m_apellido = apellido;
    emit apellidoChanged(m_apellido);
}

void ResumenMovimientosAlumno::setPrimer_nombre(QString primer_nombre)
{
    if (m_primer_nombre == primer_nombre)
        return;

    m_primer_nombre = primer_nombre;
    emit primer_nombreChanged(m_primer_nombre);
}

void ResumenMovimientosAlumno::setSegundo_nombre(QString segundo_nombre)
{
    if (m_segundo_nombre == segundo_nombre)
        return;

    m_segundo_nombre = segundo_nombre;
    emit segundo_nombreChanged(m_segundo_nombre);
}

void ResumenMovimientosAlumno::setDetalles(QJsonArray detalles)
{
    if (m_detalles == detalles)
        return;

    m_detalles = detalles;
    emit detallesChanged(m_detalles);
}

void ResumenMovimientosAlumno::settotal_pagado(float total_pagado)
{
    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(m_total_pagado, total_pagado))
        return;

    m_total_pagado = total_pagado;
    emit total_pagadoChanged(m_total_pagado);
}

void ResumenMovimientosAlumno::setFecha_nacimiento(QDate fecha_nacimiento)
{
    if (m_fecha_nacimiento == fecha_nacimiento)
        return;

    m_fecha_nacimiento = fecha_nacimiento;
    emit fecha_nacimientoChanged(m_fecha_nacimiento);
}
