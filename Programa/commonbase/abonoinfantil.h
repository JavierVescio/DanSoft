#ifndef ABONOINFANTIL_H
#define ABONOINFANTIL_H

#include <QObject>
#include <QDateTime>

class AbonoInfantil: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(float precio_actual READ precio_actual WRITE setPrecio_actual NOTIFY precio_actualChanged)
    Q_PROPERTY(int clases_por_semana READ clases_por_semana WRITE setClases_por_semana NOTIFY clases_por_semanaChanged)
    Q_PROPERTY(QDateTime fecha_creacion READ fecha_creacion WRITE setFecha_creacion NOTIFY fecha_creacionChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)

public:
    AbonoInfantil();

    int id() const;
    float precio_actual() const;
    int clases_por_semana() const;
    QDateTime fecha_creacion() const;
    QString estado() const;


public slots:
    void setPrecio_actual(float precio_actual);
    void setClases_por_semana(int clases_por_semana);
    void setFecha_creacion(QDateTime fecha_creacion);
    void setEstado(QString estado);
    void setId(int id);

private:
    int m_id;
    float m_precio_actual;
    int m_clases_por_semana;
    QDateTime m_fecha_creacion;
    QString m_estado;

signals:
    void idChanged(int id);
    void precio_actualChanged(float precio_actual);
    void clases_por_semanaChanged(int clases_por_semana);
    void fecha_creacionChanged(QDateTime fecha_creacion);
    void estadoChanged(QString estado);
};

#endif // ABONOINFANTIL_H
