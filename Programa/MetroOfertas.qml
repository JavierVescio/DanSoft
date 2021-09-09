import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"
    clip: true
    property int widthBotonOpcion : 100
    property int m_heightButton : 30
    property string colorPestania: "#FBE9E7"

    WrapperClassManagement {
        id: wrapper
    }

    FlipableMetro {
        id: flipable
        anchors.fill: parent

        front: ModuloMetro {
            id: modulo
            anchors.fill: parent
            colorTitulo: "#FFAB91"
            strTitulo : qsTrId("Tienda")
            strDescripcion : qsTrId("Desde aquí, haga lo siguiente:  \n\n- Registre ventas adicionales\n- Admin. productos y servicios\n")
            strImagen: "qrc:/media/Media/dancer-store-cartoon-t.png"
        }

        back: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#FFAB91"
            strTitulo : qsTrId("Tienda")
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
                    m_text: qsTrId("Ingresar a la tienda")
                    m_strSourceIcon: "qrc:/media/Media/ico-carrito.png"
                    //m_strSourceIcon: "qrc:/media/Media/ico-bolsa.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Tienda","qrc:/ofertas/CompraOfertas.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Alta de oferta")
                    m_strSourceIcon: "qrc:/media/Media/ico-sale.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Alta de oferta","qrc:/ofertas/AltaOferta.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Administración de ofertas")
                    //m_strSourceIcon: "qrc:/media/Media/ico-bolsa.png"
                    m_strSourceIcon: "qrc:/media/Media/opciones.png"

                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Admin. de ofertas","qrc:/ofertas/AdminOfertas.qml",colorPestania)
                    }
                }
            }
        }
    }
}
