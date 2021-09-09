#include "manageroferta.h"

ManagerOferta::ManagerOferta()
{

}

bool ManagerOferta::agregarOferta(
        QString nombre,
        QString descripcion,
        QString tipo,
        float precio,
        int stock,
        bool uno_por_alumno,
        QString str_vigente_desde,
        QString str_vigente_hasta)
{
    bool salida = true;
    QSqlQuery query;

    query.prepare("INSERT INTO oferta "
                  "(nombre, descripcion, tipo, precio, stock, uno_por_alumno, fecha_creacion, fecha_vigente_desde, fecha_vigente_hasta) "
                  "VALUES "
                  "(:nombre, :descripcion, :tipo, :precio, :stock, :uno_por_alumno, :fecha_creacion, :fecha_vigente_desde, :fecha_vigente_hasta)");

    query.bindValue(":nombre", nombre);
    query.bindValue(":descripcion", descripcion);
    query.bindValue(":tipo", tipo);
    query.bindValue(":precio", precio);
    query.bindValue(":stock", stock);
    query.bindValue(":uno_por_alumno", uno_por_alumno);
    query.bindValue(":fecha_creacion", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));

    QDate fecha_vigente_desde = QDate::fromString(str_vigente_desde, "dd/MM/yyyy");
    if (fecha_vigente_desde.year() == 1900)
        query.bindValue(":fecha_vigente_desde", NULL);
    else
        query.bindValue(":fecha_vigente_desde", fecha_vigente_desde.toString("yyyy-MM-dd"));

    QDate fecha_vigente_hasta = QDate::fromString(str_vigente_hasta, "dd/MM/yyyy");
    if (fecha_vigente_hasta.year() == 1900)
        query.bindValue(":fecha_vigente_hasta", NULL);
    else
        query.bindValue(":fecha_vigente_hasta", fecha_vigente_hasta.toString("yyyy-MM-dd"));

    if (fecha_vigente_desde.daysTo(fecha_vigente_hasta) < 0)
        return false;

    if(!query.exec())
        salida = false;

    return salida;
}

bool ManagerOferta::actualizarOferta(
        int id,
        QString nombre,
        QString descripcion,
        QString tipo,
        float precio,
        int stock,
        bool uno_por_alumno,
        QString str_vigente_desde,
        QString str_vigente_hasta)
{
    bool salida = true;
    QSqlQuery query;

    query.prepare("UPDATE oferta "
                  "SET nombre = :nombre, "
                  "descripcion = :descripcion, "
                  "tipo = :tipo, "
                  "precio = :precio, "
                  "stock = :stock, "
                  "uno_por_alumno = :uno_por_alumno, "
                  "fecha_vigente_desde = :fecha_vigente_desde, "
                  "fecha_vigente_hasta = :fecha_vigente_hasta "
                  "WHERE id = :id");

    query.bindValue(":nombre", nombre);
    query.bindValue(":descripcion", descripcion);
    query.bindValue(":tipo", tipo);
    query.bindValue(":precio", precio);
    query.bindValue(":stock", stock);
    query.bindValue(":uno_por_alumno", uno_por_alumno);

    QDate fecha_vigente_desde = QDate::fromString(str_vigente_desde,"dd/MM/yyyy");
    if (fecha_vigente_desde.year() == 1900)
        query.bindValue(":fecha_vigente_desde", NULL);
    else
        query.bindValue(":fecha_vigente_desde", fecha_vigente_desde.toString("yyyy-MM-dd"));

    QDate fecha_vigente_hasta = QDate::fromString(str_vigente_hasta,"dd/MM/yyyy");
    if (fecha_vigente_hasta.year() == 1900)
        query.bindValue(":fecha_vigente_hasta", NULL);
    else
        query.bindValue(":fecha_vigente_hasta", fecha_vigente_hasta.toString("yyyy-MM-dd"));

    query.bindValue(":id", id);

    if (fecha_vigente_desde.daysTo(fecha_vigente_hasta) < 0)
        return false;

    if(!query.exec())
        salida = false;

    return salida;
}

bool ManagerOferta::bajarOferta(
        int id)
{
    bool salida = true;
    QSqlQuery query;

    query.prepare("UPDATE oferta "
                  "SET estado = 'Deshabilitado' "
                  "WHERE id = :id");
    query.bindValue(":id", id);
    if(!query.exec())
        salida = false;

    return salida;
}

