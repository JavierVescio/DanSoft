import QtQuick 2.0

Rectangle {
    id: circuloHijo
    property int parentWidth : parent.width
    property int parentHeight : parent.height
    width: parentWidth * p_porcentajeDeTamanioDelCirculoHijoRespectoAlPadre
    height: parentHeight * p_porcentajeDeTamanioDelCirculoHijoRespectoAlPadre
    border {width:p_borderWidthCirculoHijo; color:p_colorBordeDeCirculoHijo}
    radius: width * 0.5
    antialiasing:true
    property int tamanioImagenChica : 35

    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: p_colorInteriorDeCirculoHijoInicial
        }
        GradientStop {
            position: 1.00;
            color: p_colorInteriorDeCirculoHijoFinal
        }
    }

    Behavior on height {PropertyAnimation{duration:p_duracionAnimacion}}
    Behavior on width {PropertyAnimation{duration:p_duracionAnimacion}}

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            circuloHijo.height = parentHeight * p_porcentajeDeCrecimientoDelCirculoHijoRespectoAlPadreAlEntrarConElMouse
            circuloHijo.width = parentWidth * p_porcentajeDeCrecimientoDelCirculoHijoRespectoAlPadreAlEntrarConElMouse
            imgIcono.height = ((1 - p_porcentajeDeCrecimientoDelCirculoHijoRespectoAlPadreAlEntrarConElMouse) * tamanioImagenChica) + tamanioImagenChica
            imgIcono.width = ((1 - p_porcentajeDeCrecimientoDelCirculoHijoRespectoAlPadreAlEntrarConElMouse) * tamanioImagenChica) + tamanioImagenChica
        }

        onExited: {
            circuloHijo.height = parentHeight * p_porcentajeDeTamanioDelCirculoHijoRespectoAlPadre
            circuloHijo.width = parentWidth * p_porcentajeDeTamanioDelCirculoHijoRespectoAlPadre
            imgIcono.height = tamanioImagenChica
            imgIcono.width = tamanioImagenChica
        }
    }

    Image {
        id: imgIcono
        anchors.centerIn: parent
        height: tamanioImagenChica
        width: tamanioImagenChica
        fillMode: Image.Stretch
        source: p_pathImagen

        Behavior on height {PropertyAnimation{duration:p_duracionAnimacion}}
        Behavior on width {PropertyAnimation{duration:p_duracionAnimacion}}
    }
}
