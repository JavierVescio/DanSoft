import QtQuick.Controls 1.4
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.2
import QtQuick.Layouts 1.3

Item {
    id: principal
    anchors.fill: parent
    enabled: false

    signal ofertaNoSeleccionada()
    signal ofertaSeleccionada(var recordOfertaSeleccionada)

    property color backColorSubtitles: "#FFCCBC"
    property color colorSubtitles: "black"


    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: buscar_ofertas()

    onEnabledChanged: {
        if (enabled)
            buscar_ofertas()
    }

    function buscar_ofertas() {
        var tipo_oferta_a_buscar = radioBuscarProducto.checked ? "Producto" : "Servicio"
        tableOfertas.model = wrapper.managerOferta.traerOfertas(
                    txtNombreBuscar.text,
                    tipo_oferta_a_buscar,
                    !checkBuscarNoVigente.checked,
                    true)
        txtNombreBuscar.focus = true
    }

    function cleanAndExit() {
        txtNombreBuscar.text = ""
        principal.enabled = false
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        z: 0
        opacity: principal.enabled ? 0.2 : 0
        enabled: principal.enabled

        Behavior on opacity {PropertyAnimation{}}

        MouseArea {
            anchors.fill: parent

            onClicked: {
                console.debug("Me hiciste clic")
                ofertaNoSeleccionada()
                cleanAndExit()
            }
        }
    }

    Rectangle {
        id: recContenido
        anchors.fill: parent
        anchors.margins: 25
        border.color: "grey"
        border.width: 2
        color: "white"
        radius: 2
        z: 10
        opacity: principal.enabled ? 0.95 : 0
        enabled: principal.enabled

        Behavior on opacity {PropertyAnimation{}}

        MouseArea {
            id: mouseAreaControl
            anchors.fill: parent
            z:1
            //Es para que no capture el clic del mousearea del rec de color negro
        }

        Rectangle {
            id: recTabla
            anchors.top: parent.top
            anchors.topMargin: -1
            anchors.left: parent.left
            anchors.right: recOpciones.left
            anchors.rightMargin: -1
            anchors.bottom: parent.bottom
            z:2 //Asi el mouseAreaControl no molesta

            TableView {
                id: tableOfertas
                anchors.fill: parent


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

                onDoubleClicked: {
                    ofertaSeleccionada(tableOfertas.model[tableOfertas.currentRow])
                    cleanAndExit()
                }
            }
        }

        Rectangle {
            id: recOpciones
            width: 250
            anchors.top: recTabla.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            border.width: 1
            z:2 //Asi el mouseAreaControl no molesta

            Item {
                id: itemBuscar
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 3
                width: 240
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
                            visible: false
                            checked: false

                            //onCheckedChanged: buscar_ofertas()
                        }
                    }
                }
            }

        }
    }

}
