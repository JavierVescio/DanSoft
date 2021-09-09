import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    color: "transparent"
    clip: true

    WrapperClassManagement {
        id: wrapper
    }

    ModuloMetro {
        id: modulo
        anchors.fill: parent
        colorTitulo: "#63adf1"
        strTitulo : qsTrId("Estadísticas")
        strDescripcion : qsTrId("En un período, consulte:  \n\n- Cantidad de alumnos\n- Carga horaria\n- Ganancias\n- Y más...\n\n\n\t     A partir de v3.0")
        strImagen : "qrc:/media/Media/Estadisticas.png"

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.05
        }
    }
}
