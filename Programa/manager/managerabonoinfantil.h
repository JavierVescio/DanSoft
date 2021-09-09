#ifndef MANAGERABONOINFANTIL_H
#define MANAGERABONOINFANTIL_H

#include <QObject>
#include <QDate>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include <QVector2D>

#include "commonbase/abonoinfantil.h"
#include "commonbase/preciomatricula.h"
#include "commonbase/abonoinfantilcompra.h"
#include "commonbase/claseasistenciainfantil.h"
#include "commonbase/clienteasistenciasmovimientos.h"

class ManagerAbonoInfantil: public QObject
{
    Q_OBJECT
public:
    ManagerAbonoInfantil();

    Q_INVOKABLE int altaDeAbonoInfantil(float precio_actual, int clases_por_semana);
    Q_INVOKABLE bool traerTodosLasOfertasDeAbono();
    Q_INVOKABLE bool actualizarAbonoOfertado(int id_abono_infantil, float precio_actual, bool estado);

    Q_INVOKABLE int comprarAbonoInfantil(int id_cliente, int id_abono_infantil, float precio_abono, QString estado = "Habilitado", QDateTime fecha_compra = QDateTime::currentDateTime());
    Q_INVOKABLE bool actualizarAbonoComprado(int id_abono_comprado, int id_abono_ofertado, float precio_a_sumar);
    Q_INVOKABLE QObject* traerCompraDeAbonoInfantil(int id_cliente, QDate fecha = QDate::currentDate());

    Q_INVOKABLE QList<QObject*> traerAlumnosQueCompraronAbonoInfantil(int mes, int anio);
    Q_INVOKABLE QList<QObject*> traerAlumnosQueCompraronAbonoInfantilConDiasDePresentesMasMovimientos(int mes, int anio, int id_clase);
    Q_INVOKABLE QList<QObject*> traerAlumnosInscriptosConDiasDePresentesMasMovimientos(int mes, int anio, int id_clase);
    Q_INVOKABLE QList<QObject*> traerAlumnosInscriptosPorClase(int id_clase);

    Q_INVOKABLE int registrarPresenteInfantil(int id_abono_infantil_compra, int id_danza_clase, QDateTime fecha = QDateTime::currentDateTime());
    Q_INVOKABLE QList<QObject*> traerPresentesPorAbonoInfantilComprado(int id_abono_infantil_compra, QDate fecha = QDate::currentDate());

    Q_INVOKABLE float obtenerPrecioDelAbonoQueOfreceUnaClaseMasPorSem(int clases_ofrecidas_abono_actual);
    Q_INVOKABLE int verificarSiEstaCubiertoElPresente(QList<QObject*> lista, int clases_ofrecidas_abono_actual);
    Q_INVOKABLE int obtenerIdAbonoSuperior();
    Q_INVOKABLE int obtenerTotalClasesAbonoSuperior();

    Q_INVOKABLE bool actualizarPrecioMatricula(float precio_actual);
    Q_INVOKABLE float traerPrecioMatricula();

    Q_INVOKABLE bool matricularAlumno(int id_cliente);

    Q_INVOKABLE int darDeBajaAbono(int id);
    Q_INVOKABLE int anularPresente(int id_presente);

    Q_INVOKABLE AbonoInfantil* traerOfertaDeAbonoMinimaDisponible();
    Q_INVOKABLE AbonoInfantil* traerUltimaOfertaDeAbonoComprada(int id_cliente);

    Q_INVOKABLE QObject* comprarAbonoAutomaticamente(int id_cliente, bool alumno_matriculado);

private:

    void controlarMensajesDeError(QSqlQuery query);
    QList<QObject*> listaAbonosEnOferta;
    int idAbonoSuperior;
    int totalClasesAbonoSuperior;
    PrecioMatricula* precioMatricula;

signals:
    void sig_listaAbonosEnOferta(QList<QObject*> lista);
    void sig_mensajeError(bool requiereCerrarElPrograma, QString msjError);
    void sig_abonoInfantilBorrado(int arg);
};

#endif // MANAGERABONOINFANTIL_H
