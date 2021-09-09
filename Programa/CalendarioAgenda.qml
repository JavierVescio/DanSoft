import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import com.mednet.WrapperClassManagement 1.0
import QtQuick.Controls.Private 1.0

Rectangle {
    height: 281
    width: 251
    color: "transparent"
    //border.color: "black"

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: wrapper.managerNuevoEvento

        onSig_eventoGuardado: {
            recargarCalendario()
        }

        onSig_eventoEliminado: {
            recargarCalendario()
        }
    }

    function recargarCalendario() {
        loaderCalendario.sourceComponent = undefined
        loaderCalendario.sourceComponent = compCalendar
    }

    TituloF1 {
        id: titulo
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        strTitulo: qsTrId("Selección de fecha")
    }

    Loader {
        id: loaderCalendario
        sourceComponent: compCalendar
        anchors.top: titulo.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    Component {
        id: compCalendar

        Calendar {
            id: calendarioAgendaEventos
            height: 300
            width: 300
            /*anchors.top: titulo.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom*/
            weekNumbersVisible: true

            Component.onCompleted: {
                selectedDate = wrapper.managerNuevoEvento.fechaCalendario
                wrapper.managerNuevoEvento.eventsForDate(selectedDate,true)
            }

            onClicked: {
                wrapper.managerNuevoEvento.fechaCalendario = date
                wrapper.managerNuevoEvento.eventsForDate(date,true)
            }

            style: CalendarStyle {
                dayDelegate: Item {
                    readonly property color sameMonthDateTextColor: "#444"
                    readonly property color selectedDateColor: "lightsteelblue"
                    readonly property color selectedDateTextColor: "white"
                    readonly property color differentMonthDateTextColor: "#bbb"
                    readonly property color invalidDatecolor: "#dddddd"

                    Rectangle {
                        anchors.fill: parent
                        border.color: "transparent"
                        color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                        anchors.margins: styleData.selected ? -1 : 0
                    }

                    Image {
                        visible: wrapper.managerNuevoEvento.eventsForDate(styleData.date, false).length > 0
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: -1
                        width: 12
                        height: width
                        source: "qrc:/media/Media/eventindicator.png"
                    }

                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        color: {
                            var color = invalidDatecolor;
                            if (styleData.valid) {
                                // Date is within the valid range.
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected) {
                                    color = selectedDateTextColor;
                                }
                            }
                            color;
                        }
                    }
                }
            }
        }
    }
}

