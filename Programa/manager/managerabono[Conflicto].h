#ifndef MANAGERABONO_H
#define MANAGERABONO_H
#include <QObject>
#include <QDebug>
#include <QDate>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>

class ManagerAbono: public QObject
{
    Q_OBJECT
public:
    ManagerAbono();
    Q_INVOKABLE QDate obtenerFechaDeHoy();
    Q_INVOKABLE QDate obtenerFechaDeVencimiento();

    Q_INVOKABLE bool comprarAbono(int id_cliente, QString fecha_vencimiento, QString tipo, int cantidad_clases, int cantidad_restante);
};

#endif // MANAGERABONO_H
