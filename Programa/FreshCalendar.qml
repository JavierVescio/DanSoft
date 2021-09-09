import QtQuick.Controls 1.4
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}
    property string sinFoto : "qrc:/media/Media/woman.jpg"
    property int idEvento : -1
    property string strDefaultText : "Seleccione un día"
    color: "#FCFCFC"

    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: {
        wrapper.managerCalendar.construirCalendarioPorFecha()
    }

    MessageDialog {
        id: messageDialog
        title: qsTrId("Calendario")

        onAccepted: {
            close()
        }
    }

    MessageDialog {
        id: msgEliminarEvento
        icon: StandardIcon.Question
        title: qsTrId("Calendario")
        text: qsTrId("Está a punto de eliminar la nota. ¿Esta seguro que desea continuar?")
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            wrapper.managerNuevoEvento.eliminarEvento(idEvento)
            wrapper.managerCalendar.construirCalendarioPorFecha(gridCalendar.model[gridCalendar.currentIndex].fecha)
        }
    }

    Connections {
        target: wrapper.managerCalendar

        onSig_listaDiasCalendario: {
            gridCalendar.model = 0
            gridCalendar.model = arg
            gridCalendar.currentIndex = -1
            var fechaCalendario = wrapper.managerCalendar.fechaCalendario
            nombreMesAnio.text = Qt.formatDate(fechaCalendario,"MMMM yyyy")
            lblFechaSeleccionada.aliasLblTitulo.text = strDefaultText
            listViewCumpleanieros.model = 0
            listViewEventos.model = 0
            txtNuevoEvento.enabled = false
        }
    }

    Connections {
        target: wrapper.managerNuevoEvento

        onSig_eventoGuardado: {
            wrapper.managerCalendar.construirCalendarioPorFecha(arg)
        }
    }

    Rectangle {
        id: leftPanel
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        //width: parent.width * 0.23
        width: parent.width * 0.35
        color: "transparent"

        TituloSubtitulo {
            id: lblFechaSeleccionada
            anchors.left: parent.left
            anchors.right: separador.left
            colorLblTitulo: "black"
            colorRecSubtitulo: "lightgrey"
            colorBackgroundTitle: "white"
            aliasLblTitulo.text: strDefaultText
            aliasLblSubtitulo.text: "Cumpleaños"
        }

        Rectangle {
            id: recInforDia
            anchors.top: parent.top
            anchors.topMargin: lblFechaSeleccionada.heightItem + 3
            anchors.left: parent.left
            anchors.right: separador.left
            height: 120
            color: "transparent"

            ListView {
                id: listViewCumpleanieros
                anchors.fill: parent
                spacing: 3
                clip: true
                orientation: Qt.Horizontal
                delegate: StudentCard {
                    height: 120
                    width: 260
                }
            }
        }

        TituloSubtitulo {
            id: lblEventos
            anchors.top: recInforDia.bottom
            anchors.left: parent.left
            anchors.right: separador.left
            colorLblTitulo: "black"
            colorRecSubtitulo: "lightgrey"
            colorBackgroundTitle: "white"
            aliasLblTitulo.text: ""
            aliasLblTitulo.height: 0
            aliasLblSubtitulo.text: "Notas"
        }

        Rectangle {
            id: recEventosGeneral
            anchors.top: recInforDia.bottom
            anchors.topMargin: lblEventos.heightItem + 3
            anchors.left: parent.left
            anchors.right: separador.left
            anchors.bottom: parent.bottom
            color: "transparent"
            property var recEventosFecha

            TextField {
                id: txtNuevoEvento
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 40
                font.pixelSize: 16
                font.family: "verdana"
                placeholderText: "Nueva nota..."

                onAccepted: {
                    var fecha = gridCalendar.model[gridCalendar.currentIndex].fecha
                    if (wrapper.managerNuevoEvento.guardarNuevoEvento(fecha,txtNuevoEvento.text))
                        txtNuevoEvento.text = ""
                    else {
                        messageDialog.text = qsTrId("Ups! Algo no fue bien. ¿Seleccionó un día en el calendario?")
                        messageDialog.open()
                    }
                }
            }

            ListView {
                id: listViewEventos
                anchors.top: txtNuevoEvento.bottom
                anchors.topMargin: 3
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                spacing: 3
                clip: true
                orientation: Qt.Horizontal
                delegate: Rectangle {
                    width: 230; height: parent.height
                    color: "#FFEB3B"

                    TextArea {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignLeft
                        antialiasing: true
                        font.pointSize: 12
                        text: listViewEventos.model[index].descripcion

                        readOnly: true

                        style: TextAreaStyle {
                            //textColor: "#333"
                            //selectionColor: "steelblue"
                            //selectedTextColor: "#eee"
                            backgroundColor: "#FFF9C4"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        z: 1

                        onDoubleClicked: {
                            idEvento = listViewEventos.model[index].id
                            msgEliminarEvento.open()
                        }
                    }
                }
            }
        }

        Rectangle {
            id: separador
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: 2
            color: "#006d7e"
            height: parent.height
        }
    }

    Rectangle {
        id: topPanel
        anchors.top: parent.top
        anchors.left: leftPanel.right
        anchors.right: parent.right
        height: 75
        //color: "#FFFCCC"

        Rectangle {
            anchors.top: parent.top
            anchors.bottom: rowNombreDias.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: "transparent"

            Row {
                //imagen atras
                property int nombreMesAnioFontSize: 1/7*(gridCalendar.cellHeight)
                spacing: 3

                Image {
                    id: imgBtnBackMonth
                    y: 7
                    source: "qrc:/media/Media/Arrow.png"
                    rotation: 270
                    height: 1/8*(gridCalendar.cellHeight)
                    fillMode: Image.PreserveAspectFit
                    antialiasing: true

                    MouseArea {
                        anchors.fill: parent

                        onClicked: wrapper.managerCalendar.retrocederUnMesEnCalendario()
                    }
                }

                Image {
                    y: imgBtnBackMonth.y
                    source: "qrc:/media/Media/Arrow.png"
                    rotation: 90
                    height: 1/8*(gridCalendar.cellHeight)
                    fillMode: Image.PreserveAspectFit
                    antialiasing: true

                    MouseArea {
                        anchors.fill: parent

                        onClicked: wrapper.managerCalendar.avanzarUnMesEnCalendario()
                    }
                }

                Text {
                    id: nombreMesAnio
                    font.family: "Verdana"
                    font.pixelSize: 1/5*(gridCalendar.cellHeight)
                }
            }

        }

        Row {
            id: rowNombreDias
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 3
            height: 30
            property string nombreDiaFontFamily: "Verdana"
            property int nombreDiaWidth: gridCalendar.cellWidth
            property int nombreDiaFontSize: 1/7*(gridCalendar.cellHeight)

            Text {
                text: "Lunes"
                font.family: parent.nombreDiaFontFamily
                width: parent.nombreDiaWidth
                font.pixelSize: parent.nombreDiaFontSize
            }

            Text {
                text: "Martes"
                font.family: parent.nombreDiaFontFamily
                width: parent.nombreDiaWidth
                font.pixelSize: parent.nombreDiaFontSize
            }

            Text {
                text: "Miércoles"
                font.family: parent.nombreDiaFontFamily
                width: parent.nombreDiaWidth
                font.pixelSize: parent.nombreDiaFontSize
            }

            Text {
                text: "Jueves"
                font.family: parent.nombreDiaFontFamily
                width: parent.nombreDiaWidth
                font.pixelSize: parent.nombreDiaFontSize
            }

            Text {
                text: "Viernes"
                font.family: parent.nombreDiaFontFamily
                width: parent.nombreDiaWidth
                font.pixelSize: parent.nombreDiaFontSize
            }

            Text {
                text: "Sábado"
                font.family: parent.nombreDiaFontFamily
                width: parent.nombreDiaWidth
                font.pixelSize: parent.nombreDiaFontSize
            }

            Text {
                text: "Domingo"
                font.family: parent.nombreDiaFontFamily
                width: parent.nombreDiaWidth
                font.pixelSize: parent.nombreDiaFontSize
            }
        }
    }

    GridView {
        id: gridCalendar
        anchors.top: topPanel.bottom
        anchors.left: leftPanel.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        cellHeight: 1.1*(width / 7)
        cellWidth:  Math.floor(width / 7)
        clip: true
        z: 1
        highlight: highlight
        highlightFollowsCurrentItem: false
        focus: true
        delegate: CalendarDay {
//            MouseArea {
//                anchors.fill: parent

//                onClicked: {
//                    gridCalendar.currentIndex = index
//                    wrapper.managerNuevoEvento.fechaCalendario = gridCalendar.model[index].fecha
//                    lblFechaSeleccionada.aliasLblTitulo.text = Qt.formatDate(gridCalendar.model[index].fecha,"ddd dd")

//                    listViewCumpleanieros.model = parent.aliasLista_cumples_alumnos.model
//                    listViewEventos.model = parent.modelEventos
//                }
//            }
        }

        Component {
            id: highlight
            Rectangle {
                id: recInterno
                width: gridCalendar.cellWidth; height: gridCalendar.cellHeight
                border.color: "#2375BC"; radius: 5
                border.width: 3
                color: "transparent"
                x: gridCalendar.currentIndex !== -1 ? gridCalendar.currentItem.x : -1
                y: gridCalendar.currentIndex !== -1 ? gridCalendar.currentItem.y : -1
                z: 1

                Behavior on x { SpringAnimation { spring: 3; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }
            }
        }

    }
}
