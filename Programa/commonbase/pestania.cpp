#include "pestania.h"
#include <QDebug>

Pestania::Pestania() {
    m_tituloPestania = "";
    m_source = "";
    m_hayCambiosSinGuardar = false;
    m_sePuedeCerrar = true;
}

Pestania::Pestania(QString tituloPestania, QString source, QString color, bool hayCambiosSinGuardar, bool sePuedeCerrar) {
    m_tituloPestania = tituloPestania;
    m_source = source;
    m_color = color;
    m_hayCambiosSinGuardar = hayCambiosSinGuardar;
    m_sePuedeCerrar = sePuedeCerrar;
}

QString Pestania::getTituloPestania() const
{
    return m_tituloPestania;
}

QString Pestania::getSource() const
{
    return m_source;
}

bool Pestania::getHayCambiosSinGuardar() const
{
    return m_hayCambiosSinGuardar;
}

bool Pestania::getSePuedeCerrar() const
{
    return m_sePuedeCerrar;
}

QObject *Pestania::getQmlPestania() const
{
    return m_qmlPestania;
}

QString Pestania::color() const
{
    return m_color;
}

void Pestania::setTituloPestania(QString arg)
{
    if (m_tituloPestania == arg)
        return;

    m_tituloPestania = arg;
    emit tituloPestaniaChanged(arg);
}

void Pestania::setSource(QString arg)
{
    if (m_source == arg)
        return;

    m_source = arg;
    emit sourceChanged(arg);
}

void Pestania::setHayCambiosSinGuardar(bool arg)
{
    if (m_hayCambiosSinGuardar == arg)
        return;

    m_hayCambiosSinGuardar = arg;
    emit hayCambiosSinGuardarChanged(arg);
}

void Pestania::setSePuedeCerrar(bool arg)
{
    if (m_sePuedeCerrar == arg)
        return;

    m_sePuedeCerrar = arg;
    emit sePuedeCerrarChanged(arg);
}

void Pestania::setQmlPestania(QObject *arg)
{
    if (m_qmlPestania == arg)
        return;

    m_qmlPestania = arg;
    emit qmlPestaniaChanged(arg);
}

void Pestania::setColor(QString color)
{
    if (m_color == color)
        return;

    m_color = color;
    emit colorChanged(m_color);
}
