import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"
    clip: true
    property int widthBotonOpcion : 100
    property int m_heightButton : 30
    property string colorPestania: "#FFF9C4"

    WrapperClassManagement {
        id: wrapper
    }

    FlipableMetro {
        id: flipable
        anchors.fill: parent

        front: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#FFF59D"
            strTitulo : qsTrId("Gestión de alumnos")
            strDescripcion : qsTrId("Desde aquí, haga lo siguiente: \n\n- Consulte fichas de alumnos\n- Registre un nuevo alumno/a\n- Actualice datos\n- Baja de alumno/a")
            //strImagen : "qrc:/media/Media/Alumnos.png"
            strImagen: "qrc:/media/Media/varios_alumnos.png"
            enabled: !parent.flipped
            antialiasing: true
        }

        back: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#FFF59D"
            strTitulo : qsTrId("Gestión de alumnos")
            strDescripcion: ""
            //strImgBackground: "qrc:/media/Media/woman.jpg"
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
                    m_text: qsTrId("Alta de alumno (F3)")
                    m_strSourceIcon: "qrc:/media/Media/Persona.png"

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Alta de alumno/a","qrc:/estudiante/PreAltaDeCliente.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Administración de alumnos (F4)")
                    m_strSourceIcon: "qrc:/media/Media/Personas.png"

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Admin. de alumnos","qrc:/estudiante/ConsultaDeCliente.qml",colorPestania)
                    }
                }
            }
        }
    }
}
