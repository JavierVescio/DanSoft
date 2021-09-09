#include "gestionbasededatos.h"
#include <QDebug>
#include "../wrapperclassmanagement.h"


///
/// \brief GestionBaseDeDatos::strDataBasePath
///24-03-2018
/// En todos los lugares donde aparece "CURRENT_TIMESTAMP", si no se pasa el parametro al guardar,
/// se guardara como la hora actual en GMT (hora mundial). En esos casos, verificar que despues
/// se traiga la informacion correctamente.
///


const QString GestionBaseDeDatos::strDataBasePath = "./DanSoftDB.db";
const QString GestionBaseDeDatos::strDataBaseOldPath = "./ClassManagementDataBase.db";

//strQueryCrearTablaActivacionDanzaSoft

GestionBaseDeDatos::GestionBaseDeDatos()
{
    if (QFile::exists(strDataBaseOldPath))
        QFile::rename(strDataBaseOldPath,strDataBasePath);

    if (!this->conectarBaseClassManagement()) {
        m_creacionDeTablasOk = false;
    }
    else {
        qDebug() << "\n|||CONEXION A BASE DE DATOS EXITOSA|||";
        m_creacionDeTablasOk = true;
        emit sig_conexionBaseAlumnosOk();
    }

}

bool GestionBaseDeDatos::conectarBaseClassManagement() {
    bool salida = false;
    this->abrirConexion();

    if(!db.open())
    {
        qDebug() << db.lastError();
        salida = false;
        qDebug("Falló conexión a la base de datos.");
    }
    else {
        /*21-07-15 ¡¡¡El query siguiente es super importante!!! Resulta que SQLite 3, por defecto, tiene las foreign keys
         * desactivadas. Entonces, si elimino un alumno, en la table de presentes aun van a seguir estando
         * sus asistencias, pese a estar la foreign key mas el on delete cascade.
         * Por medio de este pragma, se activan las foreign keys en esta conexión, entonces
         * por supuesto, de eliminar un alumno, se eliminan todas las tablas donde haya asociación a directa o no a él.
         * Si entrás a la base de datos desde el SQLite Manager las foreign keys están activadas en forma predeterminada.*/
        QSqlQuery query;
        query.exec("PRAGMA foreign_keys = ON;");
        if( !query.exec() ) {
            qDebug() << "Falló Pragma Foreign Keys - " << query.lastError();
        }

        if (this->crearTablas()) {
            salida = true;
        }
    }

    return salida;
}

void GestionBaseDeDatos::beginTransaction(){
    QSqlQuery query;
    query.exec("BEGIN;");
}

void GestionBaseDeDatos::commitTransaction() {
    QSqlQuery query;
    query.exec("COMMIT;");
}

void GestionBaseDeDatos::rollbackTransaction() {
    QSqlQuery query;
    query.exec("ROLLBACK;");
}

