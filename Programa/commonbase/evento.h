#ifndef EVENTO_H
#define EVENTO_H
#include <QObject>
#include <QDate>

class Evento : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QDate fecha READ getFecha WRITE setFecha NOTIFY fechaChanged)
    Q_PROPERTY(QString descripcion READ descripcion WRITE setDescripcion NOTIFY descripcionChanged)

public:
    Evento();
    Evento(QDate fecha, QString descripcion);

    int id() const;
    QDate getFecha();
    QString descripcion() const;

private:
    int m_id;
    QDate m_fecha;
    QString m_descripcion;

signals:
    void idChanged(int arg);
    void fechaChanged();
    void descripcionChanged(QString arg);

public slots:
    void setFecha(QDate fecha){this->m_fecha = fecha;emit fechaChanged();}
    void setDescripcion(QString arg){m_descripcion = arg;emit descripcionChanged(arg);}
    void setId(int arg) {m_id = arg; emit idChanged(arg);}
};

#endif // EVENTO_H
