#include "managerclase.h"

ManagerClase::ManagerClase()
{

}

bool ManagerClase::obtenerTodasLasClasesPorIdDanza(int id_danza)
{
    bool salida = true;
    QSqlQuery query;
    query.prepare("SELECT * FROM danza_clase WHERE estado = 'Habilitado' AND id_danza = '"+QString::number(id_danza)+"' ORDER BY nombre");

    if(!query.exec())
        salida = false;
    else {
        QList<QObject*> listaClases;
        while (query.next()) {
            Clase * clase = new Clase();
            clase->setId(query.value("id").toInt());
            clase->setId_danza(query.value("id_danza").toInt());
            clase->setNombre(query.value("nombre").toString());
            clase->setEstado(query.value("estado").toString());
            clase->setBlame_timestamp(query.value("blame_timestamp").toDateTime());
            clase->setCategoria(query.value("categoria").toString());
            clase->setDias_semana(query.value("dias_semana").toString());
            listaClases.append(clase);
        }
        emit sig_listaClases(listaClases);
    }

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerClase::obtenerTodasLasClasesPorIdDanzaConFiltro(int id_danza, QString categoria) {
    bool salida = true;
    QSqlQuery query;

    int number_day_of_week = QDate::currentDate().dayOfWeek();

    if (categoria == "KidsAdults") {
        query.prepare("SELECT c.* "
                      "FROM danza_clase c "
                      "WHERE c.estado = 'Habilitado' "
                      "AND c.id_danza = '"+QString::number(id_danza)+"' "
                      "AND (c.categoria = 'Kids' OR c.categoria = 'Adults' OR c.categoria = '"+categoria+"') "
                      "AND (c.dias_semana = -1 OR c.dias_semana LIKE '%"+QString::number(number_day_of_week)+"%') "
                      "ORDER BY c.nombre");
    }else {
        query.prepare("SELECT c.* "
                      "FROM danza_clase c "
                      "WHERE c.estado = 'Habilitado' "
                      "AND c.id_danza = '"+QString::number(id_danza)+"' "
                      "AND (c.categoria = 'KidsAdults' OR c.categoria = '"+categoria+"') "
                      "AND (c.dias_semana = -1 OR c.dias_semana LIKE '%"+QString::number(number_day_of_week)+"%') "
                      "ORDER BY c.nombre");
    }



    if(!query.exec())
        salida = false;
    else {
        QList<QObject*> listaClases;
        while (query.next()) {
            Clase * clase = new Clase();
            clase->setId(query.value("id").toInt());
            clase->setId_danza(query.value("id_danza").toInt());
            clase->setNombre(query.value("nombre").toString());
            clase->setEstado(query.value("estado").toString());
            clase->setBlame_timestamp(query.value("blame_timestamp").toDateTime());
            clase->setCategoria(query.value("categoria").toString());
            clase->setDias_semana(query.value("dias_semana").toString());
            listaClases.append(clase);
        }
        emit sig_listaClases(listaClases);
    }

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerClase::agregarClase(int id_danza, QString nombre)
{
    bool salida = true;
    QSqlQuery query;
    query.prepare("INSERT INTO danza_clase (id_danza, nombre, estado, blame_timestamp, categoria) VALUES (:id_danza, :nombre, :estado, :blame_timestamp, :categoria)");
    query.bindValue(":id_danza", id_danza);
    query.bindValue(":nombre", nombre);
    query.bindValue(":categoria", "KidsAdults");
    query.bindValue(":estado", "Habilitado");
    query.bindValue(":blame_timestamp", QDateTime::currentDateTime());

    if(!query.exec())
        salida = false;

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerClase::cambiarNombreClase(int id_clase, QString nombre)
{
    bool salida = true;

    QString strQuery;
    QSqlQuery query;
    strQuery = "UPDATE danza_clase SET nombre = '"+nombre+"' WHERE id = '"+QString::number(id_clase)+"'";
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerClase::actualizarCategoriaClase(int id_clase, int id_categoria)
{
    bool salida = true;

    QString strQuery;
    QSqlQuery query;

    QString categoria = "Kids";

    if (id_clase < 1) {
        qDebug() << "id clase incorrecto";
    }

    qDebug() << ".. id_categoria: " << id_categoria;


    if (id_categoria == 2){
        categoria = "Adults";
    }
    else if (id_categoria == 3){
        categoria = "KidsAdults";
    }


    strQuery = "UPDATE danza_clase SET categoria = '"+categoria+"' WHERE id = '"+QString::number(id_clase)+"'";
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerClase::actualizarDiasClase(int id_clase, QString dias)
{
    bool salida = true;

    QString strQuery;
    QSqlQuery query;

    qDebug() << "manager::dias: " << dias;

    strQuery = "UPDATE danza_clase SET dias_semana = '"+dias+"' WHERE id = '"+QString::number(id_clase)+"'";
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerClase::eliminarClase(int id_clase)
{
    bool salida = true;
    QSqlQuery query;
    query.prepare("UPDATE danza_clase SET estado = 'Deshabilitado' WHERE id = '"+QString::number(id_clase)+"'");

    if(!query.exec())
        salida = false;

    this->controlarMensajesDeError(query);
    return salida;
}

void ManagerClase::controlarMensajesDeError(QSqlQuery query) {
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
