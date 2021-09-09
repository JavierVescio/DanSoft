#ifndef INSCRIPCIONCLIENTECLASE_H
#define INSCRIPCIONCLIENTECLASE_H

#include <QObject>
#include <QDateTime>

class InscripcionClienteClase: public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id_cliente READ id_cliente WRITE setId_cliente NOTIFY id_clienteChanged)
    Q_PROPERTY(int id_danza_clase READ id_danza_clase WRITE setId_danza_clase NOTIFY id_danza_claseChanged)
    Q_PROPERTY(QDateTime fecha_inscripcion READ fecha_inscripcion WRITE setFecha_inscripcion NOTIFY fecha_inscripcionChanged)
    Q_PROPERTY(QDateTime fecha_vencimiento READ fecha_vencimiento WRITE setFecha_vencimiento NOTIFY fecha_vencimientoChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)
    Q_PROPERTY(QString nombre_clase READ nombre_clase WRITE setNombre_clase NOTIFY nombre_claseChanged)
    Q_PROPERTY(QString nombre_actividad READ nombre_actividad WRITE setNombre_actividad NOTIFY nombre_actividadChanged)

public:
    InscripcionClienteClase();

    int id_cliente() const;

    int id_danza_clase() const;

    QDateTime fecha_inscripcion() const;

    QDateTime fecha_vencimiento() const;

    QString estado() const;

    QString nombre_clase() const;

    QString nombre_actividad() const;

public slots:
    void setId_cliente(int id_cliente);

    void setId_danza_clase(int id_danza_clase);

    void setFecha_inscripcion(QDateTime fecha_inscripcion);

    void setFecha_vencimiento(QDateTime fecha_vencimiento);

    void setEstado(QString estado);

    void setNombre_clase(QString nombre_clase);

    void setNombre_actividad(QString nombre_actividad);

signals:
    void id_clienteChanged(int id_cliente);

    void id_danza_claseChanged(int id_danza_clase);

    void fecha_inscripcionChanged(QDateTime fecha_inscripcion);

    void fecha_vencimientoChanged(QDateTime fecha_vencimiento);

    void estadoChanged(QString estado);

    void nombre_claseChanged(QString nombre_clase);

    void nombre_actividadChanged(QString nombre_actividad);

private:

    int m_id_cliente;
    int m_id_danza_clase;
    QDateTime m_fecha_inscripcion;
    QDateTime m_fecha_vencimiento;
    QString m_estado;
    QString m_nombre_clase;
    QString m_nombre_actividad;
};

#endif // INSCRIPCIONCLIENTECLASE_H
