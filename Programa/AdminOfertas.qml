import QtQuick.Controls 1.4
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import com.mednet.CuentaAlumno 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

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

    Component.onCompleted: buscar_ofertas()

    MessageDialog {
        id: messageDialog
        title: "Ofertas"
    }
    MessageDialog {
        id: messageDialogYesNo
        title: "Ofertas"
        standardButtons: StandardButton.Yes | StandardButton.No
        icon: StandardIcon.Question

        onYes: {
            wrapper.managerOferta.bajarOferta(tableOfertas.model[tableOfertas.currentRow].id)
            buscar_ofertas()
        }
    }

    function buscar_ofertas() {
        var tipo_oferta_a_buscar = radioBuscarProducto.checked ? "Producto" : "Servicio"
        tableOfertas.model = wrapper.managerOferta.traerOfertas(
                    txtNombreBuscar.text,
                    tipo_oferta_a_buscar,
                    !checkBuscarNoVigente.checked)

        limpiar_formulario()
        checkEditar.enabled = false
        mostrar_seleccion_para_editar()

    }

    function mostrar_seleccion_para_editar(){
        checkEditar.checked = false
        if (tableOfertas.model.length > 0){
            if (tableOfertas.currentRow != -1) {
                checkEditar.enabled = true
                txtNombre.text = tableOfertas.model[tableOfertas.currentRow].nombre
                txtDescripcion.text = tableOfertas.model[tableOfertas.currentRow].descripcion
                txtMontoIngresado.text = tableOfertas.model[tableOfertas.currentRow].precio
                spinStock.value = tableOfertas.model[tableOfertas.currentRow].stock
                checkSoloUnaCompra.checked = tableOfertas.model[tableOfertas.currentRow].uno_por_alumno
                txtFechaInicial.text = Qt.formatDate(tableOfertas.model[tableOfertas.currentRow].fecha_vigente_desde,"dd/MM/yyyy")
                txtFechaFinal.text =Qt.formatDate(tableOfertas.model[tableOfertas.currentRow].fecha_vigente_hasta,"dd/MM/yyyy")
            }
        }
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

    Rectangle {
        id: recTabla
        anchors.top: parent.top
        anchors.topMargin: -1
        anchors.left: parent.left
        anchors.right: recEdicion.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -1

        TableView {
            id: tableOfertas
            anchors.fill: parent

            onCurrentRowChanged: {
                mostrar_seleccion_para_editar()
            }

            TableViewColumn {
                role: "id"
                title: "Nro"
                width: 55
            }

            TableViewColumn {
                role: "nombre"
                title: "Nombre"
            }

            TableViewColumn {
                role: "descripcion"
                title: "Descripcion"
            }

            TableViewColumn {
                role: "precio"
                title: "Precio"
                width: 55

                delegate: Item {
                    Text {
                        x: 1
                        text: "$ "+styleData.value
                        color: styleData.selected && tableOfertas.focus ? "white" : "black"
                    }
                }
            }

            TableViewColumn {
                role: "stock"
                title: "Cantidad"
                width: 55
            }

            TableViewColumn {
                role: "fecha_creacion"
                title: "Creación"
                delegate: Item {
                    Text {
                        x: 1
                        text: Qt.formatDate(styleData.value,"dd/MM/yyyy")
                        color: styleData.selected && tableOfertas.focus ? "white" : "black"
                    }
                }
            }

            TableViewColumn {
                role: "fecha_vigente_desde"
                title: "Desde"
                delegate: Item {
                    Text {
                        x: 1
                        text: Qt.formatDate(styleData.value,"dd/MM/yyyy")
                        color: styleData.selected && tableOfertas.focus ? "white" : "black"
                    }
                }
            }

            TableViewColumn {
                role: "fecha_vigente_hasta"
                title: "Hasta"
                delegate: Item {
                    Text {
                        x: 1
                        text: Qt.formatDate(styleData.value,"dd/MM/yyyy")
                        color: styleData.selected && tableOfertas.focus ? "white" : "black"
                    }
                }
            }
        }
    }

    Rectangle {
        id: recEdicion
        width: 280
        anchors.top: recTabla.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Item {
            id: itemBuscar
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 3
            width: 270
            height: 150

            Behavior on opacity {PropertyAnimation{}}

            Text {
                id: lblTitleBuscar
                anchors.left: parent.left
                anchors.top: parent.top
                text: qsTrId("BÚSQUEDA")
                font.pixelSize: 25
                font.family: "Verdana"
                color: "#D84315"
                focus: false
            }

            Rectangle {
                id: recSubtituloBuscar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: lblTitleBuscar.bottom
                height: 25
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
                    text: "PARÁMETROS"
                }
            }


            Column {
                anchors.top: recSubtituloBuscar.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10
                property int textFieldHeight: 29
                property int textFieldPixelSize : 12
                property string textFieldFontFamily : "verdana"
                property color textFieldTextColor : "#585858"


                ExclusiveGroup {
                    id: groupTipoOfertaBusqueda
                }

                TextField {
                    id: txtNombreBuscar
                    placeholderText: qsTrId("nombre")
                    height: parent.textFieldHeight
                    width: parent.width
                    font.pixelSize: parent.textFieldPixelSize
                    font.family: parent.textFieldFontFamily
                    focus: true
                    maximumLength: 45
                    text: ""


                    onTextChanged: {
                        buscar_ofertas()
                    }

                }

                Row {
                    spacing: 10

                    RadioButton {
                        id: radioBuscarProducto
                        text: "Producto"
                        checked: true
                        exclusiveGroup: groupTipoOfertaBusqueda

                        onCheckedChanged: buscar_ofertas()
                    }
                    RadioButton {
                        text: "Servicio"
                        exclusiveGroup: groupTipoOfertaBusqueda

                        onCheckedChanged: buscar_ofertas()
                    }

                    CheckBox {
                        id: checkBuscarNoVigente
                        text: "Buscar en no vigentes"

                        onCheckedChanged: buscar_ofertas()
                    }
                }
            }
        }

        Item {
            id: itemEdicion
            anchors.top: itemBuscar.bottom
            anchors.right: parent.right
            anchors.margins: 5
            width: 270
            height: 400

            Behavior on opacity {PropertyAnimation{}}

            Text {
                id: lblTitle
                anchors.left: parent.left
                anchors.top: parent.top
                text: qsTrId("CAMBIAR OFERTA")
                font.pixelSize: 25
                font.family: "Verdana"
                color: "#D84315"
                focus: false
            }

            Rectangle {
                id: recSubtitulo
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: lblTitle.bottom
                height: 25
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
                    text: "ACTUALIZACIÓN DE DATOS"
                }
            }


            Column {
                id: col
                anchors.top: recSubtitulo.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10
                property int textFieldHeight: 29
                property int textFieldPixelSize : 12
                property string textFieldFontFamily : "verdana"
                property color textFieldTextColor : "#585858"


                ExclusiveGroup {
                    id: groupTipoOferta
                }

                Row {
                    spacing: 135

                    CheckBox {
                        id: checkEditar
                        text: "Editar oferta"
                        enabled: false
                    }

                    Text{
                        id: btnBajaOferta
                        y: 2
                        height: 20
                        width: col.width
                        color: "blue"
                        text: "dar de baja"
                        enabled: checkEditar.checked
                        visible: enabled

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: parent.enabled

                            onEntered:
                                parent.font.underline = true
                            onExited:
                                parent.font.underline = false
                            onClicked: {
                                messageDialogYesNo.text = "¿Seguro que querés dar de baja la oferta?"
                                messageDialogYesNo.open()
                            }
                        }
                    }
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
                    enabled: checkEditar.checked


                    onTextChanged: {
                        validado = text.length > 1

                        if (text.length > 0) {
                            text = text.substring(0,1).toUpperCase() + text.substring(1)
                        }
                    }

                    //onAccepted:
                    //  btnContinuarSeguridad.clicked()
                }

                TextField {
                    id: txtDescripcion
                    placeholderText: qsTrId("descripción")
                    height: parent.textFieldHeight
                    width: parent.width
                    font.pixelSize: parent.textFieldPixelSize
                    font.family: parent.textFieldFontFamily
                    maximumLength: 140
                    enabled: checkEditar.checked

                    onTextChanged: {

                        if (text.length > 0) {
                            text = text.substring(0,1).toUpperCase() + text.substring(1)
                        }
                    }
                }

                Row {
                    spacing: 10
                    enabled: checkEditar.checked

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
                        y:1
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
                    enabled: checkEditar.checked
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
                    enabled: checkEditar.checked
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
                    enabled: checkEditar.checked

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
                    text: "Período vigente de oferta. Es opcional. Formato: día/mes/año. Ejemplos: 01/12/2018, 28/06/2019."
                    wrapMode: Text.WordWrap
                    width: parent.width
                }

                Button {
                    id: btnActualizar
                    text: qsTrId("Actualizar")
                    height: parent.textFieldHeight
                    width: parent.width
                    enabled:
                        txtNombre.validado && txtMontoIngresado.validado && checkEditar.checked

                    onClicked: {
                        var tipo = "Producto"
                        if (radioServicio.checked)
                            tipo = "Servicio"

                        if (wrapper.managerOferta.actualizarOferta(
                                    tableOfertas.model[tableOfertas.currentRow].id,
                                    txtNombre.text,
                                    txtDescripcion.text,
                                    tipo,
                                    txtMontoIngresado.text,
                                    spinStock.value,
                                    checkSoloUnaCompra.checked,
                                    txtFechaInicial.text,
                                    txtFechaFinal.text))
                        {
                            messageDialog.text = "Perfecto, la oferta ya se actualizó."
                            messageDialog.icon = StandardIcon.Information
                            limpiar_formulario()
                            buscar_ofertas()
                        }else{
                            messageDialog.text = "Ups, algo no salió bien. Por favor, revisá lo completado."
                            messageDialog.icon = StandardIcon.Critical
                        }
                        messageDialog.open()

                    }
                }
            }
        }
    }

}
