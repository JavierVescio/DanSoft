import QtQuick 2.0
import QtQuick.Controls 1.0
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

RecConFormato {
    id: principal
    height: 40
    property date p_fechaSeleccionada
    property variant p_record
    property int p_index
    property alias p_hora : spinHora.value
    property alias p_minuto : spinMinuto.value
    property bool hacerActualizacion : false

  /*  onP_fechaSeleccionadaChanged: {
        txtFecha.text = Qt.formatDate(p_fechaSeleccionada,"dd/MM/yyyy")
    }*/

    function actualizarDatos() {
        if (hacerActualizacion){
            wrapper.managerNuevoEvento.actualizarEvento(p_index, txtFecha.text, spinHora.value, spinMinuto.value)
        }
        hacerActualizacion = true
    }

    WrapperClassManagement{
        id: wrapper
    }

    Row {
        anchors.fill: parent
        anchors.margins: 1
        spacing: 5

        TextField {
            id: txtFecha
            inputMask: "00/00/0000;_"
            maximumLength: 10
            width: 65
            height: parent.height
            text: "//"

            onTextChanged: {
                console.debug(text)
                 actualizarDatos()
            }
        }

        SpinBox {
            id: spinHora
            minimumValue: 0
            maximumValue: 23
            height: parent.height
            value: 00

            onValueChanged: {
                actualizarDatos()
            }
        }

        SpinBox {
            id: spinMinuto
            minimumValue: 0
            maximumValue: 59
            height: parent.height
            value: 00

            onValueChanged: {
                actualizarDatos()
            }
        }

        Button {
            height: parent.height
            width: parent.height
            text: "C"

            onClicked: {
                wrapper.managerNuevoEvento.eliminarEvento(index)
            }
        }
    }
}
