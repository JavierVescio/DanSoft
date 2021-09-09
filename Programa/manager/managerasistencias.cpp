#include "managerasistencias.h"

ManagerAsistencias::ManagerAsistencias()
{

}

int ManagerAsistencias::darPresente(int id_cliente, bool clase_debitada, int id_clase, QString fecha) {
    int salida = 0;

    //"yyyy-MM-dd HH:mm:ss"

    QSqlQuery query;
    query.prepare("INSERT INTO cliente_asistencia (id_cliente, id_clase_horario, fecha, clase_debitada, estado) VALUES (:id_cliente, :id_clase_horario, :fecha, :clase_debitada, :estado)");
    query.bindValue(":id_cliente", id_cliente);
    query.bindValue(":id_clase_horario", id_clase); //'2007-01-01 10:00:00'
    query.bindValue(":fecha", fecha);
    query.bindValue(":clase_debitada", clase_debitada ? "Si" : "No");
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

int ManagerAsistencias::anularPresente(int id_presente) {
    int salida = 0;

    QSqlQuery query;
    query.prepare("UPDATE cliente_asistencia SET clase_debitada = 'Si', estado = 'Borrada' WHERE id = '"+QString::number(id_presente)+"'");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        salida = 1;
    }


    this->controlarMensajesDeError(query);
    return salida;
}

//SELECT cliente_asistencia.*, abono_asistencia.credencial_firmada FROM cliente_asistencia LEFT JOIN abono_asistencia ON cliente_asistencia.id = abono_asistencia.id_cliente_asistencia WHERE abono_asistencia.id_abono = 1

bool ManagerAsistencias::obtenerClasesPorAbono(int id_abono) {
    bool salida = true;

    QSqlQuery query;
    query.prepare("SELECT cliente_asistencia.*, abono_asistencia.credencial_firmada, danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN abono_asistencia ON cliente_asistencia.id = abono_asistencia.id_cliente_asistencia LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza WHERE danza_clase.estado = 'Habilitado' AND danza.estado = 'Habilitado' AND cliente_asistencia.estado = 'Activa' AND abono_asistencia.id_abono = '"+QString::number(id_abono)+"' ORDER BY cliente_asistencia.id DESC");
    QList<QObject*> listaClaseAsistenciaObj;
    if( !query.exec() ) {
        qDebug() << query.lastError();
        salida = false;
    }
    else
    {
        while(query.next()) {
            ClaseAsistencia * claseAsistencia = new ClaseAsistencia();
            claseAsistencia->setId(query.value(0).toInt());
            claseAsistencia->setId_cliente(query.value(1).toInt());
            claseAsistencia->setId_clase_horario(query.value(2).toInt());
            claseAsistencia->setFecha(query.value(3).toDateTime());
            claseAsistencia->setClase_debitada(query.value(4).toString());
            claseAsistencia->setCredencial_firmada(query.value(5).toString());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            listaClaseAsistenciaObj.append(claseAsistencia);
        }
    }
    QList<QObject*> list;

    if (listaClaseAsistenciaObj.count() > 0)
        emit sig_listaClaseAsistencias(listaClaseAsistenciaObj,list);
    else
        emit sig_noHayAsistenciasDelAlumno();


    this->controlarMensajesDeError(query);
    return salida;
}

