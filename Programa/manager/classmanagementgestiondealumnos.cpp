#include "classmanagementgestiondealumnos.h"

ClassManagementGestionDeAlumnos::ClassManagementGestionDeAlumnos()
{
    recordAlumnoSeleccionado = NULL;
    ultimoAlumnoBuscado = NULL;
    realizarUltimaBusqueda = false;
    clienteEnProcesoDeAlta = new CMAlumno();
    m_pathFotoCliente = "";
    m_pathFotoAlta = "";
    m_clienteEnProcesoDeActualizacion = new CMAlumno();
    hayFoto = false;
    //    QTemporaryDir dir(QDir::tempPath());
    //dir.filePath(QDir::absolutePath());
    dir.mkpath("media/profile");
}

bool ClassManagementGestionDeAlumnos::darDeAltaAlumno() {
    bool resultadoOperacion = false;
    QSqlQuery query;
    query.prepare("INSERT INTO cliente (apellido, primer_nombre, segundo_nombre, genero, fecha_nacimiento, dni, telefono_fijo, telefono_celular, correo, nota, estado, blame_user, blame_timestamp, fecha_alta)"
                  "VALUES (:apellido, :primer_nombre, :segundo_nombre, :genero, :fecha_nacimiento, :dni, :telefono_fijo, :telefono_celular, :correo, :nota, :estado, :blame_user, :blame_timestamp, :fecha_alta)");
    query.bindValue(":apellido", clienteEnProcesoDeAlta->getApellido());
    query.bindValue(":primer_nombre", clienteEnProcesoDeAlta->getPrimerNombre());
    query.bindValue(":segundo_nombre", clienteEnProcesoDeAlta->getSegundoNombre());
    query.bindValue(":genero", clienteEnProcesoDeAlta->getGenero());
    query.bindValue(":fecha_nacimiento", clienteEnProcesoDeAlta->getNacimiento());
    query.bindValue(":dni", clienteEnProcesoDeAlta->getDni());
    query.bindValue(":telefono_fijo", clienteEnProcesoDeAlta->getTelefonoFijo());
    query.bindValue(":telefono_celular", clienteEnProcesoDeAlta->getTelefonoCelular());
    query.bindValue(":correo", clienteEnProcesoDeAlta->getCorreo());
    query.bindValue(":nota", clienteEnProcesoDeAlta->getNota());
    query.bindValue(":estado", "Habilitado");
    query.bindValue(":blame_user", "IslasMalvinas");
    query.bindValue(":blame_timestamp", QDateTime::currentDateTime());
    query.bindValue(":fecha_alta", QDateTime::currentDateTime());

    if(!query.exec()) {
        qDebug() << query.lastError();
        emit sig_falloAltaCliente();
        resultadoOperacion = false;
    }
    else {
        qDebug( "Inserted!" );
        qDebug() << "m_pathFotoCliente!" + m_pathFotoAlta;
        if (m_pathFotoAlta != "") {
            //QFile file(m_pathFotoCliente.mid(8));

            //Nuevas lineas
            QImage image(m_pathFotoAlta.mid(8));
            if (image.width() > 720)
                image = image.scaledToWidth(720); //Achica la imagen a un width de 720 manteniendo la proporcion.

            QByteArray ba;
            QBuffer buffer(&ba);
            buffer.open(QIODevice::WriteOnly);
            image.save(&buffer, "JPEG");

            //Viejas lineas
            m_pathFotoAlta = "";
            if (buffer.open(QIODevice::ReadOnly)) {
                QByteArray imgByteArray = buffer.readAll();
                QSqlQuery queryFoto;
                queryFoto.prepare("INSERT INTO cliente_foto (id_cliente,foto) VALUES (:id_cliente,:foto)");
                queryFoto.bindValue(":id_cliente",query.lastInsertId().toInt());
                queryFoto.bindValue(":foto",imgByteArray);
                if (!queryFoto.exec()) {
                    emit sig_falloAltaFotoCliente();
                }
            }
            else
                emit sig_falloAltaFotoCliente();
        }

        emit sig_altaClienteExitosa();
        resultadoOperacion = true;
    }

    this->controlarMensajesDeError(query);

    return resultadoOperacion;
}

