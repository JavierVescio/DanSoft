import QtQuick 2.0
import QtQuick.Controls 1.2

Rectangle {
    width: parent.width
    height: 28

    property string strLblTexto : "- Sin definir -"
    property string strTxtTexto : ""
    property color p_colorTitle : "black"
    property alias aliasTxtTexto : txtTexto
    property int distancia : 50
    signal realizarBusqueda

    function limpiarTexto() {
        txtTexto.text = ""
    }

    Text {
        id: lblTexto
        y: 5
        x: 3
        text: strLblTexto
        font.family: "verdana"
        styleColor: "grey"
        color: p_colorTitle
    }

    TextField {
        id: txtTexto
        y: 3
        anchors.right: parent.right
        width: parent.width - distancia
        font.family: "verdana"
        onTextChanged: strTxtTexto = text
        //onAccepted: realizarBusqueda
    }
}
