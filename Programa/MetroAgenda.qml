/*import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"
    clip: true

    WrapperClassManagement {
        id: wrapper
    }

    FlipableMetro {
        id: flipable
        anchors.fill: parent

        front: ModuloMetro {
            id: modulo
            anchors.fill: parent
            colorTitulo: "#ff6d6d"
            strTitulo : qsTrId("Agenda de eventos")
            strDescripcion : qsTrId("Programe encuentros.  \n\n- Evento único\n- Múltiples eventos\n- Cancelación")
            strImagen : "qrc:/media/Media/Calendario.png"
        }

        back: ModuloMetro {
            anchors.fill: parent
            colorTitulo: "#ff6d6d"
            strTitulo : qsTrId("Agenda de eventos")
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
                    m_text: qsTrId("Calendario")

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("C:Admin.","qrc:/agenda/AbmAgenda.qml")
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Hoy")

                    onM_clicked: {
                        //wrapper.managerPestanias.nuevaPestania("C:Alta","qrc:/estudiante/AltaDeCliente.qml")
                    }
                }
            }
        }
    }
}
*/
import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"
    clip: true
    property int widthBotonOpcion : 100
    property int m_heightButton : 30

    WrapperClassManagement {
        id: wrapper
    }

    FlipableMetro {
        id: flipable
        anchors.fill: parent

        front: ModuloMetro {
            anchors.fill: parent
            enabled: !parent.flipped
            antialiasing: true
            colorTitulo: "#ff6d6d"
            strTitulo : qsTrId("Agenda")
            strDescripcion : qsTrId("Práctica agenda a su disposición  \n\n- Tome cuantas notas quiera\n- Mire lo agendado de cada día\n- Vea los cumpleaños del mes")
            strImagen : "qrc:/media/Media/Calendario.png"
        }

        back: ModuloMetro {
            anchors.fill: parent
            strDescripcion: ""
            //strImgBackground: "qrc:/media/Media/woman.jpg"
            enabled: parent.flipped
            antialiasing: true
            colorTitulo: "#ff6d6d"
            strTitulo : qsTrId("Agenda")

            Column {
                anchors.top: parent.top
                anchors.topMargin: parent.heightTitulo
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 1
                spacing: 1

                /*BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Fresh Calendar")

                    onM_clicked: {
                        wrapper.managerPestanias.nuevaPestania("E:Fresh Calendar","qrc:/fresh_calendar/FreshCalendar.qml")
                    }
                }*/

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Abrir agenda")
                    m_strSourceIcon: "qrc:/media/Media/calendar.png"

                    onM_clicked: {
                        //wrapper.managerPestanias.nuevaPestania("E:Agenda","qrc:/agenda/AbmAgenda.qml")
                        wrapper.managerPestanias.nuevaPestania("Agenda","qrc:/fresh_calendar/FreshCalendar.qml")
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Evento rápido para hoy")
                    m_strSourceIcon: "qrc:/media/Media/nota.png"

                    onM_clicked: {
                        wrapper.managerNuevoEvento.eventoRapidoParaHoy()
                    }
                }

                BotonOpcion {
                    height: m_heightButton
                    width: parent.width
                    m_text: qsTrId("Evento rápido para mañana")
                    m_strSourceIcon: "qrc:/media/Media/nota.png"
                    m_strSourceIconExtra: "qrc:/media/Media/clock.png"

                    onM_clicked: {
                        wrapper.managerNuevoEvento.eventoRapidoParaManiana()
                    }
                }
            }
        }
    }
}