int ManagerAsistencias::obtenerClasesSinPagarPorAlumno(int id_cliente) {
    int salida = 0;

    QSqlQuery query;
    query.prepare("SELECT * FROM cliente_asistencia WHERE cliente_asistencia.estado = 'Activa' AND id_cliente = '"+QString::number(id_cliente)+"' AND clase_debitada = 'No'");

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

//int ManagerAsistencias::obtenerClasesSinPagarPorAlumno(int id_cliente) {
//    int salida = 0;

//    QSqlQuery query;
//    query.prepare("SELECT * FROM cliente_asistencia WHERE id_cliente = '"+QString::number(id_cliente)+"' AND clase_debitada = 'No'");

//    if(!query.exec()) {
//        qDebug() << query.lastError();
//    }
//    else {
//        while (query.next())
//            salida++;
//    }

//    return salida;
//}

int ManagerAsistencias::normalizarCuentaDeAlumno(int id_cliente) {
    int salida = 0;

    QSqlQuery query;
    query.prepare("UPDATE cliente_asistencia SET clase_debitada = 'Si' WHERE id_cliente = '"+QString::number(id_cliente)+"'");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        salida = 1;
    }


    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerAsistencias::obtenerPresentesEntreFechas(QDate fecha_inicial, QDate fecha_final, int id_cliente) {
    bool salida = true;

    QSqlQuery query;
    QString strQuery;

    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    if (id_cliente == -1)
        strQuery = "SELECT cliente_asistencia.*, cliente.*, cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente, danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza WHERE danza_clase.estado = 'Habilitado' AND danza.estado = 'Habilitado' AND cliente_asistencia.estado = 'Activa' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY cliente_asistencia.id DESC";
    else
        strQuery = "SELECT cliente_asistencia.*,danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza WHERE danza_clase.estado = 'Habilitado' AND danza.estado = 'Habilitado' AND cliente_asistencia.estado = 'Activa' AND id_cliente = "+QString::number(id_cliente)+" AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY cliente_asistencia.id DESC";

    query.prepare(strQuery);
    QList<QObject*> listaClaseAsistenciaObj;
    QList<QObject*> listaClienteAsistenciaObj;

    if( !query.exec() ) {
        qDebug() << query.lastError();
        salida = false;
    }
    else
    {
        for( int r=0; query.next(); r++ ) {
            ClaseAsistencia * claseAsistencia = new ClaseAsistencia();
            claseAsistencia->setId(query.value(0).toInt());
            claseAsistencia->setId_cliente(query.value(1).toInt());
            claseAsistencia->setId_clase_horario(query.value(2).toInt());
            claseAsistencia->setFecha(query.value(3).toDateTime());
            claseAsistencia->setClase_debitada(query.value(4).toString());
            if (query.value("nombre_cliente").isValid())
                claseAsistencia->setNombre_cliente(query.value("nombre_cliente").toString());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            claseAsistencia->setEstado(query.value("estado").toString());

            listaClaseAsistenciaObj.append(claseAsistencia);
            if (id_cliente == -1) {
                listaClienteAsistenciaObj.append(this->extraerAlumnoDelQueryDeAsistencias(query));
            }
        }
    }

    if (listaClaseAsistenciaObj.count() > 0)
        emit sig_listaClaseAsistencias(listaClaseAsistenciaObj,listaClienteAsistenciaObj);
    else
        emit sig_noHayAsistenciasDelAlumno();


    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerAsistencias::obtenerPresentesInfantilesEntreFechas(QDate fecha_inicial, QDate fecha_final, int id_cliente, bool rellenarConObjetosNulosLosDiasSinAsistencia)
{
    bool salida = true;

    QSqlQuery query;
    QString strQuery;

    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    if (id_cliente == -1){

        //strQuery = "SELECT cliente_asistencia.*, cliente.*, cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente, danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza WHERE danza_clase.estado = 'Habilitado' AND danza.estado = 'Habilitado' AND cliente_asistencia.estado = 'Activa' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY fecha, apellido, primer_nombre";

        strQuery = "SELECT "
                   "presente.*, "
                   "cliente.*, "
                   "compra.id_cliente AS id_cliente, "
                   "cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente, "
                   "clase.nombre AS nombre_clase, "
                   "danza.nombre AS nombre_actividad "
                   "FROM clase_asistencia_infantil presente "
                   "INNER JOIN abono_infantil_compra compra "
                   "ON presente.id_abono_infantil_compra = compra.id "
                   "INNER JOIN danza_clase clase "
                   "ON presente.id_danza_clase = clase.id "
                   "INNER JOIN danza "
                   "ON clase.id_danza = danza.id "
                   "INNER JOIN cliente "
                   "ON cliente.id = compra.id_cliente "
                   "WHERE '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= presente.fecha "
                   "AND presente.fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' "
                   "AND clase.estado = 'Habilitado' "
                   "AND danza.estado = 'Habilitado' "
                   "AND presente.estado = 'Activa' "
                   "ORDER BY presente.id DESC";
        
    }else{
        strQuery = "SELECT "
                   "presente.*, "
                   "compra.id_cliente AS id_cliente, "
                   "clase.nombre AS nombre_clase, "
                   "danza.nombre AS nombre_actividad "
                   "FROM clase_asistencia_infantil presente "
                   "INNER JOIN abono_infantil_compra compra "
                   "ON presente.id_abono_infantil_compra = compra.id "
                   "INNER JOIN danza_clase clase "
                   "ON presente.id_danza_clase = clase.id "
                   "INNER JOIN danza "
                   "ON clase.id_danza = danza.id "
                   "WHERE compra.id_cliente = "+QString::number(id_cliente)+" "
                   "AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= presente.fecha "
                   "AND presente.fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' "
                   "AND clase.estado = 'Habilitado' "
                   "AND danza.estado = 'Habilitado' "
                   "AND presente.estado = 'Activa' "
                   "ORDER BY presente.id DESC";

    }

    query.prepare(strQuery);
    QList<QObject*> listaClaseAsistenciaObj;
    QList<QObject*> listaClienteAsistenciaObj;

    if( !query.exec() ) {
        qDebug() << query.lastError();
        salida = false;
    }
    else
    {
        for( int r=0; query.next(); r++ ) {
            ClaseAsistencia * claseAsistencia = new ClaseAsistencia();
            claseAsistencia->setId(query.value("id").toInt());
            claseAsistencia->setId_cliente(query.value("id_cliente").toInt());
            claseAsistencia->setId_clase_horario(query.value("id_danza_clase").toInt());
            claseAsistencia->setFecha(query.value("fecha").toDateTime());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            claseAsistencia->setEstado(query.value("estado").toString());
            if (query.value("nombre_cliente").isValid())
                claseAsistencia->setNombre_cliente(query.value("nombre_cliente").toString());


            if (rellenarConObjetosNulosLosDiasSinAsistencia) {
                while (fecha_inicial.daysTo(claseAsistencia->fecha().date()) > 0){
                    listaClaseAsistenciaObj.append(NULL);
                    fecha_inicial = fecha_inicial.addDays(1);
                }
                listaClaseAsistenciaObj.append(claseAsistencia);
                fecha_inicial = fecha_inicial.addDays(1);
            }
            else {
                listaClaseAsistenciaObj.append(claseAsistencia);


                if (id_cliente == -1) {
                    listaClienteAsistenciaObj.append(this->extraerAlumnoDelQueryDeAsistencias(query));
                }
            }

        }

        if (rellenarConObjetosNulosLosDiasSinAsistencia) {
            while (fecha_inicial.daysTo(fecha_final) >= 0){
                listaClaseAsistenciaObj.append(NULL);
                fecha_inicial = fecha_inicial.addDays(1);
            }
        }

    }

    qDebug() << "query managerasistencias infantiles: " << query.executedQuery();

    if (listaClaseAsistenciaObj.count() > 0)
        emit sig_listaClaseAsistenciasInfantil(listaClaseAsistenciaObj,listaClienteAsistenciaObj);
    else
        emit sig_noHayAsistenciasDelAlumnoInfantil();


    this->controlarMensajesDeError(query);
    return salida;
}

CMAlumno * ManagerAsistencias::extraerAlumnoDelQueryDeAsistencias(QSqlQuery query){
    CMAlumno * objAlumnoResult = new CMAlumno();
    objAlumnoResult->setId(query.value("id_cliente").toInt());
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
    return objAlumnoResult;
}


bool ManagerAsistencias::obtenerPresentesDelAlumno(int id_cliente, int limite) {
    bool salida = true;

    QSqlQuery query;
    QString strQuery;


    //SELECT cliente_asistencia.*,abono_asistencia.credencial_firmada,danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza LEFT JOIN abono_asistencia ON abono_asistencia.id_cliente_asistencia = cliente_asistencia.id WHERE id_cliente = 1 ORDER BY fecha DESC LIMIT 3
    if (limite == 0)
        strQuery = "SELECT cliente_asistencia.*,abono_asistencia.credencial_firmada,danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza LEFT JOIN abono_asistencia ON abono_asistencia.id_cliente_asistencia = cliente_asistencia.id WHERE cliente_asistencia.estado = 'Activa' AND id_cliente = "+QString::number(id_cliente)+" ORDER BY cliente_asistencia.id DESC";
    else
        strQuery = "SELECT cliente_asistencia.*,abono_asistencia.credencial_firmada,danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza LEFT JOIN abono_asistencia ON abono_asistencia.id_cliente_asistencia = cliente_asistencia.id WHERE cliente_asistencia.estado = 'Activa' AND id_cliente = "+QString::number(id_cliente)+" ORDER BY cliente_asistencia.id DESC LIMIT "+QString::number(limite);
    query.prepare(strQuery);
    QList<QObject*> listaClaseAsistenciaObj;

    if( !query.exec() ) {
        qDebug() << query.lastError();
        salida = false;
    }
    else
    {
        for( int r=0; query.next(); r++ ) {
            ClaseAsistencia * claseAsistencia = new ClaseAsistencia();
            claseAsistencia->setId(query.value(0).toInt());
            claseAsistencia->setId_cliente(query.value(1).toInt());
            claseAsistencia->setId_clase_horario(query.value(2).toInt());
            claseAsistencia->setFecha(query.value(3).toDateTime());
            claseAsistencia->setClase_debitada(query.value(4).toString());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            claseAsistencia->setCredencial_firmada(query.value("credencial_firmada").toString());
            listaClaseAsistenciaObj.append(claseAsistencia);
        }
    }

    QList<QObject*> list;

    if (listaClaseAsistenciaObj.count() > 0)
        emit sig_listaClaseAsistencias(listaClaseAsistenciaObj,list);
    else
        emit sig_noHayAsistenciasDelAlumno();


    this->controlarMensajesDeError(query);
    return salida;
}

bool ManagerAsistencias::traerAlumnosInfantilesAsistidoresDelMesPorClase(int id_clase, QDate fecha_inicial, QDate fecha_final)
{
    bool salida = true;

    QSqlQuery query;
    QString strQuery;


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
               "FROM clase_asistencia_infantil presente "

               "INNER JOIN abono_infantil_compra compra ON presente.id_abono_infantil_compra = compra.id "
               "INNER JOIN cliente ON cliente.id = compra.id_cliente "
               "INNER JOIN cuenta_cliente cuenta ON cuenta.id_cliente = cliente.id "
               "INNER JOIN danza_clase clase ON presente.id_danza_clase = clase.id "
               "INNER JOIN danza ON clase.id_danza = danza.id "
               "WHERE clase.estado = 'Habilitado' AND danza.estado = 'Habilitado' AND presente.estado = 'Activa' "
               "AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' "
               "AND clase.id = "+QString::number(id_clase)+" "
               "GROUP BY cliente.id";

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


    if (listaAlumnosAsistidoresDelMesPorClase.count() > 0){
        emit sig_listaAlumnos(listaAlumnosAsistidoresDelMesPorClase);
    }
    else{
        emit sig_noHayAsistenciasDelAlumno();
    }




    this->controlarMensajesDeError(query);
    return salida;
}

void ManagerAsistencias::intentarRegistrarPresenteTablaInfantil()
{
    emit sig_intentarRegistrarPresenteTablaInfantil();
}

QList<QObject *> ManagerAsistencias::traerInscripcionesDelAlumno(int id_cliente)
{
    QSqlQuery query;


    QString strQuery;

    strQuery = "SELECT danza.nombre AS nombre_actividad, clase.nombre AS nombre_clase, clase.*, inscripcion.* "
    "FROM inscripcion_cliente_clase inscripcion "
    "INNER JOIN cliente ON cliente.id = inscripcion.id_cliente "
    "INNER JOIN danza_clase clase ON clase.id = inscripcion.id_danza_clase "
    "INNER JOIN danza ON danza.id = clase.id_danza "
    "WHERE danza.estado = 'Habilitado' AND clase.estado = 'Habilitado' "
    "AND cliente.id = "+QString::number(id_cliente);

    query.prepare(strQuery);
    QList<QObject*> listInscripcionesDelAlumno;
    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else
    {
        /*
    int m_id_cliente;
    int m_id_danza_clase;
    QDateTime m_fecha_inscripcion;
    QDateTime m_fecha_vencimiento;
    QString m_estado;
    QString m_nombre_clase;
    QString m_nombre_actividad;
*/

        while(query.next()) { //ESTA MEDIO INCOMPLETO 23/05/2018
            InscripcionClienteClase * inscripcion = new InscripcionClienteClase();
            inscripcion->setId_cliente(id_cliente);
            inscripcion->setId_danza_clase(query.value("id_danza_clase").toInt());
            inscripcion->setNombre_clase(query.value("nombre_clase").toString());
            inscripcion->setNombre_actividad(query.value("nombre_actividad").toString());
            listInscripcionesDelAlumno.append(inscripcion);
        }
    }

    return listInscripcionesDelAlumno;
}

bool ManagerAsistencias::inscribirDesinscribirClienteClase(int id_cliente, int id_danza_clase, bool inscribir)
{
    int salida = 0;

    //"yyyy-MM-dd HH:mm:ss"

    QSqlQuery query;
    if (inscribir){
        query.prepare("INSERT INTO inscripcion_cliente_clase (id_cliente, id_danza_clase, fecha_inscripcion) VALUES (:id_cliente, :id_danza_clase, :fecha_inscripcion)");
        query.bindValue(":id_cliente", id_cliente);
        query.bindValue(":id_danza_clase", id_danza_clase);
        query.bindValue(":fecha_inscripcion", QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
    }
    else {
        query.prepare("DELETE FROM inscripcion_cliente_clase WHERE id_cliente = "+QString::number(id_cliente)+" AND id_danza_clase = "+QString::number(id_danza_clase));
    }


    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        salida = query.lastInsertId().toInt();
    }


    this->controlarMensajesDeError(query);
    return salida;
}

void ManagerAsistencias::enviarSenialCambioDeMes()
{
    emit sig_cambioDeMes();
}

//strQuery = "SELECT cliente_asistencia.*,danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza WHERE id_cliente = "+QString::number(id_cliente)+" AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY fecha";

int ManagerAsistencias::obtenerAsistenciasEntreFechas(QDate fecha_inicial, QDate fecha_final) {
    int salida = 0;

    QSqlQuery query;
    QString strQuery;
    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    strQuery = "SELECT * FROM cliente_asistencia WHERE cliente_asistencia.estado = 'Activa' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY cliente_asistencia.id DESC";
    query.prepare(strQuery);

    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            salida++;
        }
    }


    this->controlarMensajesDeError(query);
    return salida;
}

