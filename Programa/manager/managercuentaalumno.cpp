#include "managercuentaalumno.h"
#include "../wrapperclassmanagement.h"

ManagerCuentaAlumno::ManagerCuentaAlumno()
{

}

///////////////////////////////////
//CUENTA_ALUMNO
///////////////////////////////////

CuentaAlumno* ManagerCuentaAlumno::crearCuentaAlumno(int id_alumno)
{
    CuentaAlumno* cuenta_alumno = NULL;
    QSqlQuery query;
    query.prepare("INSERT INTO cuenta_cliente (id_cliente, credito_actual) VALUES (:id_cliente, :credito_actual)");
    query.bindValue(":id_cliente", id_alumno);
    query.bindValue(":credito_actual", 0);

    if(!query.exec()) {
        WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        qDebug() << query.lastError();
        return NULL;
    }
    //this->controlarMensajesDeError(query);
    query.prepare("SELECT * FROM cuenta_cliente WHERE id = "+QString::number(query.lastInsertId().toInt()));
    if(!query.exec()) {
        WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        qDebug() << query.lastError();
        return NULL;
    }
    while (query.next()) {
        cuenta_alumno = new CuentaAlumno();
        cuenta_alumno->setId(query.value("id").toInt());
        cuenta_alumno->setId_cliente(query.value("id_cliente").toInt());
        cuenta_alumno->setCredito_actual(query.value("credito_actual").toDouble());
    }
    if (cuenta_alumno == NULL){
        WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        return NULL;
    }

    return cuenta_alumno;
}

bool ManagerCuentaAlumno::actualizarCuentaAlumno(CuentaAlumno* cuenta_alumno)
{
    if (cuenta_alumno == NULL)
        return false;
    bool salida = true;
    QSqlQuery query;

    QString strQuery = "UPDATE cuenta_cliente SET credito_actual = "+QString::number(cuenta_alumno->credito_actual())+" WHERE id_cliente = "+QString::number(cuenta_alumno->id_cliente());
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
    }
    //this->controlarMensajesDeError(query);
    return salida;
}


///
/// \brief ManagerCuentaAlumno::traerCuentaAlumnoPorIdAlumno
/// \param id_alumno
/// \return CuentaAlumno. Si no existe, la crea y la retorna.
///
CuentaAlumno *ManagerCuentaAlumno::traerCuentaAlumnoPorIdAlumno(int id_alumno)
{
    ///TRAIGO LA CUENTA
    CuentaAlumno* cuenta_alumno = NULL;
    QSqlQuery query;
    query.prepare("SELECT * FROM cuenta_cliente WHERE id_cliente = "+QString::number(id_alumno));
    if(!query.exec()) {
        qDebug() << query.lastError();
        WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        return NULL;
    }
    //this->controlarMensajesDeError(query);
    while (query.next()) {
        cuenta_alumno = new CuentaAlumno();
        cuenta_alumno->setId(query.value("id").toInt());
        cuenta_alumno->setId_cliente(query.value("id_cliente").toInt());
        cuenta_alumno->setCredito_actual(query.value("credito_actual").toDouble());
    }

    ///SI NO TENGO CUENTA, LA CREO
    if (cuenta_alumno == NULL) {
        cuenta_alumno = this->crearCuentaAlumno(id_alumno);
    }

    return cuenta_alumno;
}




///////////////////////////////////
//TIPO_OPERACION
///////////////////////////////////

int ManagerCuentaAlumno::crearTipoOperacion(QString descripcion)
{
    QSqlQuery query;
    query.prepare("INSERT INTO tipo_operacion (descripcion,estado) VALUES (:descripcion,:estado)");
    query.bindValue(":descripcion", descripcion);
    query.bindValue(":estado", "Habilitado");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    //this->controlarMensajesDeError(query);
    return query.lastInsertId().toInt();
}


/*
        "id_tipo_operacion integer NOT NULL, "
        "id_cuenta_cliente integer NOT NULL, "
        "monto REAL NOT NULL, "
        "fecha_movimiento DATETIME NOT NULL, "
        "descripcion VARCHAR(140), "
*/

bool ManagerCuentaAlumno::actualizarTipoOperacion(int idOperacion, QString descripcion, QString estado)
{
    bool salida = true;
    QSqlQuery query;

    QString strQuery = "UPDATE tipo_operacion SET descripcion = '"+descripcion+"', estado = '"+estado+"' WHERE id = '"+QString::number(idOperacion)+"'";
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
    }

    //this->controlarMensajesDeError(query);
    return salida;
}