/*bool ClassManagementGestionDeAlumnos::obtenerFoto(int id_cliente) {
    QSqlQuery queryFoto;
    QImage fotoCliente;
    queryFoto.prepare("SELECT foto FROM cliente_foto WHERE id_cliente="+QString::number(id_cliente));
    if( !queryFoto.exec() )
        qDebug() << queryFoto.lastError();
    else
    {
        if (queryFoto.next()){
            QByteArray arrayFoto = queryFoto.value(0).toByteArray();
            fotoCliente.loadFromData(arrayFoto);
            //QTemporaryDir dir(QDir::tempPath());
            //dir.setAutoRemove(false);       //A la larga, se va a generar mucha basura!
            //if (dir.isValid()) {
                QString pathFoto = dir.absolutePath()+"/media/profile/foto_cliente"+QString::number(id_cliente)+".jpg";
                if (fotoCliente.save(pathFoto,"JPEG")) {
                    hayFoto = true;
                    emit sig_urlFotoCliente("file:///"+pathFoto);
                    //emit sig_urlFotoCliente(pathFoto);
                }
                else {
                    hayFoto = false;
                    emit sig_noHayFoto();
                }
            //}
            //else {
             //   qDebug() << "Directorio inválido!";
            //}
        }
        else {
            hayFoto = false;
            emit sig_noHayFoto();
        }
    }
    return hayFoto;
}*/

bool ClassManagementGestionDeAlumnos::obtenerFoto(int id_cliente) {
    QSqlQuery queryFoto;
    QImage fotoCliente;

    dir.refresh();

    QString pathFoto = dir.absolutePath()+"/media/profile/"+QString::number(id_cliente)+".jpg";

    if (dir.exists(pathFoto)){
        hayFoto = true;
        emit sig_urlFotoCliente("file:///"+pathFoto);
    }
    else {
        queryFoto.prepare("SELECT foto FROM cliente_foto WHERE id_cliente="+QString::number(id_cliente));
        if( !queryFoto.exec() )
            qDebug() << queryFoto.lastError();
        else
        {
            if (queryFoto.next()){
                QByteArray arrayFoto = queryFoto.value(0).toByteArray();
                fotoCliente.loadFromData(arrayFoto);

                if (fotoCliente.save(pathFoto,"JPEG")) {
                    hayFoto = true;
                    emit sig_urlFotoCliente("file:///"+pathFoto);
                }
                else {
                    hayFoto = false;
                    emit sig_noHayFoto();
                }
            }
            else {
                hayFoto = false;
                emit sig_noHayFoto();
            }
        }
    }

    return hayFoto;
}

CMAlumno * ClassManagementGestionDeAlumnos::obtenerAlumnoPorId(QString dni, int estado) {
    CMAlumno * objAlumnoResult;
    objAlumnoResult = NULL;
    QSqlQuery query;
    QString strQuery;
    if (estado == 1)
        strQuery = "SELECT * FROM cliente WHERE estado='Habilitado' AND dni = '"+dni+"'";
    else if (estado == 2)
        strQuery = "SELECT * FROM cliente WHERE estado='Deshabilitado' AND dni = '"+dni+"'";
    else if (estado == 0)
        strQuery = "SELECT * FROM cliente WHERE dni = '"+dni+"'";
    query.prepare(strQuery);
    if( !query.exec() )
        qDebug() << "obtenerAlumnoPorId(QString dni, int estado): " << query.lastError();
    else
    {
        if (query.next()) {
            objAlumnoResult = new CMAlumno();
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

        }
    }

    this->controlarMensajesDeError(query);

    return objAlumnoResult;
}

CMAlumno * ClassManagementGestionDeAlumnos::obtenerAlumnoPorId(int id, int estado) {
    CMAlumno * objAlumnoResult;
    objAlumnoResult = NULL;
    QSqlQuery query;
    QString strQuery;
    if (estado == 1)
        strQuery = "SELECT * FROM cliente WHERE estado='Habilitado' AND id = '"+QString::number(id)+"'";
    else if (estado == 2)
        strQuery = "SELECT * FROM cliente WHERE estado='Deshabilitado' AND id = '"+QString::number(id)+"'";
    else if (estado == 0)
        strQuery = "SELECT * FROM cliente WHERE id = '"+QString::number(id)+"'";
    query.prepare(strQuery);
    if( !query.exec() )
        qDebug() << "obtenerAlumnoPorId(int id, int estado): " << query.lastError();
    else
    {
        if (query.next()) {
            objAlumnoResult = new CMAlumno();
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
        }
    }

    this->controlarMensajesDeError(query);

    return objAlumnoResult;
}