QList<QObject *> ManagerOferta::traerOfertas(
        QString nombre,
        QString tipo,
        bool vigente,
        bool soloConStock)
{
    QList<QObject *> lista;
    QSqlQuery query;

    if (vigente){
        query.prepare("SELECT * "
                      "FROM oferta "
                      "WHERE nombre LIKE '%'||:nombre||'%' "
                      "AND tipo = :tipo "
                      "AND estado = 'Habilitado' "
                      "AND ((fecha_vigente_desde <= :fecha_actual AND :fecha_actual <= fecha_vigente_hasta) "
                      "OR (fecha_vigente_desde IS NULL "
                      "OR fecha_vigente_hasta IS NULL)) "
                      "ORDER BY nombre");
        query.bindValue(":nombre", nombre);
        query.bindValue(":tipo", tipo);
        query.bindValue(":fecha_actual", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));
    }else{
        query.prepare("SELECT * "
                      "FROM oferta "
                      "WHERE nombre LIKE '%'||:nombre||'%' "
                      "AND estado = 'Habilitado' "
                      "AND tipo = :tipo "
                      "AND (fecha_vigente_hasta < :fecha_actual OR :fecha_actual < fecha_vigente_desde) "
                      "ORDER BY nombre");
        query.bindValue(":nombre", nombre);
        query.bindValue(":tipo", tipo);
        query.bindValue(":fecha_actual", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));
    }


    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            if (soloConStock) {
                if (query.value("stock").toInt() > 0){
                    Oferta *oferta = new Oferta();
                    oferta->setId(query.value("id").toInt());
                    oferta->setNombre(query.value("nombre").toString());
                    oferta->setDescripcion(query.value("descripcion").toString());
                    oferta->setTipo(query.value("tipo").toString());
                    oferta->setPrecio(query.value("precio").toFloat());
                    oferta->setStock(query.value("stock").toInt());
                    oferta->setUno_por_alumno(query.value("uno_por_alumno").toBool());
                    oferta->setFecha_creacion(query.value("fecha_creacion").toDateTime());
                    oferta->setFecha_vigente_desde(query.value("fecha_vigente_desde").toDateTime());
                    oferta->setFecha_vigente_hasta(query.value("fecha_vigente_hasta").toDateTime());
                    lista.append(oferta);
                }
            }else{
                Oferta *oferta = new Oferta();
                oferta->setId(query.value("id").toInt());
                oferta->setNombre(query.value("nombre").toString());
                oferta->setDescripcion(query.value("descripcion").toString());
                oferta->setTipo(query.value("tipo").toString());
                oferta->setPrecio(query.value("precio").toFloat());
                oferta->setStock(query.value("stock").toInt());
                oferta->setUno_por_alumno(query.value("uno_por_alumno").toBool());
                oferta->setFecha_creacion(query.value("fecha_creacion").toDateTime());
                oferta->setFecha_vigente_desde(query.value("fecha_vigente_desde").toDateTime());
                oferta->setFecha_vigente_hasta(query.value("fecha_vigente_hasta").toDateTime());
                lista.append(oferta);
            }

        }
    }
    return lista;
}

