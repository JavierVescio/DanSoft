import QtQuick 2.0
import QtQuick.Controls 1.2

Rectangle {
    width: parent.width
    height: 28

    property string strLblTexto : "- Sin definir -"
    property string strTxtTexto : ""
    property alias p_txtTexto : txtTexto
    property bool p_fieldRequired : false
    property bool validado : true
    signal realizarBusqueda

    function limpiarTexto() {
        txtTexto.text = ""
    }

    Text {
        id: lblTexto
        y: 3
        x: 3
        text: strLblTexto
        font.family: "verdana"
        styleColor: "grey"
    }

    TextField {
        id: txtTexto
        y: 1
        anchors.right: parent.right
        width: parent.width - 165
        font.family: "verdana"
        onTextChanged: {
            strTxtTexto = text

            if (p_fieldRequired) {
                if (text == "" || text == "..") {
                    recFieldRequired.opacity = 0.1
                    validado = false
                }
                else {
                    recFieldRequired.opacity = 0.0
                    validado = true
                }
            }
        }
        onAccepted: realizarBusqueda

        Rectangle {
            id: recFieldRequired
            anchors.fill: parent
            opacity: p_fieldRequired ? 0.1 : 0
            color: "red"

            Behavior on opacity {PropertyAnimation{}}
        }
    }
}
