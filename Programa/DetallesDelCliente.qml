import QtQuick 2.2
import QtQuick.Controls 1.3
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    id: detallesDelCliente
    /*anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 3*/
    height: 350
    width: 250
    property string p_imagenDeFondo: "qrc:/media/Media/woman.jpg"
    property alias aliasRecordClienteSeleccionado : informacionDelCliente.recordClienteSeleccionado
    property alias aliasSourceImage : imgFotoCliente.source
    property alias aliasCalendarVisible : calendar.visible
    property alias aliasCalendar : calendar
    signal sig_hoveredFecha(var date)
    signal sig_clickedFecha(var date)

    onAliasRecordClienteSeleccionadoChanged: {
        if (aliasRecordClienteSeleccionado !== null) {
            wrapper.classManagementGestionDeAlumnos.obtenerFoto(aliasRecordClienteSeleccionado.id);
            var res = wrapper.classManagementGestionDeAlumnos.isItHerBirthday(aliasRecordClienteSeleccionado.id)
            if (res !== 0) {
                itemCumple.opacity = 0.9
                lblCumple.nacimiento = aliasRecordClienteSeleccionado.nacimiento //Qt.formatDate(aliasRecordClienteSeleccionado.nacimiento,"yyyy-MM-dd")
                lblCumple.today = wrapper.classManagementManager.obtenerFecha()
                lblCumple.aniosQueCumple = lblCumple.today.getFullYear() - lblCumple.nacimiento.getFullYear()
                if (Qt.formatDate(lblCumple.nacimiento,"dd") !== Qt.formatDate(lblCumple.today,"dd")) {
                    lblCumple.hoyManiana = "Mañana"
                    rec.border.color = "Plum"
                    imgFotoCumple.opacity = 0
                }
                else {
                    imgFotoCumple.opacity = 0.9
                    lblCumple.hoyManiana = "Hoy"
                    rec.border.color = "lightsteelblue"
                }

                var numDiaNac = Qt.formatDate(lblCumple.nacimiento,"dd")
                var mesDiaNac = Qt.formatDate(lblCumple.nacimiento,"M")
                if (numDiaNac == 29 && mesDiaNac == 2) {
                    if (lblCumple.today.getFullYear() % 4 != 0) {
                        //No es bisiesto el año actual
                        var numDiaAc = Qt.formatDate(lblCumple.today,"dd")
                        var mesDiaAc = Qt.formatDate(lblCumple.today,"M")

                        if (numDiaAc == 28 && mesDiaAc == 2) {
                            lblCumple.hoyManiana = "Mañana"
                            rec.border.color = "Plum"
                            imgFotoCumple.opacity = 0
                        }
                        else if (numDiaAc == 1 && mesDiaAc == 3) {
                            lblCumple.hoyManiana = "Hoy"
                            rec.border.color = "lightsteelblue"
                            imgFotoCumple.opacity = 0.9
                        }
                    }
                }

                lblCumple.text = lblCumple.hoyManiana + " cumple " + lblCumple.aniosQueCumple + " años."
            }
            else {
                imgFotoCumple.opacity = 0
                itemCumple.opacity = 0
            }
        }
        else{
            aliasSourceImage = p_imagenDeFondo
            imgFotoCumple.opacity = 0
            itemCumple.opacity = 0
        }
    }

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: parent.enabled ? wrapper.classManagementGestionDeAlumnos : null
        ignoreUnknownSignals: true

        onSig_urlFotoCliente: {
            aliasSourceImage = arg
        }

        onSig_noHayFoto: {
            aliasSourceImage = p_imagenDeFondo
        }
    }

    Rectangle {
        id: recImagen
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: -1
        //anchors.margins: 3
        height: width
        border.color: "#006d7e"
        //radius: 5

        Image {
            source: "qrc:/media/Media/Expandir.png"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 3
            width: 24
            height: 24
            opacity: imgFotoCliente.source == "qrc:/media/Media/woman.jpg" ? 0 : 0.7
            z: 5

            Behavior on opacity {PropertyAnimation{}}

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (imgFotoCliente.opacity == 1) {
                        wrapper.classManagementGestionDeAlumnos.mostrarFotoDePerfilGrande(imgFotoCliente.source)
                    }
                }
            }
        }

        Calendar {
            id: calendar
            anchors.fill: parent
            anchors.margins: 1
            enabled: visible
            visible: false
            opacity: 0.9
            z: 6

            onHovered: {
                sig_hoveredFecha(date)
            }

            onClicked: {
                sig_clickedFecha(date)
            }
        }

        Image {
            id: imgFotoCumple
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 1
            opacity: 0
            height: 32
            width: opacity === 0 ? 0 : 32
            z: 1
            source: "qrc:/media/Media/birthday.png"

            Behavior on opacity {PropertyAnimation{}}
        }

        Item {
            id: itemCumple
            width: recImagen.width; height: 32
            anchors.top: parent.top
            anchors.left: imgFotoCumple.right
            anchors.right: parent.right
            opacity: 0
            z: 1

            Behavior on opacity {PropertyAnimation{}}

            Text {
                id: lblCumple
                property string strApellido
                property int aniosQueCumple
                property date nacimiento
                property date today
                property string hoyManiana : "Hoy"
                font.family: "Verdana"
                color: "#BF6363"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                z: 1
            }

            Rectangle{
                id: rec
                anchors.fill: parent
                color: "white"; //radius: 5
                border.width: 2
            }
        }


        Item {
            anchors.fill: parent
            anchors.margins: 1

            Image {
                id: imgFotoCliente
                anchors.fill: parent
                cache: false //Si esta en true (default), si actualizas una foto y queres verla, puede que sigas viendo la vieja
                source: p_imagenDeFondo
                fillMode: Image.PreserveAspectFit
                opacity: 0.1

                Behavior on opacity {PropertyAnimation{}}

                onSourceChanged: {
                    if (source != p_imagenDeFondo){
                        imgFotoCliente.opacity = 1
                    }
                    else {
                        imgFotoCliente.opacity = 0.1
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onDoubleClicked: {
                        if (imgFotoCliente.opacity == 1) {
                            wrapper.classManagementGestionDeAlumnos.mostrarFotoDePerfilGrande(imgFotoCliente.source)
                        }
                    }

                }
            }
            Text {
                id: lblClienteSeleccionado
                anchors.fill: parent
                font.family: "Arial"
                style: Text.Outline
                styleColor: "#006d7e"
                color: "white"
                antialiasing: true
                //text: aliasRecordClienteSeleccionado !== null ? aliasRecordClienteSeleccionado.apellido + ", " + aliasRecordClienteSeleccionado.primerNombre + " " + aliasRecordClienteSeleccionado.segundoNombre + "\n\t" + aliasRecordClienteSeleccionado.dni : ""
                text: aliasRecordClienteSeleccionado !== null ? "<i>"+aliasRecordClienteSeleccionado.apellido + " </i>" + aliasRecordClienteSeleccionado.primerNombre + " " + aliasRecordClienteSeleccionado.segundoNombre : ""
                font.pointSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                opacity: text.length > 0 ? 1 : 0

                Behavior on opacity {PropertyAnimation{}}
            }

            Text {
                anchors.fill: parent
                font.family: "Arial"
                style: Text.Outline
                styleColor: "#006d7e"
                color: "white"
                antialiasing: true
                text: aliasRecordClienteSeleccionado !== null ? aliasRecordClienteSeleccionado.dni  : ""
                font.pointSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                opacity: text.length > 0 ? 1 : 0

                Behavior on opacity {PropertyAnimation{}}
            }
        }


    }

    TituloF1 {
        id: titulo
        strTitulo: qsTrId("Detalles")
        anchors.topMargin: -1
        anchors.top: recImagen.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: -1
        //anchors.margins: 3
    }

    InformacionDeCliente {
        id: informacionDelCliente
        anchors.top: titulo.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
