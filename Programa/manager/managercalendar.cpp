#include "managercalendar.h"
#include "wrapperclassmanagement.h"
#include "qdebug.h"

ManagerCalendar::ManagerCalendar()
{
    listaDiasCalendario.clear();
    fechaCalendario = QDate::currentDate();
}

QList<QObject*> ManagerCalendar::construirCalendarioPorFecha(int mes, int anio)
{
    listaDiasCalendario.clear();
    if (mes == 0 || anio == 0) {
        mes = QDate::currentDate().month();
        anio = QDate::currentDate().year();
        fechaCalendario = QDate::currentDate();
    }

    QDate fecha;
    if (fecha.setDate(anio,mes,1)) {
        int dayOfWeek = fecha.dayOfWeek();

        while (dayOfWeek > 1) {
            DiaCalendario * objCalendario = new DiaCalendario();
            listaDiasCalendario.append(dynamic_cast<QObject*>(objCalendario));
            dayOfWeek--;
        }

        for(int dia=1;dia<=fecha.daysInMonth();dia++) {
            QDate fecha_nueva(anio,mes,dia);
            QString estado = "pasado";
            if (fecha_nueva >= QDate::currentDate()) {
                estado = "presente";
            }
            DiaCalendario * objCalendario = new DiaCalendario(fecha_nueva,estado);
            listaDiasCalendario.append(dynamic_cast<QObject*>(objCalendario));
        }
        WrapperClassManagement::getClassManagementGestionDeAlumnos()->getBirthdaysByMonth(fecha);
        emit sig_listaDiasCalendario(listaDiasCalendario);
    }
    return listaDiasCalendario;
}

QDate ManagerCalendar::getFechaCalendario() const
{
    return fechaCalendario;
}

void ManagerCalendar::retrocederUnMesEnCalendario() {
    fechaCalendario = fechaCalendario.addMonths(-1);
    this->construirCalendarioPorFecha(fechaCalendario.month(),fechaCalendario.year());
}

void ManagerCalendar::avanzarUnMesEnCalendario() {
    fechaCalendario = fechaCalendario.addMonths(1);
    this->construirCalendarioPorFecha(fechaCalendario.month(),fechaCalendario.year());
}
