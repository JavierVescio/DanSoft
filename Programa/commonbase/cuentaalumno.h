#ifndef CUENTAALUMNO_H
#define CUENTAALUMNO_H

#include <QObject>

class CuentaAlumno: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int id_cliente READ id_cliente WRITE setId_cliente NOTIFY id_clienteChanged)
    Q_PROPERTY(float credito_actual READ credito_actual WRITE setCredito_actual NOTIFY credito_actualChanged)

public:
    CuentaAlumno();
    int id_cliente() const;
    float credito_actual() const;

    int id() const;

public slots:
    void setId_cliente(int id_cliente);
    void setCredito_actual(float credito_actual);

    void setId(int id);

private:
    int m_id_cliente;
    float m_credito_actual;

    int m_id;

signals:
    void id_clienteChanged(int id_cliente);
    void credito_actualChanged(float credito_actual);

    void idChanged(int id);
};

#endif // CUENTAALUMNO_H
