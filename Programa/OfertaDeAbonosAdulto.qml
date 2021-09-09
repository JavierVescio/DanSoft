import QtQuick.Controls 1.4
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0
    enabled: false
    //color: "#e8eaf6"
    color: "#BBDEFB"
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}

    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: {
        wrapper.managerAbono.traerTodosLasOfertasDeAbono();
    }

    Rectangle {
        id: rectContenido
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: recBottom.top
        anchors.topMargin: parent.height / 15
        anchors.bottomMargin: recBottom.height
        anchors.leftMargin: parent.width / 10
        anchors.rightMargin: parent.width / 10
        color: "#e8eaf6"

        Rectangle {
            id: recTitulo
            height: parent.height / 7.5
            width: parent.width
            color: "#75a478"

            Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
                text: "ABONOS ADULTOS EN VENTA"
                font.family: "arial"
                font.bold: false
                font.pointSize: parent.height / 4
            }
        }

        Row {
            id: rowPrimero
            anchors.top: recTitulo.bottom
            spacing: 3

            AbonoOfertadoAdulto {
                id: abonoUnaClase
                height: ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "1"
                strTitle: "1 clase"
            }

            AbonoOfertadoAdulto {
                id: abonoDosClases
                height:  ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "4"
                strTitle: "4 clases"
            }

            AbonoOfertadoAdulto {
                id: abonoTresClases
                height:  ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "8"
                strTitle: "8 clases"
            }
        }

        Row {
            id: rowSegundo
            anchors.top: rowPrimero.bottom
            anchors.topMargin: 3
            anchors.bottom: rectContenido.bottom
            spacing: 3

            AbonoOfertadoAdulto {
                id: abonoCuatroClases
                height:  ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "12"
                strTitle: "12 clases"
            }

            AbonoOfertadoAdulto {
                id: abonoCincoClases
                height:  ((rectContenido.height - recTitulo.height) / 2)- 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "16"
                strTitle: "16 clases"
            }

            AbonoOfertadoAdulto {
                id: abonoSeisClases
                height:  ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "99"
                strTitle: "Libre"
            }
        }
    }

    Rectangle {
        id: recBottom
        height: parent.height / 12
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#ffffff"

    }
}
