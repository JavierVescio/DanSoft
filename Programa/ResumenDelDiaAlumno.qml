/*import QtQuick 2.0

Rectangle {
    width: 200
    height: 100
    border.color: "black"
    property alias aliasApellidoNombre: apellidoNombre.text

    Text {
        id: apellidoNombre
        text: "Apellido, Nombre"
    }
}*/

import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

Rectangle {
    id: rec
    property var record: null
    property string sinFoto : "qrc:/media/Media/woman.jpg"
    height: recMask.height + recListView.height + 5

    Component.onCompleted: {
        conexionFoto.target = wrapper.classManagementGestionDeAlumnos
        wrapper.classManagementGestionDeAlumnos.obtenerFoto(record.id_alumno);

        listViewDetalles.model = record.detalles

        /*for (var i in record.detalles) {

            //monto, fecha_movimiento, descripcion, credito_cuenta, codigo_oculto
            console.debug("Monto: " + record.detalles[i].monto)
            console.debug("fecha_movimiento: " + Qt.formatDateTime(record.detalles[i].fecha_movimiento,"HH:mm"))
            console.debug("Descripcion: " + record.detalles[i].descripcion)
            console.debug("Codigo oculto: " + record.detalles[i].codigo_oculto)


        }*/

        conexionFoto.target = null;
    }

    Connections {
        id: conexionFoto
        target: null
        ignoreUnknownSignals: true

        onSig_urlFotoCliente: {
            imgFotoCliente.source = arg
            recMask.opacity = 1
        }

        onSig_noHayFoto: {
            imgFotoCliente.source = sinFoto
            recMask.opacity = 0.1
        }
    }

    Rectangle {
        id: recMask
        anchors.top: parent.top
        anchors.left: parent.left
        height: 100
        width: height
        clip: true
        visible: true
        color: "transparent"

        MouseArea {
            anchors.fill: parent

            onDoubleClicked: {
                if (imgFotoCliente.source != sinFoto)
                    wrapper.classManagementGestionDeAlumnos.mostrarFotoDePerfilGrande(imgFotoCliente.source)
            }
        }

        Image {
            id: imgFotoCliente
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            visible: false // Do not forget to make original pic insisible
        }

        Rectangle {
            id: mask
            anchors { fill: parent; margins: 5}
            color: "black";
            radius: 40
            clip: true
            visible: false
        }

        OpacityMask {
            anchors.fill: mask
            source: imgFotoCliente
            maskSource: mask
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.left: recMask.right
        height: 100
        anchors.top: parent.top
        anchors.margins: 3
        color: "transparent"

        Rectangle {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 3
            anchors.bottomMargin: 4
            height: 30
            width: 75

            Text {
                anchors.centerIn: parent
                font.family: "Tahoma"
                font.pixelSize:12
                text: "Pagó: $ <font color=\"green\">"+record.total_pagado+"</font>"
            }
        }

        Column {
            anchors.fill: parent
            spacing: 3
            property string fontFamily: "Freestyle Script"
            property int fontPixelSize: 26

            Text {
                text: record.apellido
                font.family: parent.fontFamily
                font.pixelSize: parent.fontPixelSize
            }

            Text {
                text: record.primer_nombre
                font.family: parent.fontFamily
                font.pixelSize: parent.fontPixelSize
            }

            Text {
                text: Qt.formatDateTime(record.fecha_nacimiento,"dd-MM-yyyy")
                font.family: parent.fontFamily
                font.pixelSize: parent.fontPixelSize - 6
            }
        }
    }

    Rectangle {
        id: recListView
        anchors.top: recMask.bottom
        anchors.left: parent.left
        anchors.margins: 3
        anchors.right: parent.right
        height: listViewDetalles.model !== null ? (listViewDetalles.model.length * 85) - 3 : 0

        ListView {
            id: listViewDetalles
            clip: true
            spacing: 10
            anchors.fill: parent
            delegate: Rectangle {
                id: recPadre
                width: parent.width
                height: 75
                //border.color: "lightgrey"
                radius: 5

                Column {
                    x: 5
                    y: 5
                    spacing: 10

                    Text {
                        font.family: "Tahoma"
                        font.pixelSize:12
                        text: listViewDetalles.model[index].descripcion
                    }

                    Row {
                        spacing: 5
                        Text {
                            font.family: "Tahoma"
                            font.pixelSize: 12
                            text: {
                                if (listViewDetalles.model[index] !== null){
                                    if (listViewDetalles.model[index].monto >= 0)
                                        "Pagó: $"
                                    else
                                        "Valor: $"
                                }
                                else
                                    ""
                            }
                        }

                        Text {
                            font.family: "Tahoma"
                            font.pixelSize: 12
                            text: if (listViewDetalles.model[index] !== null){
                                      if (listViewDetalles.model[index].monto >= 0){
                                          color = "green"
                                          listViewDetalles.model[index].monto
                                      }else{
                                          color = "red"
                                          listViewDetalles.model[index].monto*-1
                                      }
                                  }
                        }

                        Text {
                            font.family: "Tahoma"
                            font.pixelSize: 12
                            text: "("+ listViewDetalles.model[index].codigo_oculto + ")"
                        }
                    }

                    Text {
                        font.family: "Tahoma"
                        font.pixelSize: 12
                        text: listViewDetalles.model[index].fecha_movimiento
                    }

                    LineaSeparadora{
                        visible: (index+1)!== listViewDetalles.model.length
                        width: recPadre.width - 10
                    }
                }
            }
        }
    }
}

