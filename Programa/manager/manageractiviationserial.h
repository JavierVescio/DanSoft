#ifndef MANAGERACTIVIATIONSERIAL_H
#define MANAGERACTIVIATIONSERIAL_H
#include <QObject>
#include <QDate>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include "commonbase/activationserial.h"

class ManagerActiviationSerial: public QObject
{
    Q_OBJECT
public:
    ManagerActiviationSerial();

    Q_INVOKABLE int verifySerial(QString serial, QDate fecha = QDate::currentDate());
    Q_INVOKABLE bool verificarActivacion(int mes);
    Q_INVOKABLE bool verificarActivacion(QDate date);
    Q_INVOKABLE QList<QObject*> getListaActivationSerial();

private:
    QList<QObject*> listaActivationSerial;
    void cargarLista();
    int registrarSerialEnBase(QString serial);
    bool serialYaCargado(QString serial);
    const int licensed_year = 2016;
    const QString serials[12] = {"bj9l5zg2euaklqiz", //Enero
                                 "nv6g3cg0in3kmf1k",
                                 "geusawjvq8nhplbw",
                                 "5vvodq0tjcu4gbkv",

                                 "olvj1rhgfjmlwwpi", //Mayo
                                 "vijgxfuvbz03gp5v",
                                 "hvpyfva9kfrvh0al",
                                 "26wi9h3ck7i5e72x",

                                 "yblsid1dqrcdu2te", //Septiembre
                                 "qnqmnxzrdeikr7x2",
                                 "htkpppsn08fk5xhn",
                                 "aui2mvx8nwyhsrsw"};
signals:
    void sig_serial_loaded_successfully();
};

#endif // MANAGERACTIVIATIONSERIAL_H
