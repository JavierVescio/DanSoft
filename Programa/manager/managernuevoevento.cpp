#include "managernuevoevento.h"
#include "wrapperclassmanagement.h"
#include <QDebug>

ManagerNuevoEvento::ManagerNuevoEvento()
{
    m_fechaCalendario = m_fechaCalendario.currentDate();
}

void ManagerNuevoEvento::borrarListaDeEventos() {
    listaDeEventos.clear();
}

void ManagerNuevoEvento::agregarNuevoEvento(QDate fecha, QString descripcion) {
    Evento * objEvento = new Evento(fecha, descripcion);
    listaDeEventos.prepend(objEvento);
    emit sig_eventosActualizados(listaDeEventos);
}

bool ManagerNuevoEvento::actualizarEvento(int indice, QString fecha, QString descripcion) {
    bool salida = false;
    Evento * objEvento = NULL;
    QDate dateFecha = QDate::fromString(fecha,"dd/MM/yyyy");
    if (dateFecha.isValid()) {
        if (indice > 0 && indice < listaDeEventos.count()) {
            objEvento = dynamic_cast<Evento*>(listaDeEventos.at(indice));
            objEvento->setFecha(dateFecha);
            objEvento->setDescripcion(descripcion);
            salida = true;
            emit sig_eventosActualizados(listaDeEventos);
        }
    }
    return salida;
}

bool ManagerNuevoEvento::eliminarEvento(int id) {
    bool salida = true;

    QSqlQuery query;
    query.prepare("DELETE FROM eventos WHERE id="+QString::number(id));
    if(!query.exec()) {
        qDebug() << query.lastError();
        salida = false;
    }
    else {
        emit sig_eventoEliminado();
    }
    return salida;
}

bool ManagerNuevoEvento::guardarNuevoEvento(QString descripcion) {
    bool continuar = true;

    QString strQuery = "INSERT INTO eventos (descripcion, fechaInicial) VALUES ('"+descripcion+"', '"+date.toString("dd/MM/yyyy")+"')";
    QSqlQuery query;
    query.prepare(strQuery);
    if(!query.exec()) {
        qDebug() << "strQuery: " << strQuery;
        qDebug() << query.lastError();
        continuar = false;
    }
    else {
        this->eventsForDate(date,true);
        emit sig_eventoGuardado(date);
    }

    return continuar;
}

bool ManagerNuevoEvento::guardarNuevoEvento(QDate fecha,QString descripcion) {
    bool continuar = true;

    QString strQuery = "INSERT INTO eventos (descripcion, fechaInicial) VALUES ('"+descripcion+"', '"+fecha.toString("dd/MM/yyyy")+"')";
    QSqlQuery query;
    query.prepare(strQuery);

    if (fecha.isValid()) {
        if(!query.exec()) {
            continuar = false;
        }
        else {
            emit sig_eventoGuardado(fecha);
        }
    }
    else {
        continuar = false;
    }

    return continuar;
}

QList<QObject*> ManagerNuevoEvento::eventsForDate(const QDate &date, bool cargarEventosEnLista)
{
    this->date = date;
    emit fechaSeleccionadaChanged();
    const QString queryStr = QString::fromLatin1("SELECT eventos.* FROM eventos WHERE '%1' = fechaInicial").arg(date.toString("dd/MM/yyyy"));
    QSqlQuery query(queryStr);
    if (!query.exec()) {
        qFatal("Query failed");
    }

    QList<QObject*> events;
    while (query.next()) {
        Evento * event;
        event = new Evento();
        event->setFecha(QDate::fromString(query.value("fechaInicial").toString(),"dd/MM/yyyy"));
        event->setId(query.value("id").toInt());
        event->setDescripcion(query.value("descripcion").toString());
        events.append(event);
    }
    if (cargarEventosEnLista) {
        sig_eventsForDate(events);
    }

    return events;
}