QList<QObject*> ManagerCuentaAlumno::traerTodosLosTiposDeOperacion() {
    QList<QObject*> lista;
    QSqlQuery query;
    query.prepare("SELECT * FROM tipo_operacion WHERE estado = 'Habilitado'");
    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    //this->controlarMensajesDeError(query);
    lista.clear();
    while (query.next()) {
        TipoOperacion* tipoOperacion = new TipoOperacion();
        tipoOperacion->setId(query.value("id").toInt());
        tipoOperacion->setDescripcion(query.value("descripcion").toString());
        lista.append(tipoOperacion);
    }
    return lista;
}


///////////////////////////////////
//MOVIMIENTO
///
/// 05/03/2018
///ES REQUISITO INICIAR UNA TRANSACCION ANTES DE LLAMAR A ESTA FUNCION
///
///Hacemos un movimiento. Ademas de registrar el movimiento, tenemos que actualizar la cuenta del alumno,
/// ya que en funcion del monto del movimiento, este acreditara o debitara saldo a la cuenta del alumno.
/// Asimismo, para tener un control de lo gastado en el mes y desde el origen de los tiempos, es necesario
/// actualizar el resumen de mes del alumno.
///
/// Esto implica que la realizacion de un movimiento afecta
/// 1.- La cuenta del alumno.
/// 2.- El resumen de mes de dicho alumno.
///
/// Por lo tanto, la funcion  es extremadamente importante, ya que ella sola se encarga de
/// registrar en la base de datos el movimiento, refleja los cambios en la cuenta del alumno y actualiza
/// el resumen del mes del alumno.

///////////////////////////////////

int ManagerCuentaAlumno::crearMovimiento(
        int id_tipo_operacion,
        int id_cuenta_cliente,
        float monto,
        QString descripcion,
        CuentaAlumno * cuenta_alumno,
        ResumenMes * resumen_mes,
        QString codigo_oculto,
        bool ingreso_egreso_caja)
{
    int idMovimiento = -1;
    QSqlQuery query;

    if (cuenta_alumno == NULL && !ingreso_egreso_caja) {
        //WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        return -1;
    }

    if (resumen_mes == NULL && !ingreso_egreso_caja) {
        //WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        return -1;
    }



    ///REGISTRO EL MOVIMIENTO
    query.prepare("INSERT INTO movimiento (id_tipo_operacion,id_cuenta_cliente,monto,descripcion,credito_cuenta,codigo_oculto, fecha_movimiento) VALUES (:id_tipo_operacion,:id_cuenta_cliente,:monto,:descripcion,:credito_cuenta,:codigo_oculto,:fecha_movimiento)");
    if (id_tipo_operacion == -1) {
        query.bindValue(":id_tipo_operacion", QVariant::Int); //Guarda un NULL
    }
    else {
        query.bindValue(":id_tipo_operacion", id_tipo_operacion);
    }
    if (ingreso_egreso_caja)
        query.bindValue(":id_cuenta_cliente", QVariant::Int);
    else
        query.bindValue(":id_cuenta_cliente", id_cuenta_cliente);
    query.bindValue(":monto", monto);
    query.bindValue(":descripcion", descripcion);
    if (!ingreso_egreso_caja)
        query.bindValue(":credito_cuenta", cuenta_alumno->credito_actual()+monto);
    else
        query.bindValue(":credito_cuenta", -1);
    query.bindValue(":codigo_oculto", codigo_oculto);
    query.bindValue(":fecha_movimiento", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
        //WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        return -1; //Me voy
    }
    idMovimiento = query.lastInsertId().toInt();
    if (ingreso_egreso_caja)
        return idMovimiento;
    ///Hasta aca, se puede decir que el movimiento se inserto* correctamente.
    /// (Tecnicamente aun no, ya que la transaccion se comitearia mas adelante)


    ///ACTUALIZO LA CUENTA
    cuenta_alumno->setCredito_actual(cuenta_alumno->credito_actual() + monto);
    if (this->actualizarCuentaAlumno(cuenta_alumno) == false){
        //WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        return -1;
    }
    ///Hasta aca, se podria decir que el movimiento y la actualizacion de cuenta se registraron correctamente.
    ////////////////////////


    ///ACTUALIZO EL RESUMEN MES
    float suma = resumen_mes->ultimo_saldo_parcial_mes()+monto;
    resumen_mes->setUltimo_saldo_parcial_mes(suma);
    if (this->actualizarResumenMes(resumen_mes) == false){
        //WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        return -1;
    }
    ////////////////////////

    return idMovimiento;
}

