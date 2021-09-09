#ifndef WRAPPERCLASSMANAGEMENT_H
#define WRAPPERCLASSMANAGEMENT_H
#include <QObject>
#include "Singleton.h"
#include "../Programa/manager/classmanagementmanager.h"
#include "../Programa/manager/gestionbasededatos.h"
#include "../Programa/manager/managerpestanias.h"
#include "../Programa/manager/classmanagementgestiondealumnos.h"
#include "../Programa/manager/managernuevoevento.h"
#include "../Programa/manager/managerasistencias.h"
#include "../Programa/manager/managerabono.h"
#include "../Programa/manager/managerabonoinfantil.h"
#include "../Programa/manager/managerdanza.h"
#include "../Programa/manager/managerclase.h"
#include "../Programa/manager/managercalendar.h"
#include "../Programa/manager/manageractiviationserial.h"
#include "../Programa/manager/managercuentaalumno.h"
#include "../Programa/manager/manageroferta.h"
#include "../Programa/manager/managercaja.h"
#include "../Programa/manager/managerestadisticas.h"

class WrapperClassManagement: public QObject{
    Q_OBJECT
    Q_PROPERTY(ClassManagementManager *  classManagementManager READ getClassManagementManager NOTIFY classManagementManagerNotify)
    Q_PROPERTY(GestionBaseDeDatos *  gestionBaseDeDatos READ getGestionBaseDeDatos NOTIFY gestionBaseDeDatosNotify)
    Q_PROPERTY(ManagerPestanias *  managerPestanias READ getManagerPestanias NOTIFY managerPestaniasNotify)
    Q_PROPERTY(ClassManagementGestionDeAlumnos *  classManagementGestionDeAlumnos READ getClassManagementGestionDeAlumnos NOTIFY classManagementGestionDeAlumnosNotify)
    Q_PROPERTY(ManagerNuevoEvento *  managerNuevoEvento READ getManagerNuevoEvento NOTIFY managerNuevoEventoNotify)
    Q_PROPERTY(ManagerAsistencias *  managerAsistencias READ getManagerAsistencias NOTIFY managerAsistenciasNotify)
    Q_PROPERTY(ManagerAbono *  managerAbono READ getManagerAbono NOTIFY managerAbonoNotify)
    Q_PROPERTY(ManagerAbonoInfantil *  managerAbonoInfantil READ getManagerAbonoInfantil NOTIFY managerAbonoInfantilNotify)
    Q_PROPERTY(ManagerDanza *  managerDanza READ getManagerDanza NOTIFY managerDanzaNotify)
    Q_PROPERTY(ManagerClase *  managerClase READ getManagerClase NOTIFY managerClaseNotify)
    Q_PROPERTY(ManagerCalendar *  managerCalendar READ getManagerCalendar NOTIFY managerCalendarNotify)
    Q_PROPERTY(ManagerActiviationSerial *  managerActiviationSerial READ getManagerActiviationSerial NOTIFY managerActiviationSerialNotify)
    Q_PROPERTY(ManagerCuentaAlumno *  managerCuentaAlumno READ getManagerCuentaAlumno NOTIFY managerCuentaAlumnoNotify)
    Q_PROPERTY(ManagerOferta *  managerOferta READ getManagerOferta NOTIFY managerOfertaNotify)
    Q_PROPERTY(ManagerCaja *  managerCaja READ getManagerCaja NOTIFY managerCajaNotify)
    Q_PROPERTY(ManagerEstadisticas *  managerEstadisticas READ getManagerEstadisticas NOTIFY managerEstadisticasNotify)

public:
    WrapperClassManagement();
    static ClassManagementManager * getClassManagementManager(){return Singleton<ClassManagementManager>::getInstance();}
    static GestionBaseDeDatos * getGestionBaseDeDatos(){return Singleton<GestionBaseDeDatos>::getInstance();}
    static ManagerPestanias * getManagerPestanias(){return Singleton<ManagerPestanias>::getInstance();}
    static ClassManagementGestionDeAlumnos * getClassManagementGestionDeAlumnos(){return Singleton<ClassManagementGestionDeAlumnos>::getInstance();}
    static ManagerNuevoEvento * getManagerNuevoEvento(){return Singleton<ManagerNuevoEvento>::getInstance();}
    static ManagerAsistencias * getManagerAsistencias(){return Singleton<ManagerAsistencias>::getInstance();}
    static ManagerAbono * getManagerAbono(){return Singleton<ManagerAbono>::getInstance();}
    static ManagerAbonoInfantil * getManagerAbonoInfantil(){return Singleton<ManagerAbonoInfantil>::getInstance();}
    static ManagerDanza * getManagerDanza(){return Singleton<ManagerDanza>::getInstance();}
    static ManagerClase * getManagerClase(){return Singleton<ManagerClase>::getInstance();}
    static ManagerCalendar * getManagerCalendar(){return Singleton<ManagerCalendar>::getInstance();}
    static ManagerActiviationSerial * getManagerActiviationSerial(){return Singleton<ManagerActiviationSerial>::getInstance();}
    static ManagerCuentaAlumno * getManagerCuentaAlumno(){return Singleton<ManagerCuentaAlumno>::getInstance();}
    static ManagerOferta * getManagerOferta(){return Singleton<ManagerOferta>::getInstance();}
    static ManagerCaja * getManagerCaja(){return Singleton<ManagerCaja>::getInstance();}
    static ManagerEstadisticas * getManagerEstadisticas(){return Singleton<ManagerEstadisticas>::getInstance();}

signals:
    void classManagementManagerNotify();
    void gestionBaseDeDatosNotify();
    void managerPestaniasNotify();
    void classManagementGestionDeAlumnosNotify();
    void managerNuevoEventoNotify();
    void managerAsistenciasNotify();
    void managerAbonoNotify();
    void managerAbonoInfantilNotify();
    void managerDanzaNotify();
    void managerClaseNotify();
    void managerCalendarNotify();
    void managerActiviationSerialNotify();
    void managerCuentaAlumnoNotify();
    void managerOfertaNotify();
    void managerCajaNotify();
    void managerEstadisticasNotify();
};


#endif // WRAPPERCLASSMANAGEMENT_H
