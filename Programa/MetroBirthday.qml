import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import com.mednet.CMAlumno 1.0

Rectangle {
    id: principal
    color: "transparent"
    clip: true
    property int widthBotonOpcion : 100
    property int m_heightButton : 30

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: parent.enabled ? wrapper.classManagementGestionDeAlumnos : null

        onSig_listaBirthday: {
            if (arg.length > 0)
                listaAlumnos.model = arg
            else
                principal.visible = false
                //moduloMetro.strDescripcion = qsTrId("Los cumples de tus alumnos:\n\n¡No hay cumples por hoy y mañana!")
        }
    }

    /*Connections {
        target: wrapper.gestionBaseDeDatos

        onSig_conexionBaseAlumnosOk: {
            wrapper.classManagementGestionDeAlumnos.getBirthdays()
        }
    }*/

    Component.onCompleted: {
        if (wrapper.gestionBaseDeDatos.creacionDeTablasOk) {
            wrapper.classManagementGestionDeAlumnos.getBirthdays()
        }
    }

    ModuloMetro {
        id: moduloMetro
        anchors.fill: parent
        colorTitulo: "#9FA8DA"
        strTitulo : qsTrId("Cumpleaños")
        strDescripcion: qsTrId("Los cumples de tus alumnos:")
        //strImagen : "qrc:/media/Media/birthday.png"
        antialiasing: true
        canRotate: false

        Rectangle {
            z: 10
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 3
            height: parent.height - 53
            width: parent.width - 6
            color: "transparent"

            Component {
                id: contactDelegate
                Item {
                    width: listaAlumnos.width; height: 45

                    Text{
                        text: (index+1) + "/" + listaAlumnos.model.length
                        x:4
                        y:4
                        font.pixelSize: 9
                    }

                    Text {
                        id: textoCumple
                        property string strApellido
                        property int aniosQueCumple
                        property date nacimiento
                        property date today
                        property string hoyManiana : "Hoy"
                        font.family: "Verdana"
                        color: "black"//"#BF6363"
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        z: 1

                        Component.onCompleted: {
                            nacimiento = listaAlumnos.model[index].nacimiento
                            today = wrapper.classManagementManager.obtenerFecha()
                            aniosQueCumple = today.getFullYear() - nacimiento.getFullYear()
                            strApellido = listaAlumnos.model[index].apellido
                            if (Qt.formatDate(nacimiento,"dd") !== Qt.formatDate(today,"dd")) {
                                hoyManiana = "Mañana"
                                rec.border.color = "lightsteelblue"
                            }
                            else {
                                hoyManiana = "Hoy"
                                rec.border.color = "#FA5858"
                            }

                            var numDiaNac = Qt.formatDate(nacimiento,"dd")
                            var mesDiaNac = Qt.formatDate(nacimiento,"M")
                            if (numDiaNac == 29 && mesDiaNac == 2) {
                                if (today.getFullYear() % 4 != 0) {
                                    //No es bisiesto el año actual
                                    var numDiaAc = Qt.formatDate(today,"dd")
                                    var mesDiaAc = Qt.formatDate(today,"M")

                                    if (numDiaAc == 28 && mesDiaAc == 2) {
                                        hoyManiana = "Mañana"
                                        rec.border.color = "lightsteelblue"
                                    }
                                    else if (numDiaAc == 1 && mesDiaAc == 3) {
                                        hoyManiana = "Hoy"
                                        rec.border.color = "#FA5858"
                                    }
                                }
                            }

                            text = strApellido.toUpperCase() + "\n" + listaAlumnos.model[index].primerNombre + " " + listaAlumnos.model[index].segundoNombre
                                    + "\n" + hoyManiana + " cumple " + aniosQueCumple + " años."
                        }

                        //listaAlumnos.model[index].apellido + ", " + listaAlumnos.model[index].primerNombre;
                    }

                    Rectangle{
                        id: rec
                        anchors.fill: parent
                        color: "transparent";
                        border.width: 2
                    }
                }
            }

            ListView {
                id: listaAlumnos
                anchors.fill: parent
                delegate: contactDelegate
                focus: true
                clip: true
                spacing: 5
            }
        }
    }
}

