#include "managercaja.h"

ManagerCaja::ManagerCaja()
{

}

bool ManagerCaja::iniciar_caja(
        float monto_inicial,
        QString comentario)
{
    bool salida = true;
    QSqlQuery query;

    query.prepare("INSERT INTO caja "
                  "(monto_inicial, comentario, fecha_inicio, estado) "
                  "VALUES "
                  "(:monto_inicial, :comentario, :fecha_inicio, :estado)");

    query.bindValue(":monto_inicial", monto_inicial);
    query.bindValue(":comentario", comentario);
    query.bindValue(":fecha_inicio", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
    query.bindValue(":estado", "Abierta");

    if(!query.exec()){
        qDebug() << query.lastError();
        salida = false;
    }else{
        emit sig_cajaAbierta(QDateTime::currentDateTime());
    }

    return salida;
}

bool ManagerCaja::cerrar_caja(
        int id,
        float monto_inicial,
        float monto_final,
        float monto_segun_sistema,
        QString comentario)
{
    bool salida = true;
    QSqlQuery query;

    query.prepare("UPDATE caja "
                  "SET monto_final = :monto_final, "
                  "monto_segun_sistema = :monto_segun_sistema, "
                  "comentario = comentario || ' | ' || :comentario, "
                  "fecha_cierre = :fecha_cierre, "
                  "estado = :estado "
                  "WHERE id = :id");

    query.bindValue(":monto_final", monto_final);
    query.bindValue(":monto_segun_sistema", monto_segun_sistema);
    query.bindValue(":comentario", comentario);
    query.bindValue(":fecha_cierre", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
    query.bindValue(":estado", "Cerrada");
    query.bindValue(":id", id);

    if(!query.exec()){
        qDebug() << query.lastError();
        salida = false;
    }else{
        emit sig_cajaCerrada(QDateTime::currentDateTime(),monto_segun_sistema-monto_final);
    }

    return salida;
}

QList<QObject *> ManagerCaja::obtener_registros_caja()
{
    QList<QObject *> lista;
    QSqlQuery query;


    query.prepare("SELECT * FROM caja ORDER BY id DESC");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            Caja *caja = new Caja();
            caja->setId(query.value("id").toInt());
            caja->setMonto_inicial(query.value("monto_inicial").toFloat());
            caja->setMonto_final(query.value("monto_final").toFloat());
            caja->setMonto_segun_sistema(query.value("monto_segun_sistema").toFloat());
            caja->setComentario(query.value("comentario").toString());
            caja->setFecha_inicio(query.value("fecha_inicio").toDateTime());
            caja->setFecha_cierre(query.value("fecha_cierre").toDateTime());
            caja->setEstado(query.value("estado").toString());
            caja->setDiferencia_monto(caja->monto_segun_sistema()-caja->monto_final());
            lista.append(caja);
        }
    }
    return lista;
}

QObject *ManagerCaja::traer_ultima_caja()
{
    Caja *caja = NULL;
    QSqlQuery query;

    query.prepare("SELECT * "
                  "FROM caja "
                  "WHERE estado = 'Abierta' OR estado = 'Cerrada' "
                  "ORDER BY fecha_inicio DESC LIMIT 1");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            caja = new Caja();
            caja->setId(query.value("id").toInt());
            caja->setMonto_inicial(query.value("monto_inicial").toFloat());
            caja->setMonto_final(query.value("monto_final").toFloat());
            caja->setMonto_segun_sistema(query.value("monto_segun_sistema").toFloat());
            caja->setComentario(query.value("comentario").toString());
            caja->setFecha_inicio(query.value("fecha_inicio").toDateTime());
            caja->setFecha_cierre(query.value("fecha_cierre").toDateTime());
            caja->setEstado(query.value("estado").toString());
            caja->setDiferencia_monto(caja->monto_segun_sistema()-caja->monto_final());
        }
    }
    return caja;
}

bool ManagerCaja::anular_caja(
        int id,
        QString comentario)
{
    bool salida = true;
    QSqlQuery query;

    query.prepare("UPDATE caja "
                  "SET estado = :estado, "
                  "fecha_cierre = :fecha_cierre, "
                  "comentario = comentario || ' | ' || :comentario "
                  "WHERE id = :id");

    query.bindValue(":comentario", comentario);
    query.bindValue(":estado", "Anulada");
    query.bindValue(":id", id);
    query.bindValue(":fecha_cierre", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

    if(!query.exec()) {
        salida = false;
    }else {
        emit sig_cajaAnulada(QDateTime::currentDateTime());
    }

    return salida;
}

float ManagerCaja::traerIngresosAbonoAdulto(QDateTime dt_inicial, QDateTime dt_final)
{
    float total = -1;
    QSqlQuery query;

    query.prepare("SELECT SUM(monto) AS ingresosAdultos "
                  "FROM movimiento "
                  "WHERE codigo_oculto LIKE 'CSAA%' "
                  "AND monto >= 0 "
                  "AND :dt_inicial <= fecha_movimiento AND fecha_movimiento <= :dt_final");
    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            qDebug() << "";
            qDebug() << "dt_inicial: " << dt_inicial.toString("yyyy-MM-dd hh:mm:ss");
            qDebug() << "dt_final: " << dt_final.toString("yyyy-MM-dd hh:mm:ss");
            qDebug() << query.executedQuery();
            total = query.value("ingresosAdultos").toFloat();
        }
    }
    return total;
}

