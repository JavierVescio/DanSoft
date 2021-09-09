#ifndef ESTADOALUMNO_H
#define ESTADOALUMNO_H

#include <QObject>

class EstadoAlumno: public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id_alumno READ id_alumno WRITE setId_alumno NOTIFY id_alumnoChanged)
    Q_PROPERTY(int id_cuenta READ id_cuenta WRITE setId_cuenta NOTIFY id_cuentaChanged)
    Q_PROPERTY(float credito READ credito WRITE setCredito NOTIFY creditoChanged)
    Q_PROPERTY(QString nombre_cliente READ nombre_cliente WRITE setNombre_cliente NOTIFY nombre_clienteChanged)


public:
    EstadoAlumno();

    int id_alumno() const;

    int id_cuenta() const;

    float credito() const;

    QString nombre_cliente() const;

public slots:
    void setId_alumno(int id_alumno);

    void setId_cuenta(int id_cuenta);

    void setCredito(float credito);

    void setNombre_cliente(QString nombre_cliente);

signals:
    void id_alumnoChanged(int id_alumno);

    void id_cuentaChanged(int id_cuenta);

    void creditoChanged(float credito);

    void nombre_clienteChanged(QString nombre_cliente);

private:

    int m_id_alumno;
    int m_id_cuenta;
    float m_credito;
    QString m_nombre_cliente;
};

#endif // ESTADOALUMNO_H
