import QtQuick 2.0
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    id: principal
    property alias p_modelAbonos : listaDeAbonos.model
    property alias aliasListaDeAbonos : listaDeAbonos
    property int idAbonoSeleccionado : -1
    property bool mostrarLeyendaDeVigentes : false
    property bool permitirEliminar : false
    property bool mostrarInfoPosibilidadRegistrarPresente: false
    signal idAbono(var id)

    //property int estadoPresentePotencial: -1
    property real montoDeudaPotencial: -1

    property int estadoPresentePotencial: 0

    function desseleccionarAbonoSeleccionado() {
        listaDeAbonos.currentIndex = -1
        idAbonoSeleccionado = model[0].id
        idAbono(idAbonoSeleccionado)
    }

    function determinarEstadoDelPresente() {
        var abono_seleccionado = listaDeAbonos.model[listaDeAbonos.currentIndex]
        montoDeudaPotencial = wrapper.managerAbono.obtenerPrecioDelAbonoQueOfreceMasClases(abono_seleccionado.cantidad_comprada) - abono_seleccionado.precio_abono

        /// \return 0 si está cubierta la clase, 1 si es la ultima clase cubierta, 2 si la clase no esta cubierta
        if (abono_seleccionado.cantidad_restante > 1){
            estadoPresentePotencial = 0
        }else if(abono_seleccionado.cantidad_restante === 1){
            estadoPresentePotencial = 1
        }
        else {
            estadoPresentePotencial = 2
        }

    }

    WrapperClassManagement {
        id: wrapper
    }

    ListView {
        id: listaDeAbonos
        anchors{
            top:parent.top
            bottom: rowInfo.top
            left: parent.left
            right: parent.right
        }

        orientation: ListView.Horizontal
        clip: true
        spacing: 3
        highlightFollowsCurrentItem: false
        highlight: Component {
            RecHighLightDos {
                x: listaDeAbonos.currentItem !== null ? listaDeAbonos.currentItem.x : -1
                height: listaDeAbonos.height
                width: 300
                z: 10
            }
        }

        onModelChanged: {
            if (model.length > 0) {
                listaDeAbonos.currentIndex = 0
                idAbonoSeleccionado = model[0].id
                if (mostrarInfoPosibilidadRegistrarPresente)
                    determinarEstadoDelPresente()
            }
            else {
                idAbonoSeleccionado = -1
            }
            idAbono(idAbonoSeleccionado)
        }

        delegate: Abono {
            mostrarLeyendaDeVigentes: principal.mostrarLeyendaDeVigentes
            permitirEliminar: principal.permitirEliminar

            Component.onCompleted: {
                record = listaDeAbonos.model[index]

            }

            onClicked: {
                listaDeAbonos.currentIndex = index
                idAbonoSeleccionado = record.id
                if (mostrarInfoPosibilidadRegistrarPresente)
                    determinarEstadoDelPresente()

                idAbono(idAbonoSeleccionado)
            }
        }
    }

    Row {
        id: rowInfo
        height: 32
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 3
        spacing: 5
        visible: idAbonoSeleccionado !== -1 & mostrarInfoPosibilidadRegistrarPresente

        Image {
            width: 16
            height: width
            source: {
                if (estadoPresentePotencial === 1) {
                    "qrc:/media/Media/warning_sign.png"
                }
                else if(estadoPresentePotencial === 2) {
                    "qrc:/media/Media/icono.png"
                }
                else if (estadoPresentePotencial === 0){
                    "qrc:/media/Media/icoyes.png"
                }
                else {
                    ""
                }
            }

        }

        Text {
            id: lblInfoAdicional
            font.family: "verdana"
            font.pixelSize: 12

            text: {
                if (estadoPresentePotencial === 1) {
                    "Asistencia a registrar será la última cubierta por el abono"
                }
                else if(estadoPresentePotencial === 2) {
                    "El abono se ha quedado sin clases.\nSi se registra el presente, se le cobrará un extra de $ " + montoDeudaPotencial + " al alumno/a"
                }
                else if (estadoPresentePotencial === 0){
                    "Asistencia a registrar cubierta por el abono"
                }
                else {
                    ""
                }
            }
        }
    }

}

