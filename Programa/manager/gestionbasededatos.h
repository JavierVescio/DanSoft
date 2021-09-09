#ifndef GESTIONBASEDEDATOS_H
#define GESTIONBASEDEDATOS_H
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QSqlRecord>
#include <QObject>
#include <QDateTime>
#include <QDesktopServices>
#include <QImage>
#include "commonbase/backup.h"

class GestionBaseDeDatos: public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool creacionDeTablasOk READ creacionDeTablasOk)

public:
    GestionBaseDeDatos();

    Q_INVOKABLE void beginTransaction();
    Q_INVOKABLE void commitTransaction();
    Q_INVOKABLE void rollbackTransaction();
    Q_INVOKABLE int chequeoDeSeguridadDeLaHoraFecha();

    Q_INVOKABLE int agregarInfoBackUp(
            QString ruta1,
            QString ruta2,
            bool al_cerrar_caja,
            bool al_cerrar_sistema);
    Q_INVOKABLE bool actualizarInfoBackUp(
            int id,
            QString ruta1,
            QString ruta2,
            bool al_cerrar_caja,
            bool al_cerrar_sistema);
    Q_INVOKABLE QObject* traerInfoBackUp();

    Q_INVOKABLE bool hacerBackUp(
            QString dir1,
            QString dir2,
            bool dejar_abierta_conexion_bd=true);


    Q_INVOKABLE bool abrirConexion();
    Q_INVOKABLE void cerrarConexion();

    bool conectarBaseClassManagement();
    bool crearTablas();

    static const QString strDataBasePath;
    static const QString strDataBaseOldPath;
    static const QString STR_OUTPUT_FOLDER_NAME;
    bool creacionDeTablasOk() const;

private:
    bool m_creacionDeTablasOk;
    QSqlDatabase db;

signals:
    void sig_conexionBaseAlumnosOk();
    void sig_conexionBaseAlumnosMal();
    void sig_chequeoDeHoraFecha(QString mensaje, bool requiereCerrarElPrograma);
    void sig_problemaBackUp(QString arg, QString arg2);
};

#endif // GESTIONBASEDEDATOS_H
