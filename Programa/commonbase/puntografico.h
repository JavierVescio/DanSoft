#ifndef PUNTOGRAFICO_H
#define PUNTOGRAFICO_H

#include <QObject>
#include <QDateTime>

class PuntoGrafico: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString nombre READ nombre WRITE setNombre NOTIFY nombreChanged)
    Q_PROPERTY(int valor READ valor WRITE setValor NOTIFY valorChanged)
    Q_PROPERTY(QDateTime fecha READ fecha WRITE setFecha NOTIFY fechaChanged)

public:
    PuntoGrafico();

    QString nombre() const;

    QDateTime fecha() const;

    int valor() const;

public slots:
    void setNombre(QString nombre);

    void setFecha(QDateTime fecha);

    void setValor(int valor);

signals:
    void nombreChanged(QString nombre);

    void fechaChanged(QDateTime fecha);

    void valorChanged(int valor);

private:
    QString m_nombre;
    QDateTime m_fecha;
    int m_valor;
};

#endif // PUNTOGRAFICO_H
