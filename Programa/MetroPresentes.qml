import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"
    clip: true
    property int widthBotonOpcion : 100
    property int m_heightButton : 30
    property string colorPestania: "#E1BEE7"

    WrapperClassManagement {
        id: wrapper
    }

    FlipableMetro {
        id: flipable
        anchors.fill: parent

        front: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#CE93D8"
            strTitulo : qsTrId("Asistencias")
            strDescripcion : qsTrId("Desde aquí, consulte presentes:  \n\n- De un alumno/a\n- De varios alumnos\n- Asociados al abono adulto\n- Por clase\n- Por actividad")
            strImagen : "qrc:/media/Media/asistiendo.PNG"
            enabled: !parent.flipped
            antialiasing: true
        }

        back: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#CE93D8"
            strTitulo : qsTrId("Asistencias")
            strDescripcion: ""
            enabled: parent.flipped
            antialiasing: true

            Column {
                anchors.top: parent.top
                anchors.topMargin: parent.heightTitulo
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 1
                spacing: 1

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Dar presente como clase suelta")
                    m_strSourceIcon: "qrc:/media/Media/agregar_blanco_negro.png"

                    //ELIMINAR LA SIGUIENTE LINEA LUEGO
                    enabled: false
                    visible: false
                    ///////////////////////////////////

                    onM_clicked: {
                        //wrapper.managerPestanias.nuevaPestania("C:Admin.","qrc:/estudiante/ConsultaDeCliente.qml", colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Por fecha de un alumno/a")
                    m_strSourceIcon: "qrc:/media/Media/Persona.png"
                    m_strSourceIconExtra: "qrc:/media/Media/buscar.png"

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Asist. de un alumno","qrc:/presentes/ConsultarPresentesPorAlumno.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Por fecha de varios alumnos")
                    m_strSourceIcon: "qrc:/media/Media/Personas.png"
                    m_strSourceIconExtra: "qrc:/media/Media/buscar.png"

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Asist. de varios alumnos","qrc:/presentes/ConsultarPresentesPorFecha.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Por abono adulto")
                    m_strSourceIcon: "qrc:/media/Media/credencial.png"
                    m_strSourceIconExtra: "qrc:/media/Media/buscar.png"

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Asist. por abono adulto","qrc:/presentes/ConsultarPresentesPorAbono.qml",colorPestania)
                    }
                }
                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Por actividad")
                    m_strSourceIcon: "qrc:/media/Media/bailarines.png"
                    m_strSourceIconExtra: "qrc:/media/Media/buscar.png"
                    alias_opacity_image: 0.7

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Asist. por actividad","qrc:/presentes/ConsultarPresentesPorActividad.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Por clase")
                    m_strSourceIcon: "qrc:/media/Media/bailarines.png"
                    m_strSourceIconExtra: "qrc:/media/Media/buscar.png"
                    alias_opacity_image: 0.7

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Asist. por clase","qrc:/presentes/ConsultarPresentesPorClase.qml",colorPestania)
                    }
                }

            }
        }
    }
}
