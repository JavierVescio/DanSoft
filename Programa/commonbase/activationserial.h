#ifndef ACTIVATIONSERIAL_H
#define ACTIVATIONSERIAL_H
#include <QObject>
#include <QDate>

class ActivationSerial: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString serial READ getSerial WRITE setSerial NOTIFY serialChanged)
    Q_PROPERTY(QDate valid_date_from READ getValid_date_from WRITE setValid_date_from NOTIFY valid_date_fromChanged)
    Q_PROPERTY(QDate valid_date_to READ getValid_date_to WRITE setValid_date_to NOTIFY valid_date_toChanged)

public:
    ActivationSerial();
    ActivationSerial(QString serial, QDate valid_date_from, QDate valid_date_to);

    QString getSerial() const;
    QDate getValid_date_from() const;
    QDate getValid_date_to() const;

private:
    QString m_serial;
    QDate m_valid_date_from;
    QDate m_valid_date_to;

public slots:
    void setSerial(QString serial);
    void setValid_date_from(QDate valid_date_from);
    void setValid_date_to(QDate valid_date_to);

signals:
    void serialChanged(QString serial);
    void valid_date_fromChanged(QDate valid_date_from);
    void valid_date_toChanged(QDate valid_date_to);
};

#endif // ACTIVATIONSERIAL_H
