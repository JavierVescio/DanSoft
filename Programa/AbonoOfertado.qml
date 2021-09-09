import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: principal
    property string strNumero : "1"

    property real real_param_precio_actual: 0
    property date date_param_fecha_creacion
    property int idAbonoOfertado : -1

    property bool available: false



    Connections {
        target: wrapper.managerAbonoInfantil

        onSig_listaAbonosEnOferta: {
            var x;
            for (x=0;x<lista.length;x++){
                if (Number(strNumero) === lista[x].clases_por_semana) {
                    if (lista[x].estado === "Habilitado"){
                        switchButton.checked = true
                    }
                    real_param_precio_actual = lista[x].precio_actual
                    date_param_fecha_creacion = lista[x].fecha_creacion
                    idAbonoOfertado = lista[x].id

                    spinPrecio.value = real_param_precio_actual.toString()
                }
            }
            available = true
        }

    }

    function actualizar() {

        if (available) {

            if (idAbonoOfertado === -1)
                idAbonoOfertado = wrapper.managerAbonoInfantil.altaDeAbonoInfantil(spinPrecio.value,strNumero)
            else
                wrapper.managerAbonoInfantil.actualizarAbonoOfertado(idAbonoOfertado,spinPrecio.value,switchButton.checked)
        }


    }

    Rectangle {
        id: recTitle
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 4

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: switchButton.checked ? 0 : 0.1

            Behavior on opacity {PropertyAnimation{}}
        }

        Text {
            anchors.centerIn: parent
            //text: strNumero + " clases / semana"
            text: strNumero === "1" ? "1 clase / semana" : strNumero + " clases / semana"
            font.pointSize: recTitle.height / 3.5
        }
    }

    Rectangle {
        id: recPrecio
        anchors.top: recTitle.bottom
        anchors.bottom: recSwitch.top
        anchors.left: parent.left
        anchors.right: parent.right
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: switchButton.checked ? 0 : 0.1

            Behavior on opacity {PropertyAnimation{}}
        }

        Rectangle{
            anchors.top: parent.top
            anchors.bottom: spinPrecio.top
            anchors.left: spinPrecio.left
            anchors.right: spinPrecio.right
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: "$"
                color: "#75a478"
                font.bold: true
                font.pointSize: recTitle.height / 3.5
            }
        }

        SpinBox {
            id: spinPrecio
            anchors.centerIn: parent
            from: 0
            to: 100000
            value: 1000
            stepSize: 10
            enabled: switchButton.checked

            onValueChanged: {
                actualizar()
            }
        }

    }

    Rectangle {
        id: recSwitch
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 4

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: switchButton.checked ? 0 : 0.1

            Behavior on opacity {PropertyAnimation{}}
        }

        Switch {
            id: switchButton
            anchors.centerIn: parent
            height: parent.height / 1.5
            text: qsTr("Habilitar")

            onCheckedChanged: {
                actualizar()
            }
        }
    }
}