bool ClassManagementGestionDeAlumnos::buscarAlumno(QString apellido, QString nombre, QString dni, int tipoDeBusqueda, int idClase) {
    CMAlumno * objCMAlumno;
    if (dni == "..")
        dni = "";
    if (realizarUltimaBusqueda) {
        realizarUltimaBusqueda = false;
        objCMAlumno = ultimoAlumnoBuscado;
    }
    else {
        objCMAlumno = new CMAlumno(apellido, nombre, dni);
        ultimoAlumnoBuscado = objCMAlumno;
    }

    bool resultadoOperacion = false;
    QSqlQuery query;
    QList<QObject*> listaAlumnosObj;
    listaAlumnosObj.clear();
    QString strQuery;
    if (tipoDeBusqueda == 1)
        strQuery = "SELECT * FROM cliente WHERE estado='Habilitado' AND "+ objCMAlumno->getQueryParaBusqueda();
    else if (tipoDeBusqueda == 2)
        strQuery = "SELECT * FROM cliente WHERE estado='Deshabilitado' AND "+ objCMAlumno->getQueryParaBusqueda();
    else if (tipoDeBusqueda == 3) {
        if (dni == "")
            strQuery = "SELECT * FROM cliente WHERE estado='Habilitado' AND apellido LIKE '"+apellido+"%' AND primer_nombre LIKE '"+nombre+"%' ";
        else
            strQuery = "SELECT * FROM cliente WHERE estado='Habilitado' AND apellido LIKE '"+apellido+"%' AND primer_nombre LIKE '"+nombre+"%' OR dni =  '"+dni+"' ";
    }
    else if (tipoDeBusqueda == 4) {
        if (dni == "")
            strQuery = "SELECT inscripcion.estado AS estado_inscripcion, cliente.* FROM cliente LEFT JOIN inscripcion_cliente_clase inscripcion ON (inscripcion.id_danza_clase = "+QString::number(idClase)+" AND cliente.id = inscripcion.id_cliente) WHERE cliente.estado='Habilitado' AND apellido LIKE '"+apellido+"%' AND primer_nombre LIKE '"+nombre+"%' GROUP BY cliente.id ";
        else
            strQuery = "SELECT inscripcion.estado AS estado_inscripcion, cliente.* FROM cliente LEFT JOIN inscripcion_cliente_clase inscripcion ON (inscripcion.id_danza_clase = "+QString::number(idClase)+" AND cliente.id = inscripcion.id_cliente) WHERE cliente.estado='Habilitado' AND apellido LIKE '"+apellido+"%' AND primer_nombre LIKE '"+nombre+"%' OR dni = '"+dni+"' GROUP BY cliente.id ";
    }
    else if (tipoDeBusqueda == 5) {
        QDate fechaActual = QDate::currentDate();
        QDate fecha_inicial(fechaActual.year(),fechaActual.month(),1);
        QDate fecha_final(fechaActual.year(),fechaActual.month(),fechaActual.daysInMonth());

        QDateTime dt_fecha_inicial;
        QDateTime dt_fecha_final;
        dt_fecha_inicial.setDate(fecha_inicial);
        dt_fecha_inicial.setTime(QTime(0,0,0));
        dt_fecha_final.setDate(fecha_final);
        dt_fecha_final.setTime(QTime(23,59,59));
        //'"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= compra.fecha_compra AND compra.fecha_compra <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"'

        if (dni == "")
            strQuery = "SELECT inscripcion.estado AS estado_inscripcion, cliente.* FROM cliente INNER JOIN abono_infantil_compra compra ON compra.id_cliente = cliente.id LEFT JOIN inscripcion_cliente_clase inscripcion ON (inscripcion.id_danza_clase = "+QString::number(idClase)+" AND cliente.id = inscripcion.id_cliente) WHERE cliente.estado='Habilitado' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= compra.fecha_compra AND compra.fecha_compra <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' AND apellido LIKE '"+apellido+"%' AND compra.estado = 'Habilitado' AND primer_nombre LIKE '"+nombre+"%' GROUP BY cliente.id ";
        else
            strQuery = "SELECT inscripcion.estado AS estado_inscripcion, cliente.* FROM cliente INNER JOIN abono_infantil_compra compra ON compra.id_cliente = cliente.id LEFT JOIN inscripcion_cliente_clase inscripcion ON (inscripcion.id_danza_clase = "+QString::number(idClase)+" AND cliente.id = inscripcion.id_cliente) WHERE cliente.estado='Habilitado' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= compra.fecha_compra AND compra.fecha_compra <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' AND apellido LIKE '"+apellido+"%' AND compra.estado = 'Habilitado' AND primer_nombre LIKE '"+nombre+"%' OR dni = '"+dni+"' GROUP BY cliente.id ";
    }

    strQuery = strQuery + "ORDER BY apellido, primer_nombre";

    query.prepare(strQuery);

    if( !query.exec() )
        qDebug() << "\n\nbuscarAlumno(QString apellido, QString nombre, QString dni, int tipoDeBusqueda): " << query.lastError();
    else
    {
        for( int r=0; query.next(); r++ ) {
            CMAlumno * objAlumnoResult;
            objAlumnoResult = new CMAlumno();
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


            if (tipoDeBusqueda == 4 || tipoDeBusqueda == 5){
                if (query.value("estado_inscripcion").isNull())
                    objAlumnoResult->setInscripto_a_clase(false);
                else{
                    if (query.value("estado_inscripcion").toString() == "Habilitado"){
                        objAlumnoResult->setInscripto_a_clase(true);
                    }
                    else {
                        objAlumnoResult->setInscripto_a_clase(false);
                    }
                }
            }

            listaAlumnosObj.append(objAlumnoResult);
        }
    }

    this->controlarMensajesDeError(query);

    emit sig_listaAlumnos(listaAlumnosObj);
    return resultadoOperacion;
}