bool GestionBaseDeDatos::crearTablas() {
    bool salida = false;


    QString strQueryCrearTablaAlumno =
            "CREATE TABLE IF NOT EXISTS [cliente] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT,"
            "apellido VARCHAR(45) NOT NULL,"
            "primer_nombre VARCHAR(45) NOT NULL,"
            "segundo_nombre VARCHAR(45),"
            "genero VARCHAR(20) NOT NULL,"
            "fecha_nacimiento DATE,"
            "dni VARCHAR(20),"
            "telefono_fijo VARCHAR(20),"
            "telefono_celular VARCHAR(20),"
            "correo VARCHAR(45),"
            "nota VARCHAR(140),"
            "estado VARCHAR(20) NOT NULL, "
            "blame_user VARCHAR(45),"
            "blame_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "fecha_alta DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "fecha_matriculacion_infantil DATETIME)";

    QString strQueryCrearTablaClienteFoto =
            "CREATE TABLE IF NOT EXISTS [cliente_foto] "
            "(id_cliente integer UNIQUE,"
            "foto blob NOT NULL, "
            "FOREIGN KEY(id_cliente) REFERENCES cliente(id) ON DELETE CASCADE)";

    ///Deberia llamarse "cliente_asistencia_adulto"
    QString strQueryCrearTablaClienteAsistencia =
            "CREATE TABLE IF NOT EXISTS [cliente_asistencia] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT,"
            "id_cliente integer NOT NULL,"
            "id_clase_horario integer NOT NULL DEFAULT -1,"
            "fecha datetime NOT NULL, "
            "clase_debitada varchar[2] NOT NULL DEFAULT Si, "
            "estado VARCHAR(20) NOT NULL, "
            "FOREIGN KEY(id_cliente) REFERENCES cliente(id) ON DELETE CASCADE)";

    QString strQueryCrearTablaAbonoAdulto =
            "CREATE TABLE IF NOT EXISTS [abono_adulto] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "precio_actual REAL NOT NULL, "
            "total_clases integer NOT NULL UNIQUE,"
            "fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "estado VARCHAR(20) NOT NULL DEFAULT 'Habilitado')";

    ///Deberia llamarse "abono_adulto_compra"
    QString strQueryCrearTablaAbono =
            "CREATE TABLE IF NOT EXISTS [abono] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "id_cliente integer NOT NULL, "
            "id_abono_adulto integer DEFAULT -1, "
            "precio_abono REAL DEFAULT -1, "
            "fecha_vigente date NOT NULL,"
            "fecha_vencimiento date NOT NULL,"
            "tipo VARCHAR(8) NOT NULL,"
            "cantidad_comprada integer NOT NULL, "
            "cantidad_clases integer NOT NULL,"
            "cantidad_restante integer NOT NULL, "
            "estado VARCHAR(20) NOT NULL, "
            "fecha_compra DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "blame_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "FOREIGN KEY(id_abono_adulto) REFERENCES abono_adulto(id), "
            "FOREIGN KEY(id_cliente) REFERENCES cliente(id) ON DELETE CASCADE)";

    QString strQueryCrearTablaAbonoAsistencia =
            "CREATE TABLE IF NOT EXISTS [abono_asistencia] "
            "(id_abono integer NOT NULL, "
            "id_cliente_asistencia int NOT NULL, "
            "credencial_firmada varchar[2] NOT NULL DEFAULT Si, "
            "FOREIGN KEY(id_abono) REFERENCES abono(id) ON DELETE CASCADE, "
            "FOREIGN KEY(id_cliente_asistencia) REFERENCES cliente_asistencia(id) ON DELETE CASCADE)";

    QString strQueryCrearTablaDanza =
            "CREATE TABLE IF NOT EXISTS [danza] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "nombre VARCHAR(45) NOT NULL, "
            "estado VARCHAR(20) NOT NULL, "
            "blame_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)";

    QString strQueryCrearTablaEvento =
            "CREATE TABLE IF NOT EXISTS [eventos] "
            "(id integer PRIMARY KEY AUTOINCREMENT,"
            "descripcion text,"
            "fechaInicial date NOT NULL)";

    QString strQueryCrearTablaActivacionDanzaSoft =
            "CREATE TABLE IF NOT EXISTS [activacion_programa] "
            "(serial text PRIMARY KEY)";

    QString strQueryCrearTablaDanzaClase =
            "CREATE TABLE IF NOT EXISTS [danza_clase] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "id_danza integer NOT NULL, "
            "nombre VARCHAR(45) NOT NULL, "
            "estado VARCHAR(20) NOT NULL, "
            "blame_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "categoria VARCHAR(10) NOT NULL DEFAULT 'KidsAdults', "
            "dias_semana VARCHAR(8) DEFAULT '-1', "
            "FOREIGN KEY(id_danza) REFERENCES danza(id))";

    QString strQueryCrearTablaCuentaCliente =
            "CREATE TABLE IF NOT EXISTS [cuenta_cliente] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "id_cliente integer NOT NULL UNIQUE, "
            "credito_actual REAL NOT NULL, "
            "FOREIGN KEY(id_cliente) REFERENCES cliente(id))";

    QString strQueryCrearTablaEstadoOperacion =
            "CREATE TABLE IF NOT EXISTS [tipo_operacion] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "descripcion VARCHAR(140) NOT NULL,"
            "estado VARCHAR(20) NOT NULL DEFAULT 'Habilitado')";

    QString strQueryCrearTablaMovimiento =
            "CREATE TABLE IF NOT EXISTS [movimiento] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "id_tipo_operacion integer, "
            "id_cuenta_cliente integer, "
            "monto REAL NOT NULL, "
            "fecha_movimiento DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "descripcion VARCHAR(140), "
            "credito_cuenta REAL NOT NULL, "
            "codigo_oculto VARCHAR(16) NOT NULL, "
            "FOREIGN KEY(id_tipo_operacion) REFERENCES tipo_operacion(id), "
            "FOREIGN KEY(id_cuenta_cliente) REFERENCES cuenta_cliente(id))";

    QString strQueryCrearTablaAbonoInfantil =
            "CREATE TABLE IF NOT EXISTS [abono_infantil] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "precio_actual REAL NOT NULL, "
            "clases_por_semana integer NOT NULL UNIQUE, "
            "fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "estado VARCHAR(20) NOT NULL DEFAULT 'Habilitado')";

    QString strQueryCrearTablaAbonoInfantilCompra =
            "CREATE TABLE IF NOT EXISTS [abono_infantil_compra] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "id_cliente integer NOT NULL, "
            "id_abono_infantil integer NOT NULL, "
            "fecha_compra DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "precio_abono REAL NOT NULL, "
            "estado VARCHAR(20) NOT NULL, "
            "FOREIGN KEY(id_cliente) REFERENCES cliente(id), "
            "FOREIGN KEY(id_abono_infantil) REFERENCES abono_infantil(id))";

    QString strQueryCrearTablaClaseAsistenciaInfantil =
            "CREATE TABLE IF NOT EXISTS [clase_asistencia_infantil] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "id_abono_infantil_compra integer NOT NULL, "
            "id_danza_clase integer NOT NULL, "
            "fecha DATETIME NOT NULL, "
            "estado VARCHAR(20) NOT NULL, "
            "FOREIGN KEY(id_abono_infantil_compra) REFERENCES abono_infantil_compra(id), "
            "FOREIGN KEY(id_danza_clase) REFERENCES danza_clase(id))";

    QString strQueryCrearTablaResumenMes =
            "CREATE TABLE IF NOT EXISTS [resumen_mes] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "id_cliente integer NOT NULL, "
            "fecha DATE NOT NULL DEFAULT CURRENT_DATE, "
            "ultimo_saldo_parcial_mes REAL NOT NULL, "
            "ultimo_saldo_acumulado_mes REAL NOT NULL, "
            "FOREIGN KEY(id_cliente) REFERENCES cliente(id))";

    QString strQueryCrearTablaInscripcionClienteClase =
            "CREATE TABLE IF NOT EXISTS [inscripcion_cliente_clase] ("
            "id_cliente integer NOT NULL, "
            "id_danza_clase integer NOT NULL, "
            "fecha_inscripcion DATETIME, "
            "fecha_vencimiento DATETIME, "
            "estado VARCHAR(20) NOT NULL DEFAULT 'Habilitado', "
            "FOREIGN KEY(id_cliente) REFERENCES cliente(id), "
            "FOREIGN KEY(id_danza_clase) REFERENCES danza_clase(id))";

    QString strQueryCrearTablaOferta =
            "CREATE TABLE IF NOT EXISTS [oferta] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "nombre VARCHAR(45) NOT NULL, "
            "descripcion VARCHAR(140), "
            "tipo VARCHAR(45) NOT NULL DEFAULT 'Producto', "
            "precio float NOT NULL, "
            "stock integer NOT NULL, "
            "uno_por_alumno TINYINT,"
            "fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, "
            "fecha_vigente_desde DATE, "
            "fecha_vigente_hasta DATE, "
            "estado VARCHAR(20) NOT NULL DEFAULT 'Habilitado')";

    QString strQueryCrearTablaOfertaFoto =
            "CREATE TABLE IF NOT EXISTS [oferta_foto] "
            "(id_oferta integer UNIQUE,"
            "foto blob NOT NULL, "
            "FOREIGN KEY(id_oferta) REFERENCES oferta(id))";

    QString strQueryCrearTablaVenta =
            "CREATE TABLE IF NOT EXISTS [venta] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "id_cliente integer NOT NULL, "
            "fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, "
            "precio_total float NOT NULL, "
            "comentario TEXT, "
            "estado VARCHAR(20) NOT NULL DEFAULT 'Habilitado', "
            "FOREIGN KEY(id_cliente) REFERENCES cliente(id))";

    QString strQueryCrearTablaItemVenta =
            "CREATE TABLE IF NOT EXISTS [item_venta] "
            "(id_oferta integer NOT NULL, "
            "id_venta integer NOT NULL, "
            "cantidad integer NOT NULL, "
            "precio_subtotal float NOT NULL, "
            "FOREIGN KEY(id_oferta) REFERENCES oferta(id), "
            "FOREIGN KEY(id_venta) REFERENCES venta(id) ON DELETE CASCADE)";

    QString strQueryCrearTablaCaja =
            "CREATE TABLE IF NOT EXISTS [caja] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "monto_inicial float NOT NULL, "
            "monto_final float, "
            "monto_segun_sistema float, "
            "comentario VARCHAR(255), "
            "fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, "
            "fecha_cierre DATETIME, "
            "estado VARCHAR(20) NOT NULL DEFAULT 'Habilitado')";

    QString strQueryCrearTablaBackUp =
            "CREATE TABLE IF NOT EXISTS [backup] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "ruta1 VARCHAR(255), "
            "ruta2 VARCHAR(255), "
            "al_cerrar_caja TINYINT NOT NULL, "
            "al_cerrar_sistema TINYINT NOT NULL)";

    QString strQueryCrearTablaMatricula =
            "CREATE TABLE IF NOT EXISTS [matricula] "
            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "tipo VARCHAR(16) DEFAULT 'Infantil',"
            "precio REAL NOT NULL DEFAULT 0,"
            "fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP)";


    QSqlQuery query;
    query.prepare(strQueryCrearTablaAlumno);
    if( !query.exec() ) {
        qDebug() << query.lastError();
        qDebug("Falló 1");
        salida = false;
    }
    else {        
        salida = true;
    }
    if (salida) {
        query.prepare(strQueryCrearTablaClienteFoto);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 5");
            salida = false;
        }
        else {
            salida = true;
        }
    }
    if (salida) {
        query.prepare(strQueryCrearTablaAbonoAdulto);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló strQueryCrearTablaAbonoAdulto");
            salida = false;
        }
        else {
            salida = true;
        }
    }
    if (salida) {
        query.prepare(strQueryCrearTablaClienteAsistencia);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 2");
            salida = false;
        }
        else {
            salida = true;
        }
    }
    if (salida) {
        query.prepare(strQueryCrearTablaAbono);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 3");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaAbonoAsistencia);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 4");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaDanza);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 5");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaDanzaClase);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 6");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaEvento);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 7");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaActivacionDanzaSoft);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 8");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    /////////////////////////////////////////

    if (salida) {
        query.prepare(strQueryCrearTablaCuentaCliente);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 9");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaEstadoOperacion);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 10");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaMovimiento);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 11");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaAbonoInfantil);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 12");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaAbonoInfantilCompra);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 13");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaClaseAsistenciaInfantil);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 14");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaResumenMes);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 14");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaInscripcionClienteClase);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló 14");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaOferta);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló strQueryCrearTablaOferta");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaOfertaFoto);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló strQueryCrearTablaOfertaFoto");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaVenta);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló strQueryCrearTablaVenta");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaItemVenta);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló strQueryCrearTablaItemVenta");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaCaja);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló strQueryCrearTablaCaja");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaBackUp);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló strQueryCrearTablaBackUp");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    if (salida) {
        query.prepare(strQueryCrearTablaMatricula);
        if( !query.exec() ) {
            qDebug() << query.lastError();
            qDebug("Falló strQueryCrearTablaMatricula");
            salida = false;
        }
        else {
            salida = true;
        }
    }

    /*
26/03/2020: Lo siguiente se agrego para que la bd de la version 6.0 siga siendo compatible con la version 6.1
*/

    query.prepare("PRAGMA table_info(cliente)");
    if( !query.exec() ) {
        salida = false;
    }else{
        bool existeColumnaDeFechaDeMatriculacionInfantil = false;
        while (query.next() && existeColumnaDeFechaDeMatriculacionInfantil == false){
            if (query.value("name").toString() == "fecha_matriculacion_infantil")
                existeColumnaDeFechaDeMatriculacionInfantil = true;
        }
        if (existeColumnaDeFechaDeMatriculacionInfantil == false){
            query.prepare("ALTER TABLE cliente ADD COLUMN fecha_matriculacion_infantil DATETIME");
            salida = query.exec();
        }else{
            salida = true;
        }
    }

    return salida;
}