//QString strQuery = "SELECT COUNT(id_cliente) AS total_asistencias, cliente.* FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id WHERE id_clase_horario = '"+QString::number(id_clase)+"' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' GROUP BY id_cliente ORDER BY COUNT(id_cliente) DESC LIMIT 10";

void ManagerAsistencias::obtenerAlumnosMasAsistidoresEntreFechasPorClase(int id_clase, QDate fecha_inicial, QDate fecha_final) {
    int salida = 0;

    QList<QObject*> listaAlumnosObj;
    QList<int> listaTotalAsistencias;
    listaAlumnosObj.clear();
    listaTotalAsistencias.clear();
    QSqlQuery query;
    QString strQuery;
    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));
    strQuery = "SELECT cliente.*,COUNT(id_cliente) AS total_asistencias FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id WHERE cliente_asistencia.estado = 'Activa' AND id_clase_horario = '"+QString::number(id_clase)+"' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' GROUP BY id_cliente ORDER BY COUNT(id_cliente) DESC LIMIT 5";
    qDebug() << "strQuery obtenerAlumnosMasAsistidoresEntreFechasPorClase: " << strQuery;
    query.prepare(strQuery);

    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            salida++;
            CMAlumno * objAlumnoResult = new CMAlumno();
            objAlumnoResult->setId(query.value(0).toInt());
            objAlumnoResult->setApellido(query.value(1).toString());
            objAlumnoResult->setPrimerNombre(query.value(2).toString());
            objAlumnoResult->setSegundoNombre(query.value(3).toString());
            objAlumnoResult->setGenero(query.value(4).toString());
            objAlumnoResult->setNacimiento(query.value(5).toDate());
            objAlumnoResult->setDni(query.value(6).toString());
            objAlumnoResult->setTelefonoFijo(query.value(7).toString());
            objAlumnoResult->setTelefonoCelular(query.value(8).toString());
            objAlumnoResult->setCorreo(query.value(9).toString());
            objAlumnoResult->setNota(query.value(10).toString());
            objAlumnoResult->setEstado(query.value(11).toString());
            objAlumnoResult->setBlameUser(query.value(12).toString());
            objAlumnoResult->setBlameTimeStamp(query.value(13).toDateTime());
            objAlumnoResult->setFechaAlta(query.value(14).toDateTime());
            objAlumnoResult->setFecha_matriculacion_infantil(query.value("fecha_matriculacion_infantil").toDateTime());
            listaTotalAsistencias.append(query.value("total_asistencias").toInt());
            listaAlumnosObj.append(objAlumnoResult);
        }
    }
    emit sig_listaAlumnosMasAsistidores(listaTotalAsistencias, listaAlumnosObj);


    this->controlarMensajesDeError(query);
    return;
}

