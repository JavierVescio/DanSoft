import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    height: 150
    width: 500
    property alias tableViewMovimientos: tablaMovimientos
    property string strMovimientosMasRecientes: "(se muestra lo reciente)"
    property string strTodosLosMovimientos: "(todos los movimientos)"
    property bool mostrarTextoRecientes: true
    property string strCodigo: ""
    property bool movimientosDeCaja: false

    Rectangle {
        id: recInfo
        height: 0
        width: parent.width
    }

    TableView {
        id: tablaMovimientos
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: recInfo.bottom

        TableViewColumn {
            role: "id"
            title: "Nro"
            width: 45
        }

        TableViewColumn {
            role: "codigo_oculto"
            title: "Codigo"
            visible: !movimientosDeCaja
        }

        /*TableViewColumn {
            role: "descripcion_tipo_operacion"
            title: "Tipo"
        }*/

        TableViewColumn {
            role: "descripcion"
            title: {
                if (mostrarTextoRecientes){
                    "Descripción "+strMovimientosMasRecientes
                }
                else {
                    "Descripción "+strTodosLosMovimientos
                }
            }
        }

        TableViewColumn {
            role: "monto"
            title: "Monto"
            width: 45

            ///PROBANDO COLORES 01/04/2018. BORRAR SI QUEDA MAL
            delegate: Item {
                Text {
                    x: 1
                    text: styleData.value
                    color: styleData.value < 0 ? "red" : styleData.value === 0 ? "black" : "green"
                }
            }
        }

        TableViewColumn {
            role: "credito_cuenta"
            title: "Credito Cuenta"
            width: 45
            visible: !movimientosDeCaja

            ///PROBANDO COLORES 01/04/2018. BORRAR SI QUEDA MAL
            delegate: Item {
                Text {
                    x: 1
                    text: styleData.value
                    color: styleData.value < 0 ? "red" : styleData.value === 0 ? "black" : "green"
                }
            }
        }

        TableViewColumn {
            role: "fecha_movimiento"
            title: "Fecha"

            delegate: Item {
                Text {
                    x: 1
                    //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                    text: wrapper.classManagementManager.calcularTiempoPasado(styleData.value)
                    color: styleData.selected && tablaMovimientos.focus ? "white" : "black"
                }
            }
        }

        onDoubleClicked: {
            //tablaClase.model[tablaClase.currentRow].id
            strCodigo = model[currentRow].codigo_oculto
            if (strCodigo.substring(0,2) == "CT"){
                var codigoVenta = strCodigo.substring(2)
                wrapper.managerOferta.mostrarVenta(codigoVenta)
            }
        }

    }
}
