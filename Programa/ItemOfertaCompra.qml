import QtQuick 2.2
import QtQuick.Controls 1.3

Rectangle {
    id: principal
    height: 50
    color: "#ffffff"
    border.color: "#FBE9E7"
    width: 255
    property var recordOferta: null
    property int indice: -1
    property int subtotal: 0
    signal quitarItem(var indice)
    property color colorHovered: "#FBE9E7"
    property color colorNormal: "#ffffff"

    Behavior on color {
        ColorAnimation {duration:75}
    }

    onRecordOfertaChanged: {
        if (recordOferta != null){
            subtotal = spinBox.value * recordOferta.precio
            recordOferta.subtotal = subtotal
            recordOferta.cantidad = spinBox.value
            wrapper.managerOferta.actualizarCarritoDeCompras(
                        recordOferta.id,
                        recordOferta.cantidad)
            calcular_precio_carrito()
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: principal.color = colorHovered
        onExited: principal.color = colorNormal
    }

    Row {
        spacing: 15
        anchors.fill: parent
        anchors.margins: 5

        Text {
            id: lblNombreOferta
            text: recordOferta != null ? recordOferta.nombre : ""
            width: principal.width * .35
            height: parent.height
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            clip:true
            font.family: "Verdana"
        }

        Column {
            spacing: 5

            Text {
                id: text2
                text: qsTr("cant.")
                font.pixelSize: 11
                font.family: "Verdana"
            }

            SpinBox {
                id: spinBox
                minimumValue: 1
                maximumValue: recordOferta != null ? recordOferta.stock : 0
                value: 1

                onValueChanged: {
                    if (recordOferta != null) {
                        subtotal = value * recordOferta.precio
                        recordOferta.subtotal = subtotal
                        recordOferta.cantidad = spinBox.value
                        wrapper.managerOferta.actualizarCarritoDeCompras(
                                    recordOferta.id,
                                    recordOferta.cantidad)
                        calcular_precio_carrito()
                    }
                }

            }

        }

        Column {
            spacing: 10
            width: 35

            Text {
                id: text3
                text: qsTr("subtotal")
                font.pixelSize: 11
                font.family: "Verdana"
            }

            Text {
                id: text4
                text: {
                   if (recordOferta != null){
                       "$ "+subtotal
                   }else{
                       "$ 0"
                   }
                }

                font.family: "Verdana"
                font.pixelSize: 11
            }
        }

        /*Text{
            id: btnBajaOferta
            color: "blue"
            text: "quitar"
            height: parent.height
            verticalAlignment: Text.AlignVCenter

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                enabled: parent.enabled

                onEntered:
                    parent.font.underline = true
                onExited:
                    parent.font.underline = false
                onClicked:
                    quitarItem(indice)
            }
        }*/
    }

    Rectangle {
        id: recBotonCerrar
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 3
        height: 17
        width: 17
        //radius: 5
        border.width: 1
        border.color: "grey"
        color: "red"
        opacity: 0.15
        visible: enabled
        z: 1

        Behavior on opacity {PropertyAnimation{}}

        Text {
            id: lblCruz
            text: "x"
            x: 6
            y: 2
            opacity: 0.9
            font.pixelSize: 9
        }


        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                recBotonCerrar.opacity = 0.3
                principal.color = colorHovered
            }

            onExited: {
                recBotonCerrar.opacity = 0.15
                principal.color = colorNormal
            }

            onClicked: quitarItem(indice)
        }
    }
}