int ManagerAsistencias::obtenerAsistenciasPorClaseGeneroEntreFechas(int id_clase, QString genero, QDate fecha_inicial, QDate fecha_final) {
    int salida = 0;

    QSqlQuery query;
    QString strQuery;
    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    strQuery = "SELECT * FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id WHERE cliente_asistencia.estado = 'Activa' AND cliente.genero = '"+genero+"' AND id_clase_horario = '"+QString::number(id_clase)+"' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY fecha";
    //SELECT * FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id WHERE cliente.genero = 'Femenino' AND cliente_asistencia.id_clase_horario = '1' AND '2015-08-22 00:00:00' <= cliente_asistencia.fecha AND cliente_asistencia.fecha <= '2015-08-29 23:59:59' ORDER BY cliente_asistencia.fecha
    qDebug() << "strQuery mujeres: " << strQuery;
    query.prepare(strQuery);

    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            salida++;
        }
    }


    this->controlarMensajesDeError(query);
    return salida;
}



int ManagerAsistencias::obtenerAsistenciasEntreFechasPorActividad(int id_actividad,QDate fecha_inicial, QDate fecha_final) {
    int salida = 0;

    QList<QObject*> listaClaseAsistenciaObj;
    QList<QObject*> listaClienteAsistenciaObj;
    QSqlQuery query;
    QString strQuery;
    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    strQuery = "SELECT cliente_asistencia.*, cliente.*, cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente, danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza WHERE cliente_asistencia.estado = 'Activa' AND danza.id = "+QString::number(id_actividad)+" AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY cliente_asistencia.id DESC";
    //strQuery = "SELECT cliente_asistencia.*, cliente.apellido || ", " || cliente.primer_nombre AS nombre_cliente FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id WHERE id_actividad = '"+QString::number(id_actividad)+"' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY fecha";

    query.prepare(strQuery);

    qDebug() << "Query!!!: " << strQuery;

    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            salida++;
            ClaseAsistencia * claseAsistencia = new ClaseAsistencia();
            claseAsistencia->setId(query.value(0).toInt());
            claseAsistencia->setId_cliente(query.value(1).toInt());
            claseAsistencia->setId_clase_horario(query.value(2).toInt());
            claseAsistencia->setFecha(query.value(3).toDateTime());
            claseAsistencia->setClase_debitada(query.value(4).toString());
            if (query.value("nombre_cliente").isValid())
                claseAsistencia->setNombre_cliente(query.value("nombre_cliente").toString());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            listaClaseAsistenciaObj.append(claseAsistencia);
            listaClienteAsistenciaObj.append(this->extraerAlumnoDelQueryDeAsistencias(query));

        }
    }

    if (listaClaseAsistenciaObj.count() > 0)
        emit sig_listaClaseAsistencias(listaClaseAsistenciaObj, listaClienteAsistenciaObj);
    else
        emit sig_noHayAsistenciasDelAlumno();


    this->controlarMensajesDeError(query);
    return salida;
}

