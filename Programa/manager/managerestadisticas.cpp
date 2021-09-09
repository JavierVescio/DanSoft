#include "managerestadisticas.h"

ManagerEstadisticas::ManagerEstadisticas()
{
    maximo_presentes_adultos = 0;
    maximo_presentes_infantiles = 0;

    total_presentes_infantiles = 0;
    total_presentes_adultos = 0;
    cantidad_alumnos= 0;
    maximo_cantidad_alumnos=0;

    maximo_abonos_adultos=0;
    total_abonos_adultos=0;

    maximo_abonos_infantiles=0;
    total_abonos_infantiles=0;

    total_deuda = 0;
    total_favor=0;
    total_deuda_hoy = 0;
    total_favor_hoy =0;
}

QList<QObject*> ManagerEstadisticas::obtenerCantidadPresentesAdultos(
        int periodo_dias,
        QDateTime dt_final)
{
    QList<QObject*> lista;
    QSqlQuery query;
    QDateTime dt_inicial;

    dt_inicial = dt_final.addDays(-1*periodo_dias);
    dt_inicial.setTime(QTime(0,0,0));
    dt_final.setTime(QTime(23,59,59));

    int tipo = -1;

    total_presentes_adultos = 0;
    if (periodo_dias == 0) {
        tipo=0;
        query.prepare("SELECT count(id) "
                      "AS total_presentes_adultos, fecha "
                      "FROM cliente_asistencia "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "GROUP BY strftime('%d-%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }else if (periodo_dias == 1){
        tipo=0;
        dt_inicial = dt_inicial.addDays(-1);
        dt_final = dt_final.addDays(-1);

        query.prepare("SELECT count(id) "
                      "AS total_presentes_adultos, fecha "
                      "FROM cliente_asistencia "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "GROUP BY strftime('%d-%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }
    else if (periodo_dias >= 2 && periodo_dias < 31){
        tipo=1;
        query.prepare("SELECT count(id) "
                      "AS total_presentes_adultos, fecha "
                      "FROM cliente_asistencia "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "GROUP BY strftime('%d-%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }else if (periodo_dias >= 31 && periodo_dias < 366){
        tipo=2;
        query.prepare("SELECT count(id) "
                      "AS total_presentes_adultos, fecha "
                      "FROM cliente_asistencia "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "GROUP BY strftime('%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }

    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if( !query.exec() ) {
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }
    else
    {
        maximo_presentes_adultos = 0;
        QDate auxDate = dt_inicial.date();
        QTime auxTime = dt_inicial.time();

        while(query.next()) {
            QDateTime fecha_query = query.value("fecha").toDateTime();



            if (tipo == 0){
                while(auxTime.hour() < fecha_query.time().hour()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                    auxTime = auxTime.addSecs(3600);
                }
            }else if(tipo == 1){
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("dd"));
                    lista.append(pg);
                    auxDate = auxDate.addDays(1);
                }
            }else {
                auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("MMM/yy"));
                    lista.append(pg);
                    auxDate = auxDate.addMonths(1);
                    auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                }
            }


            PuntoGrafico *pg = new PuntoGrafico();
            pg->setFecha(fecha_query);
            pg->setValor(query.value("total_presentes_adultos").toInt());
            if (tipo==0){
                pg->setNombre(fecha_query.toString("HH"));
                auxTime = auxTime.addSecs(3600);
            }else if (tipo==1){
                pg->setNombre(fecha_query.toString("dd"));
                auxDate = auxDate.addDays(1);
            }else{
                pg->setNombre(fecha_query.toString("MMM/yy"));
                auxDate = auxDate.addMonths(1);
            }
            if (pg->valor() > maximo_presentes_adultos){
                maximo_presentes_adultos=pg->valor();
            }


            total_presentes_adultos += pg->valor();
            lista.append(pg);
        }

        if (tipo==0){
            while (auxTime.hour()<dt_final.time().hour()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setFecha(QDateTime(auxDate,auxTime));
                pg->setValor(0);
                pg->setNombre(auxTime.toString("HH"));
                lista.append(pg);
                auxTime = auxTime.addSecs(3600);
                if (auxTime.hour() == 23){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                }
            }
        }else if (tipo==1){
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("dd"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addDays(1);
            }
        }else{
            auxDate.setDate(auxDate.year(),auxDate.month(),1);
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("MMM/yy"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addMonths(1);
            }
        }

    }
    return lista;
}

QList<QObject *> ManagerEstadisticas::obtenerCantidadPresentesInfantiles(int periodo_dias, QDateTime dt_final)
{
    QList<QObject*> lista;
    QSqlQuery query;
    QDateTime dt_inicial;

    dt_inicial = dt_final.addDays(-1*periodo_dias);
    dt_inicial.setTime(QTime(0,0,0));
    dt_final.setTime(QTime(23,59,59));

    int tipo = -1;

    total_presentes_infantiles = 0;
    if (periodo_dias == 0) {
        tipo=0;
        query.prepare("SELECT count(id) "
                      "AS total_presentes_infantiles, fecha "
                      "FROM clase_asistencia_infantil "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "GROUP BY strftime('%d-%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }else if (periodo_dias == 1){
        tipo=0;
        dt_inicial = dt_inicial.addDays(-1);
        dt_final = dt_final.addDays(-1);

        query.prepare("SELECT count(id) "
                      "AS total_presentes_infantiles, fecha "
                      "FROM clase_asistencia_infantil "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "GROUP BY strftime('%d-%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }
    else if (periodo_dias >= 2 && periodo_dias < 31){
        tipo=1;
        query.prepare("SELECT count(id) "
                      "AS total_presentes_infantiles, fecha "
                      "FROM clase_asistencia_infantil "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "GROUP BY strftime('%d-%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }else if (periodo_dias >= 31 && periodo_dias < 366){
        tipo=2;
        query.prepare("SELECT count(id) "
                      "AS total_presentes_infantiles, fecha "
                      "FROM clase_asistencia_infantil "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "GROUP BY strftime('%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }

    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if( !query.exec() ) {
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }
    else
    {
        maximo_presentes_infantiles = 0;
        QDate auxDate = dt_inicial.date();
        QTime auxTime = dt_inicial.time();
        while(query.next()) {
            QDateTime fecha_query = query.value("fecha").toDateTime();


            if (tipo == 0){
                while(auxTime.hour() < fecha_query.time().hour()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                    auxTime = auxTime.addSecs(3600);
                }
            }else if(tipo == 1){
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("dd"));
                    lista.append(pg);
                    auxDate = auxDate.addDays(1);
                }
            }else {
                auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("MMM/yy"));
                    lista.append(pg);
                    auxDate = auxDate.addMonths(1);
                    auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                }
            }


            PuntoGrafico *pg = new PuntoGrafico();
            pg->setFecha(fecha_query);
            pg->setValor(query.value("total_presentes_infantiles").toInt());
            if (tipo==0){
                pg->setNombre(fecha_query.toString("HH"));
                auxTime = auxTime.addSecs(3600);
            }else if (tipo==1){
                pg->setNombre(fecha_query.toString("dd"));
                auxDate = auxDate.addDays(1);
            }else{
                pg->setNombre(fecha_query.toString("MMM/yy"));
                auxDate = auxDate.addMonths(1);
            }
            if (pg->valor() > maximo_presentes_infantiles){
                maximo_presentes_infantiles=pg->valor();
            }

            total_presentes_infantiles += pg->valor();

            lista.append(pg);
        }

        if (tipo==0){
            while (auxTime.hour()<dt_final.time().hour()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setFecha(QDateTime(auxDate,auxTime));
                pg->setValor(0);
                pg->setNombre(auxTime.toString("HH"));
                lista.append(pg);
                auxTime = auxTime.addSecs(3600);
                if (auxTime.hour() == 23){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                }
            }
        }else if (tipo==1){
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("dd"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addDays(1);
            }
        }else{
            auxDate.setDate(auxDate.year(),auxDate.month(),1);
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("MMM/yy"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addMonths(1);
            }
        }


        //lista = this->rellenarHuecos(tipo, lista,dt_inicial,dt_final);

    }
    return lista;
}

QList<QObject *> ManagerEstadisticas::obtenerCantidadAlumnos(
        bool alta,
        int periodo_dias,
        QDateTime dt_final)
{
    QList<QObject*> lista;
    QSqlQuery query;
    QDateTime dt_inicial;

    dt_inicial = dt_final.addDays(-1*periodo_dias);
    dt_inicial.setTime(QTime(0,0,0));
    dt_final.setTime(QTime(23,59,59));

    //Solo para esta funcion hago lo siguiente, sino no se toman los eventos del dia actual.
    //Quizas es porque fecha_alta se guarda a la base con el formato automatico de fecha de SQlite.
    dt_final = dt_final.addDays(1);
    ////////////////////////

    int tipo = -1;
    QString estado = "Deshabilitado";

    if (alta){
        estado = "Habilitado";
    }

    cantidad_alumnos = 0;
    if (periodo_dias == 0) {
        tipo=0;
        query.prepare("SELECT count(id) "
                      "AS cantidad, blame_timestamp "
                      "FROM cliente "
                      "WHERE :dt_inicial <= blame_timestamp AND blame_timestamp <= :dt_final AND estado='"+estado+"' "
                                                                                                                  "GROUP BY strftime('%d-%m-%Y',blame_timestamp)"
                                                                                                                  "ORDER BY blame_timestamp ");
    }else if (periodo_dias == 1){
        tipo=0;
        dt_inicial = dt_inicial.addDays(-1);
        dt_final = dt_final.addDays(-1);

        query.prepare("SELECT count(id) "
                      "AS cantidad, blame_timestamp "
                      "FROM cliente "
                      "WHERE :dt_inicial <= blame_timestamp AND blame_timestamp <= :dt_final AND estado='"+estado+"' "
                                                                                                                  "GROUP BY strftime('%d-%m-%Y',blame_timestamp)"
                                                                                                                  "ORDER BY blame_timestamp ");
    }
    else if (periodo_dias >= 2 && periodo_dias < 31){
        tipo=1;
        query.prepare("SELECT count(id) "
                      "AS cantidad, blame_timestamp "
                      "FROM cliente "
                      "WHERE :dt_inicial <= blame_timestamp AND blame_timestamp <= :dt_final AND estado='"+estado+"' "
                                                                                                                  "GROUP BY strftime('%d-%m-%Y',blame_timestamp)"
                                                                                                                  "ORDER BY blame_timestamp ");
    }else if (periodo_dias >= 31 && periodo_dias < 366){
        tipo=2;
        query.prepare("SELECT count(id) "
                      "AS cantidad, blame_timestamp "
                      "FROM cliente "
                      "WHERE :dt_inicial <= blame_timestamp AND blame_timestamp <= :dt_final AND estado='"+estado+"' "
                                                                                                                  "GROUP BY strftime('%m-%Y',blame_timestamp)"
                                                                                                                  "ORDER BY blame_timestamp ");
    }


    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if( !query.exec() ) {
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }
    else
    {
        qDebug() << "dtinicial: "<< dt_inicial.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << "dtfinal: "<< dt_final.toString("yyyy-MM-dd hh:mm:ss");
        qDebug() << query.lastQuery();

        maximo_cantidad_alumnos = 0;
        QDate auxDate = dt_inicial.date();
        QTime auxTime = dt_inicial.time();
        while(query.next()) {
            QDateTime fecha_query = query.value("blame_timestamp").toDateTime();


            if (tipo == 0){
                while(auxTime.hour() < fecha_query.time().hour()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                    auxTime = auxTime.addSecs(3600);
                }
            }else if(tipo == 1){
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("dd"));
                    lista.append(pg);
                    auxDate = auxDate.addDays(1);
                }
            }else {
                auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("MMM/yy"));
                    lista.append(pg);
                    auxDate = auxDate.addMonths(1);
                    auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                }
            }


            PuntoGrafico *pg = new PuntoGrafico();
            pg->setFecha(fecha_query);
            pg->setValor(query.value("cantidad").toInt());
            if (tipo==0){
                pg->setNombre(fecha_query.toString("HH"));
                auxTime = auxTime.addSecs(3600);
            }else if (tipo==1){
                pg->setNombre(fecha_query.toString("dd"));
                auxDate = auxDate.addDays(1);
            }else{
                pg->setNombre(fecha_query.toString("MMM/yy"));
                auxDate = auxDate.addMonths(1);
            }
            if (pg->valor() > maximo_cantidad_alumnos){
                maximo_cantidad_alumnos=pg->valor();
            }


            cantidad_alumnos += pg->valor();
            lista.append(pg);
        }

        if (tipo==0){
            while (auxTime.hour()<dt_final.time().hour()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setFecha(QDateTime(auxDate,auxTime));
                pg->setValor(0);
                pg->setNombre(auxTime.toString("HH"));
                lista.append(pg);
                auxTime = auxTime.addSecs(3600);
                if (auxTime.hour() == 23){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                }
            }
        }else if (tipo==1){
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("dd"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addDays(1);
            }
        }else{
            auxDate.setDate(auxDate.year(),auxDate.month(),1);
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("MMM/yy"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addMonths(1);
            }
        }

    }
    return lista;
}

