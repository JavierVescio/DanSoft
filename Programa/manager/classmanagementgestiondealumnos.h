#ifndef CLASSMANAGEMENTGESTIONDEALUMNOS_H
#define CLASSMANAGEMENTGESTIONDEALUMNOS_H
#include "commonbase/cmalumno.h"
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QObject>
#include <QDate>
#include <QImage>
#include <QByteArray>
#include <QFile>
#include <QDir>
#include <QBuffer>
#include <QDir>

class ClassManagementGestionDeAlumnos: public QObject
{
    Q_OBJECT

    Q_PROPERTY(CMAlumno * recordAlumnoSeleccionado READ getRecordAlumnoSeleccionado WRITE setRecordAlumnoSeleccionado)
    Q_PROPERTY(CMAlumno * clienteEnProcesoDeAlta READ getClienteEnProcesoDeAlta WRITE setClienteEnProcesoDeAlta)
    Q_PROPERTY(CMAlumno * clienteEnProcesoDeActualizacion READ getClienteEnProcesoDeActualizacion  WRITE setClienteEnProcesoDeActualizacion)
    Q_PROPERTY(QString pathFotoCliente READ getPathFotoCliente WRITE setPathFotoCliente NOTIFY pathFotoClienteChanged)
    Q_PROPERTY(QString pathFotoAlta READ getPathFotoAlta WRITE setPathFotoAlta NOTIFY pathFotoAltaChanged)
public:
    ClassManagementGestionDeAlumnos();

    Q_INVOKABLE void realizarUltimaBusquedaDeAlumno(bool realizarUltimaBusqueda){this->realizarUltimaBusqueda = realizarUltimaBusqueda;}
    Q_INVOKABLE CMAlumno * obtenerAlumnoPorId(int id, int estado = 1);
    Q_INVOKABLE CMAlumno * obtenerAlumnoPorId(QString dni, int estado = 1);
    Q_INVOKABLE bool buscarAlumno(QString apellido, QString nombre, QString dni, int tipoDeBusqueda = 1, int idClase = -1);
    Q_INVOKABLE bool darDeAltaAlumno();
    Q_INVOKABLE bool actualizacionAlumno();
    Q_INVOKABLE bool eliminarAlumno(int id_cliente);
    Q_INVOKABLE bool eliminacionFisica(int id_cliente);
    Q_INVOKABLE bool reactivarCliente(int id_cliente);
    Q_INVOKABLE bool obtenerFoto(int id_cliente);
    Q_INVOKABLE int getBirthdays(QDate fecha = QDate::currentDate(), bool getAlsoNextDayBirthdays = true);
    Q_INVOKABLE QList<QObject*> getListaAlumnosCumpleanios(){return listaAlumnosCumpleanios;}
    Q_INVOKABLE int isItHerBirthday(int id_alumno);
    Q_INVOKABLE int getBirthdaysByDate(QDate fecha);
    Q_INVOKABLE int getBirthdaysByMonth(QDate fecha);
    Q_INVOKABLE QList<QObject*> getBirthdaysByDay(QDate fecha);
    Q_INVOKABLE void mostrarFotoDePerfilGrande(QString source);
    Q_INVOKABLE bool alumnoConMatriculaVigente(QDateTime dt_fecha_matriculacion);
    Q_INVOKABLE bool alumnoConMatriculaInfantilVigente(int id_alumno);

    CMAlumno * getClienteEnProcesoDeAlta() const;
    CMAlumno * clienteEnProcesoDeAlta;
    CMAlumno * getClienteEnProcesoDeActualizacion() const;
    QString getPathFotoCliente() const;

    QString getPathFotoAlta() const;


public slots:
    void setClienteEnProcesoDeAlta(CMAlumno * arg);
    void setClienteEnProcesoDeActualizacion(CMAlumno * arg);
    void setPathFotoCliente(QString arg);

    void setPathFotoAlta(QString arg);

private:
    CMAlumno * recordAlumnoSeleccionado;
    CMAlumno * ultimoAlumnoBuscado;
    CMAlumno * getRecordAlumnoSeleccionado();
    void controlarMensajesDeError(QSqlQuery query);
    void setRecordAlumnoSeleccionado(CMAlumno * recordAlumnoSeleccionado);
    bool realizarUltimaBusqueda;
    CMAlumno * m_clienteEnProcesoDeActualizacion;
    QString m_pathFotoCliente;
    bool hayFoto;
    QString m_pathFotoAlta;
    QList<QObject*> listaAlumnosCumpleanios;
    QList<QObject*> birthdaysByMonthList;
    QDir dir;

signals:
    void sig_altaClienteExitosa();
    void sig_falloAltaCliente();
    void sig_falloAltaFotoCliente();
    void sig_recordAlumnoSeleccionado(CMAlumno * recordAlumnoSeleccionado);
    void sig_listaAlumnos(QList<QObject*>listaAlumnos);
    void sig_listaBirthday(QList<QObject*>arg);
    void pathFotoClienteChanged(QString arg);
    void sig_urlFotoCliente(QString arg);
    void sig_mostrarFotoDePerfil(QString arg);
    void sig_noHayFoto();
    void pathFotoAltaChanged(QString arg);
    void sig_isItHerBirthday(int arg);
    void sig_birthdaysByMonthListReady();
    void sig_mensajeError(bool requiereCerrarElPrograma, QString msjError);
};

#endif // CLASSMANAGEMENTGESTIONDEALUMNOS_H
