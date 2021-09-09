#ifndef MANAGERCLASE_H
#define MANAGERCLASE_H
#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include "commonbase/clase.h"

class ManagerClase: public QObject
{
    Q_OBJECT
public:
    ManagerClase();

    Q_INVOKABLE bool obtenerTodasLasClasesPorIdDanza(int id_danza);

    Q_INVOKABLE bool obtenerTodasLasClasesPorIdDanzaConFiltro(int id_danza, QString categoria);

    Q_INVOKABLE bool agregarClase(int id_danza, QString nombre);
    Q_INVOKABLE bool cambiarNombreClase(int id_clase, QString nombre);
    Q_INVOKABLE bool actualizarCategoriaClase(int id_clase, int id_categoria);
    Q_INVOKABLE bool actualizarDiasClase(int id_clase, QString dias);
    Q_INVOKABLE bool eliminarClase(int id_clase);

private:
    void controlarMensajesDeError(QSqlQuery query);

signals:
    void sig_listaClases(QList<QObject*> arg);
    void sig_mensajeError(bool requiereCerrarElPrograma, QString msjError);
};

#endif // MANAGERCLASE_H