int ManagerOferta::realizarCompra(
        int id_cliente,
        float precio_total)
{
    QSqlQuery query;


    QString comentario = this->obtenerResumenDelCarritoDeCompras();

    query.prepare("INSERT INTO venta "
                  "(id_cliente,fecha,precio_total,comentario) "
                  "VALUES "
                  "(:id_cliente,:fecha,:precio_total,:comentario)");

    query.bindValue(":id_cliente", id_cliente);
    query.bindValue(":fecha", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
    query.bindValue(":precio_total", precio_total);
    query.bindValue(":comentario", comentario);


    if(!query.exec()){
        return -1;
    }

    int id_venta = query.lastInsertId().toInt();


    int id_oferta;
    int cantidad;
    float precio_subtotal;

    int x=0;
    while(x<arrayCarrito.count()){
        QJsonObject itemCarrito = arrayCarrito.at(x).toObject();
        id_oferta = itemCarrito.value("idOferta").toInt();
        cantidad = itemCarrito.value("cantidad_comprada").toInt();
        precio_subtotal = cantidad * itemCarrito.value("precio_unidad").toDouble();

        query.prepare("INSERT INTO item_venta "
                      "(id_oferta,id_venta,cantidad,precio_subtotal) "
                      "VALUES "
                      "(:id_oferta,:id_venta,:cantidad,:precio_subtotal)");

        query.bindValue(":id_oferta", id_oferta);
        query.bindValue(":id_venta", id_venta);
        query.bindValue(":cantidad", cantidad);
        query.bindValue(":precio_subtotal", precio_subtotal);

        if(!query.exec()){
            return -1;
        }


        query.prepare("UPDATE oferta "
                      "SET stock = stock - :stock "
                      "WHERE id = :id");

        query.bindValue(":stock", cantidad);
        query.bindValue(":id", id_oferta);

        if(!query.exec()){
            return -1;
        }

        x++;
    }
    return id_venta;
}

bool ManagerOferta::agregarAlCarritoDeCompras(
        int idOferta,
        QString nombre,
        int cantidad,
        float precio)
{
    if (cantidad < 1)
        return false;
    if (itemYaAgregadoAlCarrito(idOferta))
        return false;

    QJsonObject objItemCarrito;
    objItemCarrito.insert("idOferta",idOferta);
    objItemCarrito.insert("nombre",nombre);
    objItemCarrito.insert("cantidad_comprada",cantidad);
    objItemCarrito.insert("precio_unidad",precio);

    arrayCarrito.append(objItemCarrito);
    return true;
}

bool ManagerOferta::quitarItemCarritoDeCompras(
        int idOferta)
{
    bool itemYaRemovido = false;
    int x=0;
    while (x<arrayCarrito.count() && !itemYaRemovido){
        if (arrayCarrito.at(x).toObject().value("idOferta").toInt() == idOferta){
            arrayCarrito.removeAt(x);
            itemYaRemovido = true;
        }
        x++;
    }
    return itemYaRemovido;
}

bool ManagerOferta::actualizarCarritoDeCompras(
        int idOferta,
        int cantidad)
{
    qDebug() << "ManagerOferta::actualizarCarritoDeCompras";
    bool itemYaActualizado = false;
    int x=0;
    while (x<arrayCarrito.count() && !itemYaActualizado){
        if (arrayCarrito.at(x).toObject().value("idOferta").toInt() == idOferta){
            QJsonObject item = arrayCarrito.at(x).toObject();
            item.insert("cantidad_comprada",cantidad);
            arrayCarrito.replace(x,item);
            itemYaActualizado = true;
        }
        x++;
    }
    return itemYaActualizado;
}

void ManagerOferta::vaciarCarritoDeCompras()
{
    while(arrayCarrito.isEmpty() == false)
        arrayCarrito.removeFirst();
}

QString ManagerOferta::obtenerBreveResumenDelCarritoDeCompras()
{
    int id_oferta,cantidad,x=0;
    float precio_unidad;
    QString nombre;
    QString salida = "Compra tienda | ";

    while(x<arrayCarrito.count()){
        QJsonObject itemCarrito = arrayCarrito.at(x).toObject();

        id_oferta = itemCarrito.value("idOferta").toInt();
        nombre = itemCarrito.value("nombre").toString().left(5);
        cantidad = itemCarrito.value("cantidad_comprada").toInt();
        precio_unidad = itemCarrito.value("precio_unidad").toDouble();

        salida += QString::number(cantidad)+"x"+nombre+"($"+QString::number(precio_unidad)+")";

        if (x<arrayCarrito.count()-1){
            salida += "+";
        }

        x++;
    }

    return salida;
}

QString ManagerOferta::obtenerResumenDelCarritoDeCompras()
{
    int id_oferta,cantidad,x=0;
    float precio_unidad,precio_subtotal,precio_total=0;
    QString nombre;
    QString salida = "<table style='width:100%'>";
    salida += "<tr>";
    salida += "<th>ID</th>";
    salida += "<th>Cantidad</th>";
    salida += "<th>Nombre</th>";
    salida += "<th>Precio Unit.</th>";
    salida += "<th>Importe</th>";
    salida += "</tr>";
    while(x<arrayCarrito.count()){
        salida += "<tr>";
        QJsonObject itemCarrito = arrayCarrito.at(x).toObject();

        id_oferta = itemCarrito.value("idOferta").toInt();
        nombre = itemCarrito.value("nombre").toString();
        cantidad = itemCarrito.value("cantidad_comprada").toInt();
        precio_unidad = itemCarrito.value("precio_unidad").toDouble();
        precio_subtotal = cantidad * precio_unidad;
        precio_total += precio_subtotal;

        salida += "<td>"+QString::number(id_oferta)+"</td>";
        salida += "<td>"+QString::number(cantidad)+"</td>";
        salida += "<td>"+nombre+"</td>";
        salida += "<td>$ "+QString::number(precio_unidad)+"</td>";
        salida += "<td>$ "+QString::number(precio_subtotal)+"</td>";

        salida += "</tr>";
        x++;
    }
    salida += "</table><br><br>";
    salida += "<span><b>Total: $ </b>"+QString::number(precio_total)+"</span>";

    return salida;
}

void ManagerOferta::mostrarVenta(int id)
{
    QSqlQuery query;

    query.prepare("SELECT comentario "
                  "FROM venta "
                  "WHERE id = :id");
    query.bindValue(":id", id);
    if(query.exec()){
        while(query.next()){
            emit sig_comentarioVenta(id,query.value("comentario").toString());
        }
    }
}

bool ManagerOferta::itemYaAgregadoAlCarrito(
        int idOferta)
{
    bool itemYaAgregado = false;
    int x=0;
    while (x<arrayCarrito.count() && !itemYaAgregado){
        if (arrayCarrito.at(x).toObject().value("idOferta").toInt() == idOferta)
            itemYaAgregado = true;
        x++;
    }
    return itemYaAgregado;
}
