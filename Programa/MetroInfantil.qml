import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"
    clip: true
    property int widthBotonOpcion : 100
    property int m_heightButton : 30
    property string colorPestania: "#FFCDD2"

    WrapperClassManagement {
        id: wrapper
    }

    FlipableMetro {
        id: flipable
        anchors.fill: parent

        front: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#EF9A9A"
            strTitulo : qsTrId("Niños")
            strDescripcion : qsTrId("Desde aquí, haga lo siguiente:  \n\n- De un presente\n- Venda un abono\n- Administre los abonos")
            //strImagen : "qrc:/media/Media/GirlDancing.png"
            strImagen: "qrc:/media/Media/niños.PNG"
            enabled: !parent.flipped
            antialiasing: true
        }

        back: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#EF9A9A"
            strTitulo : qsTrId("Niños")
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
                    m_text: qsTrId("Dar presente (F5)")
                    m_strSourceIcon: "qrc:/media/Media/ok.png"

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Dar presente infantil","qrc:/infantil/RegistrarPresenteInfantil.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("     Dar presente vía tabla gráfica (F9)")
                    m_strSourceIcon: "qrc:/media/Media/tablas.png"

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Tabla gráfica presentes","qrc:/infantil/NuevaTablaGrafica.qml",colorPestania)
                        //wrapper.managerPestanias.nuevaPestania("Tabla gráfica presentes","qrc:/infantil/VistaGraficaPresentes.qml",colorPestania)
                    }
                }

                /*BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Nueva tabla gráfica (F5)")
                    m_strSourceIcon: "qrc:/media/Media/tablas.png"

                    onM_clicked: {
                        //wrapper.managerPestanias.nuevaPestania("Nueva tabla gráfica","qrc:/infantil/NuevaTablaGrafica.qml",colorPestania)
                        wrapper.managerPestanias.nuevaPestania("Tabla gráfica presentes","qrc:/infantil/VistaGraficaPresentes.qml",colorPestania)
                    }
                }*/

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Vender abono (F6)")
                    m_strSourceIcon: "qrc:/media/Media/credencial.png"

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Venta abono infantil","qrc:/infantil/ComprarAbonoInfantil.qml",colorPestania)
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Mejorar o degradar abono")
                    m_strSourceIcon: "qrc:/media/Media/cajon.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Editar abono infantil","qrc:/infantil/AdministrarAbonosInfantiles.qml",colorPestania)
                    }
                }


                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Oferta de abonos")
                    m_strSourceIcon: "qrc:/media/Media/oferta_abonos.png"
                    alias_opacity_image: 0.6

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("Ofertas de abono infantil","qrc:/infantil/OfertaDeAbonos.qml",colorPestania)
                    }
                }
            }
        }
    }
}


