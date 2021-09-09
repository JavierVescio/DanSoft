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
    color: "#FFCDD2"
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}

    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: {
        wrapper.managerAbonoInfantil.traerTodosLasOfertasDeAbono();
        traerPrecioMatricula()
    }

    function actualizar() {
        if (spinPrecioMatricula.enabled)
            wrapper.managerAbonoInfantil.actualizarPrecioMatricula(spinPrecioMatricula.value)
    }

    function traerPrecioMatricula() {
        spinPrecioMatricula.enabled = false
        spinPrecioMatricula.value = wrapper.managerAbonoInfantil.traerPrecioMatricula();
        spinPrecioMatricula.enabled = true
    }


    Connections {
        target: wrapper.managerAbonoInfantil

        onSig_listaAbonosEnOferta: {
            //lista
            /*


            "(id integer NOT NULL PRIMARY KEY AUTOINCREMENT, "
            "precio_actual REAL NOT NULL, "
            "clases_por_semana integer NOT NULL UNIQUE, "
            "fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP, "
            "estado VARCHAR(20) NOT NULL DEFAULT 'Habilitado')";


    property bool boolParamChecked : false
    property real real_param_precio_actual: 0
    property date date_param_fecha_creacion


            var x;
            var dia_en_segundos = 86400
            for(x=0;x<arg.length;x++){
                if (wrapper.classManagementManager.calcularTiempoPasadoEnSegundos(arg[x].fecha) < dia_en_segundos){
                    modelPresentes.append(arg[x])
                }
            }
*/
        /*    var x;
            for (x=0;x<lista.length;x++){
                arg[x].clases_por_semana
            }*/

        }
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
                text: "ABONOS INFANTILES EN VENTA"
                font.family: "arial"
                font.bold: false
                font.pointSize: parent.height / 4
            }
        }

        Row {
            id: rowPrecioMatricula
            anchors.top: recTitulo.bottom
            width: parent.width
            height: spinPrecioMatricula.height
            spacing: 3

            Row {
                anchors.centerIn: parent
                spacing: 10

                Text{
                    y: 5
                    text: "Precio matrícula"
                    font.pointSize: recTitulo.height / 4
                }

                Text {
                    y: 5
                    text: "$"
                    color: "#75a478"
                    font.bold: true
                    font.pointSize: recTitulo.height / 4
                }

                SpinBox {
                    id: spinPrecioMatricula
                    from: 0
                    to: 100000
                    value: 1000
                    stepSize: 10

                    onValueChanged: {
                        actualizar()
                    }
                }
            }

        }

        Row {
            id: rowPrimero
            anchors.top: rowPrecioMatricula.bottom
            spacing: 3

            AbonoOfertado {
                id: abonoUnaClase
                height: ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "1"
            }

            AbonoOfertado {
                id: abonoDosClases
                height:  ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "2"
            }

            AbonoOfertado {
                id: abonoTresClases
                height:  ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "3"
            }
        }

        Row {
            id: rowSegundo
            anchors.top: rowPrimero.bottom
            anchors.topMargin: 3
            anchors.bottom: rectContenido.bottom
            spacing: 3

            AbonoOfertado {
                id: abonoCuatroClases
                height:  ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "4"
            }

            AbonoOfertado {
                id: abonoCincoClases
                height:  ((rectContenido.height - recTitulo.height) / 2)- 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "5"
            }

            AbonoOfertado {
                id: abonoSeisClases
                height:  ((rectContenido.height - recTitulo.height) / 2) - 1.5
                width: (rectContenido.width / 3) - 2
                strNumero: "6"
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
