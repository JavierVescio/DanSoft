#ifndef BACKUP_H
#define BACKUP_H

#include <QObject>

class BackUp: public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString ruta1 READ ruta1 WRITE setRuta1 NOTIFY ruta1Changed)
    Q_PROPERTY(QString ruta2 READ ruta2 WRITE setRuta2 NOTIFY ruta2Changed)
    Q_PROPERTY(bool al_cerrar_caja READ al_cerrar_caja WRITE setAl_cerrar_caja NOTIFY al_cerrar_cajaChanged)
    Q_PROPERTY(bool al_cerrar_sistema READ al_cerrar_sistema WRITE setAl_cerrar_sistema NOTIFY al_cerrar_sistemaChanged)

public:
    BackUp();

    int id() const;

    QString ruta1() const;

    QString ruta2() const;

    bool al_cerrar_caja() const;

    bool al_cerrar_sistema() const;

public slots:
    void setId(int id);

    void setRuta1(QString ruta1);

    void setRuta2(QString ruta2);

    void setAl_cerrar_caja(bool al_cerrar_caja);

    void setAl_cerrar_sistema(bool al_cerrar_sistema);

signals:
    void idChanged(int id);

    void ruta1Changed(QString ruta1);

    void ruta2Changed(QString ruta2);

    void al_cerrar_cajaChanged(bool al_cerrar_caja);

    void al_cerrar_sistemaChanged(bool al_cerrar_sistema);

private:

    int m_id;
    QString m_ruta1;
    QString m_ruta2;
    bool m_al_cerrar_caja;
    bool m_al_cerrar_sistema;
};

#endif // BACKUP_H
