#include "managerabonoinfantil.h"
#include "../wrapperclassmanagement.h"

ManagerAbonoInfantil::ManagerAbonoInfantil()
{
    idAbonoSuperior = -1;
    totalClasesAbonoSuperior = -1;
    precioMatricula = NULL;
}

int ManagerAbonoInfantil::altaDeAbonoInfantil(float precio_actual, int clases_por_semana){
    QSqlQuery query;
    query.prepare("INSERT INTO abono_infantil (precio_actual, clases_por_semana, fecha_creacion) VALUES (:precio_actual, :clases_por_semana, :fecha_creacion)");
    query.bindValue(":precio_actual", precio_actual);
    query.bindValue(":clases_por_semana", clases_por_semana);
    query.bindValue(":fecha_creacion", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    this->controlarMensajesDeError(query);
    return query.lastInsertId().toInt();
}

bool ManagerAbonoInfantil::traerTodosLasOfertasDeAbono() {
    bool salida = true;

    QSqlQuery query;
    query.prepare("SELECT * FROM abono_infantil ORDER BY clases_por_semana");
    if(!query.exec())
        salida = false;
    else {
        listaAbonosEnOferta.clear();
        while (query.next()) {
            AbonoInfantil * abonoInfantil = new AbonoInfantil();
            abonoInfantil->setId(query.value("id").toInt());
            abonoInfantil->setPrecio_actual(query.value("precio_actual").toFloat());
            abonoInfantil->setClases_por_semana(query.value("clases_por_semana").toInt());
            abonoInfantil->setFecha_creacion(query.value("fecha_creacion").toDateTime());
            abonoInfantil->setEstado(query.value("estado").toString());

            listaAbonosEnOferta.append(abonoInfantil);
        }
        emit sig_listaAbonosEnOferta(listaAbonosEnOferta);
    }
    return salida;
}

AbonoInfantil *ManagerAbonoInfantil::traerOfertaDeAbonoMinimaDisponible()
{
    AbonoInfantil* ofertaAbonoMinimaDisponible = NULL;

    QSqlQuery query;
    query.prepare("SELECT * FROM abono_infantil WHERE estado = 'Habilitado' ORDER BY clases_por_semana LIMIT 1");
    if (!query.exec())
        qDebug() << query.lastError();
    else{
        while(query.next()){
            ofertaAbonoMinimaDisponible = new AbonoInfantil();
            ofertaAbonoMinimaDisponible->setId(query.value("id").toInt());
            ofertaAbonoMinimaDisponible->setPrecio_actual(query.value("precio_actual").toFloat());
            ofertaAbonoMinimaDisponible->setClases_por_semana(query.value("clases_por_semana").toInt());
            ofertaAbonoMinimaDisponible->setFecha_creacion(query.value("fecha_creacion").toDateTime());
            ofertaAbonoMinimaDisponible->setEstado(query.value("estado").toString());
        }
    }

    return ofertaAbonoMinimaDisponible;
}

///
/// \brief ManagerAbonoInfantil::traerUltimaOfertaDeAbonoComprada
/// \param id_cliente
/// \return trae la ultima oferta comprada por el alumno. Si no hubiera, trae la oferta minima de abono.
///

AbonoInfantil *ManagerAbonoInfantil::traerUltimaOfertaDeAbonoComprada(int id_cliente)
{
    AbonoInfantil* ultimaOfertaAbonoComprada = NULL;

    QSqlQuery query;
    query.prepare("SELECT abono_infantil.* FROM abono_infantil_compra c INNER JOIN abono_infantil ON c.id_abono_infantil = abono_infantil.id WHERE c.id_cliente = "+QString::number(id_cliente)+" AND c.estado = 'Habilitado' ORDER BY c.fecha_compra DESC LIMIT 1");
    if (!query.exec())
        qDebug() << query.lastError();
    else{
        while(query.next()){
            ultimaOfertaAbonoComprada = new AbonoInfantil();
            ultimaOfertaAbonoComprada->setId(query.value("id").toInt());
            ultimaOfertaAbonoComprada->setPrecio_actual(query.value("precio_actual").toFloat());
            ultimaOfertaAbonoComprada->setClases_por_semana(query.value("clases_por_semana").toInt());
            ultimaOfertaAbonoComprada->setFecha_creacion(query.value("fecha_creacion").toDateTime());
            ultimaOfertaAbonoComprada->setEstado(query.value("estado").toString());
        }
    }

    return ultimaOfertaAbonoComprada;
}

QObject* ManagerAbonoInfantil::comprarAbonoAutomaticamente(int id_cliente, bool alumno_matriculado)
{
    AbonoInfantilCompra* registroCompraAbono = NULL;

    if (alumno_matriculado == false)
        matricularAlumno(id_cliente);

    AbonoInfantil* ultimaOfertaAbonoComprada = traerUltimaOfertaDeAbonoComprada(id_cliente);
    if (ultimaOfertaAbonoComprada == NULL)
        ultimaOfertaAbonoComprada = traerOfertaDeAbonoMinimaDisponible();

    if (ultimaOfertaAbonoComprada == NULL)
        return registroCompraAbono;
    else {
        int idRegistroCompra = comprarAbonoInfantil(id_cliente,ultimaOfertaAbonoComprada->id(),ultimaOfertaAbonoComprada->precio_actual());
        registroCompraAbono = new AbonoInfantilCompra();
        registroCompraAbono->setId(idRegistroCompra);
        registroCompraAbono->setPrecio_abono(ultimaOfertaAbonoComprada->precio_actual());
        registroCompraAbono->setClases_por_semana(ultimaOfertaAbonoComprada->clases_por_semana());
        return registroCompraAbono;
    }
}

int ManagerAbonoInfantil::comprarAbonoInfantil(int id_cliente, int id_abono_infantil, float precio_abono, QString estado, QDateTime fecha_compra){
    int salida;
    QSqlQuery query;
    query.prepare("INSERT INTO abono_infantil_compra (id_cliente, id_abono_infantil, fecha_compra, precio_abono, estado, fecha_compra) VALUES (:id_cliente, :id_abono_infantil, :fecha_compra, :precio_abono, :estado, :fecha_compra)");
    query.bindValue(":id_cliente", id_cliente);
    query.bindValue(":id_abono_infantil", id_abono_infantil);
    query.bindValue(":fecha_compra", fecha_compra.toString("yyyy-MM-dd HH:mm:ss"));
    query.bindValue(":precio_abono", precio_abono);
    query.bindValue(":estado", estado);

    if(!query.exec()) {
        qDebug() << query.lastError();
        salida = -1;
    }
    else{
        salida = query.lastInsertId().toInt();
    }
    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerAbonoInfantil::actualizarAbonoComprado(int id_abono_comprado, int id_abono_ofertado, float precio_a_sumar)
{
    bool salida = true;

    QSqlQuery query;

    QString strQuery = "UPDATE abono_infantil_compra SET id_abono_infantil = "+QString::number(id_abono_ofertado)+", precio_abono = precio_abono + "+QString::number(precio_a_sumar)+" WHERE id = '"+QString::number(id_abono_comprado)+"'";
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

QObject* ManagerAbonoInfantil::traerCompraDeAbonoInfantil(int id_cliente, QDate fecha) {
    /*
    QString strDate = fecha.toString("yyyy-MM-dd");
    query.prepare("SELECT * FROM resumen_mes WHERE strftime('%m',resumen_mes.fecha) = strftime('%m','"+strDate+"') AND strftime('%Y',resumen_mes.fecha) = strftime('%Y','"+strDate+"') AND id_cliente = "+QString::number(id_cliente));
*/
    AbonoInfantilCompra* abonoCompra = NULL;

    QSqlQuery query;
    QString strDate = fecha.toString("yyyy-MM-dd");
    query.prepare("SELECT c.*, a.clases_por_semana AS total_clases FROM abono_infantil_compra c INNER JOIN abono_infantil a ON c.id_abono_infantil = a.id WHERE c.estado = 'Habilitado' AND strftime('%m',c.fecha_compra) = strftime('%m','"+strDate+"') AND strftime('%Y',c.fecha_compra) = strftime('%Y','"+strDate+"') AND id_cliente = "+QString::number(id_cliente));
    if(!query.exec())
        qDebug() << query.lastError();
    else {
        while (query.next()) {
            abonoCompra = new AbonoInfantilCompra();
            abonoCompra->setId(query.value("id").toInt());
            abonoCompra->setId_cliente(query.value("id_cliente").toInt());
            abonoCompra->setPrecio_abono(query.value("precio_abono").toFloat());
            abonoCompra->setClases_por_semana(query.value("total_clases").toInt());
            abonoCompra->setFecha_compra(query.value("fecha_compra").toDateTime());
            abonoCompra->setEstado(query.value("estado").toString());
        }
    }
    return abonoCompra;
}


QList<QObject *> ManagerAbonoInfantil::traerAlumnosQueCompraronAbonoInfantilConDiasDePresentesMasMovimientos(int mes, int anio, int id_clase)
{
    QList<QObject*> superLista;
    QList<QObject*> listaDelAlumnoPresentesMovimientos;
    QList<QObject*> listAlumnosConAbonoInfantil = this->traerAlumnosQueCompraronAbonoInfantil(mes,anio);
    if (!listAlumnosConAbonoInfantil.isEmpty()){
        QDate fecha_inicial(anio,mes,1);
        QDate fecha_final(anio,mes,fecha_inicial.daysInMonth());

        for(int x=0;x<listAlumnosConAbonoInfantil.count();x++){
            CMAlumno* alumno = dynamic_cast<CMAlumno*>(listAlumnosConAbonoInfantil.at(x));
            ClienteAsistenciasMovimientos* clienteAsistenciasMovimientos = new ClienteAsistenciasMovimientos();
            ListasConInformacion* listasConInformacion = new ListasConInformacion();

            QList<QObject*> listaAsistenciasDelAlumno = WrapperClassManagement::getManagerAsistencias()->obtenerAsistenciasDelAlumnoEntreFechasPorClase(id_clase,alumno->getId(),fecha_inicial,fecha_final,true);
            QList<QObject*> listaMovimientosDelAlumno = WrapperClassManagement::getManagerCuentaAlumno()->traerTodosLosMovimientosPorCuenta(alumno->id_cuenta_alumno(),fecha_inicial,fecha_final,true);

            listasConInformacion->setListaAsistencias(listaAsistenciasDelAlumno);
            listasConInformacion->setListaMovimientos(listaMovimientosDelAlumno);

            clienteAsistenciasMovimientos->setAlumno(dynamic_cast<CMAlumno*>(listAlumnosConAbonoInfantil.at(x)));
            clienteAsistenciasMovimientos->setListasConInformacion(listasConInformacion);

            superLista.append(clienteAsistenciasMovimientos);
        }
    }

    return superLista;
}

QList<QObject*> ManagerAbonoInfantil::traerAlumnosInscriptosPorClase(int id_clase){
    QList<QObject*> listAlumnosInscriptos;

    QSqlQuery query;
    QString strQuery;



    strQuery = "SELECT "
               "cuenta.id AS id_cuenta, "
               "cuenta.credito_actual AS credito, "
               "cliente.* "
               "FROM inscripcion_cliente_clase inscripcion "
               "INNER JOIN cliente ON cliente.id = inscripcion.id_cliente "
               "INNER JOIN cuenta_cliente cuenta ON cuenta.id_cliente = cliente.id "
               "WHERE cliente.estado = 'Habilitado' AND inscripcion.id_danza_clase = "+QString::number(id_clase)+" ORDER BY cliente.apellido";

    query.prepare(strQuery);


    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else
    {
        for( int r=0; query.next(); r++ ) {
            CMAlumno * objAlumnoResult = new CMAlumno();
            objAlumnoResult->setId(query.value("id").toInt());
            objAlumnoResult->setApellido(query.value("apellido").toString());
            objAlumnoResult->setPrimerNombre(query.value("primer_nombre").toString());
            objAlumnoResult->setSegundoNombre(query.value("segundo_nombre").toString());
            objAlumnoResult->setGenero(query.value("genero").toString());
            objAlumnoResult->setNacimiento(query.value("fecha_nacimiento").toDate());
            objAlumnoResult->setDni(query.value("dni").toString());
            objAlumnoResult->setTelefonoFijo(query.value("telefono_fijo").toString());
            objAlumnoResult->setTelefonoCelular(query.value("telefono_celular").toString());
            objAlumnoResult->setCorreo(query.value("correo").toString());
            objAlumnoResult->setNota(query.value("nota").toString());
            objAlumnoResult->setEstado(query.value("estado").toString());
            objAlumnoResult->setBlameUser(query.value("blame_user").toString());
            objAlumnoResult->setBlameTimeStamp(query.value("blame_timestamp").toDateTime());
            objAlumnoResult->setFechaAlta(query.value("fecha_alta").toDateTime());
            objAlumnoResult->setFecha_matriculacion_infantil(query.value("fecha_matriculacion_infantil").toDateTime());
            objAlumnoResult->setId_cuenta_alumno(query.value("id_cuenta").toInt());
            objAlumnoResult->setCredito_cuenta(query.value("credito").toFloat());

            listAlumnosInscriptos.append(objAlumnoResult);

        }
    }


    return listAlumnosInscriptos;
}

QList<QObject *> ManagerAbonoInfantil::traerAlumnosInscriptosConDiasDePresentesMasMovimientos(int mes, int anio, int id_clase)
{
    QList<QObject*> superLista;
    QList<QObject*> listaDelAlumnoPresentesMovimientos;
    QList<QObject*> listAlumnosInscriptos = this->traerAlumnosInscriptosPorClase(id_clase);
    if (!listAlumnosInscriptos.isEmpty()){
        QDate fecha_inicial(anio,mes,1);
        QDate fecha_final(anio,mes,fecha_inicial.daysInMonth());

        for(int x=0;x<listAlumnosInscriptos.count();x++){
            CMAlumno* alumno = dynamic_cast<CMAlumno*>(listAlumnosInscriptos.at(x));
            ClienteAsistenciasMovimientos* clienteAsistenciasMovimientos = new ClienteAsistenciasMovimientos();
            ListasConInformacion* listasConInformacion = new ListasConInformacion();

            QList<QObject*> listaAsistenciasDelAlumno = WrapperClassManagement::getManagerAsistencias()->obtenerAsistenciasDelAlumnoEntreFechasPorClase(id_clase,alumno->getId(),fecha_inicial,fecha_final,true);
            QList<QObject*> listaMovimientosDelAlumno = WrapperClassManagement::getManagerCuentaAlumno()->traerTodosLosMovimientosPorCuenta(alumno->id_cuenta_alumno(),fecha_inicial,fecha_final,true);

            listasConInformacion->setListaAsistencias(listaAsistenciasDelAlumno);
            listasConInformacion->setListaMovimientos(listaMovimientosDelAlumno);

            clienteAsistenciasMovimientos->setAlumno(dynamic_cast<CMAlumno*>(listAlumnosInscriptos.at(x)));
            clienteAsistenciasMovimientos->setListasConInformacion(listasConInformacion);

            superLista.append(clienteAsistenciasMovimientos);
        }
    }

    return superLista;
}

QList<QObject *> ManagerAbonoInfantil::traerAlumnosQueCompraronAbonoInfantil(int mes, int anio)
{
    bool salida = true;

    QSqlQuery query;
    QString strQuery;

    QDate fecha_inicial; QDate fecha_final;

    fecha_inicial.setDate(anio,mes,1);
    fecha_final.setDate(anio,mes,fecha_inicial.daysInMonth());

    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    strQuery = "SELECT "
               "cuenta.id AS id_cuenta, "
               "cuenta.credito_actual AS credito, "
               "cliente.* "
               "FROM abono_infantil_compra compra "
               "INNER JOIN cliente ON cliente.id = compra.id_cliente "
               "INNER JOIN cuenta_cliente cuenta ON cuenta.id_cliente = cliente.id "
               "WHERE '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= compra.fecha_compra AND compra.fecha_compra <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' AND compra.estado = 'Habilitado' AND cliente.estado = 'Habilitado' GROUP BY cliente.id ORDER BY cliente.apellido";

    query.prepare(strQuery);

    QList<QObject*> listaAlumnosAsistidoresDelMesPorClase;

    if( !query.exec() ) {
        qDebug() << query.lastError();
        salida = false;
    }
    else
    {
        for( int r=0; query.next(); r++ ) {
            CMAlumno * objAlumnoResult = new CMAlumno();
            objAlumnoResult->setId(query.value("id").toInt());
            objAlumnoResult->setApellido(query.value("apellido").toString());
            objAlumnoResult->setPrimerNombre(query.value("primer_nombre").toString());
            objAlumnoResult->setSegundoNombre(query.value("segundo_nombre").toString());
            objAlumnoResult->setGenero(query.value("genero").toString());
            objAlumnoResult->setNacimiento(query.value("fecha_nacimiento").toDate());
            objAlumnoResult->setDni(query.value("dni").toString());
            objAlumnoResult->setTelefonoFijo(query.value("telefono_fijo").toString());
            objAlumnoResult->setTelefonoCelular(query.value("telefono_celular").toString());
            objAlumnoResult->setCorreo(query.value("correo").toString());
            objAlumnoResult->setNota(query.value("nota").toString());
            objAlumnoResult->setEstado(query.value("estado").toString());
            objAlumnoResult->setBlameUser(query.value("blame_user").toString());
            objAlumnoResult->setBlameTimeStamp(query.value("blame_timestamp").toDateTime());
            objAlumnoResult->setFechaAlta(query.value("fecha_alta").toDateTime());
            objAlumnoResult->setFecha_matriculacion_infantil(query.value("fecha_matriculacion_infantil").toDateTime());
            objAlumnoResult->setId_cuenta_alumno(query.value("id_cuenta").toInt());
            objAlumnoResult->setCredito_cuenta(query.value("credito").toFloat());

            listaAlumnosAsistidoresDelMesPorClase.append(objAlumnoResult);


            //claseAsistencia->setEstado(query.value("estado").toString());
        }
    }

    this->controlarMensajesDeError(query);
    return listaAlumnosAsistidoresDelMesPorClase;
}

int ManagerAbonoInfantil::registrarPresenteInfantil(int id_abono_infantil_compra, int id_danza_clase, QDateTime fecha)
{
    int salida = 0;

    //"yyyy-MM-dd HH:mm:ss"

    QSqlQuery query;
    query.prepare("INSERT INTO clase_asistencia_infantil (id_abono_infantil_compra, id_danza_clase, fecha, estado) VALUES (:id_abono_infantil_compra, :id_danza_clase, :fecha, :estado)");
    query.bindValue(":id_abono_infantil_compra", id_abono_infantil_compra);
    query.bindValue(":id_danza_clase", id_danza_clase); //'2007-01-01 10:00:00'
    query.bindValue(":fecha", fecha.toString("yyyy-MM-dd HH:mm:ss"));
    query.bindValue(":estado", "Activa");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        salida = query.lastInsertId().toInt();
    }


    this->controlarMensajesDeError(query);
    return salida;
}

QList<QObject *> ManagerAbonoInfantil::traerPresentesPorAbonoInfantilComprado(int id_abono_infantil_compra, QDate fecha)
{
    QSqlQuery query;

    QString strDate = fecha.toString("yyyy-MM-dd");

    query.prepare("SELECT "
                  "asistencia.*,clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad "
                  "FROM "
                  "clase_asistencia_infantil asistencia "
                  "INNER JOIN "
                  "danza_clase clase "
                  "ON "
                  "asistencia.id_danza_clase = clase.id "
                  "INNER JOIN "
                  "danza "
                  "ON "
                  "clase.id_danza = danza.id "
                  "WHERE "
                  "strftime('%m',asistencia.fecha) = strftime('%m','"+strDate+"') AND strftime('%Y',asistencia.fecha) = strftime('%Y','"+strDate+"') "
                                                                                                                                                 "AND asistencia.estado = 'Activa' "
                                                                                                                                                 "AND asistencia.id_abono_infantil_compra = "+QString::number(id_abono_infantil_compra)+" "
                                                                                                                                                                                                                                        "ORDER BY id DESC");

    QList<QObject*> listaClaseAsistenciaInfantil;
    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else
    {
        while(query.next()) {
            ClaseAsistenciaInfantil* claseAsistencia = new ClaseAsistenciaInfantil();
            claseAsistencia->setId(query.value("id").toInt());
            claseAsistencia->setFecha(query.value("fecha").toDateTime());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            claseAsistencia->setEstado(query.value("estado").toString());

            listaClaseAsistenciaInfantil.append(claseAsistencia);
        }
    }

    this->controlarMensajesDeError(query);
    return listaClaseAsistenciaInfantil;
}

float ManagerAbonoInfantil::obtenerPrecioDelAbonoQueOfreceUnaClaseMasPorSem(int clases_ofrecidas_abono_actual)
{
    bool operacion = true;
    float precio_abono = -1;
    float id_abono = -1;
    idAbonoSuperior = -1;
    totalClasesAbonoSuperior = -1;

    operacion = this->traerTodosLasOfertasDeAbono();

    if (operacion){
        int x=0;
        bool continuar = true;
        while (x<listaAbonosEnOferta.count() && continuar) {
            AbonoInfantil* abonoInfantil = dynamic_cast<AbonoInfantil*>(listaAbonosEnOferta.at(x));
            if (abonoInfantil->clases_por_semana() == clases_ofrecidas_abono_actual){
                precio_abono = abonoInfantil->precio_actual();
                id_abono = abonoInfantil->id();
                //El precio del abono que tengo
            }
            else if ((abonoInfantil->clases_por_semana() > clases_ofrecidas_abono_actual) && abonoInfantil->estado() == "Habilitado"){
                precio_abono = abonoInfantil->precio_actual();
                id_abono = abonoInfantil->id();
                totalClasesAbonoSuperior = abonoInfantil->clases_por_semana();
                continuar = false;
                //El precio del abono que le seguiria.
            }
            x++;
        }
    }
    idAbonoSuperior = id_abono;
    return precio_abono;
}

int ManagerAbonoInfantil::obtenerIdAbonoSuperior() {
    return idAbonoSuperior;
}

int ManagerAbonoInfantil::obtenerTotalClasesAbonoSuperior()
{
    return totalClasesAbonoSuperior;
}

bool ManagerAbonoInfantil::actualizarAbonoOfertado(int id_abono_infantil, float precio_actual, bool estado) {
    bool salida = true;

    QSqlQuery query;
    QString strEstado = "Habilitado";

    if (estado == false)
        strEstado = "Deshabilitado";

    QString strQuery = "UPDATE abono_infantil SET estado = '"+strEstado+"', precio_actual = "+QString::number(precio_actual)+", fecha_creacion=CURRENT_TIMESTAMP WHERE id = '"+QString::number(id_abono_infantil)+"'";
    query.prepare(strQuery);

    if (!query.exec()) {
        salida = false;
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }

    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerAbonoInfantil::actualizarPrecioMatricula(float precio_actual)
{
    /*
            "CREATE TABLE IF NOT EXISTS [matriculas] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "tipo VARCHAR(16) DEFAULT 'Infantil',"
            "precio REAL NOT NULL DEFAULT 0,"
            "fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP)";
*/
    bool salida;
    QSqlQuery query;
    if (precioMatricula == NULL){
        query.prepare("INSERT INTO matricula (tipo, precio, fecha_creacion) VALUES (:tipo, :precio, :fecha_creacion)");
        query.bindValue(":tipo", "Infantil");
        query.bindValue(":precio", precio_actual);
        query.bindValue(":fecha_creacion", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
        salida = query.exec();
        traerPrecioMatricula();
    }else{
        query.prepare("UPDATE matricula SET fecha_creacion = '"+QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss")+"', precio = '"+QString::number(precio_actual)+"' WHERE id = '"+QString::number(precioMatricula->id())+"'");
        salida = query.exec();
    }

    return salida;
}

float ManagerAbonoInfantil::traerPrecioMatricula()
{
    float precio = 0;
    QSqlQuery query;
    query.prepare("SELECT * FROM matricula WHERE tipo = 'Infantil'");
    if(!query.exec())
        return false;
    else {
        while (query.next()) {
            precioMatricula = new PrecioMatricula();
            precioMatricula->setId(query.value("id").toInt());
            precioMatricula->setTipo(query.value("tipo").toString());
            precioMatricula->setFecha_creacion(query.value("fecha_creacion").toDateTime());
            precioMatricula->setPrecio(query.value("precio").toFloat());

            precio = precioMatricula->precio();
        }
    }
    return precio;
}

bool ManagerAbonoInfantil::matricularAlumno(int id_cliente)
{
    QSqlQuery query;
    query.prepare("UPDATE cliente SET fecha_matriculacion_infantil = '"+QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss")+"' WHERE id = '"+QString::number(id_cliente)+"'");
    return query.exec();
}

///
/// \brief ManagerAbonoInfantil::verificarSiEstaCubiertoElPresente
/// \param lista
/// \param clases_ofrecidas_abono_actual
/// \return 0 si está cubierta la clase, 1 si es la ultima clase cubierta, 2 si la clase no esta cubierta
///
int ManagerAbonoInfantil::verificarSiEstaCubiertoElPresente(QList<QObject*> lista, int clases_ofrecidas_abono_actual) {
    int salida = 0;
    int total_asistencias_activas = 0;



    for(int x=0;x<lista.count();x++){
        if (dynamic_cast<ClaseAsistenciaInfantil*>(lista.at(x))->estado()=="Activa"){
            total_asistencias_activas++;
        }
    }

    qDebug() << "total_asistencias_activas: " << total_asistencias_activas;
    qDebug() << "clases_ofrecidas_abono_actual: " << clases_ofrecidas_abono_actual;

    switch (clases_ofrecidas_abono_actual) {
    case 1:
        if (total_asistencias_activas >=0 && total_asistencias_activas <=5) {
            if (total_asistencias_activas == 4){
                salida = 1;
            }
            else if(total_asistencias_activas == 5){
                salida = 2;
            }
        }
        else {
            salida = 2;
        }
        break;
    case 2:
        if (total_asistencias_activas >=0 && total_asistencias_activas <=10) {
            //if (total_asistencias_activas >=6 && total_asistencias_activas <=10) {
            if (total_asistencias_activas == 9){
                salida = 1;
            }
            else if(total_asistencias_activas == 10){
                salida = 2;
            }
        }
        else {
            salida = 2;
        }
        break;
    case 3:
        if (total_asistencias_activas >=0 && total_asistencias_activas <=15) {
            //if (total_asistencias_activas >=11 && total_asistencias_activas <=15) {
            if (total_asistencias_activas == 14){
                salida = 1;
            }
            else if(total_asistencias_activas == 15){
                salida = 2;
            }
        }
        else {
            salida = 2;
        }
        break;
    case 4:
        if (total_asistencias_activas >=0 && total_asistencias_activas <=19) {
            //if (total_asistencias_activas >=16 && total_asistencias_activas <=19) {
            if (total_asistencias_activas == 18){
                salida = 1;
            }
            else if(total_asistencias_activas == 19){
                salida = 2;
            }
        }
        else {
            salida = 2;
        }
        break;
    case 5:
        if (total_asistencias_activas >=0 && total_asistencias_activas <=23) {
            //if (total_asistencias_activas >=20 && total_asistencias_activas <=23) {
            if (total_asistencias_activas == 22){
                salida = 1;
            }
            else if(total_asistencias_activas == 23){
                salida = 2;
            }
        }
        else {
            salida = 2;
        }
        break;
    case 6:
        if (total_asistencias_activas >=0 && total_asistencias_activas <=27) {
            //if (total_asistencias_activas >=24 && total_asistencias_activas <=27) {
            if (total_asistencias_activas == 26){
                salida = 1;
            }
            else if(total_asistencias_activas == 27){
                salida = 2;
            }
        }
        else {
            salida = 2;
        }
        break;
    default:
        break;
    }

    qDebug () << "La salida es: " << salida;

    return salida;
}

int ManagerAbonoInfantil::anularPresente(int id_presente) {
    int salida = 0;

    QSqlQuery query;
    query.prepare("UPDATE clase_asistencia_infantil SET estado = 'Borrada' WHERE id = '"+QString::number(id_presente)+"'");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        salida = 1;
    }


    this->controlarMensajesDeError(query);
    return salida;
}


int ManagerAbonoInfantil::darDeBajaAbono(int id) {
    int salida = 0;

    QSqlQuery query;
    query.prepare("UPDATE abono_infantil_compra SET estado = 'Deshabilitado' WHERE id = '"+QString::number(id)+"'");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        salida = id;
        emit sig_abonoInfantilBorrado(id);
    }

    this->controlarMensajesDeError(query);

    return salida;
}



void ManagerAbonoInfantil::controlarMensajesDeError(QSqlQuery query) {
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
