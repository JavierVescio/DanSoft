#include "classmanagementmanager.h"
#include "../wrapperclassmanagement.h"

ClassManagementManager::ClassManagementManager()
{
    //m_versionGratis = true;
    m_versionGratis = true;
    m_limiteDeAlumnos = 20;
    m_sistema_bloqueado = false;
    this->setClienteSeleccionado(NULL);
}

void ClassManagementManager::enviarMail(QString direccion) {
    QDesktopServices::openUrl(QUrl("mailto:"+direccion, QUrl::TolerantMode));

    //QDesktopServices::openUrl(QUrl("mailto:user@foo.com?subject=Test&body=Just a test", QUrl::TolerantMode));
}

QStringList ClassManagementManager::traerDiasDeSemanaConNumero(QDate fecha_inicial, QDate fecha_final)
{
    QStringList lista;


    while (fecha_inicial.daysTo(fecha_final) >= 0) {
        QString nombre_dia_semana = fecha_inicial.toString("ddd");
        QString numero_dia_mes = fecha_inicial.toString("dd");

        lista.append(nombre_dia_semana);
        lista.append(numero_dia_mes);

        fecha_inicial = fecha_inicial.addDays(1);
    }

    return lista;
}

QString ClassManagementManager::traerNombreDiaCorto(int dia, int mes, int anio)
{
    return QDate(anio,mes,dia).toString("ddd");
}

int ClassManagementManager::totalDiasDelMes(int mes, int anio)
{
    QDate date(anio,mes,1);
    return date.daysInMonth();
}

void ClassManagementManager::abrirModulo(QString strPath) {
    emit sig_abrirModulo(strPath); //En desuso
}

QDate ClassManagementManager::obtenerFecha(QString fecha) {
    if (fecha == "")
        return QDate::currentDate();
    else {
        return QDate::fromString(fecha,"dd/MM/yyyy");
    }
}

QDateTime ClassManagementManager::obtenerFechaHora() {
    return QDateTime::currentDateTime();
}


int ClassManagementManager::obtenerDiferenciaDias(QDate fechaInicial, QDate fechaFinal) {
    return fechaInicial.daysTo(fechaFinal);
}


bool ClassManagementManager::seLlegoAlLimite() {
    bool seLlegoAlLimite = false;

    QSqlQuery query;
    query.prepare("SELECT COUNT(id) AS cantidad FROM cliente WHERE cliente.estado = 'Habilitado'");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        query.next();
        seLlegoAlLimite = (query.value("cantidad").toInt() >= m_limiteDeAlumnos);
        //qDebug() << "cantidad: " << cantidad;
    }

    seLlegoAlLimite = false; //Pongo esto para que la versión gratuita ahora soporte ilimitados registros.
    return seLlegoAlLimite;
}

/*QString ClassManagementManager::calcularTiempoPasado(QDateTime fecha_inicial, QDateTime fecha_final) {
    QString salida = "";

    int seconds = fecha_inicial.secsTo(fecha_final);

    if (seconds < 10)
        salida = "AHORA MISMO";
    else if (seconds < 60)
        salida = "RECIÉN. (" + fecha_inicial.time().toString("HH:mm")+"hs)";
    else if (seconds < 3600)
        salida = "Hace " + QString::number(seconds/60) + " minutos. (" + fecha_inicial.time().toString("HH:mm")+"hs)";
    else if (seconds < 86400) //Un dia
        salida = "Hace " + QString::number((seconds/60)/60) + " horas. (" + fecha_inicial.time().toString("HH:mm")+"hs)";

    if (salida == "") {
        if (fecha_inicial.date().daysTo(fecha_final.date()) == 1) {
            salida = "Ayer a las " + fecha_inicial.time().toString("HH:mm")+"hs.";
        }
        else {
            salida = fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs";
        }
    }

    return salida;
}*/

int ClassManagementManager::calcularTiempoPasadoEnSegundos(QDateTime fecha_inicial, QDateTime fecha_final) {
    return fecha_inicial.secsTo(fecha_final);
}