float ManagerCaja::traerIngresosAbonoInfantil(QDateTime dt_inicial, QDateTime dt_final)
{
    float total = -1;
    QSqlQuery query;

    query.prepare("SELECT SUM(monto) AS ingresosInfantiles "
                  "FROM movimiento "
                  "WHERE codigo_oculto LIKE 'CSAI%' "
                  "AND monto >= 0 "
                  "AND :dt_inicial <= fecha_movimiento AND fecha_movimiento <= :dt_final");
    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            qDebug() << "";
            qDebug() << "dt_inicial: " << dt_inicial.toString("yyyy-MM-dd hh:mm:ss");
            qDebug() << "dt_final: " << dt_final.toString("yyyy-MM-dd hh:mm:ss");
            qDebug() << query.executedQuery();
            total = query.value("ingresosInfantiles").toFloat();
        }
    }
    return total;
}

float ManagerCaja::traerIngresosTesoreria(QDateTime dt_inicial, QDateTime dt_final)
{
    float total = -1;
    QSqlQuery query;

    query.prepare("SELECT SUM(monto) AS ingresosTesoreria "
                  "FROM movimiento "
                  "WHERE (codigo_oculto = 'OM' OR codigo_oculto = 'MC') "
                  "AND monto >= 0 "
                  "AND :dt_inicial <= fecha_movimiento AND fecha_movimiento <= :dt_final");
    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        qDebug() << "";
        qDebug() << "dt_inicial: " << dt_inicial.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << "dt_final: " << dt_final.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << query.executedQuery();
        while (query.next()) {
            total = query.value("ingresosTesoreria").toFloat();
        }
    }
    return total;
}

float ManagerCaja::traerIngresosTienda(QDateTime dt_inicial, QDateTime dt_final)
{
    float total = -1;
    QSqlQuery query;

    query.prepare("SELECT SUM(monto) AS ingresosTienda "
                  "FROM movimiento "
                  "WHERE codigo_oculto LIKE 'CSCT%' "
                  "AND monto >= 0 "
                  "AND :dt_inicial <= fecha_movimiento AND fecha_movimiento <= :dt_final");
    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        qDebug() << "";
        qDebug() << "dt_inicial: " << dt_inicial.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << "dt_final: " << dt_final.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << query.executedQuery();
        while (query.next()) {
            total = query.value("ingresosTienda").toFloat();
        }
    }
    return total;
}

float ManagerCaja::traerIngresosTotales(QDateTime dt_inicial, QDateTime dt_final)
{
    float total = -1;
    QSqlQuery query;

    query.prepare("SELECT SUM(monto) AS ingresosTotales "
                  "FROM movimiento "
                  "WHERE ("
                  "codigo_oculto LIKE 'CSAA%' OR "
                  "codigo_oculto LIKE 'CSAI%' OR "
                  "codigo_oculto LIKE 'CSCT%' OR "
                  "codigo_oculto = 'OM' OR "
                  "codigo_oculto = 'MC') "
                  "AND monto >= 0 "
                  "AND :dt_inicial <= fecha_movimiento AND fecha_movimiento <= :dt_final");
    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        qDebug() << "";
        qDebug() << "dt_inicial: " << dt_inicial.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << "dt_final: " << dt_final.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << query.executedQuery();
        while (query.next()) {
            total = query.value("ingresosTotales").toFloat();
        }
    }
    return total;
}

float ManagerCaja::traerEgresosTesoreria(QDateTime dt_inicial, QDateTime dt_final)
{
    float total = -1;
    QSqlQuery query;

    query.prepare("SELECT SUM(monto) AS egresosTesoreria "
                  "FROM movimiento "
                  "WHERE (codigo_oculto = 'OM' OR codigo_oculto = 'MC') "
                  "AND monto < 0 "
                  "AND :dt_inicial <= fecha_movimiento AND fecha_movimiento <= :dt_final");
    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        qDebug() << "";
        qDebug() << "dt_inicial: " << dt_inicial.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << "dt_final: " << dt_final.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << query.executedQuery();
        while (query.next()) {
            total = (query.value("egresosTesoreria").toFloat())*-1;
        }
    }
    return total;
}

float ManagerCaja::traerEgresosTotales(QDateTime dt_inicial, QDateTime dt_final)
{
    float total = -1;
    QSqlQuery query;

    query.prepare("SELECT SUM(monto) AS egresosTotales "
                  "FROM movimiento "
                  "WHERE ("
                  "codigo_oculto = 'OM' OR "
                  "codigo_oculto = 'MC') "
                  "AND monto < 0 "
                  "AND :dt_inicial <= fecha_movimiento AND fecha_movimiento <= :dt_final");
    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        qDebug() << "";
        qDebug() << "dt_inicial: " << dt_inicial.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << "dt_final: " << dt_final.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << query.executedQuery();
        while (query.next()) {
            total = (query.value("egresosTotales").toFloat())*-1;
        }
    }
    return total;
}
