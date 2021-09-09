import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2

Rectangle {
    width: 848//parent.width
    height: 50
    property variant recordCliente: null
    property var movimientosCuenta: null
    property int id_clase : -1

    property int nro_mes: -1
    property int nro_anio: (new Date()).getFullYear()

    property int total_dias_mes: -1

    property string fecha_inicial: ""
    property string fecha_final: ""

    property var todayNumber: ""

    property var lista_nombredia_numero: null


    Component.onDestruction: {
        for(var i = listaMovimientos.children.length; i > 0 ; i--) {
            listaMovimientos.children[i-1].destroy()
        }

        for(i = listaDias.children.length; i > 0 ; i--) {
            listaDias.children[i-1].destroy()
        }
    }




    Component.onCompleted: {
        todayNumber = (new Date()).getDate()


        var varNroMes, varNroDia
        if (nro_mes < 10)
            varNroMes = "0"+nro_mes
        else
            varNroMes = nro_mes

        fecha_inicial = nro_anio + "-" + varNroMes + "-01"
        total_dias_mes = wrapper.classManagementManager.totalDiasDelMes(nro_mes,nro_anio);
        fecha_final = nro_anio + "-" + varNroMes + "-" + total_dias_mes

        wrapper.managerAsistencias.obtenerAsistenciasDelAlumnoEntreFechasPorClase(id_clase, recordCliente.id, fecha_inicial,fecha_final,true)
        movimientosCuenta = wrapper.managerCuentaAlumno.traerTodosLosMovimientosPorCuenta(recordCliente.id_cuenta_alumno, fecha_inicial,fecha_final,true)


        lista_nombredia_numero = wrapper.classManagementManager.traerDiasDeSemanaConNumero(fecha_inicial,fecha_final)



        var incremento = 0;
        var nameDay = 0;


        for (incremento=0;incremento<movimientosCuenta.length;incremento++){
            var component = Qt.createComponent("../components/MovimientoAlumno.qml");
            var recComponenteDia = component.createObject(listaMovimientos);
            recComponenteDia.enabled = false

            if (incremento + 1 > todayNumber) {
                recComponenteDia.color = "#E0E0E0"
            }
            else {
                recComponenteDia.color = movimientosCuenta[incremento] !== null ? "#A5D6A7" : "white"
                recComponenteDia.hayMovimiento = movimientosCuenta[incremento] !== null

                if (incremento + 1 === todayNumber) {
                    recComponenteDia.esHoy = true
                    recComponenteDia.enabled = true
                }
            }

            recComponenteDia.textDayName = lista_nombredia_numero[nameDay]
            nameDay = nameDay + 2;

            if (incremento === 14) {
                component = Qt.createComponent("../components/RecNombreAlumno.qml");
                var recComponenteAlumno = component.createObject(listaMovimientos, {"recordCliente":recordCliente,"tipoInfo":2});
            }
        }
    }

    /* Component.onDestroyed: {
        console.debug("onDestroyed")



    }*/

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        //target: principal.enabled ? wrapper.managerAsistencias : null
        target: wrapper.managerAsistencias
        ignoreUnknownSignals: true

        onSig_listaClaseAsistenciasInfantil: {
            if (id_cliente === recordCliente.id) {
                //listaDias.model = arg

                lista_nombredia_numero = wrapper.classManagementManager.traerDiasDeSemanaConNumero(fecha_inicial,fecha_final)

                var incremento = 0;
                var nameDay = 0;

                for (incremento=0;incremento<arg.length;incremento++){
                    var component = Qt.createComponent("../components/DiaAsistenciaClaseAlumno.qml");
                    var recComponenteDia = component.createObject(listaDias, {"nroDia":incremento,"recordCliente":recordCliente});

                    recComponenteDia.enabled = false
                    if (incremento + 1 > todayNumber) {
                        recComponenteDia.color = "#E0E0E0" //#F8BBD0
                        recComponenteDia.enabled = false
                    }
                    else {
                        recComponenteDia.color = arg[incremento] !== null ? "#F8BBD0" : "white"
                        recComponenteDia.tienePresente = arg[incremento] !== null

                        if (incremento + 1 === todayNumber) {
                            recComponenteDia.esHoy = true
                            recComponenteDia.enabled = true
                        }
                    }

                    recComponenteDia.textDayName = lista_nombredia_numero[nameDay]
                    nameDay = nameDay + 2;


                    if (incremento === 14) {
                        component = Qt.createComponent("../components/RecNombreAlumno.qml");
                        var recComponenteAlumno = component.createObject(listaDias, {"recordCliente":recordCliente});
                    }
                }
            }
        }

    }

    Rectangle {
        id: recAlumno
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        //anchors.margins: -1
        //border.color: "grey"
        color: "#A1887F"
        width: 200

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                wrapper.classManagementManager.clienteSeleccionado = recordCliente
            }

            onPressed: {
                recEfecto.opacity = .2
            }

            onReleased: {
                recEfecto.opacity = 1
            }

            onExited: {
                recEfecto.opacity = 0
            }

        }

        Rectangle {
            id: recEfecto
            anchors.fill: parent
            color: "white"
            z:1
            opacity: 0

            Behavior on opacity{PropertyAnimation{duration: 50; easing.type: Easing.InCubic}}

            onOpacityChanged: {
                if (opacity >= 0.3)
                    opacity = 0

            }
        }

        Text {
            anchors.fill: parent
            anchors.topMargin: 6
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            font.family: "verdana"
            font.pixelSize: 14
            color: "white"
            text: recordCliente.apellido + ", " + recordCliente.primerNombre
        }

        Text {
            anchors.fill: parent
            anchors.bottomMargin: 3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            font.family: "arial black"
            font.pixelSize: 14
            style: Text.Outline
            font.letterSpacing: 5
            color: {
                if (recordCliente.credito_cuenta >0){
                    "#C8E6C9"
                }else if (recordCliente.credito_cuenta ===0)
                {
                    "black"
                }
                else
                {
                    "#E57373"
                }
            }
            //styleColor: "white"
            styleColor: recordCliente.credito_cuenta >=0 ? "black" : "white"
            visible: recordCliente.credito_cuenta !== 0
            text: "$ " + recordCliente.credito_cuenta
        }
    }

    Column {
        anchors.left: recAlumno.right
        //anchors.leftMargin: -1
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        //spacing: -1

        Row {
            id: listaDias
            spacing: -1
        }

        Row {
            id: listaMovimientos
            spacing: -1
        }
    }



}