QList<QObject *> ManagerEstadisticas::obtenerCantidadAbonosAdultos(int periodo_dias, QDateTime dt_final)
{
    QList<QObject*> lista;
    QSqlQuery query;
    QDateTime dt_inicial;

    dt_inicial = dt_final.addDays(-1*periodo_dias);
    dt_inicial.setTime(QTime(0,0,0));
    dt_final.setTime(QTime(23,59,59));

    int tipo = -1;

    total_abonos_adultos = 0;
    if (periodo_dias == 0) {
        tipo=0;
        query.prepare("SELECT count(id) "
                      "AS total_abonos_adultos, fecha_compra "
                      "FROM abono "
                      "WHERE :dt_inicial <= fecha_compra AND fecha_compra <= :dt_final AND estado='Habilitado' "
                      "GROUP BY strftime('%d-%m-%Y',fecha_compra)"
                      "ORDER BY fecha_compra ");
    }else if (periodo_dias == 1){
        tipo=0;
        dt_inicial = dt_inicial.addDays(-1);
        dt_final = dt_final.addDays(-1);

        query.prepare("SELECT count(id) "
                      "AS total_abonos_adultos, fecha_compra "
                      "FROM abono "
                      "WHERE :dt_inicial <= fecha_compra AND fecha_compra <= :dt_final AND estado='Habilitado' "
                      "GROUP BY strftime('%d-%m-%Y',fecha_compra)"
                      "ORDER BY fecha_compra ");
    }
    else if (periodo_dias >= 2 && periodo_dias < 31){
        tipo=1;
        query.prepare("SELECT count(id) "
                      "AS total_abonos_adultos, fecha_compra "
                      "FROM abono "
                      "WHERE :dt_inicial <= fecha_compra AND fecha_compra <= :dt_final AND estado='Habilitado' "
                      "GROUP BY strftime('%d-%m-%Y',fecha_compra)"
                      "ORDER BY fecha_compra ");
    }else if (periodo_dias >= 31 && periodo_dias < 366){
        tipo=2;
        query.prepare("SELECT count(id) "
                      "AS total_abonos_adultos, fecha_compra "
                      "FROM abono "
                      "WHERE :dt_inicial <= fecha_compra AND fecha_compra <= :dt_final AND estado='Habilitado' "
                      "GROUP BY strftime('%m-%Y',fecha_compra)"
                      "ORDER BY fecha_compra ");
    }

    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if( !query.exec() ) {
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }
    else
    {
        maximo_abonos_adultos = 0;
        QDate auxDate = dt_inicial.date();
        QTime auxTime = dt_inicial.time();

        while(query.next()) {
            QDateTime fecha_query = query.value("fecha_compra").toDateTime();



            if (tipo == 0){
                while(auxTime.hour() < fecha_query.time().hour()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                    auxTime = auxTime.addSecs(3600);
                }
            }else if(tipo == 1){
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("dd"));
                    lista.append(pg);
                    auxDate = auxDate.addDays(1);
                }
            }else {
                auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("MMM/yy"));
                    lista.append(pg);
                    auxDate = auxDate.addMonths(1);
                    auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                }
            }


            PuntoGrafico *pg = new PuntoGrafico();
            pg->setFecha(fecha_query);
            pg->setValor(query.value("total_abonos_adultos").toInt());
            if (tipo==0){
                pg->setNombre(fecha_query.toString("HH"));
                auxTime = auxTime.addSecs(3600);
            }else if (tipo==1){
                pg->setNombre(fecha_query.toString("dd"));
                auxDate = auxDate.addDays(1);
            }else{
                pg->setNombre(fecha_query.toString("MMM/yy"));
                auxDate = auxDate.addMonths(1);
            }
            if (pg->valor() > maximo_abonos_adultos){
                maximo_abonos_adultos=pg->valor();
            }


            total_abonos_adultos += pg->valor();
            lista.append(pg);
        }

        if (tipo==0){
            while (auxTime.hour()<dt_final.time().hour()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setFecha(QDateTime(auxDate,auxTime));
                pg->setValor(0);
                pg->setNombre(auxTime.toString("HH"));
                lista.append(pg);
                auxTime = auxTime.addSecs(3600);
                if (auxTime.hour() == 23){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                }
            }
        }else if (tipo==1){
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("dd"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addDays(1);
            }
        }else{
            auxDate.setDate(auxDate.year(),auxDate.month(),1);
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("MMM/yy"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addMonths(1);
            }
        }

    }

    return lista;
}