int ManagerAsistencias::obtenerAsistenciasInfantilesEntreFechasPorActividad(int id_actividad, QDate fecha_inicial, QDate fecha_final)
{
    int salida = 0;

    QList<QObject*> listaClaseAsistenciaObj;
    QList<QObject*> listaClienteAsistenciaObj;
    QSqlQuery query;
    QString strQuery;
    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    strQuery = "SELECT "
               "presente.*, "
               "cliente.*, "
               "compra.id_cliente AS id_cliente, "
               "cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente, "
               "clase.nombre AS nombre_clase, "
               "danza.nombre AS nombre_actividad "
               "FROM clase_asistencia_infantil presente "
               "INNER JOIN abono_infantil_compra compra "
               "ON presente.id_abono_infantil_compra = compra.id "
               "INNER JOIN cliente "
               "ON cliente.id = compra.id_cliente "
               "INNER JOIN danza_clase clase "
               "ON presente.id_danza_clase = clase.id "
               "INNER JOIN danza "
               "ON clase.id_danza = danza.id "
               "WHERE '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= presente.fecha "
               "AND presente.fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' "
               "AND clase.estado = 'Habilitado' "
               "AND danza.estado = 'Habilitado' "
               "AND danza.id = "+QString::number(id_actividad);
               "AND presente.estado = 'Activa' "
               "ORDER BY presente.id DESC";

    query.prepare(strQuery);

    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else
    {
        for( int r=0; query.next(); r++ ) {
            ClaseAsistencia * claseAsistencia = new ClaseAsistencia();
            claseAsistencia->setId(query.value("id").toInt());
            claseAsistencia->setId_cliente(query.value("id_cliente").toInt());
            claseAsistencia->setId_clase_horario(query.value("id_danza_clase").toInt());
            claseAsistencia->setFecha(query.value("fecha").toDateTime());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            claseAsistencia->setEstado(query.value("estado").toString());
            if (query.value("nombre_cliente").isValid())
                claseAsistencia->setNombre_cliente(query.value("nombre_cliente").toString());

            listaClaseAsistenciaObj.append(claseAsistencia);
            listaClienteAsistenciaObj.append(this->extraerAlumnoDelQueryDeAsistencias(query));

        }
    }

    if (listaClaseAsistenciaObj.count() > 0)
        emit sig_listaClaseAsistenciasInfantil(listaClaseAsistenciaObj,listaClienteAsistenciaObj);
    else
        emit sig_noHayAsistenciasDelAlumnoInfantil();


    this->controlarMensajesDeError(query);
    return salida;
}

