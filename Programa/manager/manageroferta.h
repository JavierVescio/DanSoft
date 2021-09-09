#ifndef MANAGEROFERTA_H
#define MANAGEROFERTA_H
#include <QObject>
#include <QDateTime>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include <QStringList>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include "commonbase/oferta.h"

class ManagerOferta: public QObject
{
    Q_OBJECT
public:
    ManagerOferta();

    Q_INVOKABLE bool agregarOferta(
            QString nombre,
            QString descripcion,
            QString tipo,
            float precio,
            int stock,
            bool uno_por_alumno,
            QString str_vigente_desde,
            QString str_vigente_hasta);

    Q_INVOKABLE bool actualizarOferta(
            int id,
            QString nombre,
            QString descripcion,
            QString tipo,
            float precio,
            int stock,
            bool uno_por_alumno,
            QString str_vigente_desde,
            QString str_vigente_hasta);

    Q_INVOKABLE bool bajarOferta(
            int id);

    Q_INVOKABLE QList<QObject*> traerOfertas(
            QString nombre,
            QString tipo,
            bool vigente,
            bool soloConStock=false);

    Q_INVOKABLE int realizarCompra(
            int id_cliente,
            float precio_total);

    Q_INVOKABLE bool agregarAlCarritoDeCompras(
            int idOferta,
            QString nombre,
            int cantidad,
            float precio);

    Q_INVOKABLE bool quitarItemCarritoDeCompras(
            int idOferta);

    Q_INVOKABLE bool actualizarCarritoDeCompras(
            int idOferta,
            int cantidad);

    Q_INVOKABLE void vaciarCarritoDeCompras();

    Q_INVOKABLE QString obtenerBreveResumenDelCarritoDeCompras();

    Q_INVOKABLE QString obtenerResumenDelCarritoDeCompras();

    Q_INVOKABLE void mostrarVenta(
            int id);

private:
    bool itemYaAgregadoAlCarrito(
            int idOferta);

    QJsonArray arrayCarrito;

signals:
    void sig_comentarioVenta(int id_venta, QString comentario_venta);
};

#endif // MANAGEROFERTA_H
