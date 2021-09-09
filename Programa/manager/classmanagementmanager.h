#ifndef CLASSMANAGEMENTMANAGER_H
#define CLASSMANAGEMENTMANAGER_H
#include <QObject>
#include <QDebug>
#include <QDate>
#include <QDateTime>
#include <QDesktopServices>
#include <QDesktopServices>
#include <QUrl>
#include <QStringList>
#include "classmanagementgestiondealumnos.h"
#include <QQuickItem>
#include <QQuickItemGrabResult>
#include <QDesktopServices>


class ClassManagementManager: public QObject {
    Q_OBJECT

    Q_PROPERTY(bool versionGratis READ versionGratis)
    Q_PROPERTY(int limiteDeAlumnos READ limiteDeAlumnos)
    Q_PROPERTY(bool sistema_bloqueado READ getSistema_bloqueado WRITE setSistema_bloqueado NOTIFY sistema_bloqueadoChanged)
    Q_PROPERTY(QString cliente READ getCliente WRITE setCliente NOTIFY clienteChanged)
    Q_PROPERTY(CMAlumno* clienteSeleccionado READ clienteSeleccionado WRITE setClienteSeleccionado NOTIFY clienteSeleccionadoChanged)

public:
    ClassManagementManager();

    Q_INVOKABLE void abrirModulo(QString strPath); //En desuso
    Q_INVOKABLE QDate obtenerFecha(QString fecha = "");
    Q_INVOKABLE QDateTime obtenerFechaHora();
    Q_INVOKABLE int obtenerDiferenciaDias(QDate fechaInicial, QDate fechaFina = QDate::currentDate());
    Q_INVOKABLE bool seLlegoAlLimite();
    Q_INVOKABLE QDate nuevaFecha(QDate fechaOriginal, int addDays);
    Q_INVOKABLE int calcularTiempoPasadoEnSegundos(QDateTime fecha_inicial, QDateTime fecha_final = QDateTime::currentDateTime());
    Q_INVOKABLE QString calcularTiempoPasado(QDateTime fecha_inicial, QDateTime fecha_final = QDateTime::currentDateTime());
    Q_INVOKABLE void enviarMail(QString direccion);

    Q_INVOKABLE QStringList traerDiasDeSemanaConNumero(QDate fecha_inicial, QDate fecha_final);
    Q_INVOKABLE QString traerNombreDiaCorto(int dia, int mes, int anio);

    Q_INVOKABLE int totalDiasDelMes(int mes, int anio);

    //Q_INVOKABLE void captureQml(QQuickItem* item);
    Q_INVOKABLE void captureQml(QQuickItem* item, QString path1 = "");


    bool versionGratis() const;
    int limiteDeAlumnos() const;
    bool getSistema_bloqueado() const;
    QString getCliente() const;

    CMAlumno* clienteSeleccionado() const;

public slots:
    void setSistema_bloqueado(bool sistema_bloqueado);
    void setCliente(QString cliente);

    void setClienteSeleccionado(CMAlumno* clienteSeleccionado);

private:
    bool m_versionGratis;
    int m_limiteDeAlumnos;
    bool m_sistema_bloqueado;
    QString m_cliente;

    CMAlumno* m_clienteSeleccionado;

signals:
    void sig_abrirModulo(QString strPath);
    void sistema_bloqueadoChanged(bool sistema_bloqueado);
    void clienteChanged(QString cliente);
    void clienteSeleccionadoChanged(CMAlumno* clienteSeleccionado);
};

#endif // CLASSMANAGEMENTMANAGER_H