int ManagerAsistencias::obtenerAsistenciasEntreFechasPorClase(int id_clase,QDate fecha_inicial, QDate fecha_final) {
    int salida = 0;

    QList<QObject*> listaClaseAsistenciaObj;
    QList<QObject*> listaClienteAsistenciaObj;
    QSqlQuery query;
    QString strQuery;
    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    strQuery = "SELECT cliente_asistencia.*, cliente.*, cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente, danza_clase.nombre AS nombre_clase, danza.nombre AS nombre_actividad FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id LEFT JOIN danza_clase ON cliente_asistencia.id_clase_horario = danza_clase.id LEFT JOIN danza ON danza.id = danza_clase.id_danza WHERE cliente_asistencia.estado = 'Activa' AND cliente_asistencia.id_clase_horario = '"+QString::number(id_clase)+"' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY cliente_asistencia.id DESC";
    //strQuery = "SELECT cliente_asistencia.*, cliente.apellido || ", " || cliente.primer_nombre AS nombre_cliente FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id WHERE id_clase_horario = '"+QString::number(id_clase)+"' AND '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= fecha AND fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' ORDER BY fecha";

    query.prepare(strQuery);

    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            salida++;
            ClaseAsistencia * claseAsistencia = new ClaseAsistencia();
            claseAsistencia->setId(query.value(0).toInt());
            claseAsistencia->setId_cliente(query.value(1).toInt());
            claseAsistencia->setId_clase_horario(query.value(2).toInt());
            claseAsistencia->setFecha(query.value(3).toDateTime());
            claseAsistencia->setClase_debitada(query.value(4).toString());
            if (query.value("nombre_cliente").isValid())
                claseAsistencia->setNombre_cliente(query.value("nombre_cliente").toString());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            listaClaseAsistenciaObj.append(claseAsistencia);
            listaClienteAsistenciaObj.append(this->extraerAlumnoDelQueryDeAsistencias(query));
        }
    }

    if (listaClaseAsistenciaObj.count() > 0)
        emit sig_listaClaseAsistencias(listaClaseAsistenciaObj, listaClienteAsistenciaObj);
    else
        emit sig_noHayAsistenciasDelAlumno();


    this->controlarMensajesDeError(query);
    return salida;
}

