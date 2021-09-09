#include <QApplication>
//#include <QCoreApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QQmlExtensionPlugin>
#include "wrapperclassmanagement.h"
#include "manager/classmanagementmanager.h"
#include "manager/classmanagementgestiondealumnos.h"
#include "manager/managerasistencias.h"
#include "manager/gestionbasededatos.h"
#include "manager/managernuevoevento.h"
#include "manager/managerabono.h"
#include "manager/managerdanza.h"
#include "manager/managerclase.h"
#include "manager/managerabonoinfantil.h"
#include "manager/managerpestanias.h"
#include "manager/managercuentaalumno.h"
#include "manager/manageroferta.h"
#include "manager/managercaja.h"
#include "manager/managerestadisticas.h"
#include "commonbase/pestania.h"
#include "commonbase/cmalumno.h"
#include "commonbase/evento.h"
#include "commonbase/abono.h"
#include "commonbase/abonoinfantil.h"
#include "commonbase/claseasistencia.h"
#include "commonbase/activationserial.h"
#include "commonbase/cuentaalumno.h"
#include "commonbase/movimiento.h"
#include "commonbase/tipooperacion.h"
#include "commonbase/abonoinfantilcompra.h"
#include "commonbase/claseasistenciainfantil.h"
#include "commonbase/resumenmes.h"
#include "commonbase/clienteasistenciasmovimientos.h"
#include "commonbase/listasconinformacion.h"
#include "commonbase/oferta.h"
#include "commonbase/preciomatricula.h"
#include "commonbase/venta.h"
#include "commonbase/itemventa.h"
#include "commonbase/resumenmovimientosalumno.h"
#include "commonbase/caja.h"
#include "commonbase/puntografico.h"
#include "commonbase/backup.h"
#include "commonbase/estadoalumno.h"
#include <qqml.h>
#include <QtQml>
#include <QDesktopServices>

int main(int argc, char *argv[])
{
    qmlRegisterType<WrapperClassManagement>("com.mednet.WrapperClassManagement", 1, 0, "WrapperClassManagement");
    qmlRegisterType<GestionBaseDeDatos>("com.mednet.GestionBaseDeDatos", 1, 0, "GestionBaseDeDatos");
    qmlRegisterType<ClassManagementManager>("com.mednet.ClassManagementManager", 1, 0, "ClassManagementManager");
    qmlRegisterType<ManagerPestanias>("com.mednet.ManagerPestanias", 1, 0, "ManagerPestanias");
    qmlRegisterType<ClassManagementGestionDeAlumnos>("com.mednet.ClassManagementGestionDeAlumnos", 1, 0, "ClassManagementGestionDeAlumnos");
    qmlRegisterType<ManagerNuevoEvento>("com.mednet.ManagerNuevoEvento", 1, 0, "ManagerNuevoEvento");
    qmlRegisterType<ManagerAsistencias>("com.mednet.ManagerAsistencias", 1, 0, "ManagerAsistencias");
    qmlRegisterType<ManagerDanza>("com.mednet.ManagerDanza", 1, 0, "ManagerDanza");
    qmlRegisterType<ManagerClase>("com.mednet.ManagerClase", 1, 0, "ManagerClase");
    qmlRegisterType<ManagerAbono>("com.mednet.ManagerAbono", 1, 0, "ManagerAbono");
    qmlRegisterType<ManagerAbonoInfantil>("com.mednet.ManagerAbonoInfantil", 1, 0, "ManagerAbonoInfantil");
    qmlRegisterType<ManagerCuentaAlumno>("com.mednet.ManagerCuentaAlumno", 1, 0, "ManagerCuentaAlumno");
    qmlRegisterType<ManagerOferta>("com.mednet.ManagerOferta", 1, 0, "ManagerOferta");
    qmlRegisterType<ManagerCaja>("com.mednet.ManagerCaja", 1, 0, "ManagerCaja");
    qmlRegisterType<ManagerEstadisticas>("com.mednet.ManagerEstadisticas", 1, 0, "ManagerEstadisticas");
    qmlRegisterType<Pestania>("com.mednet.PestaniaTab", 1, 0, "PestaniaTab");
    qmlRegisterType<CMAlumno>("com.mednet.CMAlumno", 1, 0, "CMAlumno");
    qmlRegisterType<Evento>("com.mednet.Evento", 1, 0, "Evento");
    qmlRegisterType<Abono>("com.mednet.Abono", 1, 0, "Abono");
    qmlRegisterType<AbonoInfantil>("com.mednet.AbonoInfantil", 1, 0, "AbonoInfantil");
    qmlRegisterType<ClaseAsistencia>("com.mednet.ClaseAsistencia", 1, 0, "ClaseAsistencia");
    qmlRegisterType<ActivationSerial>("com.mednet.ActivationSerial", 1, 0, "ActivationSerial");
    qmlRegisterType<CuentaAlumno>("com.mednet.CuentaAlumno", 1, 0, "CuentaAlumno");
    qmlRegisterType<Movimiento>("com.mednet.Movimiento", 1, 0, "Movimiento");
    qmlRegisterType<TipoOperacion>("com.mednet.TipoOperacion", 1, 0, "TipoOperacion");
    qmlRegisterType<AbonoInfantilCompra>("com.mednet.AbonoInfantilCompra", 1, 0, "AbonoInfantilCompra");
    qmlRegisterType<ClaseAsistenciaInfantil>("com.mednet.ClaseAsistenciaInfantil", 1, 0, "ClaseAsistenciaInfantil");
    qmlRegisterType<ResumenMes>("com.mednet.ResumenMes", 1, 0, "ResumenMes");
    qmlRegisterType<ResumenMovimientosAlumno>("com.mednet.ResumenMovimientosAlumno", 1, 0, "ResumenMovimientosAlumno");
    qmlRegisterType<ClienteAsistenciasMovimientos>("com.mednet.ClienteAsistenciasMovimientos", 1, 0, "ClienteAsistenciasMovimientos");
    qmlRegisterType<Oferta>("com.mednet.Oferta", 1, 0, "Oferta");
    qmlRegisterType<Venta>("com.mednet.Venta", 1, 0, "Venta");
    qmlRegisterType<ItemVenta>("com.mednet.Venta", 1, 0, "ItemVenta");
    qmlRegisterType<Caja>("com.mednet.Caja", 1, 0, "Caja");
    qmlRegisterType<PrecioMatricula>("com.mednet.PrecioMatricula", 1, 0, "PrecioMatricula");
    qmlRegisterType<PuntoGrafico>("com.mednet.PuntoGrafico", 1, 0, "PuntoGrafico");
    qmlRegisterType<BackUp>("com.mednet.BackUp", 1, 0, "BackUp");
    qmlRegisterType<EstadoAlumno>("com.mednet.EstadoAlumno", 1, 0, "EstadoAlumno");
    QApplication app(argc, argv);
    app.setApplicationVersion("6.0 Développé");
    app.setOrganizationName("Javier Vescio");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/plugins/main.qml")));



    //GestionBaseDeDatos * objGestionBaseDeDatos = new GestionBaseDeDatos();
    ClassManagementGestionDeAlumnos * objClassManagementGestionDeAlumnos = new ClassManagementGestionDeAlumnos();
    return app.exec();
}