QList<QObject *> ManagerEstadisticas::obtenerCantidadAbonosInfantiles(int periodo_dias, QDateTime dt_final)
{
    QList<QObject*> lista;
    QSqlQuery query;
    QDateTime dt_inicial;

    dt_inicial = dt_final.addDays(-1*periodo_dias);
    dt_inicial.setTime(QTime(0,0,0));
    dt_final.setTime(QTime(23,59,59));

    int tipo = -1;

    total_abonos_infantiles = 0;
    if (periodo_dias == 0) {
        tipo=0;
        query.prepare("SELECT count(id) "
                      "AS total_abonos_infantiles, fecha_compra "
                      "FROM abono_infantil_compra "
                      "WHERE :dt_inicial <= fecha_compra AND fecha_compra <= :dt_final AND estado='Habilitado' "
                      "GROUP BY strftime('%d-%m-%Y',fecha_compra)"
                      "ORDER BY fecha_compra ");
    }else if (periodo_dias == 1){
        tipo=0;
        dt_inicial = dt_inicial.addDays(-1);
        dt_final = dt_final.addDays(-1);

        query.prepare("SELECT count(id) "
                      "AS total_abonos_infantiles, fecha_compra "
                      "FROM abono_infantil_compra "
                      "WHERE :dt_inicial <= fecha_compra AND fecha_compra <= :dt_final AND estado='Habilitado' "
                      "GROUP BY strftime('%d-%m-%Y',fecha_compra)"
                      "ORDER BY fecha_compra ");
    }
    else if (periodo_dias >= 2 && periodo_dias < 31){
        tipo=1;
        query.prepare("SELECT count(id) "
                      "AS total_abonos_infantiles, fecha_compra "
                      "FROM abono_infantil_compra "
                      "WHERE :dt_inicial <= fecha_compra AND fecha_compra <= :dt_final AND estado='Habilitado' "
                      "GROUP BY strftime('%d-%m-%Y',fecha_compra)"
                      "ORDER BY fecha_compra ");
    }else if (periodo_dias >= 31 && periodo_dias < 366){
        tipo=2;
        query.prepare("SELECT count(id) "
                      "AS total_abonos_infantiles, fecha_compra "
                      "FROM abono_infantil_compra "
                      "WHERE :dt_inicial <= fecha_compra AND fecha_compra <= :dt_final AND estado='Habilitado' "
                      "GROUP BY strftime('%m-%Y',fecha_compra)"
                      "ORDER BY fecha_compra ");
    }

    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));

    if( !query.exec() ) {
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }
    else
    {
        maximo_abonos_infantiles = 0;
        QDate auxDate = dt_inicial.date();
        QTime auxTime = dt_inicial.time();

        while(query.next()) {
            QDateTime fecha_query = query.value("fecha_compra").toDateTime();

            if (tipo == 0){
                while(auxTime.hour() < fecha_query.time().hour()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                    auxTime = auxTime.addSecs(3600);
                }
            }else if(tipo == 1){
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("dd"));
                    lista.append(pg);
                    auxDate = auxDate.addDays(1);
                }
            }else {
                auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("MMM/yy"));
                    lista.append(pg);
                    auxDate = auxDate.addMonths(1);
                    auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                }
            }


            PuntoGrafico *pg = new PuntoGrafico();
            pg->setFecha(fecha_query);
            pg->setValor(query.value("total_abonos_infantiles").toInt());
            if (tipo==0){
                pg->setNombre(fecha_query.toString("HH"));
                auxTime = auxTime.addSecs(3600);
            }else if (tipo==1){
                pg->setNombre(fecha_query.toString("dd"));
                auxDate = auxDate.addDays(1);
            }else{
                pg->setNombre(fecha_query.toString("MMM/yy"));
                auxDate = auxDate.addMonths(1);
            }
            if (pg->valor() > maximo_abonos_infantiles){
                maximo_abonos_infantiles=pg->valor();
            }


            total_abonos_infantiles += pg->valor();
            lista.append(pg);
        }

        if (tipo==0){
            while (auxTime.hour()<dt_final.time().hour()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setFecha(QDateTime(auxDate,auxTime));
                pg->setValor(0);
                pg->setNombre(auxTime.toString("HH"));
                lista.append(pg);
                auxTime = auxTime.addSecs(3600);
                if (auxTime.hour() == 23){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                }
            }
        }else if (tipo==1){
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("dd"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addDays(1);
            }
        }else{
            auxDate.setDate(auxDate.year(),auxDate.month(),1);
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("MMM/yy"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addMonths(1);
            }
        }

    }

    return lista;
}

