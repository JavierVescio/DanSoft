#ifndef PESTANIA_H
#define PESTANIA_H
#include <QObject>

class Pestania : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString tituloPestania READ getTituloPestania WRITE setTituloPestania NOTIFY tituloPestaniaChanged)
    Q_PROPERTY(QString source READ getSource WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(bool hayCambiosSinGuardar READ getHayCambiosSinGuardar WRITE setHayCambiosSinGuardar NOTIFY hayCambiosSinGuardarChanged)
    Q_PROPERTY(bool sePuedeCerrar READ getSePuedeCerrar WRITE setSePuedeCerrar NOTIFY sePuedeCerrarChanged)
    Q_PROPERTY(QObject* qmlPestania READ getQmlPestania WRITE setQmlPestania NOTIFY qmlPestaniaChanged)

public:
    Pestania();
    Pestania(QString tituloPestania, QString source, QString color = "lightgrey", bool hayCambiosSinGuardar = false, bool sePuedeCerrar = true);
    QString getTituloPestania() const;
    QString getSource() const;
    bool getHayCambiosSinGuardar() const;
    bool getSePuedeCerrar() const;
    QObject* getQmlPestania() const;

    QString color() const;

private:
    QString m_tituloPestania;
    QString m_source;
    bool m_hayCambiosSinGuardar;
    bool m_sePuedeCerrar;
    QObject* m_qmlPestania;

    QString m_color;

signals:
    void tituloPestaniaChanged(QString arg);
    void sourceChanged(QString arg);
    void hayCambiosSinGuardarChanged(bool arg);
    void sePuedeCerrarChanged(bool arg);
    void qmlPestaniaChanged(QObject* arg);
    void sig_mostrarme();

    void colorChanged(QString color);

public slots:
    void setTituloPestania(QString arg);
    void setSource(QString arg);
    void setHayCambiosSinGuardar(bool arg);
    void setSePuedeCerrar(bool arg);
    void setQmlPestania(QObject* arg);
    void setColor(QString color);
};

#endif // PESTANIA_H
