import QtQuick.Controls 1.4
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import com.mednet.Oferta 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}

    property color backColorSubtitles: "#FFCCBC"
    property color colorSubtitles: "black"

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null


    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: {
        console.debug("Bienvenido a Alta Ofertas")
    }

    Item {
        id: itemCentered
        anchors.centerIn: parent
        width: 320
        height: 400

        Behavior on opacity {PropertyAnimation{}}

        Text {
            id: lblTitle
            anchors.left: parent.left
            anchors.top: parent.top
            text: qsTrId("ALTA DE OFERTA")
            font.pixelSize: 30
            font.family: "Verdana"
            color: "#D84315"
            focus: false
        }

        Rectangle {
            id: recSubtitulo
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: lblTitle.bottom
            height: 30
            color: "#D84315"
            focus: false

            Text {
                anchors.fill: parent
                anchors.margins: 3
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: "white"
                font.family: "Verdana"
                font.pixelSize: 14
                text: "CARGA DE DATOS"
            }
        }

        Column {
            id: col
            anchors.top: recSubtitulo.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10
            property int textFieldHeight: 35
            property int textFieldPixelSize : 15
            property string textFieldFontFamily : "verdana"
            property color textFieldTextColor : "#585858"


            ExclusiveGroup {
                id: groupTipoOferta
            }

            TextField {
                id: txtNombre
                placeholderText: qsTrId("nombre")
                height: parent.textFieldHeight
                width: parent.width
                font.pixelSize: parent.textFieldPixelSize
                font.family: parent.textFieldFontFamily
                focus: true
                maximumLength: 45
                property bool validado : false


                onTextChanged: {
                    validado = text.length > 1

                    if (text.length > 0) {
                        text = text.substring(0,1).toUpperCase() + text.substring(1)
                    }
                }
            }

            TextField {
                id: txtDescripcion
                placeholderText: qsTrId("descripción")
                height: parent.textFieldHeight
                width: parent.width
                font.pixelSize: parent.textFieldPixelSize
                font.family: parent.textFieldFontFamily
                maximumLength: 140

                onTextChanged: {

                    if (text.length > 0) {
                        text = text.substring(0,1).toUpperCase() + text.substring(1)
                    }
                }
            }

            Row {
                spacing: 10

                RadioButton {
                    id: radioProducto
                    text: "Producto"
                    checked: true
                    exclusiveGroup: groupTipoOferta
                }
                RadioButton {
                    id: radioServicio
                    text: "Servicio"
                    exclusiveGroup: groupTipoOferta
                }

                Text {
                    text: "Cantidad"
                    y: -1
                    font.pixelSize: col.textFieldPixelSize
                    font.family: col.textFieldFontFamily
                }

                SpinBox {
                    id: spinStock
                    y: -2
                    minimumValue: 0
                    maximumValue: 5000
                    value: 10
                    stepSize: 1
                }
            }

            CheckBox{
                id: checkSoloUnaCompra
                text: "Permitir sólo una compra por alumno"
                visible: false
                checked: false
            }

            TextField {
                id: txtMontoIngresado
                height: parent.textFieldHeight
                width: parent.width
                font.pixelSize: parent.textFieldPixelSize
                font.family: parent.textFieldFontFamily
                horizontalAlignment: TextInput.AlignRight
                placeholderText: "precio $"
                maximumLength: 5
                validator: DoubleValidator {}

                property bool validado : false




                onTextChanged: {
                    text = text.replace(",","")
                    text = text.replace(".","")
                    text = text.replace("-","")

                    validado = text.length > 0
                }
            }

            Row {
                spacing: 40

                TextField {
                    id: txtFechaInicial
                    inputMask: "00/00/0000;_"
                    font.pixelSize: col.textFieldPixelSize
                    font.family: col.textFieldFontFamily
                    maximumLength: 10
                    height: col.textFieldHeight
                    width: (col.width / 2) - (parent.spacing / 2)
                }

                TextField {
                    id: txtFechaFinal
                    inputMask: "00/00/0000;_"
                    font.pixelSize: col.textFieldPixelSize
                    font.family: col.textFieldFontFamily
                    maximumLength: 10
                    width: (col.width / 2) - (parent.spacing / 2)
                    height: col.textFieldHeight
                }
            }

            Text {
                text: "Período vigente de oferta. Es opcional. Formato: día/mes/año.<br><br>Ejemplos: 01/12/2018, 28/06/2019."
            }

            Button {
                id: btnAgregarOferta
                text: qsTrId("Agregar oferta")
                height: parent.textFieldHeight
                width: parent.width
                enabled:
                    txtNombre.validado && txtMontoIngresado.validado

                onClicked: {
                    var tipo = "Producto"
                    if (radioServicio.checked)
                        tipo = "Servicio"

                    if (wrapper.managerOferta.agregarOferta(
                                txtNombre.text,
                                txtDescripcion.text,
                                tipo,
                                txtMontoIngresado.text,
                                spinStock.value,
                                checkSoloUnaCompra.checked,
                                txtFechaInicial.text,
                                txtFechaFinal.text))
                    {
                        messageDialog.text = "Perfecto, la oferta ya se creó."
                        messageDialog.icon = StandardIcon.Information
                        limpiar_formulario()                        
                    }else{
                        messageDialog.text = "Ups, algo no salió bien. Por favor, revisá lo completado."
                        messageDialog.icon = StandardIcon.Critical
                    }
                    messageDialog.open()

                }
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Ofertas"
    }

    function limpiar_formulario() {
        txtNombre.text=""
        txtDescripcion.text=""
        txtMontoIngresado.text=""
        spinStock.value=10
        checkSoloUnaCompra.checked=false
        txtFechaInicial.text=""
        txtFechaFinal.text=""
    }
}
