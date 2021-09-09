#ifndef MANAGERCUENTAALUMNO_H
#define MANAGERCUENTAALUMNO_H

#include <QObject>
#include <QDate>
#include <QDateTime>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>

#include "commonbase/cuentaalumno.h"
#include "commonbase/tipooperacion.h"
#include "commonbase/movimiento.h"
#include "commonbase/resumenmovimientosalumno.h"
#include "commonbase/resumenmes.h"

class ManagerCuentaAlumno: public QObject
{
    Q_OBJECT
public:
    ManagerCuentaAlumno();

    Q_INVOKABLE CuentaAlumno* traerCuentaAlumnoPorIdAlumno(int id_alumno);

    Q_INVOKABLE int crearTipoOperacion(QString descripcion);
    Q_INVOKABLE bool actualizarTipoOperacion(int idOperacion, QString descripcion, QString estado = "Habilitado");
    Q_INVOKABLE QList<QObject*> traerTodosLosTiposDeOperacion();

    Q_INVOKABLE int crearMovimiento(
            int id_tipo_operacion,
            int id_cuenta_cliente,
            float monto,
            QString descripcion,
            CuentaAlumno * cuenta_alumno,
            ResumenMes * resumen_mes,
            QString codigo_oculto,
            bool ingreso_egreso_caja = false);

    Q_INVOKABLE QList<QObject*> traerTodosLosMovimientosPorCuenta(int idCuentaCliente, int cantidad = 32);
    Q_INVOKABLE QList<QObject*> traerTodosLosMovimientosPorCuenta(int idCuentaCliente, QDate fecha_inicial, QDate fecha_final, bool rellenarConObjetosNulosLosDiasSinMovimiento = false);

    Q_INVOKABLE QList<QObject*> traerMovimientosAdultosPorFecha(QDate fecha = QDate::currentDate());
    Q_INVOKABLE QList<QObject*> traerMovimientosInfantilesPorFecha(QDate fecha = QDate::currentDate());

    Q_INVOKABLE double traerTotalIngresosAdultos();

    Q_INVOKABLE double traerTotalIngresosInfantiles();

    Q_INVOKABLE ResumenMes* traerResumenMesPorClienteFecha(int id_cliente, bool crearSiNoExiste = false, QDate fecha = QDate::currentDate());

private:
    //void controlarMensajesDeError(QSqlQuery query);
    int crearResumenMes(int id_cliente, float ultimo_saldo_parcial_mes, float ultimo_saldo_acumulado_mes);
    bool actualizarResumenMes(ResumenMes * resumen_mes);

    CuentaAlumno* crearCuentaAlumno(int id_alumno);
    bool actualizarCuentaAlumno(CuentaAlumno* cuenta_alumno);

    double totalIngresosAdultos=0, totalIngresosInfantiles=0;



signals:
    //void sig_mensajeError(bool requiereCerrarElPrograma, QString msjError);

};

#endif // MANAGERCUENTAALUMNO_H