bool GestionBaseDeDatos::creacionDeTablasOk() const
{
    return m_creacionDeTablasOk;
}

int GestionBaseDeDatos::chequeoDeSeguridadDeLaHoraFecha()
{
    ///Se traera el ultimo registro de presente de abono adulto y se extraera la fecha en que se registro.
    /// Si la fecha actual del sistema es anterior a la fecha del presente, se lanzara un error.
    QDate fecha_inicial = QDate::currentDate();
    fecha_inicial = fecha_inicial.addDays(1);
    int cantidad_asistencias = WrapperClassManagement::getManagerAsistencias()->obtenerAsistenciasEntreFechas(fecha_inicial,fecha_inicial.addYears(200));
    //qDebug() << "Cantidad de asistencias encontradas con fecha posterior a la actual: " << cantidad_asistencias;

//        QString mensaje = "La fecha de hoy es "+QDate::currentDate().toString()+" según la computadora.\nSin embargo, en el sistema hay "+QString::number(cantidad_asistencias)+" asistencia/s de adultos registradas en fecha posterior a la mencionada.\nPor favor, corrija la fecha y hora del sistema y, después, vuelva a iniciar DanSoft.";

    return cantidad_asistencias;
}

int GestionBaseDeDatos::agregarInfoBackUp(
        QString ruta1,
        QString ruta2,
        bool al_cerrar_caja,
        bool al_cerrar_sistema)
{
    QSqlQuery query;
    query.prepare("INSERT INTO backup (ruta1,ruta2,al_cerrar_caja,al_cerrar_sistema) "
                  "VALUES (:ruta1,:ruta2,:al_cerrar_caja,:al_cerrar_sistema)");
    query.bindValue(":ruta1", ruta1);
    query.bindValue(":ruta2", ruta2);
    query.bindValue(":al_cerrar_caja", al_cerrar_caja);
    query.bindValue(":al_cerrar_sistema", al_cerrar_sistema);

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    return query.lastInsertId().toInt();
}