QList<QObject*> ManagerAsistencias::obtenerAsistenciasDelAlumnoEntreFechasPorClase(int id_clase, int id_cliente, QDate fecha_inicial, QDate fecha_final, bool rellenarConObjetosNulosLosDiasSinAsistencia) {
    int salida = 0;

    QDate ultimaFechaAsistencia;
    bool primera_vez = true;

    QList<QObject*> listaClaseAsistenciaObj;
    QList<QObject*> listaClienteAsistenciaObj;
    QSqlQuery query;
    QString strQuery;
    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    strQuery = "SELECT "
               "presente.*, "
               "cliente.*, "
               "compra.id_cliente AS id_cliente, "
               "cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente, "
               "clase.nombre AS nombre_clase, "
               "danza.nombre AS nombre_actividad "
               "FROM clase_asistencia_infantil presente "
               "INNER JOIN abono_infantil_compra compra "
               "ON presente.id_abono_infantil_compra = compra.id "
               "INNER JOIN cliente "
               "ON cliente.id = compra.id_cliente "
               "INNER JOIN danza_clase clase "
               "ON presente.id_danza_clase = clase.id "
               "INNER JOIN danza "
               "ON clase.id_danza = danza.id "
               "WHERE '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= presente.fecha "
               "AND cliente.id = "+QString::number(id_cliente)+" "
               "AND presente.fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' "
               "AND clase.estado = 'Habilitado' "
               "AND danza.estado = 'Habilitado' "
               "AND compra.estado = 'Habilitado' "
               "AND presente.estado = 'Activa' "
               "AND presente.id_danza_clase = "+QString::number(id_clase)+" "
               "ORDER BY cliente.apellido";

    query.prepare(strQuery);

    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else
    {
        for( int r=0; query.next(); r++ ) {
            ClaseAsistencia * claseAsistencia = new ClaseAsistencia();
            claseAsistencia->setId(query.value("id").toInt());
            claseAsistencia->setId_cliente(query.value("id_cliente").toInt());
            claseAsistencia->setId_clase_horario(query.value("id_danza_clase").toInt());
            claseAsistencia->setFecha(query.value("fecha").toDateTime());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            claseAsistencia->setEstado(query.value("estado").toString());
            claseAsistencia->setNombre_cliente(query.value("nombre_cliente").toString());


            if (rellenarConObjetosNulosLosDiasSinAsistencia) {
                while (fecha_inicial.daysTo(claseAsistencia->fecha().date()) > 0){
                    listaClaseAsistenciaObj.append(NULL);
                    fecha_inicial = fecha_inicial.addDays(1);
                }
                if (ultimaFechaAsistencia.daysTo(claseAsistencia->fecha().date()) != 0) {
                    listaClaseAsistenciaObj.append(claseAsistencia);
                    fecha_inicial = fecha_inicial.addDays(1);
                    ultimaFechaAsistencia = claseAsistencia->fecha().date();
                }
                if (primera_vez) {
                    listaClaseAsistenciaObj.append(claseAsistencia);
                    fecha_inicial = fecha_inicial.addDays(1);
                    ultimaFechaAsistencia = claseAsistencia->fecha().date();
                    primera_vez = false;
                }

            }
            else{
                qDebug() << "Sin relleno";
                listaClaseAsistenciaObj.append(claseAsistencia);
                listaClienteAsistenciaObj.append(this->extraerAlumnoDelQueryDeAsistencias(query));
            }
        }

        if (rellenarConObjetosNulosLosDiasSinAsistencia) {
            while (fecha_inicial.daysTo(fecha_final) >= 0){
                listaClaseAsistenciaObj.append(NULL);
                fecha_inicial = fecha_inicial.addDays(1);
            }
        }

    }


    if (listaClaseAsistenciaObj.count() > 0)
        emit sig_listaClaseAsistenciasInfantil(listaClaseAsistenciaObj,listaClienteAsistenciaObj,id_cliente);
    else
        emit sig_noHayAsistenciasDelAlumnoInfantil();


    this->controlarMensajesDeError(query);
    return listaClaseAsistenciaObj;
}

