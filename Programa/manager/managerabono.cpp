#include "managerabono.h"

ManagerAbono::ManagerAbono()
{
    recordAbonoSuperior = NULL;
    totalClasesAbonoSuperior = -1;
}

QDate ManagerAbono::obtenerFechaDeHoy() {
    return QDate::currentDate();
}

QDate ManagerAbono::obtenerFechaDeVencimiento() {
    return QDate::currentDate().addDays(30);
}

int ManagerAbono::convertirEnAbonoLibre(int id) {
    int salida = 0;

    QSqlQuery query;
    query.prepare("UPDATE abono SET cantidad_comprada = 1, cantidad_clases = 1, cantidad_restante = 1, tipo = 'Libre' WHERE id = '"+QString::number(id)+"'");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        salida = id;
        emit sig_abonoMejorado();
    }

    this->controlarMensajesDeError(query);

    return salida;
}

int ManagerAbono::acreditarClasesAlAbono(int id, int total_a_acreditar, bool acreditar_tambien_en_cantidad_comprada) {
    int salida = 0;

    QSqlQuery query;
    if (acreditar_tambien_en_cantidad_comprada)
        query.prepare("UPDATE abono SET cantidad_comprada = cantidad_comprada + "+QString::number(total_a_acreditar)+", cantidad_clases = cantidad_clases + "+QString::number(total_a_acreditar)+", cantidad_restante = cantidad_restante + "+QString::number(total_a_acreditar)+" WHERE id = '"+QString::number(id)+"'");
    else
        query.prepare("UPDATE abono SET cantidad_restante = cantidad_restante + "+QString::number(total_a_acreditar)+" WHERE id = '"+QString::number(id)+"'");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        salida = id;
        emit sig_abonoMejorado();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

int ManagerAbono::darDeBajaAbono(int id) {
    int salida = 0;

    QSqlQuery query;
    query.prepare("UPDATE abono SET estado = 'Deshabilitado' WHERE id = '"+QString::number(id)+"'");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        salida = id;
        emit sig_abonoBorrado(id);
    }

    this->controlarMensajesDeError(query);

    return salida;
}

int ManagerAbono::comprarAbono(int id_cliente, int id_abono_adulto, float precio_abono, QString fecha_vigente, QString fecha_vencimiento, QString tipo, int cantidad_comprada, int cantidad_acreditada) {
    //cantidad_clases,cantidad_restante,cantidad_restante
    int salida;
    QSqlQuery query;
    query.prepare("INSERT INTO abono ("
    "id_cliente, id_abono_adulto, precio_abono, fecha_vigente, fecha_vencimiento, tipo, cantidad_clases, cantidad_restante, estado, cantidad_comprada, fecha_compra, blame_timestamp) "
    "VALUES (:id_cliente, :id_abono_adulto, :precio_abono, :fecha_vigente, :fecha_vencimiento, :tipo, :cantidad_clases, :cantidad_restante, :estado, :cantidad_comprada, :fecha_compra, :blame_timestamp)");

    query.bindValue(":id_cliente", id_cliente);
    query.bindValue(":id_abono_adulto", id_abono_adulto);
    query.bindValue(":precio_abono", precio_abono);
    query.bindValue(":fecha_vigente", QDate::fromString(fecha_vigente,"dd/MM/yyyy"));
    query.bindValue(":fecha_vencimiento", QDate::fromString(fecha_vencimiento,"dd/MM/yyyy"));
    query.bindValue(":tipo", tipo);
    query.bindValue(":cantidad_clases", cantidad_acreditada);
    query.bindValue(":cantidad_restante", cantidad_acreditada);

    query.bindValue(":fecha_compra", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
    query.bindValue(":blame_timestamp", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));

    query.bindValue(":estado", "Habilitado");
    query.bindValue(":cantidad_comprada", cantidad_comprada);

    if(!query.exec()) {
        qDebug() << query.lastError();
        salida = -1;
    }else {
        salida = query.lastInsertId().toInt();
    }
    this->controlarMensajesDeError(query);

    return salida;
}

