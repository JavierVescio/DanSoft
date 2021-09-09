#ifndef MANAGERASISTENCIAS_H
#define MANAGERASISTENCIAS_H
#include <QObject>
#include <QDate>
#include <QDateTime>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include "commonbase/claseasistencia.h"
#include "commonbase/cmalumno.h"
#include "commonbase/inscripcionclienteclase.h"

class ManagerAsistencias: public QObject
{
    Q_OBJECT
public:
    ManagerAsistencias();
    Q_INVOKABLE int darPresente(int id_cliente, bool clase_debitada, int id_clase, QString fecha = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
    Q_INVOKABLE int anularPresente(int id_presente);
    Q_INVOKABLE int obtenerClasesSinPagarPorAlumno(int id_cliente);
    Q_INVOKABLE int normalizarCuentaDeAlumno(int id_cliente);

    Q_INVOKABLE bool obtenerPresentesEntreFechas(QDate fecha_inicial, QDate fecha_final, int id_cliente = -1);
    Q_INVOKABLE bool obtenerPresentesInfantilesEntreFechas(QDate fecha_inicial, QDate fecha_final, int id_cliente = -1, bool rellenarConObjetosNulosLosDiasSinAsistencia = false);

    Q_INVOKABLE int obtenerAsistenciasEntreFechasPorActividad(int id_actividad,QDate fecha_inicial, QDate fecha_final);
    Q_INVOKABLE int obtenerAsistenciasInfantilesEntreFechasPorActividad(int id_actividad,QDate fecha_inicial, QDate fecha_final);

    Q_INVOKABLE int obtenerAsistenciasEntreFechasPorClase(int id_clase, QDate fecha_inicial, QDate fecha_final = QDate::currentDate());
    Q_INVOKABLE int obtenerAsistenciasInfantilesEntreFechasPorClase(int id_clase, QDate fecha_inicial, QDate fecha_final = QDate::currentDate(), bool rellenarConObjetosNulosLosDiasSinAsistencia = false);
    Q_INVOKABLE QList<QObject*> obtenerAsistenciasDelAlumnoEntreFechasPorClase(int id_clase, int id_cliente, QDate fecha_inicial, QDate fecha_final = QDate::currentDate(), bool rellenarConObjetosNulosLosDiasSinAsistencia = false);

    Q_INVOKABLE bool obtenerClasesPorAbono(int id_abono);
    Q_INVOKABLE int obtenerAsistenciasPorClaseGeneroEntreFechas(int id_clase, QString genero, QDate fecha_inicial, QDate fecha_final);
    Q_INVOKABLE int obtenerAsistenciasEntreFechas(QDate fecha_inicial, QDate fecha_final);
    Q_INVOKABLE void obtenerAlumnosMasAsistidoresEntreFechasPorClase(int id_clase, QDate fecha_inicial, QDate fecha_final);
    Q_INVOKABLE bool obtenerPresentesDelAlumno(int id_cliente, int limite = 0); //0 = sin limite

    Q_INVOKABLE bool traerAlumnosInfantilesAsistidoresDelMesPorClase(int id_clase, QDate fecha_inicial = QDate::currentDate(), QDate fecha_final = QDate::currentDate());
    Q_INVOKABLE void intentarRegistrarPresenteTablaInfantil();
    Q_INVOKABLE QList<QObject*> traerInscripcionesDelAlumno(int id_cliente);

    Q_INVOKABLE bool inscribirDesinscribirClienteClase(int id_cliente,int id_danza_clase, bool inscribir = true);

    Q_INVOKABLE void enviarSenialCambioDeMes();

private:
    CMAlumno * extraerAlumnoDelQueryDeAsistencias(QSqlQuery query);
    void controlarMensajesDeError(QSqlQuery query);

signals:
    void sig_idPresenteRegistrado(int arg);
    void sig_listaClaseAsistencias(QList<QObject*> arg, QList<QObject*> arg2);
    void sig_listaClaseAsistenciasInfantil(QList<QObject*> arg, QList<QObject*> arg2, int id_cliente = -1);
    void sig_noHayAsistenciasDelAlumno();
    void sig_noHayAsistenciasDelAlumnoInfantil();
    void sig_listaAlumnosMasAsistidores(QList<int> listaAsistencias, QList<QObject*> listaAlumnosArg);
    void sig_mensajeError(bool requiereCerrarElPrograma, QString msjError);
    void sig_intentarRegistrarPresenteTablaInfantil();

    void sig_listaAlumnos(QList<QObject*> arg);
    void sig_cambioDeMes();
};

#endif // MANAGERASISTENCIAS_H
