import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import com.mednet.WrapperClassManagement 1.0

TableView {
    id: principal
    property int totalDiasMes: -1
    alternatingRowColors: false

    /*style: TableViewStyle {
        //alternateBackgroundColor: "#FFCDD2"
    }*/



    rowDelegate:Rectangle {
        width: parent.width
        height: 30
        color: {
            if (styleData.selected){
                "#2196F3"
            }
            else {
                styleData.row  % 2 == 0 ? "white" : "#FFEBEE"
            }
        }


        //styleData.selected
    }

    headerDelegate: Rectangle{
        id: rec
        width: 100
        height: 30
        property int mesDeHoy: (new Date()).getMonth()
        property int diaDeHoy: (new Date()).getDate()
        property int diaColumna: -1

        function determinarSiEsHoy() {
            diaColumna = styleData.value
            if (diaColumna === diaDeHoy){
                if (comboMes.currentIndex === mesDeHoy) {
                    color = "#BBDEFB"
                }
                else {
                    color = "white"
                }
            }else{
                color = "white"

            }
        }

        Component.onCompleted: {
            determinarSiEsHoy()
        }

        Connections {
            target: wrapper.managerAsistencias

            onSig_cambioDeMes: {
                rec.determinarSiEsHoy()
            }
        }

        Rectangle {
            color: "black"
            width: 1
            height: parent.height
            visible: styleData.column > 1 && styleData.column !== 18
        }

        Text {
            text: wrapper.classManagementManager.traerNombreDiaCorto(styleData.value,(comboMes.currentIndex)+1,(new Date()).getFullYear()) + " " + styleData.value
            anchors.fill: parent
            anchors.leftMargin: 3
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 12
            color: wrapper.classManagementManager.traerNombreDiaCorto(styleData.value,(comboMes.currentIndex)+1,(new Date()).getFullYear()) === "dom." || wrapper.classManagementManager.traerNombreDiaCorto(styleData.value,(comboMes.currentIndex)+1,(new Date()).getFullYear()) === "sáb." ? "blue" : "black"
        }

        LineaSeparadora {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
        }
    }


    TableColumnVistaGrafica {
        role: "alumno"
        //title: "Alumno"
        resizable: false
        width: 250

        delegate: Rectangle {
            color: "transparent"

            Text {
                x: 3
                y: (parent.height / 2) - 8
                font.pixelSize: 12
                font.family: "times"
                text: styleData.value.apellido + " " + styleData.value.primerNombre + " ("+styleData.value.dni+")"
                color: styleData.selected ? "white" : "black"
            }
        }


    }

    TableColumnVistaGrafica {
        role: "alumno"
        //title: "Saldo $"
        width: 100;

        delegate: Rectangle {
            color: "transparent"

            Text {
                x: 3
                y: (parent.height / 2) - 8
                font.pixelSize: 12
                font.family: "times"
                text: styleData.value.credito_cuenta !== 0 ? "$ " + styleData.value.credito_cuenta : "-"
                color: styleData.value.credito_cuenta >= 0 ? "green" : "red"
            }
        }
    }


    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "1"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[0]
            recordMovimiento: styleData.value.listaMovimientos[0]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "2"


        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[1]
            recordMovimiento: styleData.value.listaMovimientos[1]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "3"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[2]
            recordMovimiento: styleData.value.listaMovimientos[2]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "4"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[3]
            recordMovimiento: styleData.value.listaMovimientos[3]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "5"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[4]
            recordMovimiento: styleData.value.listaMovimientos[4]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "6"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[5]
            recordMovimiento: styleData.value.listaMovimientos[5]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "7"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[6]
            recordMovimiento: styleData.value.listaMovimientos[6]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "8"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[7]
            recordMovimiento: styleData.value.listaMovimientos[7]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "9"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[8]
            recordMovimiento: styleData.value.listaMovimientos[8]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "10"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[9]
            recordMovimiento: styleData.value.listaMovimientos[9]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "11"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[10]
            recordMovimiento: styleData.value.listaMovimientos[10]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "12"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[11]
            recordMovimiento: styleData.value.listaMovimientos[11]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "13"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[12]
            recordMovimiento: styleData.value.listaMovimientos[12]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "14"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[13]
            recordMovimiento: styleData.value.listaMovimientos[13]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "15"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[14]
            recordMovimiento: styleData.value.listaMovimientos[14]
        }
    }





    TableColumnVistaGrafica {
        role: "alumno"
        //title: "Alumno"
        resizable: false
        width: 250

        delegate: Rectangle {
            color: "transparent"

            Rectangle {
                color: "black"
                width: 1
                height: parent.height
            }

            Text {
                x: 3
                y: (parent.height / 2) - 8
                font.pixelSize: 12
                font.family: "times"
                text: styleData.value.apellido + " " + styleData.value.primerNombre + " ("+styleData.value.dni+")"
                color: styleData.selected ? "white" : "black"
            }
        }
    }




    TableColumnVistaGrafica {
        role: "alumno"
        //title: "Saldo $"
        width: 100;

        delegate: Rectangle {
            color: "transparent"

            Text {
                x: 3
                y: (parent.height / 2) - 8
                font.pixelSize: 12
                font.family: "times"
                text: styleData.value.credito_cuenta !== 0 ? "$ " + styleData.value.credito_cuenta : "-"
                color: styleData.value.credito_cuenta >= 0 ? "green" : "red"
            }
        }
    }




    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "16"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[15]
            recordMovimiento: styleData.value.listaMovimientos[15]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "17"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[16]
            recordMovimiento: styleData.value.listaMovimientos[16]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "18"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[17]
            recordMovimiento: styleData.value.listaMovimientos[17]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "19"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[18]
            recordMovimiento: styleData.value.listaMovimientos[18]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "20"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[19]
            recordMovimiento: styleData.value.listaMovimientos[19]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "21"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[20]
            recordMovimiento: styleData.value.listaMovimientos[20]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "22"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[21]
            recordMovimiento: styleData.value.listaMovimientos[21]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "23"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[22]
            recordMovimiento: styleData.value.listaMovimientos[22]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "24"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[23]
            recordMovimiento: styleData.value.listaMovimientos[23]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "25"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[24]
            recordMovimiento: styleData.value.listaMovimientos[24]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "26"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[25]
            recordMovimiento: styleData.value.listaMovimientos[25]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "27"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[26]
            recordMovimiento: styleData.value.listaMovimientos[26]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "28"

        delegate: CeldaVistaGrafica {
            recordAsistencia: styleData.value.listaAsistencias[27]
            recordMovimiento: styleData.value.listaMovimientos[27]
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "29"
        visible: totalDiasMes >= 29

        delegate: CeldaVistaGrafica {
            recordAsistencia: totalDiasMes >= 29 ? styleData.value.listaAsistencias[28] : null
            recordMovimiento: totalDiasMes >= 29 ? styleData.value.listaMovimientos[28] : null
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "30"
        visible: totalDiasMes >= 30

        delegate: CeldaVistaGrafica {
            recordAsistencia: totalDiasMes >= 30 ? styleData.value.listaAsistencias[29] : null
            recordMovimiento: totalDiasMes >= 30 ? styleData.value.listaMovimientos[29] : null
        }
    }

    TableColumnVistaGrafica {
        role: "listasConInformacion"
        title: "31"
        visible: totalDiasMes === 31

        delegate: CeldaVistaGrafica {
            recordAsistencia: totalDiasMes === 31 ? styleData.value.listaAsistencias[30] : null
            recordMovimiento: totalDiasMes === 31 ? styleData.value.listaMovimientos[30] : null
        }
    }

}
