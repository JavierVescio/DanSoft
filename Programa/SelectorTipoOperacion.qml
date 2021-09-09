import QtQuick 2.2
import QtQuick.Controls 1.4

Item {
    id: principal
    anchors.fill: parent
    enabled: false
    property color colorTitle: "white"
    property color backColorSubtitles: "#C8E6C9"
    property int idTipoOperacionSeleccionado: -1
    property var strDescripcionSeleccionada: ""

    function salir() {
        principal.enabled = false
    }

    function limpiar() {
        idTipoOperacionSeleccionado = -1
        strDescripcionSeleccionada = ""
        txtComentarioIngresado.text = ""
        txtComentarioEditado.text = ""
    }

    onEnabledChanged: {
        if (enabled) {
            pedirOperaciones()
        }
    }

    function pedirOperaciones() {
        idTipoOperacionSeleccionado = -1
        strDescripcionSeleccionada = ""
        tablaTipoOperaciones.model = wrapper.managerCuentaAlumno.traerTodosLosTiposDeOperacion()
        tablaTipoOperaciones.resizeColumnsToContents()
        txtComentarioIngresado.text = ""
        txtComentarioEditado.text = ""
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
                salir()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 25
        z: 30
        radius: 2
        opacity: principal.enabled ? 0.95 : 0
        enabled: principal.enabled

        Behavior on opacity {PropertyAnimation{}}

        MouseArea {
            anchors.fill: parent
            z:1
        }

        Image {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            //width: 45
            //fillMode: Image.PreserveAspectFit

            source: "qrc:/media/Media/salir.png"
            z: 2

            MouseArea {
                anchors.fill: parent
                onClicked: salir()
            }
        }

        Rectangle {
            id: recTitle
            height: 60
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: colorTitle

            Text {
                anchors.centerIn: parent
                text: "TIPO DE OPERACION"
                font.pixelSize: 25
                antialiasing: true
            }
        }

        TableView {
            id: tablaTipoOperaciones
            anchors.top: recTitle.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: recOpciones.left
            z: 2

            TableViewColumn {
                role: "id"
                title: "ID"
                width: 20
            }

            TableViewColumn {
                role: "descripcion"
                title: "Descripción"
            }

            onClicked:
                seleccionDeOperacion()

            onDoubleClicked: {
                seleccionDeOperacion()
                salir()
            }

            function seleccionDeOperacion() {
                idTipoOperacionSeleccionado = model[tablaTipoOperaciones.currentRow].id
                strDescripcionSeleccionada = model[tablaTipoOperaciones.currentRow].descripcion
            }

        }

        Rectangle {
            id: recOpciones
            anchors.right: parent.right
            width: 350
            anchors.top: recTitle.bottom
            anchors.bottom: parent.bottom
            z: 2

            ScrollView {
                id: scroll
                contentItem: flickDatos
                anchors.fill: parent
            }

            Flickable {
                id: flickDatos
                parent: scroll
                anchors.fill: scroll
                contentHeight: columnaDatos.height
                contentWidth: columnaDatos.width
                clip: true

                Column {
                    id: columnaDatos
                    opacity: 1
                    spacing: 10
                    enabled: true
                    z: 1
                    property int separacionIzquierda: 3

                    Rectangle {
                        height: 29
                        width: flickDatos.width
                        color: backColorSubtitles

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            anchors.leftMargin: columnaDatos.separacionIzquierda
                            font.family: "verdana";
                            font.pixelSize: 14
                            text: qsTrId("Registrar nueva descripción")
                            color: colorSubtitles
                        }
                    }

                    Rectangle {
                        height: 30
                        width: flickDatos.width
                        color: "transparent"

                        TextField {
                            id: txtComentarioIngresado
                            anchors.fill: parent
                            anchors.rightMargin: -1
                            anchors.leftMargin: -1
                            verticalAlignment: Text.AlignVCenter
                            font.family: "verdana";
                            placeholderText: "Escriba aquí (min 3 caracteres)"
                        }
                    }

                    Rectangle {
                        height: 30
                        width: flickDatos.width
                        color: "transparent"

                        Button{
                            anchors.fill: parent
                            anchors.leftMargin: -2
                            anchors.rightMargin: -2
                            text: "Dar de alta"
                            enabled: txtComentarioIngresado.length > 2

                            onClicked: {
                                wrapper.managerCuentaAlumno.crearTipoOperacion(txtComentarioIngresado.text)
                                pedirOperaciones()
                            }
                        }
                    }

                    LineaSeparadora {
                        width: parent.width
                        color: colorTitle
                    }

                    Rectangle {
                        height: 29
                        width: flickDatos.width
                        color: backColorSubtitles

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            anchors.leftMargin: columnaDatos.separacionIzquierda
                            font.family: "verdana";
                            font.pixelSize: 14
                            text: qsTrId("Cambiar texto de descripción")
                            color: colorSubtitles
                        }
                    }


                    Rectangle {
                        height: 30
                        width: flickDatos.width
                        color: "transparent"

                        TextField {
                            id: txtComentarioEditado
                            anchors.fill: parent
                            anchors.rightMargin: -1
                            anchors.leftMargin: -1
                            verticalAlignment: Text.AlignVCenter
                            font.family: "verdana";
                            enabled: tablaTipoOperaciones.model.length > 0
                            placeholderText: "Actualizar descripción de ID: '"+tablaTipoOperaciones.model[tablaTipoOperaciones.currentRow].id+"'"
                        }
                    }

                    Rectangle {
                        height: 30
                        width: flickDatos.width
                        color: "transparent"

                        Button{
                            anchors.fill: parent
                            anchors.leftMargin: -2
                            anchors.rightMargin: -2
                            text: "Actualizar"
                            enabled: txtComentarioEditado.length > 2 && tablaTipoOperaciones.model.length > 0

                            onClicked: {
                                wrapper.managerCuentaAlumno.actualizarTipoOperacion(tablaTipoOperaciones.model[tablaTipoOperaciones.currentRow].id,txtComentarioEditado.text)
                                pedirOperaciones()
                            }
                        }
                    }

                    LineaSeparadora {
                        width: parent.width
                        color: colorTitle
                    }

                    Rectangle {
                        height: 29
                        width: flickDatos.width
                        color: backColorSubtitles

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            anchors.leftMargin: columnaDatos.separacionIzquierda
                            font.family: "verdana";
                            font.pixelSize: 14
                            text: qsTrId("Dar de baja descripción")
                            color: colorSubtitles
                        }
                    }

                    Rectangle {
                        height: 30
                        width: flickDatos.width
                        color: "transparent"

                        Button{
                            anchors.fill: parent
                            anchors.leftMargin: -2
                            anchors.rightMargin: -2
                            enabled: tablaTipoOperaciones.model.length > 0
                            text: enabled ? "Quitar descripción de ID: '"+tablaTipoOperaciones.model[tablaTipoOperaciones.currentRow].id+"'" : "Quitar descripción"

                            onClicked: {
                                wrapper.managerCuentaAlumno.actualizarTipoOperacion(tablaTipoOperaciones.model[tablaTipoOperaciones.currentRow].id,tablaTipoOperaciones.model[tablaTipoOperaciones.currentRow].descripcion, "Deshabilitado")
                                pedirOperaciones()
                            }
                        }
                    }



                }
            }
        }

    }

}