QList<QObject *> ManagerEstadisticas::obtenerCantidadPresentesActividad(int id_actividad, int periodo_dias, QDateTime dt_final)
{
    QList<QObject*> lista;
    QSqlQuery query;
    QDateTime dt_inicial;

    dt_inicial = dt_final.addDays(-1*periodo_dias);
    dt_inicial.setTime(QTime(0,0,0));
    dt_final.setTime(QTime(23,59,59));

    int tipo = -1;

    total_presentes_adultos = 0;
    if (periodo_dias == 0) {
        tipo=0;
        query.prepare("SELECT count(id) "
                      "AS total_presentes_adultos, fecha "
                      "FROM cliente_asistencia "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "AND danza.id = :id_actividad "
                      "GROUP BY strftime('%d-%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }else if (periodo_dias == 1){
        tipo=0;
        dt_inicial = dt_inicial.addDays(-1);
        dt_final = dt_final.addDays(-1);

        query.prepare("SELECT count(id) "
                      "AS total_presentes_adultos, fecha "
                      "FROM cliente_asistencia "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "AND danza.id = :id_actividad "
                      "GROUP BY strftime('%d-%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }
    else if (periodo_dias >= 2 && periodo_dias < 31){
        tipo=1;
        query.prepare("SELECT count(id) "
                      "AS total_presentes_adultos, fecha "
                      "FROM cliente_asistencia "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "AND danza.id = :id_actividad "
                      "GROUP BY strftime('%d-%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }else if (periodo_dias >= 31 && periodo_dias < 366){
        tipo=2;
        query.prepare("SELECT count(id) "
                      "AS total_presentes_adultos, fecha "
                      "FROM cliente_asistencia "
                      "WHERE :dt_inicial <= fecha AND fecha <= :dt_final AND estado='Activa' "
                      "AND danza.id = :id_actividad "
                      "GROUP BY strftime('%m-%Y',fecha)"
                      "ORDER BY fecha ");
    }

    query.bindValue(":dt_inicial", dt_inicial.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":dt_final", dt_final.toString("yyyy-MM-dd hh:mm:ss"));
    query.bindValue(":id_actividad", id_actividad);

    if( !query.exec() ) {
        qDebug() << query.lastError();
        qDebug() << query.lastQuery();
    }
    else
    {
        maximo_presentes_adultos = 0;
        QDate auxDate = dt_inicial.date();
        QTime auxTime = dt_inicial.time();

        while(query.next()) {
            QDateTime fecha_query = query.value("fecha").toDateTime();



            if (tipo == 0){
                while(auxTime.hour() < fecha_query.time().hour()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                    auxTime = auxTime.addSecs(3600);
                }
            }else if(tipo == 1){
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("dd"));
                    lista.append(pg);
                    auxDate = auxDate.addDays(1);
                }
            }else {
                auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                while(auxDate < fecha_query.date()){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxDate.toString("MMM/yy"));
                    lista.append(pg);
                    auxDate = auxDate.addMonths(1);
                    auxDate.setDate(auxDate.year(),auxDate.month(),auxDate.daysInMonth());
                }
            }


            PuntoGrafico *pg = new PuntoGrafico();
            pg->setFecha(fecha_query);
            pg->setValor(query.value("total_presentes_adultos").toInt());
            if (tipo==0){
                pg->setNombre(fecha_query.toString("HH"));
                auxTime = auxTime.addSecs(3600);
            }else if (tipo==1){
                pg->setNombre(fecha_query.toString("dd"));
                auxDate = auxDate.addDays(1);
            }else{
                pg->setNombre(fecha_query.toString("MMM/yy"));
                auxDate = auxDate.addMonths(1);
            }
            if (pg->valor() > maximo_presentes_adultos){
                maximo_presentes_adultos=pg->valor();
            }


            total_presentes_adultos += pg->valor();
            lista.append(pg);
        }

        if (tipo==0){
            while (auxTime.hour()<dt_final.time().hour()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setFecha(QDateTime(auxDate,auxTime));
                pg->setValor(0);
                pg->setNombre(auxTime.toString("HH"));
                lista.append(pg);
                auxTime = auxTime.addSecs(3600);
                if (auxTime.hour() == 23){
                    PuntoGrafico *pg = new PuntoGrafico();
                    pg->setFecha(QDateTime(auxDate,auxTime));
                    pg->setValor(0);
                    pg->setNombre(auxTime.toString("HH"));
                    lista.append(pg);
                }
            }
        }else if (tipo==1){
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("dd"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addDays(1);
            }
        }else{
            auxDate.setDate(auxDate.year(),auxDate.month(),1);
            while (auxDate <= dt_final.date()){
                PuntoGrafico *pg = new PuntoGrafico();
                pg->setValor(0);
                pg->setNombre(auxDate.toString("MMM/yy"));
                pg->setFecha(QDateTime(auxDate,auxTime));
                lista.append(pg);
                auxDate = auxDate.addMonths(1);
            }
        }

    }
    return lista;
}

QList<QObject *> ManagerEstadisticas::obtenerAlumnosDeudores()
{
    QList<QObject *> lista;
    QSqlQuery query;

    total_deuda = 0;

    query.prepare("SELECT "
                  "cliente.id AS id_alumno, "
                  "cuenta.id AS id_cuenta, "
                  "credito_actual, "
                  "cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente "
                  "FROM cuenta_cliente cuenta "
                  "INNER JOIN cliente ON cuenta.id_cliente = cliente.id "
                  "WHERE credito_actual < 0 "
                  "ORDER BY nombre_cliente");


    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            EstadoAlumno *obj = new EstadoAlumno();
            obj->setId_alumno(query.value("id_alumno").toInt());
            obj->setId_cuenta(query.value("id_cuenta").toInt());
            obj->setCredito((query.value("credito_actual").toReal())*-1);
            obj->setNombre_cliente(query.value("nombre_cliente").toString());
            lista.append(obj);
            total_deuda += obj->credito();
        }
    }

    return lista;
}