bool ManagerAbono::obtenerAbonosPorClienteMasFecha(int id_cliente, bool estado, bool incluirAbonosCompradosEnElFuturo, bool incluirAbonosConCeroClases, QString fecha) {
    bool salida = true;
    /*El comando de abajo fue probado en SQLite3 y funciona bien.
    SELECT * FROM abono WHERE id_cliente = 2 AND '2015-07-23' BETWEEN fecha_vigente AND fecha_vencimiento
    El siguiente es mejor. Considera que un abono es válido para usar desde el día de la compra hasta un día antes de la fecha de vencimiento inclusive.
    SELECT * FROM abono WHERE id_cliente = 2 AND '2015-07-23' >= fecha_vigente AND '2015-07-23' < fecha_vencimiento*/

    QString strEstado = estado ? "Habilitado" : "Deshabilitado";
    QString strAbonosConCeroClases = incluirAbonosConCeroClases ? "0" : "1";

    QSqlQuery query;
    QString strQuery;
    if (incluirAbonosCompradosEnElFuturo)
        strQuery = "SELECT * FROM abono WHERE id_cliente = "+QString::number(id_cliente)+" AND estado = '"+strEstado+"' AND '"+fecha+"' < fecha_vencimiento AND cantidad_restante >= "+strAbonosConCeroClases+" ORDER BY fecha_vencimiento";
    else
        strQuery = "SELECT * FROM abono WHERE id_cliente = "+QString::number(id_cliente)+" AND estado = '"+strEstado+"' AND '"+fecha+"' >= fecha_vigente AND '"+fecha+"' < fecha_vencimiento AND cantidad_restante >= "+strAbonosConCeroClases+" ORDER BY fecha_vencimiento";
    query.prepare(strQuery);
    QList<QObject*> listaAbonosObj;
    listaAbonosObj.clear();

    if( !query.exec() ) {
        qDebug() << query.lastError();
        salida = false;
    }
    else
    {
        for( int r=0; query.next(); r++ ) {
            Abono * abono = new Abono();

           /*abono->setId(query.value(0).toInt());
            abono->setId_cliente(query.value(1).toInt());
            abono->setFecha_vigente(query.value(2).toDate());
            abono->setFecha_vencimiento(query.value(3).toDate());
            abono->setTipo(query.value(4).toString());
            abono->setCantidad_clases(query.value(5).toInt());
            abono->setCantidad_restante(query.value(6).toInt());
            abono->setEstado(query.value(7).toString());
            abono->setFecha_compra(query.value(8).toDateTime());
            abono->setBlame_timestamp(query.value(9).toDateTime());
            abono->setCantidad_comprada(query.value(10).toInt());*/

            abono->setId(query.value("id").toInt());
            abono->setId_cliente(query.value("id_cliente").toInt());
            abono->setId_abono_adulto(query.value("id_abono_adulto").toInt());
            abono->setPrecio_abono(query.value("precio_abono").toFloat());
            abono->setFecha_vigente(query.value("fecha_vigente").toDate());
            abono->setFecha_vencimiento(query.value("fecha_vencimiento").toDate());
            abono->setTipo(query.value("tipo").toString());
            abono->setCantidad_clases(query.value("cantidad_clases").toInt());
            abono->setCantidad_restante(query.value("cantidad_restante").toInt());
            abono->setEstado(query.value("estado").toString());
            abono->setFecha_compra(query.value("fecha_compra").toDateTime());
            abono->setBlame_timestamp(query.value("blame_timestamp").toDateTime());
            abono->setCantidad_comprada(query.value("cantidad_comprada").toInt());

            listaAbonosObj.append(abono);
        }
    }
    if (listaAbonosObj.count() > 0) {
        emit sig_abonosDeAlumno(listaAbonosObj);
    }
    else {
        emit sig_noHayAbonosDelAlumno();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

int ManagerAbono::registrarPresenteAlAbono(int id_abono, int id_cliente_asistencia, QString credencial_firmada) {
    int salida;

    QSqlQuery query;
    query.prepare("INSERT INTO abono_asistencia (id_abono, id_cliente_asistencia, credencial_firmada) VALUES (:id_abono, :id_cliente_asistencia, :credencial_firmada)");
    query.bindValue(":id_abono", id_abono);
    query.bindValue(":id_cliente_asistencia", id_cliente_asistencia);
    query.bindValue(":credencial_firmada", credencial_firmada);

    if(!query.exec()) {
        qDebug() << query.lastError();
        salida = 0;
    }
    else {
        salida = query.lastInsertId().toInt();
        if (credencial_firmada == "Si") {
            QSqlQuery query;
            query.prepare("UPDATE abono_asistencia SET credencial_firmada = 'Si' WHERE id_abono = '"+QString::number(id_abono)+"'");
            if(!query.exec()) {
                qDebug() << query.lastError();
                salida = 0;
            }
        }
    }


    this->controlarMensajesDeError(query);
    return salida;
}

void ManagerAbono::controlarMensajesDeError(QSqlQuery query) {
    if (query.lastQuery() == ""){
        emit sig_mensajeError(false, "Es probable que te hayas quedado sin internet. Por favor, verificalo.\nPor ejemplo, abrí el navegador web e intenta ingresar a 'yahoo.com'. Si la página web no carga, quiere decir que te quedaste sin internet.");
    }
    if (query.lastError().type() ==  QSqlError::NoError){
        //emit sig_mensajeError(false, "Ningún error ha ocurrido.");
    } else if (query.lastError().nativeErrorCode() == "2006"){
        emit sig_mensajeError(false,"Error de conexión con la base de datos. Si estaba registrando información, es altamente probable que la misma no se haya guardado.\nVuelva a intentarlo y si el problema continua, reinicie el programa.");
    } else if (query.lastError().nativeErrorCode() == "1054"){
        emit sig_mensajeError(false,"Error en la sintaxis SQL.");
    } else if  (query.lastError().type() ==  QSqlError::TransactionError){
        emit sig_mensajeError(false,"Error de transacción fallida.");
    } else if  (query.lastError().type() ==  QSqlError::UnknownError){
        emit sig_mensajeError(true,"Error desconocido.");
    }
}

int ManagerAbono::obtenerClasesSinFirmarDeAbono(int id_abono) {
    int salida = 0;

    QSqlQuery query;
    query.prepare("SELECT * FROM abono_asistencia INNER JOIN cliente_asistencia ON cliente_asistencia.id = abono_asistencia.id_cliente_asistencia WHERE id_abono = '"+QString::number(id_abono)+"' AND credencial_firmada = 'No' AND estado = 'Activa'");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next())
            salida++;
    }

    this->controlarMensajesDeError(query);
    return salida;
}

