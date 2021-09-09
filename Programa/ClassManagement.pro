TEMPLATE = app

QT += qml quick widgets sql core printsupport gui

SOURCES += main.cpp \
    wrapperclassmanagement.cpp \
    manager/classmanagementmanager.cpp \
    manager/classmanagementgestiondealumnos.cpp \
    commonbase/cmalumno.cpp \
    manager/managernuevoevento.cpp \
    commonbase/evento.cpp \
    manager/gestionbasededatos.cpp \
    manager/managerpestanias.cpp \
    commonbase/pestania.cpp \
    manager/managerasistencias.cpp \
    manager/managerabono.cpp \
    commonbase/abono.cpp \
    commonbase/claseasistencia.cpp \
    manager/managerdanza.cpp \
    manager/managerclase.cpp \
    commonbase/danza.cpp \
    commonbase/clase.cpp \
    commonbase/diacalendario.cpp \
    manager/managercalendar.cpp \
    commonbase/activationserial.cpp \
    manager/manageractiviationserial.cpp \
    manager/managerabonoinfantil.cpp \
    commonbase/abonoinfantil.cpp \
    manager/managercuentaalumno.cpp \
    commonbase/cuentaalumno.cpp \
    commonbase/movimiento.cpp \
    commonbase/tipooperacion.cpp \
    commonbase/abonoinfantilcompra.cpp \
    commonbase/claseasistenciainfantil.cpp \
    commonbase/resumenmes.cpp \
    commonbase/clienteasistenciasmovimientos.cpp \
    commonbase/listasconinformacion.cpp \
    commonbase/abonoadulto.cpp \
    commonbase/inscripcionclienteclase.cpp \
    manager/manageroferta.cpp \
    commonbase/oferta.cpp \
    commonbase/venta.cpp \
    commonbase/itemventa.cpp \
    commonbase/caja.cpp \
    manager/managercaja.cpp \
    manager/managerestadisticas.cpp \
    commonbase/puntografico.cpp \
    commonbase/backup.cpp \
    commonbase/estadoalumno.cpp \
    commonbase/preciomatricula.cpp \
    commonbase/resumenmovimientosalumno.cpp

RESOURCES += qml.qrc

win32:RC_ICONS += IconoDS.ico

#TARGET = <ADE Islas Malvinas v1.0>

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    Singleton.h \
    wrapperclassmanagement.h \
    manager/classmanagementmanager.h \
    manager/classmanagementgestiondealumnos.h \
    commonbase/cmalumno.h \
    manager/managernuevoevento.h \
    commonbase/evento.h \
    manager/gestionbasededatos.h \
    manager/managerpestanias.h \
    commonbase/pestania.h \
    manager/managerasistencias.h \
    manager/managerabono.h \
    commonbase/abono.h \
    commonbase/claseasistencia.h \
    manager/managerdanza.h \
    manager/managerclase.h \
    commonbase/danza.h \
    commonbase/clase.h \
    commonbase/diacalendario.h \
    manager/managercalendar.h \
    commonbase/activationserial.h \
    manager/manageractiviationserial.h \
    manager/managerabonoinfantil.h \
    commonbase/abonoinfantil.h \
    manager/managercuentaalumno.h \
    commonbase/cuentaalumno.h \
    commonbase/movimiento.h \
    commonbase/tipooperacion.h \
    commonbase/abonoinfantilcompra.h \
    commonbase/claseasistenciainfantil.h \
    commonbase/resumenmes.h \
    commonbase/clienteasistenciasmovimientos.h \
    commonbase/listasconinformacion.h \
    commonbase/abonoadulto.h \
    commonbase/inscripcionclienteclase.h \
    manager/manageroferta.h \
    commonbase/oferta.h \
    commonbase/venta.h \
    commonbase/itemventa.h \
    commonbase/caja.h \
    manager/managercaja.h \
    manager/managerestadisticas.h \
    commonbase/puntografico.h \
    commonbase/backup.h \
    commonbase/estadoalumno.h \
    commonbase/preciomatricula.h \
    commonbase/resumenmovimientosalumno.h

DISTFILES +=
