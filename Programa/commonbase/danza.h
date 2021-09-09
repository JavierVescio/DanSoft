#ifndef DANZA_H
#define DANZA_H
#include <QObject>
#include <QDateTime>

class Danza: public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString nombre READ nombre WRITE setNombre NOTIFY nombreChanged)
    Q_PROPERTY(QString estado READ estado WRITE setEstado NOTIFY estadoChanged)
    Q_PROPERTY(QDateTime blame_timestamp READ blame_timestamp WRITE setBlame_timestamp NOTIFY blame_timestampChanged)
public:
    Danza();

    int id() const;
    QString nombre() const;
    QString estado() const;
    QDateTime blame_timestamp() const;

private:
    int m_id;
    QString m_nombre;
    QString m_estado;
    QDateTime m_blame_timestamp;

public slots:
    void setId(int id);
    void setNombre(QString nombre);
    void setEstado(QString estado);
    void setBlame_timestamp(QDateTime blame_timestamp);

signals:
    void idChanged(int id);
    void nombreChanged(QString nombre);
    void estadoChanged(QString estado);
    void blame_timestampChanged(QDateTime blame_timestamp);
};

#endif // DANZA_H
