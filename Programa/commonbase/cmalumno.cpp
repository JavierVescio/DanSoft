#include "cmalumno.h"
#include <QDebug>

CMAlumno::CMAlumno()
{
    m_genero = "Femenino";
}

CMAlumno::CMAlumno(QString apellido, QString primerNombre, QString dni) {
    this->apellido = apellido;
    this->primerNombre = primerNombre;
    this->dni = dni;
}

void CMAlumno::setDni(QString dni) {
    if (dni == "..")
        dni = "";
    this->dni = dni;
}

QString CMAlumno::getQueryParaBusqueda() {
    QString salida = "";
    if (dni != "") {
        salida = "dni =  '"+dni+"' ";
    }
    else {
        if (apellido != "" && primerNombre != ""){
            salida = "apellido LIKE  '"+apellido+"%' AND primer_nombre LIKE '"+primerNombre+"%' ";
        }
        else {
            if (apellido != "") {
                salida = "apellido LIKE  '"+apellido+"%' ";
            }
            else {
                salida = "primer_nombre LIKE  '"+primerNombre+"%' ";
            }
        }
    }
    return salida;
}

QString CMAlumno::getQueryParaActualizacion() {
    QString salida = "";
    salida = "apellido='"+apellido+"', primer_nombre='"+primerNombre+"', segundo_nombre='"+m_segundoNombre+"', genero='"+m_genero+"', fecha_nacimiento='"+m_nacimiento.toString("yyyy-MM-dd")+"', dni='"+dni+"', telefono_fijo='"+m_telefonoFijo+"', telefono_celular='"+m_telefonoCelular+"', correo='"+m_correo+"', nota='"+m_nota+"', estado='"+m_estado+"', blame_user='"+m_blameUser+"', blame_timestamp=CURRENT_TIMESTAMP";
    return salida;
}

QString CMAlumno::toString() {
    return "Id: " + QString::number(id) + ". Apellido: " + apellido
            + ". Nombre: " + primerNombre + ". Dni: " + dni + ".";
}

QDateTime CMAlumno::fechaAlta() const
{
    return m_fechaAlta;
}

float CMAlumno::credito_cuenta() const
{
    return m_credito_cuenta;
}

int CMAlumno::id_cuenta_alumno() const
{
    return m_id_cuenta_alumno;
}

bool CMAlumno::inscripto_a_clase() const
{
    return m_inscripto_a_clase;
}

QDateTime CMAlumno::fecha_matriculacion_infantil() const
{
    return m_fecha_matriculacion_infantil;
}

bool CMAlumno::matriculado() const
{
    if (fecha_matriculacion_infantil().isNull() == false){
        int anio_matriculacion = fecha_matriculacion_infantil().date().year();
        int anio_actual = QDate::currentDate().year();

        if (anio_actual == anio_matriculacion){
            return true;
        }
    }
    return false;
}

void CMAlumno::setSegundoNombre(QString arg)
{
    if (m_segundoNombre == arg)
        return;

    m_segundoNombre = arg;
}

void CMAlumno::setGenero(QString arg)
{
    if (m_genero == arg)
        return;

    m_genero = arg;
    emit generoChanged(arg);
}

void CMAlumno::setNacimiento(QDate arg)
{
    if (m_nacimiento == arg)
        return;

    m_nacimiento = arg;
    emit nacimientoChanged(arg);
}

void CMAlumno::setTelefonoFijo(QString arg)
{
    if (m_telefonoFijo == arg)
        return;

    m_telefonoFijo = arg;
    emit telefonoFijoChanged(arg);
}

void CMAlumno::setTelefonoCelular(QString arg)
{
    if (m_telefonoCelular == arg)
        return;

    m_telefonoCelular = arg;
    emit telefonoCelularChanged(arg);
}

void CMAlumno::setCorreo(QString arg)
{
    if (m_correo == arg)
        return;

    m_correo = arg;
    emit correoChanged(arg);
}

void CMAlumno::setNota(QString arg)
{
    if (m_nota == arg)
        return;

    m_nota = arg;
    emit notaChanged(arg);
}

void CMAlumno::setEstado(QString arg)
{
    if (m_estado == arg)
        return;

    m_estado = arg;
    emit estadoChanged(arg);
}

void CMAlumno::setBlameUser(QString arg)
{
    if (m_blameUser == arg)
        return;

    m_blameUser = arg;
    emit blameUserChanged(arg);
}

void CMAlumno::setBlameTimeStamp(QDateTime arg)
{
    if (m_blameTimeStamp == arg)
        return;

    m_blameTimeStamp = arg;
    emit blameTimeStampChanged(arg);
}

void CMAlumno::setFechaAlta(QDateTime arg)
{
    if (m_fechaAlta == arg)
        return;

    m_fechaAlta = arg;
    emit fechaAltaChanged(arg);
}

void CMAlumno::setCredito_cuenta(float credito_cuenta)
{
    if (qFuzzyCompare(m_credito_cuenta, credito_cuenta))
        return;

    m_credito_cuenta = credito_cuenta;
    emit credito_cuentaChanged(m_credito_cuenta);
}

void CMAlumno::setId_cuenta_alumno(int id_cuenta_alumno)
{
    if (m_id_cuenta_alumno == id_cuenta_alumno)
        return;

    m_id_cuenta_alumno = id_cuenta_alumno;
    emit id_cuenta_alumnoChanged(m_id_cuenta_alumno);
}

void CMAlumno::setInscripto_a_clase(bool inscripto_a_clase)
{
    if (m_inscripto_a_clase == inscripto_a_clase)
        return;

    m_inscripto_a_clase = inscripto_a_clase;
    emit inscripto_a_claseChanged(m_inscripto_a_clase);
}

void CMAlumno::setFecha_matriculacion_infantil(QDateTime fecha_matriculacion_infantil)
{
    if (m_fecha_matriculacion_infantil == fecha_matriculacion_infantil)
        return;

    m_fecha_matriculacion_infantil = fecha_matriculacion_infantil;
    emit fecha_matriculacion_infantilChanged(m_fecha_matriculacion_infantil);
}

void CMAlumno::setMatriculado(bool matriculado)
{
    if (m_matriculado == matriculado)
        return;

    m_matriculado = matriculado;
    emit matriculadoChanged(m_matriculado);
}