void ClassManagementGestionDeAlumnos::controlarMensajesDeError(QSqlQuery query) {
    if (query.lastQuery() == ""){
        //emit sig_mensajeError(false, "Es probable que te hayas quedado sin internet. Por favor, verificalo.\nPor ejemplo, abrí el navegador web e intenta ingresar a 'yahoo.com'. Si la página web no carga, quiere decir que te quedaste sin internet.");
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

bool ClassManagementGestionDeAlumnos::actualizacionAlumno() {
    ///La actualizacion consiste en 2 etapas.
    ///La primera es cuando se actualizan en la base los datos pertenecientes únicamente a la tabla cliente.
    ///La segunda cuando se actualiza la foto en la tabla cliente_foto.

    bool resultadoOperacion = false;
    QSqlQuery query;

    query.prepare("UPDATE cliente SET "
                  "apellido = :apellido, "
                  "primer_nombre = :primer_nombre, "
                  "segundo_nombre = :segundo_nombre, "
                  "genero = :genero, "
                  "fecha_nacimiento= :fecha_nacimiento, "
                  "dni = :dni, "
                  "telefono_fijo = :telefono_fijo, "
                  "telefono_celular = :telefono_celular, "
                  "correo = :correo, "
                  "nota = :nota, "
                  "estado = :estado, "
                  "blame_user = :blame_user "
                  "WHERE cliente.id="+QString::number(m_clienteEnProcesoDeActualizacion->getId()));
    query.bindValue(":apellido", m_clienteEnProcesoDeActualizacion->getApellido());
    query.bindValue(":primer_nombre", m_clienteEnProcesoDeActualizacion->getPrimerNombre());
    query.bindValue(":segundo_nombre", m_clienteEnProcesoDeActualizacion->getSegundoNombre());
    query.bindValue(":genero", m_clienteEnProcesoDeActualizacion->getGenero());
    query.bindValue(":fecha_nacimiento", m_clienteEnProcesoDeActualizacion->getNacimiento());
    query.bindValue(":dni", m_clienteEnProcesoDeActualizacion->getDni());
    query.bindValue(":telefono_fijo", m_clienteEnProcesoDeActualizacion->getTelefonoFijo());
    query.bindValue(":telefono_celular", m_clienteEnProcesoDeActualizacion->getTelefonoCelular());
    query.bindValue(":correo", m_clienteEnProcesoDeActualizacion->getCorreo());
    query.bindValue(":nota", m_clienteEnProcesoDeActualizacion->getNota());
    query.bindValue(":estado", m_clienteEnProcesoDeActualizacion->getEstado());
    query.bindValue(":blame_user", "IslasMalvinas");



    if( !query.exec() ){    ///FIN ETAPA 1
        qDebug() << "1.-actualizacionAlumno" << query.lastError();
        qDebug() << "info query: " << query.executedQuery();} //Muestra ultimo query ejecutado
    else
    {
        qDebug( "Updated!" );
        qDebug() << "info query: " << query.executedQuery(); //Muestra ultimo query ejecutado
        resultadoOperacion = true; //SI ETAPA 1 TERMINA BIEN, RESULTADO DE OPERACION ES VERDADERO.
        dir.refresh();
        if (m_pathFotoCliente != "") {
            qDebug() << m_pathFotoCliente;
            QImage image(m_pathFotoCliente.mid(8));
            if (image.width() > 720)
                image = image.scaledToWidth(720); //Achica la imagen a un width de 720 manteniendo la proporcion.

            QByteArray ba;
            QBuffer buffer(&ba);
            buffer.open(QIODevice::WriteOnly);
            image.save(&buffer, "JPEG");

            m_pathFotoCliente = "";
            if (buffer.open(QIODevice::ReadOnly)) {
                QByteArray imgByteArray = buffer.readAll();
                QSqlQuery queryFoto;
                if (hayFoto) {
                    queryFoto.prepare("UPDATE cliente_foto SET foto = :foto WHERE id_cliente="+QString::number(m_clienteEnProcesoDeActualizacion->getId()));
                }
                else {
                    queryFoto.prepare("INSERT INTO cliente_foto (id_cliente,foto) VALUES (:id_cliente,:foto)");
                    queryFoto.bindValue(":id_cliente",m_clienteEnProcesoDeActualizacion->getId());
                }
                queryFoto.bindValue(":foto",imgByteArray);
                if (!queryFoto.exec()) {
                    qDebug() << query.lastError();
                    emit sig_falloAltaFotoCliente();
                }
                else {
                    qDebug( "Updated photo" );



                    QString pathFoto = dir.absolutePath()+"/media/profile/"+QString::number(m_clienteEnProcesoDeActualizacion->getId())+".jpg";
                    //dir.remove(pathFoto);
                    if (image.save(pathFoto,"JPEG")) {
                        qDebug() << "Foto cache salvada";
                    }
                    else {
                        qDebug() << "Foto cache NO salvada";
                    }
                }
            }
        }
        else {
            QSqlQuery queryFoto;
            queryFoto.prepare("DELETE FROM cliente_foto WHERE id_cliente='"+QString::number(m_clienteEnProcesoDeActualizacion->getId())+"'");
            if (!queryFoto.exec()) {
                qDebug() << query.lastError();
                emit sig_falloAltaFotoCliente();
            }
            else {
                qDebug( "Erased photo" );

                QString pathFoto = dir.absolutePath()+"/media/profile/"+QString::number(m_clienteEnProcesoDeActualizacion->getId())+".jpg";
                dir.remove(pathFoto);
            }
        }
    }
    this->controlarMensajesDeError(query);
    return resultadoOperacion;
}

bool ClassManagementGestionDeAlumnos::eliminacionFisica(int id_cliente) {
    bool todoBien = true;
    qDebug() << "";
    QSqlQuery query;
    QString strQuery = "";

    /*strQuery = "DELETE FROM cliente_foto WHERE id_cliente="+QString::number(id_cliente);
    query.prepare(strQuery);
    if (!query.exec() && todoBien) {
        todoBien = false;
        qDebug() << "1" << query.lastError();
        qDebug () << "strQuery: " << strQuery;
        qDebug() << "";
    }

    strQuery = "DELETE FROM cliente_asistencia WHERE id_cliente="+QString::number(id_cliente);
    query.prepare(strQuery);
    if (!query.exec() && todoBien) {
        todoBien = false;
        qDebug() <<"2" << query.lastError();
        qDebug () << "strQuery: " << strQuery;
        qDebug() << "";
    }
    else{

    }

    strQuery = "DELETE FROM abono WHERE id_cliente="+QString::number(id_cliente);
    query.prepare(strQuery);
    if (!query.exec() && todoBien) {
        todoBien = false;
        qDebug() <<"3" << query.lastError();
        qDebug () << "strQuery: " << strQuery;
        qDebug() << "";
    }
    else{

    }*/

    strQuery = "DELETE FROM cliente WHERE id="+QString::number(id_cliente);
    query.prepare(strQuery);
    if (!query.exec() && todoBien) {
        todoBien = false;
        qDebug() <<"4" << query.lastError();
        qDebug () << "strQuery: " << strQuery;
        qDebug() << "";
    }
    else {

    }

    return todoBien;
}

bool ClassManagementGestionDeAlumnos::eliminarAlumno(int id_cliente) {
    bool resultadoOperacion = false;

    QSqlQuery query;
    QString strQuery = "UPDATE cliente SET estado='Deshabilitado', blame_timestamp=CURRENT_TIMESTAMP WHERE id='"+QString::number(id_cliente)+"'";
    query.prepare(strQuery);

    if( !query.exec() )
        qDebug() << query.lastError();
    else
    {
        qDebug( "Updated!" );
        resultadoOperacion = true;
    }
    this->controlarMensajesDeError(query);
    return resultadoOperacion;
}

bool ClassManagementGestionDeAlumnos::reactivarCliente(int id_cliente) {
    bool resultadoOperacion = false;

    QSqlQuery query;
    QString strQuery = "UPDATE cliente SET estado='Habilitado', blame_timestamp=CURRENT_TIMESTAMP WHERE id='"+QString::number(id_cliente)+"'";
    query.prepare(strQuery);

    if( !query.exec() )
        qDebug() << query.lastError();
    else
    {
        qDebug( "Updated!" );
        resultadoOperacion = true;
    }
    this->controlarMensajesDeError(query);
    return resultadoOperacion;
}

QList<QObject*> ClassManagementGestionDeAlumnos::getBirthdaysByDay(QDate fecha) {
    QList<QObject*> birthdayByDayList;
    birthdayByDayList.clear();
    for (int x=0;x<birthdaysByMonthList.count();x++) {
        CMAlumno * objAlumno = dynamic_cast<CMAlumno*>(birthdaysByMonthList.at(x));
        if (objAlumno->getNacimiento().day() == fecha.day() && objAlumno->getNacimiento().month() == fecha.month()) {
            birthdayByDayList.append(objAlumno);
        }
    }
    return birthdayByDayList;
}

void ClassManagementGestionDeAlumnos::mostrarFotoDePerfilGrande(QString source)
{
    emit sig_mostrarFotoDePerfil(source);
}

bool ClassManagementGestionDeAlumnos::alumnoConMatriculaInfantilVigente(int id_alumno)
{

    QSqlQuery query;
    query.prepare("SELECT * FROM cliente WHERE id = '"+QString::number(id_alumno)+"'");

    if (query.exec()){
        while (query.next()) {
            QDateTime dt_fecha_matriculacion = query.value("fecha_matriculacion_infantil").toDateTime();
            if (dt_fecha_matriculacion.isNull() == false){
                int anio_matriculacion = dt_fecha_matriculacion.date().year();
                int anio_actual = QDate::currentDate().year();

                if (anio_actual == anio_matriculacion){
                    return true;
                }
            }
        }
    }
    return false;
}

bool ClassManagementGestionDeAlumnos::alumnoConMatriculaVigente(QDateTime dt_fecha_matriculacion)
{
    if (dt_fecha_matriculacion.isNull()){
        return false;
    }

    int anio_matriculacion = dt_fecha_matriculacion.date().year();
    int anio_actual = QDate::currentDate().year();

    if (anio_actual == anio_matriculacion){
        return true;
    }
    else{
        return false;
    }
}

int ClassManagementGestionDeAlumnos::getBirthdaysByMonth(QDate fecha) {
    QString strQuery;
    QSqlQuery query;
    QString strDate = fecha.toString("yyyy-MM-dd");
    strQuery = "SELECT * FROM cliente WHERE estado = 'Habilitado' AND strftime('%m',cliente.fecha_nacimiento) = strftime('%m','"+strDate+"')";
    query.prepare(strQuery);

    birthdaysByMonthList.clear();

    if( !query.exec() )
        qDebug() << "1--" << query.lastError();
    else
    {
        qDebug() << "¡!";
        while (query.next()) {
            CMAlumno * objAlumnoResult;
            objAlumnoResult = new CMAlumno();
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
            birthdaysByMonthList.append(objAlumnoResult);
        }
    }
    this->controlarMensajesDeError(query);
    emit sig_birthdaysByMonthListReady();
    return birthdaysByMonthList.count();
}

int ClassManagementGestionDeAlumnos::getBirthdaysByDate(QDate fecha) {
    QString strQuery;
    QSqlQuery query;
    QString strDate = fecha.toString("yyyy-MM-dd");
    strQuery = "SELECT * FROM cliente WHERE estado = 'Habilitado' AND strftime('%m',cliente.fecha_nacimiento) = strftime('%m','"+strDate+"') AND strftime('%d',cliente.fecha_nacimiento) = strftime('%d','"+strDate+"')";
    qDebug() << "2 miiiii query: " << strQuery;
    query.prepare(strQuery);

    int contador = 0;

    if( !query.exec() )
        qDebug() << "getBirthdaysByDate: " << strQuery;
    else
    {
        while (query.next()) {
            contador++;
        }
    }
    this->controlarMensajesDeError(query);
    return contador;
}

int ClassManagementGestionDeAlumnos::getBirthdays(QDate fecha, bool getAlsoNextDayBirthdays) {
    QString strQuery;
    QSqlQuery query, queryDos;
    QString strDate = fecha.toString("yyyy-MM-dd");
    strQuery = "SELECT * FROM cliente WHERE estado = 'Habilitado' AND strftime('%m',cliente.fecha_nacimiento) = strftime('%m','"+strDate+"') AND strftime('%d',cliente.fecha_nacimiento) = strftime('%d','"+strDate+"')";
    query.prepare(strQuery);
    listaAlumnosCumpleanios.clear();

    if( !query.exec() )
        qDebug() << "getBirthdays: " << strQuery;
    else
    {
        while (query.next()) {
            CMAlumno * objAlumnoResult;
            objAlumnoResult = new CMAlumno();
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
            listaAlumnosCumpleanios.append(objAlumnoResult);
        }
    }

    //Esta parte tiene que ir siempre.
    //Se encarga de contabilizar a aquellos nacidos un 29 de febrero.
    //Si el año no es bisiesto, el cumple se celebra el primero de marzo
    //y el 28 de febrero te avisa que "mañana" es el cumple del alumno.
    QDate fechaDeHoy = QDate::currentDate();
    bool ejecutar = false;
    if (!QDate::isLeapYear(fechaDeHoy.year())) {
        if ((fechaDeHoy.day() == 28 && fechaDeHoy.month() == 2) || (fechaDeHoy.day() == 1 && fechaDeHoy.month() == 3)) {
            strQuery = "SELECT * FROM cliente WHERE estado = 'Habilitado' AND strftime('%m',cliente.fecha_nacimiento) = '02' AND strftime('%d',cliente.fecha_nacimiento) = '29'";
            qDebug() << "4 miiiii query: " << strQuery;
            ejecutar = true;
        }

        if (ejecutar) {
            qDebug() << "strQuery bisiesto: "<< strQuery;
            queryDos.prepare(strQuery);

            if( !queryDos.exec() )
                qDebug() << queryDos.lastError();
            else
            {
                while (queryDos.next()) {
                    CMAlumno * objAlumnoResult;
                    objAlumnoResult = new CMAlumno();
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
                    listaAlumnosCumpleanios.append(objAlumnoResult);
                }
            }
        }
    }

    if (getAlsoNextDayBirthdays) {
        strDate = QDate::currentDate().addDays(1).toString("yyyy-MM-dd");
        strQuery = "SELECT * FROM cliente WHERE estado = 'Habilitado' AND strftime('%m',cliente.fecha_nacimiento) = strftime('%m','"+strDate+"') AND strftime('%d',cliente.fecha_nacimiento) = strftime('%d','"+strDate+"')";
        queryDos.prepare(strQuery);

        if( !queryDos.exec() )
            qDebug() << queryDos.lastError();
        else
        {
            while (queryDos.next()) {
                CMAlumno * objAlumnoResult;
                objAlumnoResult = new CMAlumno();
                objAlumnoResult->setId(queryDos.value("id").toInt());
                objAlumnoResult->setApellido(queryDos.value("apellido").toString());
                objAlumnoResult->setPrimerNombre(queryDos.value("primer_nombre").toString());
                objAlumnoResult->setSegundoNombre(queryDos.value("segundo_nombre").toString());
                objAlumnoResult->setGenero(queryDos.value("genero").toString());
                objAlumnoResult->setNacimiento(queryDos.value("fecha_nacimiento").toDate());
                objAlumnoResult->setDni(queryDos.value("dni").toString());
                objAlumnoResult->setTelefonoFijo(queryDos.value("telefono_fijo").toString());
                objAlumnoResult->setTelefonoCelular(queryDos.value("telefono_celular").toString());
                objAlumnoResult->setCorreo(queryDos.value("correo").toString());
                objAlumnoResult->setNota(queryDos.value("nota").toString());
                objAlumnoResult->setEstado(queryDos.value("estado").toString());
                objAlumnoResult->setBlameUser(queryDos.value("blame_user").toString());
                objAlumnoResult->setBlameTimeStamp(queryDos.value("blame_timestamp").toDateTime());
                objAlumnoResult->setFechaAlta(queryDos.value("fecha_alta").toDateTime());
                objAlumnoResult->setFecha_matriculacion_infantil(query.value("fecha_matriculacion_infantil").toDateTime());
                listaAlumnosCumpleanios.append(objAlumnoResult);
            }
        }
    }

    this->controlarMensajesDeError(query);
    emit sig_listaBirthday(listaAlumnosCumpleanios);
    return listaAlumnosCumpleanios.count();
}

///
/// \brief ClassManagementGestionDeAlumnos::isItHerBirthday
/// \param fecha
/// \return 0 no birthday. 1 her birthday is today. 2 her birthday is tomorrow.
///
int ClassManagementGestionDeAlumnos::isItHerBirthday(int id_alumno) {
    int salida;
    bool encontrado = false;
    int index = 0;
    CMAlumno * cMAlumno = NULL;
    while (!encontrado && index < listaAlumnosCumpleanios.count()){
        if (dynamic_cast<CMAlumno*>(listaAlumnosCumpleanios.at(index))->getId() == id_alumno) {
            cMAlumno = dynamic_cast<CMAlumno*>(listaAlumnosCumpleanios.at(index));
            encontrado = true;
        }
        index++;
    }
    if (encontrado) {
        QDate nacimiento = cMAlumno->getNacimiento();
        QDate hoy = QDate::currentDate();
        if (nacimiento.day() == hoy.day())
            salida = 1;
        else
            salida = 2;
    }
    else
        salida = 0;
    emit sig_isItHerBirthday(salida);
    return salida;
}

CMAlumno *ClassManagementGestionDeAlumnos::getClienteEnProcesoDeAlta() const
{
    return clienteEnProcesoDeAlta;
}

CMAlumno *ClassManagementGestionDeAlumnos::getClienteEnProcesoDeActualizacion() const
{
    return m_clienteEnProcesoDeActualizacion;
}

QString ClassManagementGestionDeAlumnos::getPathFotoCliente() const
{
    return m_pathFotoCliente;
}

QString ClassManagementGestionDeAlumnos::getPathFotoAlta() const
{
    return m_pathFotoAlta;
}

void ClassManagementGestionDeAlumnos::setClienteEnProcesoDeAlta(CMAlumno *arg)
{
    clienteEnProcesoDeAlta = arg;
}

void ClassManagementGestionDeAlumnos::setClienteEnProcesoDeActualizacion(CMAlumno *arg)
{
    m_clienteEnProcesoDeActualizacion = arg;
}

void ClassManagementGestionDeAlumnos::setPathFotoCliente(QString arg)
{
    qDebug() << "m_pathFotoCliente: " << m_pathFotoCliente;
    m_pathFotoCliente = arg;
    emit pathFotoClienteChanged(arg);
}

void ClassManagementGestionDeAlumnos::setPathFotoAlta(QString arg)
{
    if (m_pathFotoAlta == arg)
        return;

    m_pathFotoAlta = arg;
    emit pathFotoAltaChanged(arg);
}

CMAlumno * ClassManagementGestionDeAlumnos::getRecordAlumnoSeleccionado() {
    return recordAlumnoSeleccionado;
}

void ClassManagementGestionDeAlumnos::setRecordAlumnoSeleccionado(CMAlumno * recordAlumnoSeleccionado) {
    this->recordAlumnoSeleccionado = recordAlumnoSeleccionado;
    emit sig_recordAlumnoSeleccionado(this->recordAlumnoSeleccionado);
}