QList<QObject *> ManagerEstadisticas::obtenerAlumnosMerecedores()
{
    QList<QObject *> lista;
    QSqlQuery query;

    total_favor = 0;

    query.prepare("SELECT "
                  "cliente.id AS id_alumno, "
                  "cuenta.id AS id_cuenta, "
                  "credito_actual, "
                  "cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente "
                  "FROM cuenta_cliente cuenta "
                  "INNER JOIN cliente ON cuenta.id_cliente = cliente.id "
                  "WHERE credito_actual > 0 "
                  "ORDER BY nombre_cliente");

    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            EstadoAlumno *obj = new EstadoAlumno();
            obj->setId_alumno(query.value("id_alumno").toInt());
            obj->setId_cuenta(query.value("id_cuenta").toInt());
            obj->setCredito(query.value("credito_actual").toReal());
            obj->setNombre_cliente(query.value("nombre_cliente").toString());
            lista.append(obj);
            total_favor += obj->credito();
        }
    }

    return lista;
}

QList<QObject *> ManagerEstadisticas::obtenerAlumnosDeudoresDeHoy()
{
    QList<QObject *> lista;
    QSqlQuery query;

    total_deuda_hoy=0;

    QDateTime dt = QDateTime::currentDateTime();
    dt.setTime(QTime(0,0,0));
    QString strDt = dt.toString("yyyy-MM-dd HH:mm:ss");

    query.prepare("SELECT "
                  "cliente.id AS id_alumno, "
                  "c.id AS id_cuenta, "
                  "credito_actual, "
                  "cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente "
                  "FROM movimiento m "
                  "INNER JOIN cuenta_cliente c ON c.id = m.id_cuenta_cliente "
                  "INNER JOIN cliente ON c.id_cliente = cliente.id "
                  "WHERE m.fecha_movimiento > '"+strDt+"' "
                  "AND c.credito_actual < 0 "
                  "GROUP BY c.id "
                  "ORDER BY nombre_cliente");


    if(!query.exec()) {
        qDebug() << query.lastError();
        qDebug() << query.executedQuery();
    }
    else {
        while (query.next()) {
            EstadoAlumno *obj = new EstadoAlumno();
            obj->setId_alumno(query.value("id_alumno").toInt());
            obj->setId_cuenta(query.value("id_cuenta").toInt());
            obj->setCredito((query.value("credito_actual").toReal())*-1);
            obj->setNombre_cliente(query.value("nombre_cliente").toString());
            lista.append(obj);
            total_deuda_hoy = obj->credito();
        }
    }

    qDebug() << "lista.count(): " << lista.count();

    return lista;
}

