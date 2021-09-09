import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"
    clip: true
    property int widthBotonOpcion : 100
    property int m_heightButton : 30
    property string colorPestania: "#C8E6C9"

    WrapperClassManagement {
        id: wrapper
    }

    FlipableMetro {
        id: flipable
        anchors.fill: parent

        front: ModuloMetro {
            id: modulo
            anchors.fill: parent
            colorTitulo: "#A5D6A7"
            strTitulo : qsTrId("Tesorería")
            strDescripcion : qsTrId("Desde aquí, haga lo siguiente:  \n\n- Administre cuenta alumno\n- Administre la caja\n- Control de caja\n- Rendimiento general")
            strImagen : "qrc:/media/Media/cajero_automatico.PNG"
        }

        back: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#A5D6A7"
            strTitulo : qsTrId("Tesorería")
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
                    m_text: qsTrId("Administrar cuenta alumno")
                    m_strSourceIcon: "qrc:/media/Media/icon-frasco-monedas.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Admin. cuenta alumno","qrc:/tesoreria/AdministrarSaldo.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Administrar caja")
                    m_strSourceIcon: "qrc:/media/Media/bolsa_dinero.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Administrar caja","qrc:/tesoreria/AdministrarCaja.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Control de caja")
                    m_strSourceIcon: "qrc:/media/Media/icon-calculadora.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Control de caja","qrc:/tesoreria/ControlCaja.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Rendimiento general")
                    m_strSourceIcon: "qrc:/media/Media/icon-piechart.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Rendimiento general","qrc:/tesoreria/RendimientoEstablecimiento.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("   Resumen sobre venta de abonos")
                    m_strSourceIcon: "qrc:/media/Media/oferta_abonos.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Resumen venta abonos","qrc:/tesoreria/ResumenVentaAbonos.qml",colorPestania)
                    }
                }
            }
        }
    }
}