int ManagerAsistencias::obtenerAsistenciasInfantilesEntreFechasPorClase(int id_clase, QDate fecha_inicial, QDate fecha_final, bool rellenarConObjetosNulosLosDiasSinAsistencia)
{
    int salida = 0;

    QList<QObject*> listaClaseAsistenciaObj;
    QList<QObject*> listaClienteAsistenciaObj;
    QSqlQuery query;
    QString strQuery;
    QDateTime dt_fecha_inicial;
    QDateTime dt_fecha_final;
    dt_fecha_inicial.setDate(fecha_inicial);
    dt_fecha_inicial.setTime(QTime(0,0,0));
    dt_fecha_final.setDate(fecha_final);
    dt_fecha_final.setTime(QTime(23,59,59));

    strQuery = "SELECT "
               "presente.*, "
               "cliente.*, "
               "compra.id_cliente AS id_cliente, "
               "cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente, "
               "clase.nombre AS nombre_clase, "
               "danza.nombre AS nombre_actividad "
               "FROM clase_asistencia_infantil presente "
               "INNER JOIN abono_infantil_compra compra "
               "ON presente.id_abono_infantil_compra = compra.id "
               "INNER JOIN cliente "
               "ON cliente.id = compra.id_cliente "
               "INNER JOIN danza_clase clase "
               "ON presente.id_danza_clase = clase.id "
               "INNER JOIN danza "
               "ON clase.id_danza = danza.id "
               "WHERE '"+dt_fecha_inicial.toString("yyyy-MM-dd HH:mm:ss")+"' <= presente.fecha "
               "AND presente.fecha <= '"+dt_fecha_final.toString("yyyy-MM-dd HH:mm:ss")+"' "
               "AND presente.estado = 'Activa' "
               "AND clase.estado = 'Habilitado' "
               "AND danza.estado = 'Habilitado' "
               "AND presente.id_danza_clase = "+QString::number(id_clase)+" ";

    query.prepare(strQuery);

    if( !query.exec() ) {
        qDebug() << query.lastError();
    }
    else
    {
        for( int r=0; query.next(); r++ ) {
            ClaseAsistencia * claseAsistencia = new ClaseAsistencia();
            claseAsistencia->setId(query.value("id").toInt());
            claseAsistencia->setId_cliente(query.value("id_cliente").toInt());
            claseAsistencia->setId_clase_horario(query.value("id_danza_clase").toInt());
            claseAsistencia->setFecha(query.value("fecha").toDateTime());
            claseAsistencia->setNombre_clase(query.value("nombre_clase").toString());
            claseAsistencia->setNombre_actividad(query.value("nombre_actividad").toString());
            claseAsistencia->setEstado(query.value("estado").toString());
            claseAsistencia->setNombre_cliente(query.value("nombre_cliente").toString());


            if (rellenarConObjetosNulosLosDiasSinAsistencia) {
                while (fecha_inicial.daysTo(claseAsistencia->fecha().date()) > 0){
                    listaClaseAsistenciaObj.append(NULL);
                    fecha_inicial = fecha_inicial.addDays(1);
                }
                listaClaseAsistenciaObj.append(claseAsistencia);
                fecha_inicial = fecha_inicial.addDays(1);
            }
            else{
                listaClaseAsistenciaObj.append(claseAsistencia);
                listaClienteAsistenciaObj.append(this->extraerAlumnoDelQueryDeAsistencias(query));
            }
        }

        if (rellenarConObjetosNulosLosDiasSinAsistencia) {

            while (fecha_inicial.daysTo(fecha_final) >= 0){
                listaClaseAsistenciaObj.append(NULL);
                fecha_inicial = fecha_inicial.addDays(1);
            }
        }
    }

    if (listaClaseAsistenciaObj.count() > 0)
        emit sig_listaClaseAsistenciasInfantil(listaClaseAsistenciaObj,listaClienteAsistenciaObj);
    else
        emit sig_noHayAsistenciasDelAlumnoInfantil();


    this->controlarMensajesDeError(query);
    return salida;
}

void ManagerAsistencias::controlarMensajesDeError(QSqlQuery query) {
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

//SELECT cliente_asistencia.*, cliente.apellido || ", " || cliente.primer_nombre AS nombre_cliente FROM cliente_asistencia LEFT JOIN cliente ON cliente_asistencia.id_cliente = cliente.id WHERE '2015-07-14 00:00:00' <= fecha AND fecha <= '2015-07-14 23:59:59' ORDER BY fecha