bool GestionBaseDeDatos::actualizarInfoBackUp(
        int id,
        QString ruta1,
        QString ruta2,
        bool al_cerrar_caja,
        bool al_cerrar_sistema)
{
    QSqlQuery query;
    query.prepare("UPDATE backup SET "
                  "ruta1 = :ruta1,"
                  "ruta2 = :ruta2,"
                  "al_cerrar_caja = :al_cerrar_caja,"
                  "al_cerrar_sistema = :al_cerrar_sistema "
                  "WHERE id = :id");
    query.bindValue(":id", id);
    query.bindValue(":ruta1", ruta1);
    query.bindValue(":ruta2", ruta2);
    query.bindValue(":al_cerrar_caja", al_cerrar_caja);
    query.bindValue(":al_cerrar_sistema", al_cerrar_sistema);

    if(!query.exec()) {
        qDebug() << query.lastError();
        return false;
    }
    return true;
}

QObject *GestionBaseDeDatos::traerInfoBackUp()
{
    BackUp *obj = NULL;
    QSqlQuery query;

    query.prepare("SELECT * FROM backup ORDER BY id DESC LIMIT 1");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            obj = new BackUp();
            obj->setId(query.value("id").toInt());
            obj->setRuta1(query.value("ruta1").toString());
            obj->setRuta2(query.value("ruta2").toString());
            obj->setAl_cerrar_caja(query.value("al_cerrar_caja").toBool());
            obj->setAl_cerrar_sistema(query.value("al_cerrar_sistema").toBool());
        }
    }
    return obj;
}

