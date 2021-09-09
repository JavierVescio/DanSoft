#ifndef MOVIMIENTO_H
#define MOVIMIENTO_H

#include <QObject>
#include <QDateTime>

class Movimiento: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int id_estado_operacion READ id_estado_operacion WRITE setId_estado_operacion NOTIFY id_estado_operacionChanged)
    Q_PROPERTY(int id_cuenta_cliente READ id_cuenta_cliente WRITE setId_cuenta_cliente NOTIFY id_cuenta_clienteChanged)
    Q_PROPERTY(float monto READ monto WRITE setMonto NOTIFY montoChanged)
    Q_PROPERTY(QDateTime fecha_movimiento READ fecha_movimiento WRITE setFecha_movimiento NOTIFY fecha_movimientoChanged)
    Q_PROPERTY(QString descripcion READ descripcion WRITE setDescripcion NOTIFY descripcionChanged)
    Q_PROPERTY(float credito_cuenta READ credito_cuenta WRITE setCredito_cuenta NOTIFY credito_cuentaChanged)
    Q_PROPERTY(QString codigo_oculto READ codigo_oculto WRITE setCodigo_oculto NOTIFY codigo_ocultoChanged)
    Q_PROPERTY(QString descripcion_tipo_operacion READ descripcion_tipo_operacion WRITE setDescripcion_tipo_operacion NOTIFY descripcion_tipo_operacionChanged)

    //Ejemplo de codigo: AI260 (significaria Abono Infantil de ID = 260)
    //Ejemplo de codigo: AA159 (significaria Abono Adulto de ID = 159), etc...
    ///El codigo_oculto no se muestra al usuario.


public:
    Movimiento();

    int id() const;
    int id_estado_operacion() const;
    int id_cuenta_cliente() const;
    float monto() const;
    QDateTime fecha_movimiento() const;
    QString descripcion() const;
    float credito_cuenta() const;
    QString codigo_oculto() const;
    QString descripcion_tipo_operacion() const;

public slots:
    void setId(int id);
    void setId_estado_operacion(int id_estado_operacion);
    void setId_cuenta_cliente(int id_cuenta_cliente);
    void setMonto(float monto);
    void setFecha_movimiento(QDateTime fecha_movimiento);
    void setDescripcion(QString descripcion);
    void setCredito_cuenta(float credito_cuenta);
    void setCodigo_oculto(QString codigo_oculto);
    void setDescripcion_tipo_operacion(QString descripcion_tipo_operacion);

private:
    int m_id;
    int m_id_estado_operacion;
    int m_id_cuenta_cliente;
    float m_monto;
    QDateTime m_fecha_movimiento;
    QString m_descripcion;
    float m_credito_cuenta;
    QString m_codigo_oculto;
    QString m_descripcion_tipo_operacion;

signals:
    void idChanged(int id);
    void id_estado_operacionChanged(int id_estado_operacion);
    void id_cuenta_clienteChanged(int id_cuenta_cliente);
    void montoChanged(float monto);
    void fecha_movimientoChanged(QDateTime fecha_movimiento);
    void descripcionChanged(QString descripcion);
    void credito_cuentaChanged(float credito_cuenta);
    void codigo_ocultoChanged(QString codigo_oculto);
    void descripcion_tipo_operacionChanged(QString descripcion_tipo_operacion);
};

#endif // MOVIMIENTO_H
