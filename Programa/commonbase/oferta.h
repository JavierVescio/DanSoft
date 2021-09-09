#ifndef OFERTA_H
#define OFERTA_H
#include <QObject>
#include <QDate>
#include <QDateTime>

class Oferta: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString nombre READ nombre WRITE setNombre NOTIFY nombreChanged)
    Q_PROPERTY(QString descripcion READ descripcion WRITE setDescripcion NOTIFY descripcionChanged)
    Q_PROPERTY(QString tipo READ tipo WRITE setTipo NOTIFY tipoChanged)
    Q_PROPERTY(float precio READ precio WRITE setPrecio NOTIFY precioChanged)
    Q_PROPERTY(int stock READ stock WRITE setStock NOTIFY stockChanged)
    Q_PROPERTY(bool uno_por_alumno READ uno_por_alumno WRITE setUno_por_alumno NOTIFY uno_por_alumnoChanged)
    Q_PROPERTY(QDateTime fecha_creacion READ fecha_creacion WRITE setFecha_creacion NOTIFY fecha_creacionChanged)
    Q_PROPERTY(QDateTime fecha_vigente_desde READ fecha_vigente_desde WRITE setFecha_vigente_desde NOTIFY fecha_vigente_desdeChanged)
    Q_PROPERTY(QDateTime fecha_vigente_hasta READ fecha_vigente_hasta WRITE setFecha_vigente_hasta NOTIFY fecha_vigente_hastaChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)

public:
    Oferta();



    int id() const;

    QString nombre() const;

    QString descripcion() const;

    QString tipo() const;

    float precio() const;

    int stock() const;

    bool uno_por_alumno() const;

    QDateTime fecha_creacion() const;

    QDateTime fecha_vigente_desde() const;

    QDateTime fecha_vigente_hasta() const;

    QString estado() const;

public slots:
    void setId(int id);

    void setNombre(QString nombre);

    void setDescripcion(QString descripcion);

    void setTipo(QString tipo);

    void setPrecio(float precio);

    void setStock(int stock);

    void setUno_por_alumno(bool uno_por_alumno);

    void setFecha_creacion(QDateTime fecha_creacion);

    void setFecha_vigente_desde(QDateTime fecha_vigente_desde);

    void setFecha_vigente_hasta(QDateTime fecha_vigente_hasta);

    void setEstado(QString estado);

signals:
    void idChanged(int id);

    void nombreChanged(QString nombre);

    void descripcionChanged(QString descripcion);

    void tipoChanged(QString tipo);

    void precioChanged(float precio);

    void stockChanged(int stock);

    void uno_por_alumnoChanged(bool uno_por_alumno);

    void fecha_creacionChanged(QDateTime fecha_creacion);

    void fecha_vigente_desdeChanged(QDateTime fecha_vigente_desde);

    void fecha_vigente_hastaChanged(QDateTime fecha_vigente_hasta);

    void estadoChanged(QString estado);

private:


    int m_id;
    QString m_nombre;
    QString m_descripcion;
    QString m_tipo;
    float m_precio;
    int m_stock;
    bool m_uno_por_alumno;
    QDateTime m_fecha_creacion;
    QDateTime m_fecha_vigente_desde;
    QDateTime m_fecha_vigente_hasta;
    QString m_estado;
};

#endif // OFERTA_H
