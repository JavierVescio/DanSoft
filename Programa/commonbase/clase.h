#ifndef CLASE_H
#define CLASE_H
#include <QObject>
#include <QDateTime>

class Clase: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int id_danza READ id_danza WRITE setId_danza NOTIFY id_danzaChanged)
    Q_PROPERTY(QString nombre READ nombre WRITE setNombre NOTIFY nombreChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)
    Q_PROPERTY(QDateTime blame_timestamp READ blame_timestamp WRITE setBlame_timestamp NOTIFY blame_timestampChanged)
    Q_PROPERTY(QString categoria READ categoria WRITE setCategoria NOTIFY categoriaChanged)
    Q_PROPERTY(QString dias_semana READ dias_semana WRITE setDias_semana NOTIFY dias_semanaChanged)

public:
    Clase();

    int id() const;
    int id_danza() const;
    QString nombre() const;
    QString estado() const;
    QDateTime blame_timestamp() const;

    QString categoria() const;

    QString dias_semana() const;

private:
    int m_id;
    QString m_nombre;
    QString m_estado;
    QDateTime m_blame_timestamp;

    int m_id_danza;

    QString m_categoria;

    QString m_dias_semana;

public slots:
    void setId(int id);
    void setId_danza(int id_danza);
    void setNombre(QString nombre);
    void setEstado(QString estado);
    void setBlame_timestamp(QDateTime blame_timestamp);

    void setCategoria(QString categoria);

    void setDias_semana(QString dias_semana);

signals:
    void idChanged(int id);
    void id_danzaChanged(int id_danza);
    void nombreChanged(QString nombre);
    void estadoChanged(QString estado);
    void blame_timestampChanged(QDateTime blame_timestamp);
    void categoriaChanged(QString categoria);
    void dias_semanaChanged(QString dias_semana);
};

#endif // CLASE_H
