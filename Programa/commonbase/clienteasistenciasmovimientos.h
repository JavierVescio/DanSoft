#ifndef CLIENTEASISTENCIASMOVIMIENTOS_H
#define CLIENTEASISTENCIASMOVIMIENTOS_H

#include <QObject>

#include "commonbase/cmalumno.h"
#include "commonbase/listasconinformacion.h"

class ClienteAsistenciasMovimientos: public QObject
{
    Q_OBJECT
    Q_PROPERTY(CMAlumno* alumno READ alumno WRITE setAlumno NOTIFY alumnoChanged)
    Q_PROPERTY(ListasConInformacion* listasConInformacion READ listasConInformacion WRITE setListasConInformacion NOTIFY listasConInformacionChanged)

public:
    ClienteAsistenciasMovimientos();
    CMAlumno* alumno() const;
    ListasConInformacion* listasConInformacion() const;

private:
    CMAlumno* m_alumno;
    ListasConInformacion* m_listasConInformacion;

public slots:
    void setAlumno(CMAlumno* alumno);
    void setListasConInformacion(ListasConInformacion* listasConInformacion);

signals:
    void alumnoChanged(CMAlumno* alumno);
    void listasConInformacionChanged(ListasConInformacion* listasConInformacion);
};

#endif // CLIENTEASISTENCIASMOVIMIENTOS_H