QList<QObject*> ManagerCuentaAlumno::traerTodosLosMovimientosPorCuenta(int idCuentaCliente, int cantidad) {
    QList<QObject*> lista;
    QSqlQuery query;
    if (cantidad == -1){
        if (idCuentaCliente == -1){
            query.prepare("SELECT m.*, t.descripcion AS descripcion_tipo_operacion FROM movimiento m LEFT JOIN tipo_operacion t ON m.id_tipo_operacion = t.id WHERE id_cuenta_cliente IS NULL ORDER BY id DESC");
        }
        else {
            query.prepare("SELECT m.*, t.descripcion AS descripcion_tipo_operacion FROM movimiento m LEFT JOIN tipo_operacion t ON m.id_tipo_operacion = t.id WHERE id_cuenta_cliente = '"+QString::number(idCuentaCliente)+"' ORDER BY id DESC");
        }
    }
    else {
        if (idCuentaCliente == -1){
            query.prepare("SELECT m.*, t.descripcion AS descripcion_tipo_operacion FROM movimiento m LEFT JOIN tipo_operacion t ON m.id_tipo_operacion = t.id WHERE id_cuenta_cliente IS NULL ORDER BY id DESC LIMIT "+QString::number(cantidad));
        }
        else{
            query.prepare("SELECT m.*, t.descripcion AS descripcion_tipo_operacion FROM movimiento m LEFT JOIN tipo_operacion t ON m.id_tipo_operacion = t.id WHERE id_cuenta_cliente = '"+QString::number(idCuentaCliente)+"' ORDER BY id DESC LIMIT "+QString::number(cantidad));
        }
    }

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    //this->controlarMensajesDeError(query);
    lista.clear();
    while (query.next()) {
        Movimiento* movimiento = new Movimiento();
        movimiento->setId(query.value("id").toInt());
        movimiento->setId_estado_operacion(query.value("id_tipo_operacion").toInt());
        movimiento->setId_cuenta_cliente(query.value("id_cuenta_cliente").toInt());
        movimiento->setMonto(query.value("monto").toDouble());
        movimiento->setCredito_cuenta(query.value("credito_cuenta").toDouble());
        movimiento->setFecha_movimiento(query.value("fecha_movimiento").toDateTime());
        movimiento->setDescripcion(query.value("descripcion").toString());
        movimiento->setDescripcion_tipo_operacion(query.value("descripcion_tipo_operacion").toString());
        movimiento->setCodigo_oculto(query.value("codigo_oculto").toString());
        lista.append(movimiento);
    }
    return lista;
}

