#ifndef MANAGERDANZA_H
#define MANAGERDANZA_H
#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include "commonbase/danza.h"

class ManagerDanza: public QObject
{
    Q_OBJECT
public:
    ManagerDanza();
    Q_INVOKABLE bool obtenerTodasLasDanzas();

    Q_INVOKABLE bool obtenerTodasLasDanzasConFiltro(QString categoria);

    Q_INVOKABLE bool agregarDanza(QString nombre);
    Q_INVOKABLE bool cambiarNombreDanza(int id_danza, QString nombre);
    Q_INVOKABLE bool eliminarDanza(int id_danza);

private:
    void controlarMensajesDeError(QSqlQuery query);

signals:
    void sig_listaDanzas(QList<QObject*> arg);
    void sig_mensajeError(bool requiereCerrarElPrograma, QString msjError);
};

#endif // MANAGERDANZA_H
