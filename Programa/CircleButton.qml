import QtQuick 2.0

Rectangle {
    id: circuloPadre
    width: 60
    height: 60
    color: p_colorInteriorDeCirculoPadre
    radius: width * 0.5
    border {width:p_borderWidthCirculoPadre; color:p_colorBordeDeCirculoPadre}
    antialiasing:true
    property int p_duracionAnimacion : 250
    property int p_borderWidthCirculoPadre : 1
    property int p_borderWidthCirculoHijo : 2
    property color p_colorBordeDeCirculoPadre : "lightgrey"
    property color p_colorBordeDeCirculoHijo : "grey"
    property color p_colorInteriorDeCirculoPadre : "#E0E0F8"
    property color p_colorInteriorDeCirculoHijoInicial : "white"
    property color p_colorInteriorDeCirculoHijoFinal : "#f78080"
    property real p_porcentajeDeTamanioDelCirculoHijoRespectoAlPadre : 0.8
    property real p_porcentajeDeCrecimientoDelCirculoHijoRespectoAlPadreAlEntrarConElMouse : 0.9
    property string p_pathImagen : ""
    property bool hoverEnabled : false
    signal clicked;
    signal entered;
    signal exited;

    CirculoHijo {
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
            hoverEnabled: circuloPadre.hoverEnabled

            onEntered: {
                circuloPadre.entered()
            }

            onClicked: {
                circuloPadre.clicked()
            }

            onExited: {
                circuloPadre.exited()
            }
        }
    }
}
