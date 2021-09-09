#ifndef DIACALENDARIO_H
#define DIACALENDARIO_H
#include <QObject>
#include <QDate>

class DiaCalendario: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QDate fecha READ getFecha WRITE setFecha NOTIFY fechaChanged)
    Q_PROPERTY(QString estado READ getEstado WRITE setEstado NOTIFY estadoChanged)

public:
    DiaCalendario();
    DiaCalendario(QDate fecha, QString estado);
    void setFecha(QDate fecha);
    QDate getFecha();
    QString getEstado() const;
    void setEstado(QString estado);

private:
    QDate fecha;    
    QString m_estado;

signals:
    void fechaChanged();
    void estadoChanged();
};

#endif // DIACALENDARIO_H
