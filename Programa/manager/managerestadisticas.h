#ifndef MANAGERESTADISTICAS_H
#define MANAGERESTADISTICAS_H

#include <QObject>
#include <QDate>
#include <QDateTime>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include "commonbase/puntografico.h"
#include "commonbase/estadoalumno.h"

class ManagerEstadisticas:public QObject
{
    Q_OBJECT
public:
    ManagerEstadisticas();

    Q_INVOKABLE QList<QObject*> obtenerCantidadPresentesAdultos(
            int periodo_dias = 0,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE QList<QObject*> obtenerCantidadPresentesInfantiles(
            int periodo_dias = 0,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE QList<QObject*> obtenerCantidadAlumnos(
            bool alta,
            int periodo_dias = 0,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE QList<QObject*> obtenerCantidadAbonosAdultos(
            int periodo_dias = 0,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE QList<QObject*> obtenerCantidadAbonosInfantiles(
            int periodo_dias = 0,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE QList<QObject*> obtenerCantidadPresentesActividad(
            int id_actividad,
            int periodo_dias = 0,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE QList<QObject *> obtenerAlumnosDeudores();
    Q_INVOKABLE QList<QObject *> obtenerAlumnosMerecedores();
    Q_INVOKABLE QList<QObject *> obtenerAlumnosDeudoresDeHoy();
    Q_INVOKABLE QList<QObject *> obtenerAlumnosMerecedoresDeHoy();

    Q_INVOKABLE int obtenerMaximo_presentes_adultos();
    Q_INVOKABLE int obtenerMaximo_presentes_infantiles();

    Q_INVOKABLE int obtenerTotal_presentes_adultos();
    Q_INVOKABLE int obtenerTotal_presentes_infantiles();

    Q_INVOKABLE int obtenerCantidadAlumnos();
    Q_INVOKABLE int obtenerMaximoCantidadAlumnosDelMes();

    Q_INVOKABLE int obtenerTotalAbonosAdultos();
    Q_INVOKABLE int obtenerMaximoAbonosAdultosDelMes();

    Q_INVOKABLE int obtenerTotalAbonosInfantiles();
    Q_INVOKABLE int obtenerMaximoAbonosInfantilesDelMes();

    Q_INVOKABLE float obtenerTotalDeuda();
    Q_INVOKABLE float obtenerTotalDeudaHoy();
    Q_INVOKABLE float obtenerFavor();
    Q_INVOKABLE float obtenerFavorHoy();

private:
    int maximo_presentes_adultos;
    int total_presentes_adultos;

    int maximo_presentes_infantiles;
    int total_presentes_infantiles;

    int cantidad_alumnos;
    int maximo_cantidad_alumnos;

    int maximo_abonos_adultos;
    int total_abonos_adultos;

    int maximo_abonos_infantiles;
    int total_abonos_infantiles;

    float total_deuda;
    float total_favor;
    float total_deuda_hoy;
    float total_favor_hoy;
};

#endif // MANAGERESTADISTICAS_H