QList<QObject*> ManagerCuentaAlumno::traerTodosLosMovimientosPorCuenta(int idCuentaCliente, QDate fecha_inicial, QDate fecha_final, bool rellenarConObjetosNulosLosDiasSinMovimiento) {
    QList<QObject*> lista;
    QSqlQuery query;

    QDate ultimaFechaMovimiento;
    bool primera_vez = true;

    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    QString orden = "DESC";
    if (rellenarConObjetosNulosLosDiasSinMovimiento)
        orden = "ASC";

    query.prepare("SELECT m.*, "
                  "t.descripcion AS descripcion_tipo_operacion "
                  "FROM movimiento m "
                  "LEFT JOIN tipo_operacion t ON m.id_tipo_operacion = t.id "
                  "WHERE id_cuenta_cliente = '"+QString::number(idCuentaCliente)+"' "
                                                                                 "AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha_movimiento AND fecha_movimiento <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' "
                                                                                                                                                                                                                                           "ORDER BY m.fecha_movimiento "+orden);


    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    //this->controlarMensajesDeError(query);
    lista.clear();
    while (query.next()) {
        Movimiento* movimiento = new Movimiento();
        movimiento->setId(query.value("id").toInt());
        movimiento->setId_estado_operacion(query.value("id_tipo_operacion").toInt());
        movimiento->setId_cuenta_cliente(query.value("id_cuenta_cliente").toInt());
        movimiento->setMonto(query.value("monto").toDouble());
        movimiento->setCredito_cuenta(query.value("credito_cuenta").toDouble());
        movimiento->setFecha_movimiento(query.value("fecha_movimiento").toDateTime());
        movimiento->setDescripcion(query.value("descripcion").toString());
        movimiento->setDescripcion_tipo_operacion(query.value("descripcion_tipo_operacion").toString());
        movimiento->setCodigo_oculto(query.value("codigo_oculto").toString());

        if (rellenarConObjetosNulosLosDiasSinMovimiento) {
            while (fecha_inicial.daysTo(movimiento->fecha_movimiento().date()) > 0){
                lista.append(NULL);
                fecha_inicial = fecha_inicial.addDays(1);
            }

            if (ultimaFechaMovimiento.daysTo(movimiento->fecha_movimiento().date()) != 0) {
                lista.append(movimiento);
                fecha_inicial = fecha_inicial.addDays(1);
                ultimaFechaMovimiento = movimiento->fecha_movimiento().date();
            }

            if (primera_vez) {
                lista.append(movimiento);
                fecha_inicial = fecha_inicial.addDays(1);
                ultimaFechaMovimiento = movimiento->fecha_movimiento().date();
                primera_vez = false;
            }

            //Lo anterior evita que se cargue mas de un movimiento.
        }
        else {
            lista.append(movimiento);
        }
    }
    if (rellenarConObjetosNulosLosDiasSinMovimiento) {

        while (fecha_inicial.daysTo(fecha_final) >=0){
            lista.append(NULL);
            fecha_inicial = fecha_inicial.addDays(1);
        }
    }


    return lista;
}

QList<QObject*> ManagerCuentaAlumno::traerMovimientosInfantilesPorFecha(QDate fecha)
{
/*    //MOVIMIENTO
    //monto, fecha_movimiento, descripcion, credito_cuenta, codigo_oculto

    //CLIENTE
    //id, apellido, primer_nombre, segundo_nombre


    QString strDate = fecha.toString("yyyy-MM-dd");
    query.prepare("SELECT * FROM resumen_mes WHERE strftime('%m',resumen_mes.fecha) = strftime('%m','"+strDate+"') AND strftime('%Y',resumen_mes.fecha) = strftime('%Y','"+strDate+"') AND id_cliente = "+QString::number(id_cliente));
*/

    QList<QObject*> lista;
    totalIngresosInfantiles = 0;

    QSqlQuery query;
    query.prepare("SELECT c.id, c.fecha_nacimiento, c.apellido, c.primer_nombre, c.segundo_nombre, m.monto, m.fecha_movimiento, m.descripcion, m.credito_cuenta, m.codigo_oculto "
                  "FROM movimiento m "
                  "INNER JOIN cuenta_cliente ON cuenta_cliente.id = m.id_cuenta_cliente "
                  "INNER JOIN cliente c ON c.id = cuenta_cliente.id_cliente "
                  "WHERE '"+fecha.toString("yyyy-MM-dd")+"' < m.fecha_movimiento AND m.fecha_movimiento < '"+fecha.addDays(1).toString("yyyy-MM-dd")+"' AND (codigo_oculto LIKE 'CSMAI%' OR codigo_oculto LIKE 'CSAI%' OR codigo_oculto LIKE 'AMAI%' OR codigo_oculto LIKE 'AAI%' OR codigo_oculto LIKE 'MAI%') ORDER BY c.id, m.fecha_movimiento DESC");



    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else{
        int id_cliente = -1;
        ResumenMovimientosAlumno * resumen = NULL;
        bool first_time = true;
        while(query.next()){
            if (id_cliente != query.value("id").toInt()){
                if (!first_time)
                    lista.append(resumen);
                id_cliente = query.value("id").toInt();

                resumen = new ResumenMovimientosAlumno();
                resumen->setId_alumno(id_cliente);
                resumen->setApellido(query.value("apellido").toString());
                resumen->setPrimer_nombre(query.value("primer_nombre").toString());
                resumen->setSegundo_nombre(query.value("segundo_nombre").toString());
                resumen->setFecha_nacimiento(query.value("fecha_nacimiento").toDate());
            }
            first_time = false;

            QJsonObject detalle;
            float monto = query.value("monto").toFloat();
            detalle.insert("monto",monto);
            detalle.insert("fecha_movimiento",query.value("fecha_movimiento").toDateTime().toString("dddd HH:mm"));
            detalle.insert("descripcion",query.value("descripcion").toString());
            detalle.insert("credito_cuenta",query.value("credito_cuenta").toFloat());
            detalle.insert("codigo_oculto",query.value("codigo_oculto").toString());

            if (monto>=0)
                totalIngresosInfantiles += monto;
            resumen->agregar_detalle(detalle);
        }
        if (!first_time)
            lista.append(resumen);
    }

    return lista;
}

