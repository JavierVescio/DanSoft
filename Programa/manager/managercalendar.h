#ifndef MANAGERCALENDAR_H
#define MANAGERCALENDAR_H
#include <QObject>
#include <QDate>
#include "commonbase/diacalendario.h"

class ManagerCalendar: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QDate fechaCalendario READ getFechaCalendario)

public:
    ManagerCalendar();

    Q_INVOKABLE QList<QObject*> construirCalendarioPorFecha(int mes = 0, int anio = 0);
    Q_INVOKABLE void retrocederUnMesEnCalendario();
    Q_INVOKABLE void avanzarUnMesEnCalendario();

    QDate getFechaCalendario() const;
private:
    QList<QObject*> listaDiasCalendario;
    QDate fechaCalendario;

signals:
    void sig_listaDiasCalendario(QList<QObject*>arg);
};

#endif // MANAGERCALENDAR_H
