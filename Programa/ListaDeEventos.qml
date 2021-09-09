import QtQuick 2.0
import com.mednet.WrapperClassManagement 1.0
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.4

Rectangle {
    property string strFecha : "-"
    property string strCantidadDeEventos : ""
    border.color: "grey"
    property color colorTextTitulo : "#183394"
    color: "transparent"
    property int idEvento : -1

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: wrapper.managerNuevoEvento

        onSig_eventsForDate: {
            lista.model = arg
        }
    }

    Rectangle {
        id: recParaTitulos
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        height: 30
        anchors.margins: 1
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#ffffff";
            }
            GradientStop {
                position: 1.00;
                color: "#dbdbdb";
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 5
            width: 250
            color: "transparent"

            Text {
                id: lblFechaLista
                color: colorTextTitulo
                anchors.fill: parent
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                //text: qsTrId("Viernes, 4 de enero de 2014")
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 5
            width: 120
            color: "transparent"

            Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: lista.model.length + " evento/s."
                color: colorTextTitulo
            }
        }
    }

    MessageDialog {
        id: msgEliminarEvento
        icon: StandardIcon.Question
        title: qsTrId("Agenda")
        text: qsTrId("Está a punto de eliminar el evento. ¿Esta seguro que desea continuar?")
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            wrapper.managerNuevoEvento.eliminarEvento(idEvento)
        }
    }

    Rectangle {
        anchors.top: recParaTitulos.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 1
        clip: true

        ListView {
            id: lista
            anchors.fill: parent
            anchors.leftMargin: 1
            anchors.rightMargin: 1
            anchors.bottomMargin: 1
            delegate: contactDelegate
            //highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            focus: true
            spacing: 1
        }

        Component {
            id: contactDelegate
            Rectangle {
                width: lista.width; height: 75
                border.color: "grey"
                color: "transparent"

                TextArea {
                    anchors.fill: parent
                    anchors.margins: 3
                    horizontalAlignment: Text.AlignLeft
                    antialiasing: true
                    font.pointSize: 12
                    text: lista.model[index].descripcion
                    readOnly: true
                }

                MouseArea {
                    anchors.fill: parent
                    z: 1

                    onClicked: {
                        idEvento = lista.model[index].id
                        msgEliminarEvento.open()
                    }
                }
            }
        }
    }
}
