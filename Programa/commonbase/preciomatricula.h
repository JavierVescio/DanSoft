#ifndef PRECIOMATRICULA_H
#define PRECIOMATRICULA_H

#include <QObject>
#include <QDateTime>

class PrecioMatricula: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString tipo READ tipo WRITE setTipo NOTIFY tipoChanged)
    Q_PROPERTY(float precio READ precio WRITE setPrecio NOTIFY precioChanged)
    Q_PROPERTY(QDateTime fecha_creacion READ fecha_creacion WRITE setFecha_creacion NOTIFY fecha_creacionChanged)

public:
    PrecioMatricula();
    int id() const;
    QString tipo() const;
    float precio() const;
    QDateTime fecha_creacion() const;

public slots:
    void setId(int id);
    void setTipo(QString tipo);

    void setPrecio(float precio);

    void setFecha_creacion(QDateTime fecha_creacion);

private:
    int m_id;

    QString m_tipo;

    float m_precio;

    QDateTime m_fecha_creacion;

signals:
    void idChanged(int id);
    void tipoChanged(QString tipo);
    void precioChanged(float precio);
    void fecha_creacionChanged(QDateTime fecha_creacion);
};

#endif // PRECIOMATRICULA_H
