#ifndef CLASEASISTENCIAINFANTIL_H
#define CLASEASISTENCIAINFANTIL_H

#include <QObject>
#include <QDateTime>

class ClaseAsistenciaInfantil: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int id_abono_infantil_compra READ id_abono_infantil_compra WRITE setId_abono_infantil_compra NOTIFY id_abono_infantil_compraChanged)
    Q_PROPERTY(int id_danza_clase READ id_danza_clase WRITE setId_danza_clase NOTIFY id_danza_claseChanged)
    Q_PROPERTY(QDateTime fecha READ fecha WRITE setFecha NOTIFY fechaChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)

    Q_PROPERTY(QString nombre_clase READ nombre_clase WRITE setNombre_clase NOTIFY nombre_claseChanged)
    Q_PROPERTY(QString nombre_actividad READ nombre_actividad WRITE setNombre_actividad NOTIFY nombre_actividadChanged)

public:
    ClaseAsistenciaInfantil();

    int id() const;
    int id_abono_infantil_compra() const;
    int id_danza_clase() const;
    QDateTime fecha() const;
    QString estado() const;

    QString nombre_clase() const;

    QString nombre_actividad() const;

public slots:
    void setId(int id);
    void setId_abono_infantil_compra(int id_abono_infantil_compra);
    void setId_danza_clase(int id_danza_clase);
    void setFecha(QDateTime fecha);
    void setEstado(QString estado);

    void setNombre_clase(QString nombre_clase);

    void setNombre_actividad(QString nombre_actividad);

signals:
    void idChanged(int id);
    void id_abono_infantil_compraChanged(int id_abono_infantil_compra);
    void id_danza_claseChanged(int id_danza_clase);
    void fechaChanged(QDateTime fecha);
    void estadoChanged(QString estado);

    void nombre_claseChanged(QString nombre_clase);

    void nombre_actividadChanged(QString nombre_actividad);

private:
    int m_id;
    int m_id_abono_infantil_compra;
    int m_id_danza_clase;
    QDateTime m_fecha;
    QString m_estado;
    QString m_nombre_clase;
    QString m_nombre_actividad;
};

#endif // CLASEASISTENCIAINFANTIL_H