QList<QObject *> ManagerEstadisticas::obtenerAlumnosMerecedoresDeHoy()
{
    QList<QObject *> lista;
    QSqlQuery query;

    total_favor_hoy = 0;

    QDateTime dt = QDateTime::currentDateTime();
    dt.setTime(QTime(0,0,0));
    QString strDt = dt.toString("yyyy-MM-dd HH:mm:ss");

    query.prepare("SELECT "
                  "cliente.id AS id_alumno, "
                  "c.id AS id_cuenta, "
                  "credito_actual, "
                  "cliente.apellido || ', ' || cliente.primer_nombre AS nombre_cliente "
                  "FROM movimiento m "
                  "INNER JOIN cuenta_cliente c ON c.id = m.id_cuenta_cliente "
                  "INNER JOIN cliente ON c.id_cliente = cliente.id "
                  "WHERE m.fecha_movimiento > '"+strDt+"' "
                  "AND m.credito_cuenta <= 0 "
                  "AND c.credito_actual > 0 "
                  "GROUP BY c.id "
                  "ORDER BY nombre_cliente");


    if(!query.exec()) {
        qDebug() << query.lastError();
    }
    else {
        while (query.next()) {
            EstadoAlumno *obj = new EstadoAlumno();
            obj->setId_alumno(query.value("id_alumno").toInt());
            obj->setId_cuenta(query.value("id_cuenta").toInt());
            obj->setCredito(query.value("credito_actual").toReal());
            obj->setNombre_cliente(query.value("nombre_cliente").toString());
            lista.append(obj);
            total_favor_hoy+= obj->credito();
        }
    }

    return lista;
}