QList<QObject *> ManagerCuentaAlumno::traerMovimientosAdultosPorFecha(QDate fecha)
{
    QList<QObject*> lista;
    totalIngresosAdultos = 0;

    QSqlQuery query;
    query.prepare("SELECT c.id, c.fecha_nacimiento, c.apellido, c.primer_nombre, c.segundo_nombre, m.monto, m.fecha_movimiento, m.descripcion, m.credito_cuenta, m.codigo_oculto "
                  "FROM movimiento m "
                  "INNER JOIN cuenta_cliente ON cuenta_cliente.id = m.id_cuenta_cliente "
                  "INNER JOIN cliente c ON c.id = cuenta_cliente.id_cliente "
                  "WHERE '"+fecha.toString("yyyy-MM-dd")+"' < m.fecha_movimiento AND m.fecha_movimiento < '"+fecha.addDays(1).toString("yyyy-MM-dd")+"' AND (codigo_oculto LIKE 'CSAA%' OR codigo_oculto LIKE 'AAA%' OR codigo_oculto LIKE 'MAA%') ORDER BY c.id, m.fecha_movimiento DESC");


    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else{
        int id_cliente = -1;
        ResumenMovimientosAlumno * resumen = NULL;
        bool first_time = true;
        while(query.next()){
            if (id_cliente != query.value("id").toInt()){
                if (!first_time)
                    lista.append(resumen);
                id_cliente = query.value("id").toInt();

                resumen = new ResumenMovimientosAlumno();
                resumen->setId_alumno(id_cliente);
                resumen->setApellido(query.value("apellido").toString());
                resumen->setPrimer_nombre(query.value("primer_nombre").toString());
                resumen->setSegundo_nombre(query.value("segundo_nombre").toString());
                resumen->setFecha_nacimiento(query.value("fecha_nacimiento").toDate());
            }
            first_time = false;

            QJsonObject detalle;
            float monto = query.value("monto").toFloat();
            detalle.insert("monto",monto);
            detalle.insert("fecha_movimiento",query.value("fecha_movimiento").toDateTime().toString("dddd HH:mm"));
            detalle.insert("descripcion",query.value("descripcion").toString());
            detalle.insert("credito_cuenta",query.value("credito_cuenta").toFloat());
            detalle.insert("codigo_oculto",query.value("codigo_oculto").toString());

            if (monto>=0)
                totalIngresosAdultos += monto;
            resumen->agregar_detalle(detalle);
        }
        if (!first_time)
            lista.append(resumen);
    }

    return lista;
}

double ManagerCuentaAlumno::traerTotalIngresosAdultos() {
    return totalIngresosAdultos;
}

double ManagerCuentaAlumno::traerTotalIngresosInfantiles() {
    return totalIngresosInfantiles;
}




///////////////////////////////////
//RESUMEN_MES
///////////////////////////////////


int ManagerCuentaAlumno::crearResumenMes(int id_cliente, float ultimo_saldo_parcial_mes, float ultimo_saldo_acumulado_mes)
{
    int salida = -1;
    QSqlQuery query;
    query.prepare("INSERT INTO resumen_mes (id_cliente,ultimo_saldo_parcial_mes,ultimo_saldo_acumulado_mes, fecha) VALUES (:id_cliente,:ultimo_saldo_parcial_mes,:ultimo_saldo_acumulado_mes,:fecha)");
    query.bindValue(":id_cliente", id_cliente);
    query.bindValue(":ultimo_saldo_parcial_mes", ultimo_saldo_parcial_mes);
    query.bindValue(":ultimo_saldo_acumulado_mes", ultimo_saldo_acumulado_mes);
    query.bindValue(":fecha", QDateTime::currentDateTime());

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else{
        salida = query.lastInsertId().toInt();
    }
    //this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerCuentaAlumno::actualizarResumenMes(ResumenMes *resumen_mes)
{
    if (resumen_mes == NULL)
        return false;
    bool salida = true;
    QSqlQuery query;

    qDebug() << "Hoola. ultimo_saldo_parcial_mes(): " << resumen_mes->ultimo_saldo_parcial_mes();
    qDebug() << "ultimo_saldo_acumulado_mes " << resumen_mes->ultimo_saldo_acumulado_mes();

    QString strQuery = "UPDATE resumen_mes SET ultimo_saldo_parcial_mes = "+QString::number(resumen_mes->ultimo_saldo_parcial_mes())+", ultimo_saldo_acumulado_mes = "+QString::number(resumen_mes->ultimo_saldo_acumulado_mes())+" WHERE id = '"+QString::number(resumen_mes->id())+"'";
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }

    qDebug() << "Last query: " << query.lastQuery();

    return salida;
}

