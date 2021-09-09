import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"
    clip: true
    property int widthBotonOpcion : 100
    property int m_heightButton : 30
    property string colorPestania: "#FFE0B2"

    WrapperClassManagement {
        id: wrapper
    }

    FlipableMetro {
        id: flipable
        anchors.fill: parent

        front: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#FFCC80"
            strTitulo : qsTrId("Actividades y clases")
            strDescripcion : qsTrId("Desde aquí, haga lo siguiente:  \n\n- Registre actividades\n- Cree clases para cada actividad\n- Rendimiento de las clases")
            strImagen : "qrc:/media/Media/actividades.PNG"
            enabled: !parent.flipped
            antialiasing: true
        }

        back: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#FFCC80"
            strTitulo : qsTrId("Actividades y clases")
            strDescripcion: ""
            //strImgBackground: "qrc:/media/Media/over18.png"
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
                    m_text: qsTrId("Administración general")
                    m_strSourceIcon: "qrc:/media/Media/bailarines.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Actividades y clases","qrc:/danzas/AdminDanzaPlusClase.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Rendimiento de las clases")
                    m_strSourceIcon: "qrc:/media/Media/Estad.png"

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Rendimiento de clases","qrc:/danzas/EstadisticasDanza.qml",colorPestania)
                    }
                }
            }
        }
    }
}
