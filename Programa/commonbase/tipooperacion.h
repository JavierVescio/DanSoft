#ifndef TIPOOPERACION_H
#define TIPOOPERACION_H

#include <QObject>

class TipoOperacion: public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString descripcion READ descripcion WRITE setDescripcion NOTIFY descripcionChanged)

public:
    TipoOperacion();
    int id() const;
    QString descripcion() const;

public slots:
    void setId(int id);
    void setDescripcion(QString descripcion);

signals:
    void idChanged(int id);
    void descripcionChanged(QString descripcion);

private:
    int m_id;
    QString m_descripcion;
};

#endif // TIPOOPERACION_H
