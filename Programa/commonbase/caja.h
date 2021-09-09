#ifndef CAJA_H
#define CAJA_H

#include <QObject>
#include <QDateTime>

class Caja: public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(float monto_inicial READ monto_inicial WRITE setMonto_inicial NOTIFY monto_inicialChanged)
    Q_PROPERTY(float monto_final READ monto_final WRITE setMonto_final NOTIFY monto_finalChanged)
    Q_PROPERTY(float monto_segun_sistema READ monto_segun_sistema WRITE setMonto_segun_sistema NOTIFY monto_segun_sistemaChanged)
    Q_PROPERTY(float diferencia_monto READ diferencia_monto WRITE setDiferencia_monto NOTIFY diferencia_montoChanged)
    Q_PROPERTY(QString comentario READ comentario WRITE setComentario NOTIFY comentarioChanged)
    Q_PROPERTY(QDateTime fecha_inicio READ fecha_inicio WRITE setFecha_inicio NOTIFY fecha_inicioChanged)
    Q_PROPERTY(QDateTime fecha_cierre READ fecha_cierre WRITE setFecha_cierre NOTIFY fecha_cierreChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)

public:
    Caja();

    int id() const;

    float monto_inicial() const;

    float monto_final() const;

    float monto_segun_sistema() const;

    QString comentario() const;

    QDateTime fecha_inicio() const;

    QDateTime fecha_cierre() const;

    QString estado() const;

    float diferencia_monto() const;

public slots:
    void setId(int id);

    void setMonto_inicial(float monto_inicial);

    void setMonto_final(float monto_final);

    void setMonto_segun_sistema(float monto_segun_sistema);

    void setComentario(QString comentario);

    void setFecha_inicio(QDateTime fecha_inicio);

    void setFecha_cierre(QDateTime fecha_cierre);

    void setEstado(QString estado);


    void setDiferencia_monto(float diferencia_monto);

signals:
    void idChanged(int id);

    void monto_inicialChanged(float monto_inicial);

    void monto_finalChanged(float monto_final);

    void monto_segun_sistemaChanged(float monto_segun_sistema);

    void comentarioChanged(QString comentario);

    void fecha_inicioChanged(QDateTime fecha_inicio);

    void fecha_cierreChanged(QDateTime fecha_cierre);

    void estadoChanged(QString estado);


    void diferencia_montoChanged(float diferencia_monto);

private:

    int m_id;
    float m_monto_inicial;
    float m_monto_final;
    float m_monto_segun_sistema;
    QString m_comentario;
    QDateTime m_fecha_inicio;
    QDateTime m_fecha_cierre;
    QString m_estado;

    float m_diferencia_monto;
};

#endif // CAJA_H
