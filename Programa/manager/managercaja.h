#ifndef MANAGERCAJA_H
#define MANAGERCAJA_H

#include <QObject>
#include <QDateTime>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include "commonbase/caja.h"

class ManagerCaja:public QObject
{
    Q_OBJECT

public:
    ManagerCaja();

    Q_INVOKABLE bool iniciar_caja(
            float monto_inicial,
            QString comentario);

    Q_INVOKABLE bool cerrar_caja(
            int id,
            float monto_inicial,
            float monto_final,
            float monto_segun_sistema,
            QString comentario);

    Q_INVOKABLE QList<QObject*> obtener_registros_caja();

    Q_INVOKABLE QObject* traer_ultima_caja();

    Q_INVOKABLE bool anular_caja(
            int id,
            QString comentario);

    Q_INVOKABLE float traerIngresosAbonoAdulto(
            QDateTime dt_inicial,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE float traerIngresosAbonoInfantil(
            QDateTime dt_inicial,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE float traerIngresosTesoreria(
            QDateTime dt_inicial,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE float traerIngresosTienda(
            QDateTime dt_inicial,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE float traerEgresosTesoreria(
            QDateTime dt_inicial,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE float traerIngresosTotales(
            QDateTime dt_inicial,
            QDateTime dt_final = QDateTime::currentDateTime());

    Q_INVOKABLE float traerEgresosTotales(
            QDateTime dt_inicial,
            QDateTime dt_final = QDateTime::currentDateTime());

signals:
    void sig_cajaAbierta(QDateTime fecha_hora);

    void sig_cajaAnulada(QDateTime fecha_hora);

    void sig_cajaCerrada(QDateTime fecha_hora, float resultado_caja);
};

#endif // MANAGERCAJA_H