QString ClassManagementManager::calcularTiempoPasado(QDateTime fecha_inicial, QDateTime fecha_final) {
    QString salida = "";

    int seconds = this->calcularTiempoPasadoEnSegundos(fecha_inicial,fecha_final);

    if (seconds < 0)
        salida = "Ocurrirá a las " + fecha_inicial.time().toString("HH:mm")+"hs de hoy";
    else if (seconds < 10)
        salida = "AHORA MISMO";
    else if (seconds < 60)
        salida = "RECIÉN. (" + fecha_inicial.time().toString("HH:mm")+"hs)";
    else if (seconds < 3600)
        salida = "Hace " + QString::number(seconds/60) + " minuto/s (" + fecha_inicial.time().toString("HH:mm")+"hs)";
    else if (seconds < 86400) //Un dia
        salida = "Hace " + QString::number((seconds/60)/60) + " hora/s (" + fecha_inicial.time().toString("HH:mm")+"hs)";

    if (salida == "") {
        int dias_pasados = fecha_inicial.date().daysTo(fecha_final.date());
        if (dias_pasados == 1) {
            salida = "Ayer a las " + fecha_inicial.time().toString("HH:mm")+"hs";
        }
        else if (dias_pasados > 1 && dias_pasados < 6) {
            salida = "Hace " + QString::number(dias_pasados)+" días (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados == 6) {
            salida = "Hace casi 1 sem (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados == 7) {
            salida = "Hace 1 sem (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados > 7 && dias_pasados < 13) {
            salida = "Hace más de 1 sem (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados == 13) {
            salida = "Hace casi 2 sem (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados == 14) {
            salida = "Hace 2 sem (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados > 14 && dias_pasados < 20) {
            salida = "Hace más de 2 sem (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados == 20) {
            salida = "Hace casi 3 sem (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados == 21) {
            salida = "Hace 3 sem (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados > 21 && dias_pasados < 27) {
            salida = "Hace más de 3 sem (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else if (dias_pasados == 27) {
            salida = "Hace casi 1 mes (" + fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs)";
        }
        else {
            salida = fecha_inicial.toString("ddd dd/MM/yyyy HH:mm")+"hs";
        }
    }

    return salida;
}

QDate ClassManagementManager::nuevaFecha(QDate fechaOriginal, int addDays)
{
    return fechaOriginal.addDays(addDays);
}

bool ClassManagementManager::versionGratis() const
{
    return m_versionGratis;
}

int ClassManagementManager::limiteDeAlumnos() const
{
    return m_limiteDeAlumnos;
}

bool ClassManagementManager::getSistema_bloqueado() const
{
    return m_sistema_bloqueado;
}

QString ClassManagementManager::getCliente() const
{
    return m_cliente;
}

CMAlumno *ClassManagementManager::clienteSeleccionado() const
{
    return m_clienteSeleccionado;
}

void ClassManagementManager::setSistema_bloqueado(bool sistema_bloqueado)
{
    if (m_sistema_bloqueado == sistema_bloqueado)
        return;

    m_sistema_bloqueado = sistema_bloqueado;
    emit sistema_bloqueadoChanged(sistema_bloqueado);
}

void ClassManagementManager::setCliente(QString cliente)
{
    if (m_cliente == cliente)
        return;

    m_cliente = cliente;
    emit clienteChanged(cliente);
}

void ClassManagementManager::setClienteSeleccionado(CMAlumno *clienteSeleccionado)
{
    if (m_clienteSeleccionado == clienteSeleccionado)
        return;

    m_clienteSeleccionado = clienteSeleccionado;
    emit clienteSeleccionadoChanged(m_clienteSeleccionado);
}

void ClassManagementManager::captureQml(QQuickItem* item, QString path1)
{
    qDebug() <<"SampleReports::captureQml::ini";
    qDebug() << item;
    QSharedPointer<QQuickItemGrabResult> _result =  item->grabToImage();

    connect(_result.data(),&QQuickItemGrabResult::ready, [_result,path1,this](){
        qDebug() << "grabresult ready ini";
        qDebug() << _result->image();
        QString filename = "./ResumenDS.png";

        if (path1.isEmpty() == false)
            filename = path1+"/ResumenDS.png";

        if (_result->image().save(filename))
        {

            //
        }
        else
        {
            //emit sig_saveimageerror(filename);
        }
    });
    qDebug() << "grabresult ready fin";
    qDebug() <<"SampleReports::captureQml::fin";

}

//void ClassManagementManager::captureQml(QQuickItem* item)
//{
//    qDebug() <<"SampleReports::captureQml::ini";
//    qDebug() << item;
//    QSharedPointer<QQuickItemGrabResult> _result =  item->grabToImage();

//    connect(_result.data(),&QQuickItemGrabResult::ready, [_result,this](){
//        qDebug() << "grabresult ready ini";
//        qDebug() << _result->image();
//        QString filename;


//        if (_result->image().save("./ResumenDS.png"))
//        {
//            //emit sig_saveimageok(filename);
//            QDesktopServices::openUrl(QUrl::fromLocalFile("./ResumenDS.png"));
//        }
//        else
//        {
//            //emit sig_saveimageerror(filename);
//        }
//    });
//    qDebug() << "grabresult ready fin";
//    qDebug() <<"SampleReports::captureQml::fin";

//}


