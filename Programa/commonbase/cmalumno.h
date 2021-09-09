#ifndef CMPERSON_H
#define CMPERSON_H
#include <QObject>
#include <QDate>
#include <QDateTime>

class CMAlumno: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ getId WRITE setId NOTIFY sig_idChanged)
    Q_PROPERTY(QString apellido READ getApellido WRITE setApellido NOTIFY sig_apellidoChanged)
    Q_PROPERTY(QString primerNombre READ getPrimerNombre WRITE setPrimerNombre NOTIFY sig_primerNombreChanged)
    Q_PROPERTY(QString segundoNombre READ getSegundoNombre WRITE setSegundoNombre NOTIFY segundoNombreChanged)
    Q_PROPERTY(QString genero READ getGenero WRITE setGenero NOTIFY generoChanged)
    Q_PROPERTY(QDate nacimiento READ getNacimiento WRITE setNacimiento NOTIFY nacimientoChanged)
    Q_PROPERTY(QString dni READ getDni WRITE setDni NOTIFY sig_dniChanged)
    Q_PROPERTY(QString telefonoFijo READ getTelefonoFijo WRITE setTelefonoFijo NOTIFY telefonoFijoChanged)
    Q_PROPERTY(QString telefonoCelular READ getTelefonoCelular WRITE setTelefonoCelular NOTIFY telefonoCelularChanged)
    Q_PROPERTY(QString correo READ getCorreo WRITE setCorreo NOTIFY correoChanged)
    Q_PROPERTY(QString nota READ getNota WRITE setNota NOTIFY notaChanged)
    Q_PROPERTY(QString estado READ getEstado WRITE setEstado NOTIFY estadoChanged)
    Q_PROPERTY(QString blameUser READ getBlameUser WRITE setBlameUser NOTIFY blameUserChanged)
    Q_PROPERTY(QDateTime blameTimeStamp READ getBlameTimeStamp WRITE setBlameTimeStamp NOTIFY blameTimeStampChanged)
    Q_PROPERTY(QDateTime fechaAlta READ fechaAlta WRITE setFechaAlta NOTIFY fechaAltaChanged)
    Q_PROPERTY(QDateTime fecha_matriculacion_infantil READ fecha_matriculacion_infantil WRITE setFecha_matriculacion_infantil NOTIFY fecha_matriculacion_infantilChanged)

    Q_PROPERTY(bool inscripto_a_clase READ inscripto_a_clase WRITE setInscripto_a_clase NOTIFY inscripto_a_claseChanged)
    Q_PROPERTY(bool matriculado READ matriculado WRITE setMatriculado NOTIFY matriculadoChanged)

    Q_PROPERTY(float credito_cuenta READ credito_cuenta WRITE setCredito_cuenta NOTIFY credito_cuentaChanged)
    Q_PROPERTY(int id_cuenta_alumno READ id_cuenta_alumno WRITE setId_cuenta_alumno NOTIFY id_cuenta_alumnoChanged)



    //fechaAlta
public:
    CMAlumno();
    CMAlumno(QString apellido, QString nombre, QString dni);
    void setId(int id) {this->id = id;}
    int getId() {return id;}
    void setApellido(QString apellido) {this->apellido = apellido;}
    QString getApellido() {return apellido;}
    void setPrimerNombre(QString primerNombre) {this->primerNombre = primerNombre;}
    QString getPrimerNombre() {return primerNombre;}
    void setDni(QString dni);
    QString getDni() {return dni;}
    QString getQueryParaBusqueda();
    QString getQueryParaActualizacion();
    QString toString();
    QString getSegundoNombre() const {return m_segundoNombre; }
    QString getGenero() const {return m_genero; }
    QDate getNacimiento() const { return m_nacimiento;}
    QString getTelefonoFijo() const { return m_telefonoFijo; }
    QString getTelefonoCelular() const { return m_telefonoCelular; }
    QString getCorreo() const {return m_correo;}
    QString getNota() const { return m_nota;}
    QString getEstado() const { return m_estado;}
    QString getBlameUser() const { return m_blameUser; }
    QDateTime getBlameTimeStamp() const { return m_blameTimeStamp;}
    QDateTime fechaAlta() const;

    float credito_cuenta() const;
    int id_cuenta_alumno() const;

    bool inscripto_a_clase() const;

    QDateTime fecha_matriculacion_infantil() const;

    bool matriculado() const;

public slots:
    void setSegundoNombre(QString arg);
    void setGenero(QString arg);
    void setNacimiento(QDate arg);
    void setTelefonoFijo(QString arg);
    void setTelefonoCelular(QString arg);
    void setCorreo(QString arg);
    void setNota(QString arg);
    void setEstado(QString arg);
    void setBlameUser(QString arg);
    void setBlameTimeStamp(QDateTime arg);
    void setFechaAlta(QDateTime arg);

    void setCredito_cuenta(float credito_cuenta);
    void setId_cuenta_alumno(int id_cuenta_alumno);

    void setInscripto_a_clase(bool inscripto_a_clase);

    void setFecha_matriculacion_infantil(QDateTime fecha_matriculacion_infantil);


    void setMatriculado(bool matriculado);

private:
    int id;
    QString apellido;
    QString primerNombre;
    QString dni;
    QString m_segundoNombre;
    QString m_genero;
    QDate m_nacimiento;
    QString m_telefonoFijo;
    QString m_telefonoCelular;
    QString m_correo;
    QString m_nota;
    QString m_estado;
    QString m_blameUser;
    QDateTime m_blameTimeStamp;
    QDateTime m_fechaAlta;

    float m_credito_cuenta;

    int m_id_cuenta_alumno;

    bool m_inscripto_a_clase;

    QDateTime m_fecha_matriculacion_infantil;

    bool m_matriculado;

signals:
    void sig_idChanged();
    void sig_apellidoChanged();
    void sig_primerNombreChanged();
    void sig_dniChanged();
    void segundoNombreChanged(QString arg);
    void generoChanged(QString arg);
    void nacimientoChanged(QDate arg);
    void telefonoFijoChanged(QString arg);
    void telefonoCelularChanged(QString arg);
    void correoChanged(QString arg);
    void notaChanged(QString arg);
    void estadoChanged(QString arg);
    void blameUserChanged(QString arg);
    void blameTimeStampChanged(QDateTime arg);
    void fechaAltaChanged(QDateTime arg);
    void credito_cuentaChanged(float credito_cuenta);
    void id_cuenta_alumnoChanged(int id_cuenta_alumno);
    void inscripto_a_claseChanged(bool inscripto_a_clase);
    void fecha_matriculacion_infantilChanged(QDateTime fecha_matriculacion_infantil);
    void matriculadoChanged(bool matriculado);
};

#endif // CMPERSON_H
