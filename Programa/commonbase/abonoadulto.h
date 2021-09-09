#ifndef ABONOADULTO_H
#define ABONOADULTO_H

#include <QObject>
#include <QDateTime>

class AbonoAdulto: public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(float precio_actual READ precio_actual WRITE setPrecio_actual NOTIFY precio_actualChanged)
    Q_PROPERTY(int total_clases READ total_clases WRITE setTotal_clases NOTIFY total_clasesChanged)
    Q_PROPERTY(QDateTime fecha_creacion READ fecha_creacion WRITE setFecha_creacion NOTIFY fecha_creacionChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)

public:
    AbonoAdulto();

    int id() const;
    float precio_actual() const;
    int total_clases() const;
    QDateTime fecha_creacion() const;
    QString estado() const;

public slots:
    void setId(int id);
    void setPrecio_actual(float precio_actual);
    void setTotal_clases(int total_clases);
    void setFecha_creacion(QDateTime fecha_creacion);
    void setEstado(QString estado);

signals:
    void idChanged(int id);
    void precio_actualChanged(float precio_actual);
    void total_clasesChanged(int total_clases);
    void fecha_creacionChanged(QDateTime fecha_creacion);
    void estadoChanged(QString estado);

private:
    int m_id;
    float m_precio_actual;
    int m_total_clases;
    QDateTime m_fecha_creacion;
    QString m_estado;
};

#endif // ABONOADULTO_H
