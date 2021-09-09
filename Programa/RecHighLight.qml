import QtQuick 2.0

Rectangle {
    id: rec
    width: 180; height: 20

    property color p_colorInicial : "#FDFDE8"
    property color p_colorFinal : "#FFFFCB"
    property real p_realSpring : 2
    property real p_realDamping : 0.3
    property int p_intWidthBorde : 2

    color: "transparent"
    border.color: "#FF9800"
    border.width: 2

    /*gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: p_colorInicial
        }
        GradientStop {
            position: 1.00;
            color: p_colorFinal
        }
    }*/
}


