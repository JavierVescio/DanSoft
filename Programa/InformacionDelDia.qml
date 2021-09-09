import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"

    TituloF1 {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 1
        strTitulo: "Información del día"
    }
}

