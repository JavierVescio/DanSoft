#include "managerdanza.h"

ManagerDanza::ManagerDanza()
{

}

bool ManagerDanza::obtenerTodasLasDanzas()
{
    bool salida = true;
    QSqlQuery query;
    query.prepare("SELECT * FROM danza WHERE estado = 'Habilitado' ORDER BY nombre");

    if(!query.exec())
        salida = false;
    else {
        QList<QObject*> listaDanzas;
        while (query.next()) {
            Danza * danza = new Danza();
            danza->setId(query.value("id").toInt());
            danza->setNombre(query.value("nombre").toString());
            danza->setEstado(query.value("estado").toString());
            danza->setBlame_timestamp(query.value("blame_timestamp").toDateTime());
            listaDanzas.append(danza);
        }
        emit sig_listaDanzas(listaDanzas);
    }
    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerDanza::obtenerTodasLasDanzasConFiltro(QString categoria) {
    bool salida = true;
    QSqlQuery query;

    /*
    QString strDate = fecha.toString("yyyy-MM-dd");
    query.prepare("SELECT * FROM resumen_mes WHERE strftime('%m',resumen_mes.fecha) = strftime('%m','"+strDate+"') AND strftime('%Y',resumen_mes.fecha) = strftime('%Y','"+strDate+"') AND id_cliente = "+QString::number(id_cliente));
*/
    int number_day_of_week = QDate::currentDate().dayOfWeek();

    if (categoria == "KidsAdults") {
        query.prepare("SELECT d.* FROM danza d "
                      "INNER JOIN danza_clase c "
                      "ON c.id_danza = d.id "
                      "WHERE d.estado = 'Habilitado' "
                      "AND c.estado = 'Habilitado' "
                      "AND (c.categoria = 'Kids' OR c.categoria = 'Adults' OR c.categoria = '"+categoria+"') "
                                                                                                         "AND (c.dias_semana = -1 OR c.dias_semana LIKE '%"+QString::number(number_day_of_week)+"%') "
                                                                                                                                                                                                "GROUP BY d.nombre "
                                                                                                                                                                                                "ORDER BY d.nombre");
    }else{
        query.prepare("SELECT d.* FROM danza d "
                      "INNER JOIN danza_clase c "
                      "ON c.id_danza = d.id "
                      "WHERE d.estado = 'Habilitado' "
                      "AND c.estado = 'Habilitado' "
                      "AND (c.categoria = 'KidsAdults' OR c.categoria = '"+categoria+"') "
                                                                                     "AND (c.dias_semana = -1 OR c.dias_semana LIKE '%"+QString::number(number_day_of_week)+"%') "
                                                                                                                                                                            "GROUP BY d.nombre "
                                                                                                                                                                            "ORDER BY d.nombre");
    }




    if(!query.exec())
        salida = false;
    else {
        QList<QObject*> listaDanzas;
        while (query.next()) {
            Danza * danza = new Danza();
            danza->setId(query.value("id").toInt());
            danza->setNombre(query.value("nombre").toString());
            danza->setEstado(query.value("estado").toString());
            danza->setBlame_timestamp(query.value("blame_timestamp").toDateTime());
            listaDanzas.append(danza);
        }
        emit sig_listaDanzas(listaDanzas);
    }

    this->controlarMensajesDeError(query);
    return salida;
}


bool ManagerDanza::agregarDanza(QString nombre)
{
    bool salida = true;
    QSqlQuery query;
    query.prepare("INSERT INTO danza (nombre, estado, blame_timestamp) VALUES (:nombre, :estado, :blame_timestamp)");
    query.bindValue(":nombre", nombre);
    query.bindValue(":estado", "Habilitado");
    query.bindValue(":blame_timestamp", QDateTime::currentDateTime());

    if(!query.exec())
        salida = false;

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerDanza::cambiarNombreDanza(int id_danza, QString nombre)
{
    bool salida = true;

    QString strQuery;
    QSqlQuery query;
    strQuery = "UPDATE danza SET nombre = '"+nombre+"' WHERE id = '"+QString::number(id_danza)+"'";
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerDanza::eliminarDanza(int id_danza)
{
    bool salida = true;
    QSqlQuery query;
    query.prepare("UPDATE danza SET estado = 'Deshabilitado' WHERE id = '"+QString::number(id_danza)+"'");

    if(!query.exec())
        salida = false;

    this->controlarMensajesDeError(query);
    return salida;
}


void ManagerDanza::controlarMensajesDeError(QSqlQuery query) {
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

