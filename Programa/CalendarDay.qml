import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.5
import QtQuick.Dialogs 1.2
import com.mednet.CMAlumno 1.0

Rectangle {
    id: recDia
    height: gridCalendar.cellHeight
    width: gridCalendar.cellWidth
    property color colorBordeNormal: "#CCCCCC"
    property color colorBordeMouseEntered: "#2C609F"
    property var modelCumpleanieros
    property int intCumples : 0
    property var modelEventos
    property int intEventos : 0
    property date today
    property alias aliasLista_cumples_alumnos : lista_cumples_alumnos
    border.color: colorBordeNormal

    Component.onCompleted: {
        loadDay()
    }

    /*Connections {
        target: wrapper
    }*/

    function loadDay() {
        if (lblDia.text == "") {
            recDia.visible = false
        }
        else {
            /*if (lblDia.text == "1")
                gridCalendar.currentIndex = index*/
            //cumples = wrapper.classManagementGestionDeAlumnos.getBirthdaysByDate(gridCalendar.model[index].fecha)
            modelCumpleanieros = wrapper.classManagementGestionDeAlumnos.getBirthdaysByDay(gridCalendar.model[index].fecha)
            intCumples = modelCumpleanieros.length
            if (intCumples > 0) {
                recCumples.opacity = 1
                imgFotoCumple.opacity = 1
                today = gridCalendar.model[index].fecha
                lista_cumples_alumnos.model = modelCumpleanieros
            }

            modelEventos = wrapper.managerNuevoEvento.eventsForDate(gridCalendar.model[index].fecha,false)
            intEventos = modelEventos.length
            if (intEventos > 0) {
                //recCumples.opacity = 1
                imgFotoEvento.opacity = 1
                //lista_cumples_alumnos.model = modelCumpleanieros
            }
            if (gridCalendar.model[index].estado == "pasado") {
                color = "#EEEEEE"
            }
        }
    }

    Text {
        id: lblDia
        y: 4
        x: 4
        font.family: "Verdana"
        font.pixelSize: 1/7*(recDia.height)
        text: Qt.formatDate(gridCalendar.model[index].fecha,"d")
        color: colorBordeMouseEntered
    }

    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 1

        Image {
            id: imgFotoEvento
            opacity: 0
            height: width
            width: 1/5.5*(recDia.height)
            visible: opacity
            z: 1
            source: "qrc:/media/Media/nota.png"

            Behavior on opacity {PropertyAnimation{}}
        }

        Text {
            id: lblCantidadDeEventos
            y: 4
            font.family: "Verdana"
            font.pixelSize: 1/10*(recDia.height)
            text: "x" + intEventos
            visible: intEventos > 1
            color: "red"
        }

        Image {
            id: imgFotoCumple
            opacity: 0
            height: width
            width: 1/5.5*(recDia.height)
            visible: opacity
            z: 1
            source: "qrc:/media/Media/birthday.png"

            Behavior on opacity {PropertyAnimation{}}
        }

        Text {
            id: lblCantidadDeCumples
            y: lblCantidadDeEventos.y
            font.family: "Verdana"
            font.pixelSize: lblCantidadDeEventos.font.pixelSize
            text: "x" + intCumples
            visible: intCumples > 1
            color: "red"
        }
    }


    Rectangle {
        id: recNovedades
        anchors.top: lblDia.bottom
        anchors.topMargin: 3
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "transparent"

        Rectangle {
            id: recCumples
            anchors.fill: parent
            color: "transparent"
            opacity: 0

            Behavior on opacity {PropertyAnimation{}}

            Component {
                id: contactDelegate
                Item {
                    width: lista_cumples_alumnos.width; height: 45

                    Text {
                        property string strApellido
                        property int aniosQueCumple
                        property date nacimiento
                        font.family: "Verdana"
                        font.pixelSize: (recDia.height)/11
                        color: "#BF6363"
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        z: 1

                        Component.onCompleted: {
                            nacimiento = lista_cumples_alumnos.model[index].nacimiento
                            //today = wrapper.classManagementManager.obtenerFecha()
                            //today = gridCalendar.model[index].fecha
                            aniosQueCumple = today.getFullYear() - nacimiento.getFullYear()
                            strApellido = lista_cumples_alumnos.model[index].apellido
                            text = strApellido.toUpperCase() + "\n" + lista_cumples_alumnos.model[index].primerNombre + " " + lista_cumples_alumnos.model[index].segundoNombre
                                    + "\n" + aniosQueCumple + " años"
                        }
                    }
                }
            }

            ListView {
                id: lista_cumples_alumnos
                anchors.fill: parent
                delegate: contactDelegate
                focus: true
                clip: true
                spacing: 5
            }
        }

        Rectangle {
            id: recEventos
            anchors.fill: parent
            opacity: 0
            color: "transparent"

            Behavior on opacity {PropertyAnimation{}}
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            gridCalendar.currentIndex = index
            wrapper.managerNuevoEvento.fechaCalendario = gridCalendar.model[index].fecha
            lblFechaSeleccionada.aliasLblTitulo.text = Qt.formatDate(gridCalendar.model[index].fecha,"ddd dd, MMM")
            txtNuevoEvento.enabled = true

            listViewCumpleanieros.model = lista_cumples_alumnos.model
            listViewEventos.model = modelEventos
            recEventosGeneral.recEventosFecha = gridCalendar.model[index].fecha
        }
    }

    /*MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            //gridCalendar
        }

        onEntered: {
            recDia.border.width = 2
            recDia.border.color = colorBordeMouseEntered
        }

        onExited: {
            recDia.border.width = 2
            recDia.border.color = colorBordeNormal
        }
    }*/
}
