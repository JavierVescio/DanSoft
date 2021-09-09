#ifndef LISTASCONINFORMACION_H
#define LISTASCONINFORMACION_H

#include <QObject>

class ListasConInformacion: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> listaAsistencias READ listaAsistencias WRITE setListaAsistencias NOTIFY listaAsistenciasChanged)
    Q_PROPERTY(QList<QObject*> listaMovimientos READ listaMovimientos WRITE setListaMovimientos NOTIFY listaMovimientosChanged)

public:
    ListasConInformacion();    
    QList<QObject*> listaAsistencias() const;
    QList<QObject*> listaMovimientos() const;

public slots:
    void setListaAsistencias(QList<QObject*> listaAsistencias);
    void setListaMovimientos(QList<QObject*> listaMovimientos);

signals:
    void listaAsistenciasChanged(QList<QObject*> listaAsistencias);
    void listaMovimientosChanged(QList<QObject*> listaMovimientos);

private:
    QList<QObject*> m_listaAsistencias;
    QList<QObject*> m_listaMovimientos;
};

#endif // LISTASCONINFORMACION_H