int ManagerEstadisticas::obtenerMaximo_presentes_adultos()
{
    return maximo_presentes_adultos;
}

int ManagerEstadisticas::obtenerMaximo_presentes_infantiles()
{
    return maximo_presentes_infantiles;
}

int ManagerEstadisticas::obtenerTotal_presentes_adultos()
{
    return total_presentes_adultos;
}

int ManagerEstadisticas::obtenerTotal_presentes_infantiles()
{
    return total_presentes_infantiles;
}

int ManagerEstadisticas::obtenerCantidadAlumnos()
{
    return cantidad_alumnos;
}

int ManagerEstadisticas::obtenerMaximoCantidadAlumnosDelMes()
{
    return maximo_cantidad_alumnos;
}

int ManagerEstadisticas::obtenerTotalAbonosAdultos()
{
    return total_abonos_adultos;
}

int ManagerEstadisticas::obtenerMaximoAbonosAdultosDelMes()
{
    return maximo_abonos_adultos;
}

int ManagerEstadisticas::obtenerTotalAbonosInfantiles()
{
    return total_abonos_infantiles;
}

int ManagerEstadisticas::obtenerMaximoAbonosInfantilesDelMes()
{
    return maximo_abonos_infantiles;
}

float ManagerEstadisticas::obtenerTotalDeuda(){
    return total_deuda;
}

float ManagerEstadisticas::obtenerTotalDeudaHoy() {
    return total_deuda_hoy;
}

float ManagerEstadisticas::obtenerFavor() {
    return total_favor;
}

float ManagerEstadisticas::obtenerFavorHoy() {
    return total_favor_hoy;
}

