import QtQuick 2.0
import QtQuick.Controls 1.2

Rectangle {
    width: parent.width
    height: 28

    property string strLblTexto : "- Sin definir -"
    property string strTxtTexto : ""
    //property alias p_model : combo.model
    property alias comboComp : combo
    property int indexCombo : 0
    signal realizarBusqueda

    function setDefault() {
        combo.currentIndex = 0
    }

    Text {
        id: lblTexto
        y: 3
        x: 3
        text: strLblTexto
        font.family: "verdana"
        styleColor: "grey"
    }

    ComboBox {
        id: combo
        y: 1
        anchors.right: parent.right
        width: parent.width - 165

        onCurrentIndexChanged: {
            indexCombo = currentIndex
        }
    }
}
