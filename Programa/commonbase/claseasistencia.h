#ifndef CLASEASISTENCIA_H
#define CLASEASISTENCIA_H
#include <QObject>
#include <QDateTime>

class ClaseAsistencia: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int id_cliente READ id_cliente WRITE setId_cliente NOTIFY id_clienteChanged)
    Q_PROPERTY(int id_clase_horario READ id_clase_horario WRITE setId_clase_horario NOTIFY id_clase_horarioChanged)
    Q_PROPERTY(QDateTime fecha READ fecha WRITE setFecha  NOTIFY fechaChanged)
    Q_PROPERTY(QString clase_debitada READ clase_debitada WRITE setClase_debitada NOTIFY clase_debitadaChanged)
    Q_PROPERTY(QString nombre_cliente READ nombre_cliente WRITE setNombre_cliente NOTIFY nombre_clienteChanged)
    Q_PROPERTY(QString credencial_firmada READ credencial_firmada WRITE setCredencial_firmada NOTIFY credencial_firmadaChanged)
    Q_PROPERTY(QString nombre_actividad READ nombre_actividad WRITE setNombre_actividad NOTIFY nombre_actividadChanged)
    Q_PROPERTY(QString nombre_clase READ nombre_clase WRITE setNombre_clase NOTIFY nombre_claseChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)

public:
    ClaseAsistencia();
    int id() const;
    int id_cliente() const;
    int id_clase_horario() const;
    QDateTime fecha() const;
    QString clase_debitada() const;
    QString nombre_cliente() const;
    QString credencial_firmada() const;
    QString nombre_actividad() const;
    QString nombre_clase() const;

    QString estado() const;

public slots:
    void setId(int arg);
    void setId_cliente(int arg);
    void setId_clase_horario(int arg);
    void setFecha(QDateTime arg);
    void setClase_debitada(QString arg);
    void setNombre_cliente(QString arg);
    void setCredencial_firmada(QString arg);
    void setNombre_actividad(QString nombre_actividad);
    void setNombre_clase(QString nombre_clase);

    void setEstado(QString estado);

signals:
    void idChanged(int arg);
    void id_clienteChanged(int arg);
    void id_clase_horarioChanged(int arg);
    void fechaChanged(QDateTime arg);
    void clase_debitadaChanged(QString arg);
    void nombre_clienteChanged(QString arg);
    void credencial_firmadaChanged(QString arg);
    void nombre_actividadChanged(QString nombre_actividad);
    void nombre_claseChanged(QString nombre_clase);

    void estadoChanged(QString estado);

private:
    int m_id;
    int m_id_cliente;
    int m_id_clase_horario;
    QDateTime m_fecha;
    QString m_clase_debitada;
    QString m_nombre_cliente;
    QString m_credencial_firmada;
    QString m_nombre_actividad;
    QString m_nombre_clase;
    QString m_estado;
};

#endif // CLASEASISTENCIA_H
