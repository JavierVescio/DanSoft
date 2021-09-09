#include "manageractiviationserial.h"
#include <QDebug>

ManagerActiviationSerial::ManagerActiviationSerial()
{
    listaActivationSerial.clear();
    cargarLista();
}

///
/// \brief ManagerActiviationSerial::verifySerial
/// \param serial
/// \return
///0=error;1=serial_loaded_successfully;2=serial_already_loaded;
int ManagerActiviationSerial::verifySerial(QString serial, QDate fecha)
{
    int salida = 0;
    int year = fecha.year();
    int month = fecha.month();

    if (year == licensed_year) {
        if (serial == serials[month-1]) {
            //Registrar en base el serial
            salida = registrarSerialEnBase(serial);
        }
    }

    if (salida == 1)
        emit sig_serial_loaded_successfully();

    return salida;
}

bool ManagerActiviationSerial::verificarActivacion(QDate date)
{
    return serialYaCargado(serials[date.month()-1]);
}

bool ManagerActiviationSerial::verificarActivacion(int mes)
{
    return serialYaCargado(serials[mes-1]);
}

QList<QObject*> ManagerActiviationSerial::getListaActivationSerial()
{
    return listaActivationSerial;
}

///
/// \brief ManagerActiviationSerial::registrarSerialEnBase
/// \param serial
/// \return
/// 0=error;1=serial_loaded_successfully;2=serial_already_loaded;
int ManagerActiviationSerial::registrarSerialEnBase(QString serial) {
    int salida = 0;

    if (serialYaCargado(serial)) {
        salida = 2;
    }
    else {
        QString strQuery = "INSERT INTO activacion_programa (serial) VALUES ('"+serial+"')";
        QSqlQuery query;
        query.prepare(strQuery);
        if(!query.exec()) {
            qDebug() << "strQuery: " << strQuery;
            qDebug() << query.lastError();
        }
        else {
            salida = 1;
        }
    }

    return salida;
}

bool ManagerActiviationSerial::serialYaCargado(QString serial)
{
    QString queryStr = "SELECT * FROM activacion_programa WHERE serial = '"+serial+"'";
    QSqlQuery query(queryStr);
    if (!query.exec()) {
        qFatal("Query failed");
    }
    return (query.next());
}

void ManagerActiviationSerial::cargarLista()
{
    //Licencia del primero de enero de 2016 al primero de enero de 2017.
    QDate valid_date_from(2016,1,1);
    QDate valid_date_to;

    int x;
    for (x=0;x<12;x++){
        valid_date_to = valid_date_from.addMonths(1);
        listaActivationSerial.append(new ActivationSerial(serials[x],valid_date_from,valid_date_to));
        valid_date_from = valid_date_to;
    }
}

