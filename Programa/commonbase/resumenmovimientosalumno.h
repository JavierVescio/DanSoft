#ifndef RESUMENMOVIMIENTOSALUMNO_H
#define RESUMENMOVIMIENTOSALUMNO_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QDate>

class ResumenMovimientosAlumno: public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id_alumno READ id_alumno WRITE setId_alumno NOTIFY id_alumnoChanged)
    Q_PROPERTY(QString apellido READ apellido WRITE setApellido NOTIFY apellidoChanged)
    Q_PROPERTY(QString primer_nombre READ primer_nombre WRITE setPrimer_nombre NOTIFY primer_nombreChanged)
    Q_PROPERTY(QDate fecha_nacimiento READ fecha_nacimiento WRITE setFecha_nacimiento NOTIFY fecha_nacimientoChanged)
    Q_PROPERTY(QString segundo_nombre READ segundo_nombre WRITE setSegundo_nombre NOTIFY segundo_nombreChanged)
    Q_PROPERTY(float total_pagado READ total_pagado WRITE settotal_pagado NOTIFY total_pagadoChanged)
    Q_PROPERTY(QJsonArray detalles READ detalles WRITE setDetalles NOTIFY detallesChanged)


public:
    ResumenMovimientosAlumno();

    int id_alumno() const;

    QString apellido() const;

    QString primer_nombre() const;

    QString segundo_nombre() const;

    QJsonArray detalles() const;

    void agregar_detalle(QJsonObject jsonObj);

    float total_pagado() const;

    QDate fecha_nacimiento() const;

public slots:
    void setId_alumno(int id_alumno);

    void setApellido(QString apellido);

    void setPrimer_nombre(QString primer_nombre);

    void setSegundo_nombre(QString segundo_nombre);

    void setDetalles(QJsonArray detalles);

    void settotal_pagado(float total_pagado);

    void setFecha_nacimiento(QDate fecha_nacimiento);

signals:
    void id_alumnoChanged(int id_alumno);

    void apellidoChanged(QString apellido);

    void primer_nombreChanged(QString primer_nombre);

    void segundo_nombreChanged(QString segundo_nombre);

    void detallesChanged(QJsonArray detalles);

    void total_pagadoChanged(float total_pagado);

    void fecha_nacimientoChanged(QDate fecha_nacimiento);

private:

    int m_id_alumno;
    QString m_apellido;
    QString m_primer_nombre;
    QString m_segundo_nombre;
    QJsonArray m_detalles;
    float m_total_pagado;
    QDate m_fecha_nacimiento;
};

#endif // RESUMENMOVIMIENTOSALUMNO_H