bool GestionBaseDeDatos::hacerBackUp(
        QString dir1,
        QString dir2,
        bool dejar_abierta_conexion_bd)
{
    /*QSqlQuery qry;
    qry.prepare( "BEGIN IMMEDIATE;");
    qry.exec();*/
    this->cerrarConexion();

    bool salida = true;
    bool salidaDir1 = true;
    bool salidaDir2 = true;
    QString rutasConflictivas = "";
    QString rutasOk = "";

    if (!dir1.isEmpty()){
        if (QFile::exists(dir1+"/DanSoftDB.db")){
            QFile::remove(dir1+"/DanSoftDB.db");
        }
        salidaDir1 = QFile::copy(strDataBasePath, dir1+"/DanSoftDB.db");
    }
    if (!dir2.isEmpty()){
        if (QFile::exists(dir2+"/DanSoftDB.db")){
            QFile::remove(dir2+"/DanSoftDB.db");
        }
        salidaDir2 = QFile::copy(strDataBasePath, dir2+"/DanSoftDB.db");
    }

    if (!salidaDir1)
        rutasConflictivas = "->"+dir1;
    else
        rutasOk = "->"+dir1;
    if (!salidaDir2){
        if (!rutasConflictivas.isEmpty())
            rutasConflictivas += "\n->"+ dir2;
        else
            rutasConflictivas = "->"+dir2;
    }
    else
        rutasOk = "->"+dir2;


    salida = salidaDir1 * salidaDir2;
    if (!salida){
        emit sig_problemaBackUp(rutasConflictivas,rutasOk);
    }

    //qry.prepare( "ROLLBACK;");
    if (dejar_abierta_conexion_bd){
        this->abrirConexion();
    }else{
        this->cerrarConexion();
    }
    return salida;
}

bool GestionBaseDeDatos::abrirConexion()
{
    if (db.isOpen())
        return true;
    else{
        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(strDataBasePath);
        return db.open();
    }
}

void GestionBaseDeDatos::cerrarConexion()
{
    if (db.isOpen()){
        db.close();
    }
}