int ManagerAbono::descontarClaseAlAbono(int id_abono, int cantidad_clases) {
    int salida = 0;
    QSqlQuery query;

    if (cantidad_clases < 0) {
        salida = 1;
    }
    else {
        query.prepare("UPDATE abono SET cantidad_restante = '"+QString::number(cantidad_clases)+"' WHERE id = '"+QString::number(id_abono)+"'");

        if(!query.exec()) {
            qDebug() << "descontarClaseAlAbono:";
            qDebug() << query.lastError();
        }
        else {
            salida = 1;
        }
    }

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerAbono::traerTodosLasOfertasDeAbono() {
    bool salida = true;

    QSqlQuery query;
    query.prepare("SELECT * FROM abono_adulto ORDER BY total_clases");
    if(!query.exec())
        salida = false;
    else {
        listaAbonosEnOferta.clear();
        while (query.next()) {
            AbonoAdulto * abonoAdulto = new AbonoAdulto();
            abonoAdulto->setId(query.value("id").toInt());
            abonoAdulto->setPrecio_actual(query.value("precio_actual").toFloat());
            abonoAdulto->setTotal_clases(query.value("total_clases").toInt());
            abonoAdulto->setFecha_creacion(query.value("fecha_creacion").toDateTime());
            abonoAdulto->setEstado(query.value("estado").toString());

            listaAbonosEnOferta.append(abonoAdulto);
        }
        emit sig_listaAbonosAdultosEnOferta(listaAbonosEnOferta);
    }
    return salida;
}

int ManagerAbono::altaDeAbonoAdulto(float precio_actual, int total_clases){
    QSqlQuery query;
    query.prepare("INSERT INTO abono_adulto (precio_actual, total_clases, fecha_creacion) VALUES (:precio_actual, :total_clases, :fecha_creacion)");
    query.bindValue(":precio_actual", precio_actual);
    query.bindValue(":total_clases", total_clases);
    query.bindValue(":fecha_creacion", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    this->controlarMensajesDeError(query);
    return query.lastInsertId().toInt();
}

bool ManagerAbono::actualizarAbonoOfertado(int id_abono_adulto, float precio_actual, bool estado) {
    bool salida = true;

    QSqlQuery query;
    QString strEstado = "Habilitado";

    if (estado == false)
        strEstado = "Deshabilitado";

    QString strQuery = "UPDATE abono_adulto SET estado = '"+strEstado+"', precio_actual = "+QString::number(precio_actual)+", fecha_creacion=CURRENT_TIMESTAMP WHERE id = '"+QString::number(id_abono_adulto)+"'";
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

float ManagerAbono::obtenerPrecioDelAbonoQueOfreceMasClases(int clases_ofrecidas_abono_actual)
{
    bool operacion = true;
    float precio_abono = -1;
    QObject* abono = NULL;
    recordAbonoSuperior = NULL;
    totalClasesAbonoSuperior = -1;

    operacion = this->traerTodosLasOfertasDeAbono();

    if (operacion){
        int x=0;
        bool continuar = true;
        while (x<listaAbonosEnOferta.count() && continuar) {
            AbonoAdulto* abonoAdulto = dynamic_cast<AbonoAdulto*>(listaAbonosEnOferta.at(x));


            if (abonoAdulto->total_clases() == clases_ofrecidas_abono_actual){
                precio_abono = abonoAdulto->precio_actual();
                abono = abonoAdulto;
                //El precio del abono que tengo
            }
            else if ((abonoAdulto->total_clases() > clases_ofrecidas_abono_actual) && abonoAdulto->estado() == "Habilitado"){
                precio_abono = abonoAdulto->precio_actual();
                abono = abonoAdulto;
                totalClasesAbonoSuperior = abonoAdulto->total_clases();
                continuar = false;
                //El precio del abono que le seguiria.
            }
            x++;
        }
    }
    recordAbonoSuperior = abono;
    return precio_abono;
}

QObject* ManagerAbono::obtenerRecordAbonoSuperior() {
    return recordAbonoSuperior;
}

int ManagerAbono::obtenerTotalClasesAbonoSuperior()
{
    return totalClasesAbonoSuperior;
}

bool ManagerAbono::actualizarAbonoNormalComprado(int id_abono_comprado, int id_abono_ofertado, float precio_a_sumar, int cantidad_clases_a_sumar, int cantidad_clases_restantes)
{
    bool salida = true;

    QSqlQuery query;
    QString strQuery;

    strQuery = "UPDATE abono "
                "SET id_abono_adulto = "+QString::number(id_abono_ofertado)+", "
                "tipo = 'Normal', "
                "precio_abono = precio_abono + "+QString::number(precio_a_sumar)+", "
                "cantidad_comprada = cantidad_comprada + "+QString::number(cantidad_clases_a_sumar)+", "
                "cantidad_clases = cantidad_clases + "+QString::number(cantidad_clases_a_sumar)+", "
                "cantidad_restante = cantidad_restante + "+QString::number(cantidad_clases_restantes)+" "
                "WHERE id = '"+QString::number(id_abono_comprado)+"'";

    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerAbono::actualizarHaciaAbonoLibre(int id_abono_comprado, int id_abono_ofertado, float precio_a_sumar, int cantidad_clases_restantes)
{
    bool salida = true;

    QSqlQuery query;
    QString strQuery;

    strQuery = "UPDATE abono "
                "SET id_abono_adulto = "+QString::number(id_abono_ofertado)+", "
                "precio_abono = precio_abono + "+QString::number(precio_a_sumar)+", "
                "cantidad_comprada = 99, "
                "cantidad_clases = 99, "
                "cantidad_restante = "+QString::number(cantidad_clases_restantes)+", "
                "tipo = 'Libre' "
                "WHERE id = '"+QString::number(id_abono_comprado)+"'";

    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

QObject *ManagerAbono::obtenerCompraDeAbonoAdultoPorIdAsistenciaAdulto(int id_asistencia)
{
    Abono* abono = NULL;
    QSqlQuery query;

    query.prepare("SELECT abono.* FROM abono_asistencia asistencia "
                  "INNER JOIN abono ON abono.id = asistencia.id_abono "
                  "WHERE asistencia.id_cliente_asistencia = "+QString::number(id_asistencia));

    if (!query.exec()) {
        abono = NULL;
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }
    else {
        while (query.next()){
            abono = new Abono();
            abono->setId(query.value("id").toInt());
            abono->setId_cliente(query.value("id_cliente").toInt());
            abono->setId_abono_adulto(query.value("id_abono_adulto").toInt());
            abono->setPrecio_abono(query.value("precio_abono").toFloat());
            abono->setFecha_vigente(query.value("fecha_vigente").toDate());
            abono->setFecha_vencimiento(query.value("fecha_vencimiento").toDate());
            abono->setTipo(query.value("tipo").toString());
            abono->setCantidad_clases(query.value("cantidad_clases").toInt());
            abono->setCantidad_restante(query.value("cantidad_restante").toInt());
            abono->setEstado(query.value("estado").toString());
            abono->setFecha_compra(query.value("fecha_compra").toDateTime());
            abono->setBlame_timestamp(query.value("blame_timestamp").toDateTime());
            abono->setCantidad_comprada(query.value("cantidad_comprada").toInt());
        }
    }
    return abono;
}

