#ifndef MANAGERABONO_H
#define MANAGERABONO_H
#include <QObject>
#include <QDate>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include "commonbase/abono.h"
#include "commonbase/abonoadulto.h"


class ManagerAbono: public QObject
{
    Q_OBJECT
public:
    ManagerAbono();
    Q_INVOKABLE QDate obtenerFechaDeHoy();
    Q_INVOKABLE QDate obtenerFechaDeVencimiento();
    Q_INVOKABLE int acreditarClasesAlAbono(int id, int total_a_acreditar, bool acreditar_tambien_en_cantidad_comprada = true);
    Q_INVOKABLE int convertirEnAbonoLibre(int id);

    Q_INVOKABLE int comprarAbono(int id_cliente, int id_abono_adulto, float precio_abono, QString fecha_vigente, QString fecha_vencimiento, QString tipo, int cantidad_comprada, int cantidad_acreditada);
    Q_INVOKABLE bool actualizarAbonoNormalComprado(int id_abono_comprado, int id_abono_ofertado, float precio_a_sumar, int cantidad_clases_a_sumar, int cantidad_clases_restantes);
    Q_INVOKABLE bool actualizarHaciaAbonoLibre(int id_abono_comprado, int id_abono_ofertado, float precio_a_sumar, int cantidad_clases_restantes);

    Q_INVOKABLE bool obtenerAbonosPorClienteMasFecha(int id_cliente, bool estado, bool incluirAbonosCompradosEnElFuturo = false, bool incluirAbonosConCeroClases = false, QString fecha = QDate::currentDate().toString("yyyy-MM-dd"));
    Q_INVOKABLE int registrarPresenteAlAbono(int id_abono, int id_cliente_asistencia, QString credencial_firmada);
    Q_INVOKABLE int obtenerClasesSinFirmarDeAbono(int id_abono);
    Q_INVOKABLE int descontarClaseAlAbono(int id_abono, int cantidad_clases);
    Q_INVOKABLE int darDeBajaAbono(int id);

    Q_INVOKABLE bool traerTodosLasOfertasDeAbono();
    Q_INVOKABLE int altaDeAbonoAdulto(float precio_actual, int total_clases);
    Q_INVOKABLE bool actualizarAbonoOfertado(int id_abono_adulto, float precio_actual, bool estado);

    Q_INVOKABLE QObject* obtenerCompraDeAbonoAdultoPorIdAsistenciaAdulto(int id_asistencia);

    Q_INVOKABLE QObject* obtenerRecordAbonoSuperior();
    Q_INVOKABLE int obtenerTotalClasesAbonoSuperior();
    Q_INVOKABLE float obtenerPrecioDelAbonoQueOfreceMasClases(int clases_ofrecidas_abono_actual);

    //Crear un Objeto que tenga nombre alumno, info del abono que compro y lo que pago
    //Luego crear un query que con los join correspondientes traiga la info. necesaria para llenar ese objeto.


private:
    void controlarMensajesDeError(QSqlQuery query);
    QList<QObject*> listaAbonosEnOferta;
    QObject* recordAbonoSuperior;
    int totalClasesAbonoSuperior;

signals:
    void sig_abonosDeAlumno(QList<QObject*> arg);
    void sig_noHayAbonosDelAlumno();
    void sig_abonoBorrado(int arg);
    void sig_abonoMejorado();
    void sig_mensajeError(bool requiereCerrarElPrograma, QString msjError);
    void sig_listaAbonosAdultosEnOferta(QList<QObject*> lista);
};

#endif // MANAGERABONO_H