ResumenMes *ManagerCuentaAlumno::traerResumenMesPorClienteFecha(int id_cliente, bool crearSiNoExiste, QDate fecha)
{
    ///TRAIGO LA CUENTA
    ResumenMes* resumen_mes = NULL;
    ResumenMes* resumen_mes_anterior = NULL;
    QSqlQuery query;
    QString strDate = fecha.toString("yyyy-MM-dd");
    query.prepare("SELECT * FROM resumen_mes WHERE strftime('%m',resumen_mes.fecha) = strftime('%m','"+strDate+"') AND strftime('%Y',resumen_mes.fecha) = strftime('%Y','"+strDate+"') AND id_cliente = "+QString::number(id_cliente));
    if(!query.exec()) {
        qDebug() << query.lastError();
        qDebug() << "traerResumenMesPorClienteFecha: " << query.lastQuery();
        WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        return NULL;
    }

    //this->controlarMensajesDeError(query);
    if (query.next()) {
        resumen_mes = new ResumenMes();
        resumen_mes->setId(query.value("id").toInt());
        resumen_mes->setId_cliente(query.value("id_cliente").toInt());
        resumen_mes->setFecha(query.value("fecha").toDate());
        resumen_mes->setUltimo_saldo_parcial_mes(query.value("ultimo_saldo_parcial_mes").toDouble());
        resumen_mes->setUltimo_saldo_acumulado_mes(query.value("ultimo_saldo_acumulado_mes").toDouble());
    }

    if (crearSiNoExiste == false){
        return resumen_mes;
    }

    /// Pero necesito el acumulado del resumen anterior, asi que lo traigo.
    query.prepare("SELECT * FROM resumen_mes WHERE id_cliente = "+QString::number(id_cliente))+"WHERE fecha < "+strDate+" ORDER BY fecha DESC LIMIT 1";
    if(!query.exec()) {
        qDebug() << query.lastError();
        WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
        return NULL;
    }

    if (query.next()) {
        resumen_mes_anterior = new ResumenMes();
        resumen_mes_anterior->setId(query.value("id").toInt());
        resumen_mes_anterior->setId_cliente(query.value("id_cliente").toInt());
        resumen_mes_anterior->setFecha(query.value("fecha").toDate());
        resumen_mes_anterior->setUltimo_saldo_parcial_mes(query.value("ultimo_saldo_parcial_mes").toDouble());
        resumen_mes_anterior->setUltimo_saldo_acumulado_mes(query.value("ultimo_saldo_acumulado_mes").toDouble());
    }

    if (resumen_mes == NULL){ //Lo creo
        resumen_mes = new ResumenMes();
        resumen_mes->setId_cliente(id_cliente);
        resumen_mes->setFecha(QDate::currentDate());

        if (resumen_mes_anterior == NULL){
            //El alumno no tiene registrado ningún resumen.
            resumen_mes->setUltimo_saldo_parcial_mes(0);
            resumen_mes->setUltimo_saldo_acumulado_mes(0);
        }
        else {
            resumen_mes->setUltimo_saldo_parcial_mes(resumen_mes_anterior->ultimo_saldo_parcial_mes());
            resumen_mes->setUltimo_saldo_acumulado_mes(resumen_mes_anterior->ultimo_saldo_parcial_mes());
        }

        int id_resumen = this->crearResumenMes(id_cliente, resumen_mes->ultimo_saldo_parcial_mes(), resumen_mes->ultimo_saldo_acumulado_mes());
        if(id_resumen == -1) {
            WrapperClassManagement::getGestionBaseDeDatos()->rollbackTransaction();
            return NULL;
        }
        resumen_mes->setId(id_resumen);
    }

    return resumen_mes;
}
