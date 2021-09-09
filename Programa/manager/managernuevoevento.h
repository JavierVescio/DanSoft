#ifndef MANAGERNUEVOEVENTO_H
#define MANAGERNUEVOEVENTO_H
#include <QObject>
#include "commonbase/evento.h"
#include "QDate"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>

class ManagerNuevoEvento: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QDate fechaSeleccionada READ getFechaSeleccionada WRITE setFechaSeleccionada NOTIFY fechaSeleccionadaChanged)
    Q_PROPERTY(QDate fechaCalendario READ getFechaCalendario WRITE setFechaCalendario NOTIFY fechaCalendarioChanged)
public:
    ManagerNuevoEvento();

    Q_INVOKABLE void agregarNuevoEvento(QDate fecha, QString descripcion);
    Q_INVOKABLE bool actualizarEvento(int indice, QString fecha, QString descripcion);
    Q_INVOKABLE bool eliminarEvento(int id);
    Q_INVOKABLE void borrarListaDeEventos();
    Q_INVOKABLE bool guardarNuevoEvento(QString descripcion);
    Q_INVOKABLE bool guardarNuevoEvento(QDate fecha,QString descripcion);
    Q_INVOKABLE QList<QObject*> eventsForDate(const QDate &date, bool cargarEventosEnLista);
    Q_INVOKABLE void eventoRapidoParaHoy(){emit sig_eventoRapidoParaHoy();}
    Q_INVOKABLE void eventoRapidoParaManiana(){emit sig_eventoRapidoParaManiana();}
    QDate getFechaSeleccionada(){return date;}
    QDate getFechaCalendario() const {return m_fechaCalendario;}
    void setFechaSeleccionada(QDate date){this->date = date;}

public slots:
    void setFechaCalendario(QDate arg) {m_fechaCalendario = arg;}

private:
    QList<QObject*> listaDeEventos;
    QDate date;
    QDate m_fechaCalendario;

signals:
    void sig_eventosActualizados(QList<QObject*> arg);
    void sig_eventsForDate(QList<QObject*> arg);
    void fechaSeleccionadaChanged();
    void sig_eventoGuardado(QDate arg);
    void sig_eventoEliminado();
    void fechaCalendarioChanged(QDate arg);
    void sig_eventoRapidoParaHoy();
    void sig_eventoRapidoParaManiana();
};

#endif // MANAGERNUEVOEVENTO_H
