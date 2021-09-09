#include "activationserial.h"

ActivationSerial::ActivationSerial() {

}

ActivationSerial::ActivationSerial(QString serial, QDate valid_date_from, QDate valid_date_to)
{
    m_serial = serial;
    m_valid_date_from = valid_date_from;
    m_valid_date_to = valid_date_to;
}

QString ActivationSerial::getSerial() const
{
    return m_serial;
}

QDate ActivationSerial::getValid_date_from() const
{
    return m_valid_date_from;
}

QDate ActivationSerial::getValid_date_to() const
{
    return m_valid_date_to;
}

void ActivationSerial::setSerial(QString serial)
{
    if (m_serial == serial)
        return;

    m_serial = serial;
    emit serialChanged(serial);
}

void ActivationSerial::setValid_date_from(QDate valid_date_from)
{
    if (m_valid_date_from == valid_date_from)
        return;

    m_valid_date_from = valid_date_from;
    emit valid_date_fromChanged(valid_date_from);
}

void ActivationSerial::setValid_date_to(QDate valid_date_to)
{
    if (m_valid_date_to == valid_date_to)
        return;

    m_valid_date_to = valid_date_to;
    emit valid_date_toChanged(valid_date_to);
}

