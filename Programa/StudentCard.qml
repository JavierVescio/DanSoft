import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

Rectangle {
    id: rec
    property var record: listViewCumpleanieros.model[index]

    Component.onCompleted: {
        conexionFoto.target = wrapper.classManagementGestionDeAlumnos
        wrapper.classManagementGestionDeAlumnos.obtenerFoto(listViewCumpleanieros.model[index].id);
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
        height: parent.height
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
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: 3
        color: "transparent"

        Column {
            anchors.fill: parent
            spacing: 3
            property string fontFamily: "Freestyle Script"
            property int fontPixelSize: 32

            Text {
                text: record.apellido
                font.family: parent.fontFamily
                font.pixelSize: parent.fontPixelSize
            }

            Text {
                text: record.primerNombre
                font.family: parent.fontFamily
                font.pixelSize: parent.fontPixelSize
            }

            Text {
                text: Qt.formatDateTime(record.nacimiento,"dd-MM-yyyy")
                font.family: parent.fontFamily
                font.pixelSize: parent.fontPixelSize
            }
        }
    }
}

