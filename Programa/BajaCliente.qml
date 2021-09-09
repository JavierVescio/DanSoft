import QtQuick 2.0
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick.Controls 1.2

/**************************29-5-15 BORRAR - NO SE UTILIZA MAS***********************************


***********************************************************************************************************/

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0
    enabled: false
    property variant p_objPestania
    color: "lightgrey"

    Behavior on opacity {PropertyAnimation{}}

    WrapperClassManagement {
        id: wrapper
    }

    Rectangle {
        width: 300
        height: 200
        anchors.centerIn: parent
        border.color: "grey"
        border.width: 5
        radius: 5

        TituloF1 {
            id: tituloIngreseDNI
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            strTitulo: qsTrId("Ingrese DNI")
        }



        /*TextField {
            id: txtDni
            anchors.top: tituloIngreseDNI.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            text: qsTrId("DNI (*)")
            inputMask: "00.000.000;_"
        }*/

        /*Rectangle {
            id: opciones
            anchors.left: parent.left
            anchors.right: parent.right
            height: 120
            anchors.bottom: parent.bottom
        }*/
    }
}

