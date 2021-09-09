import QtQuick 2.7
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    height: 200
    width: 500
    color: "transparent"
    property string strNoHayAbonoInfantil: "\tSin abono"
    property bool alumno_matriculado: false
    property string strEstadoMatriculacion: ""


    property var abono_infantil_compra: null

    property int estadoPresentePotencial: -1
    property real montoDeudaPotencial: -1

    property bool visualizandoseDesdeComprarAbono: false

    property bool permitirEliminar: false
    property bool mostrarInformacionEstadoAbono: true


    onAbono_infantil_compraChanged: {
        recEliminado.visible = false
        principal.enabled = true
        if (abono_infantil_compra === null){
            estadoPresentePotencial = -1
            montoDeudaPotencial = -1
        }
    }

    MessageDialog {
        id: messageDialogDos
        title: "Baja de abono infantil"
        icon: StandardIcon.Critical
        text: qsTrId("Lamentablemente ha ocurrido un error al intentar eliminar el abono.\nIntente nuevamente más tarde.")
    }

    Rectangle {
        id: recEliminado
        anchors.fill: parent
        color: "transparent"
        visible: false
        z: 10

        Rectangle {
            anchors.fill: parent
            color: "yellow"
            z: 10
            opacity: recEliminado.visible ? 0.2 : 0

            Behavior on opacity {PropertyAnimation{}}
        }

        Text {
            id: lblEliminado
            font.family: "Segoe UI"
            style: Text.Outline
            color: "white"
            styleColor: "red"
            font.pixelSize: 16
            text: qsTrId("ELIMINADO")
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            rotation: -20
            opacity: recEliminado.visible ? 1 : 0
            z: 1

            Behavior on opacity {PropertyAnimation{}}
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Baja de abono infantil"
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            //
            if (wrapper.managerAbonoInfantil.darDeBajaAbono(abono_infantil_compra.id)) {
                recEliminado.visible = true
                abono_infantil_compra.estado = "Deshabilitado"
                //principal.enabled = false
                //DESTROY
            }
            else {
                messageDialogDos.open()
            }
        }
    }

    Image {
        id: imagen
        source: "qrc:/media/Media/credencial.png"
        visible: abono_infantil_compra !== null
        width: abono_infantil_compra !== null ? 48 : 0
        height: width
    }

    Column {
        anchors.left: imagen.right
        anchors.leftMargin: 3
        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 5

        Row {
            spacing: 15

            Text {
                font.family: "verdana"
                font.pixelSize: 12
                text: abono_infantil_compra === null ? strNoHayAbonoInfantil + " (" + strEstadoMatriculacion + ")" : ""
            }



            Text {
                font.family: "verdana"
                font.pixelSize: 12
                font.underline: false
                text: abono_infantil_compra === null ? "" : "Clases/sem: " + abono_infantil_compra.clases_por_semana + " - Número: " + abono_infantil_compra.id + " - Precio: $" + abono_infantil_compra.precio_abono + " (" + strEstadoMatriculacion + ")"
            }
        }

        Row {
            spacing: 5

            Image {
                width: 16
                height: width
                visible: source !== ""
                source: {
                    if (estadoPresentePotencial === 1) {
                        "qrc:/media/Media/warning_sign.png"
                    }
                    else if(estadoPresentePotencial === 2 && montoDeudaPotencial > 0) {
                        "qrc:/media/Media/icono.png"
                    }
                    else if(estadoPresentePotencial === 2) {
                        "qrc:/media/Media/icono.png"
                    }
                    else if (estadoPresentePotencial === 0){
                        "qrc:/media/Media/icoyes.png"
                    }
                    else {
                        ""
                    }
                }

            }

            Text {
                id: lblInfoAdicional
                font.family: "verdana"
                font.pixelSize: 12
                visible: mostrarInformacionEstadoAbono
                /*color: {
                    if (estadoPresentePotencial === 1) {
                        "blue"
                    }
                    else if(estadoPresentePotencial === 2) {
                        "red"
                    }
                    else{
                        "black"
                    }
                }*/

                text: {
                    if (estadoPresentePotencial === 1) {
                        "Asistencia a registrar será la última cubierta por el abono"
                    }
                    else if(estadoPresentePotencial === 2 && montoDeudaPotencial > 0) {
                        "Límite de asistencias alcanzado.\nSi se registra el presente, se le cobrará un extra de $ " + montoDeudaPotencial + " al alumno/a"
                    }
                    else if(estadoPresentePotencial === 2) {
                        "Límite de asistencias alcanzado. No hay oferta de abono superadora.\nSe solicitará confirmación al momento de registrar el presente"
                    }
                    else if (estadoPresentePotencial === 0){
                        "Asistencia a registrar cubierta por el abono"
                    }
                    else if (visualizandoseDesdeComprarAbono && abono_infantil_compra !== null) {
                        "Ya tiene un abono el alumno. No puede comprar otro"
                    }
                    else {
                        ""
                    }
                }
            }

            Text{
                color: "blue"
                text: "(Dar de baja)"
                enabled: abono_infantil_compra !== null & !recEliminado.visible & permitirEliminar
                visible: enabled
                y: 1

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: parent.enabled

                    onEntered:
                        parent.font.underline = true
                    onExited:
                        parent.font.underline = false
                    onClicked: {

                        messageDialog.text = "¿Está seguro que desea dar de baja el abono Nº "+(abono_infantil_compra !== null ? abono_infantil_compra.id : -1)+
                                "?\n\nImportante: no le reintegraremos el precio del abono al alumno.\nSi la compra del abono fue reciente y accidental, verifique desde el modulo de cuenta de alumno cuál era el crédito del alumno (Crédito Cuenta) antes de la Adquisición del Abono Infantil (el código debería ser 'AAI"+(abono_infantil_compra !== null ? abono_infantil_compra.id : -1)+"') o si hubiera, preferentemente antes de la Carga de Saldo para pagar el Abono Adulto (código='CSAI"+(abono_infantil_compra !== null ? abono_infantil_compra.id : -1)+"') y, en base a ello, haga los ajustes correspondientes."

                        messageDialog.icon = StandardIcon.Question
                        messageDialog.open()
                    }
                }
            }

            /*Button {
                text: "Dar de baja"
                enabled: abono_infantil_compra !== null & !recEliminado.visible & permitirEliminar
                visible: false
                y: -2

                onClicked: {

                    messageDialog.text = "¿Está seguro que desea dar de baja el abono Nº "+(abono_infantil_compra !== null ? abono_infantil_compra.id : -1)+
                            "?\n\nImportante: no le reintegraremos el precio del abono al alumno.\nSi la compra del abono fue reciente y accidental, verifique desde el modulo de cuenta de alumno cuál era el crédito del alumno (Crédito Cuenta) antes de la Adquisición del Abono Infantil (el código debería ser 'AAI"+(abono_infantil_compra !== null ? abono_infantil_compra.id : -1)+"') o si hubiera, preferentemente antes de la Carga de Saldo para pagar el Abono Adulto (código='CSAI"+(abono_infantil_compra !== null ? abono_infantil_compra.id : -1)+"') y, en base a ello, haga los ajustes correspondientes."

                    messageDialog.icon = StandardIcon.Question
                    messageDialog.open()
                }
            }*/

        }


    }
}
