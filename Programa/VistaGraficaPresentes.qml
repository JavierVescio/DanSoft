/*

YA NO SE USA MAS!

*/


import "qrc:/components"
import com.mednet.CMAlumno 1.0
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}
    color: "#F5F5F5"

    property color backColorSubtitles: "#FFCDD2"
    //property color backColorSubtitles: "#D7CCC8"
    property string strSinInfoDeClase: qsTrId("")

    property int intContentWidth: 700
    property int intContentHeight: 400

    property int idClaseAsistencia : -1
    property variant recordClienteSeleccionado: null

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null
    property var listaPrecioIdAbonoMasCaro: null


    //    property int nro_mes: -1
    property int nro_anio: (new Date()).getFullYear()

    //    property int total_dias_mes: -1

    //    property string fecha_inicial: ""
    //    property string fecha_final: ""

    WrapperClassManagement {
        id: wrapper
    }


    MessageDialog {
        id: messageDialog
        title: "Niños"
    }

    function limpiar() {
        for(var i = columnaAlumnos.children.length; i > 0 ; i--) {
            columnaAlumnos.children[i-1].destroy()
        }

        recordClienteSeleccionado = null
        tablaPresentes.model = 0
        abonoInfantilDelMes.abono_infantil_compra = null
        //abonoInfantilDelMes.height = 16
        abonoInfantilDelMes.montoDeudaPotencial = -1
        abonoInfantilDelMes.estadoPresentePotencial = -1
        saldoMovimientos.tableViewMovimientos.model = 0
        cuenta_alumno = null
        listaPrecioIdAbonoMasCaro = null
        wrapper.classManagementManager.clienteSeleccionado = null
    }

    onRecordClienteSeleccionadoChanged: {
        if (recordClienteSeleccionado !== null) {
            wrapper.gestionBaseDeDatos.beginTransaction()
            cuenta_alumno = wrapper.managerCuentaAlumno.traerCuentaAlumnoPorIdAlumno(recordClienteSeleccionado.id)
            if (cuenta_alumno !== null) {
                wrapper.gestionBaseDeDatos.commitTransaction()

                wrapper.gestionBaseDeDatos.beginTransaction()
                resumen_mes_alumno = wrapper.managerCuentaAlumno.traerResumenMesPorClienteFecha(recordClienteSeleccionado.id,true)

                if (resumen_mes_alumno !== null) {
                    saldoMovimientos.tableViewMovimientos.model = wrapper.managerCuentaAlumno.traerTodosLosMovimientosPorCuenta(cuenta_alumno.id)
                    saldoMovimientos.tableViewMovimientos.resizeColumnsToContents()
                    wrapper.gestionBaseDeDatos.commitTransaction()

                    abonoInfantilDelMes.abono_infantil_compra = wrapper.managerAbonoInfantil.traerCompraDeAbonoInfantil(recordClienteSeleccionado.id)
                    if (abonoInfantilDelMes.abono_infantil_compra == null) {
                        //abonoInfantilDelMes.height = 16
                        tablaPresentes.model = 0
                    }
                    else {
                        //abonoInfantilDelMes.height = 48
                        var modelo = wrapper.managerAbonoInfantil.traerPresentesPorAbonoInfantilComprado(abonoInfantilDelMes.abono_infantil_compra.id)
                        tablaPresentes.model = modelo

                        abonoInfantilDelMes.montoDeudaPotencial = wrapper.managerAbonoInfantil.obtenerPrecioDelAbonoQueOfreceUnaClaseMasPorSem(abonoInfantilDelMes.abono_infantil_compra.clases_por_semana) - abonoInfantilDelMes.abono_infantil_compra.precio_abono
                        abonoInfantilDelMes.estadoPresentePotencial = wrapper.managerAbonoInfantil.verificarSiEstaCubiertoElPresente(modelo,abonoInfantilDelMes.abono_infantil_compra.clases_por_semana);
                    }
                }
            }
            else {
                wrapper.gestionBaseDeDatos.rollbackTransaction()
            }
        }
        else {
            limpiar()
        }
    }

    SelectorClaseDeDanza {
        id: selectorDeDanza
        z: 10
        visible: false
        filtroCategoria: "Kids"

        onClaseAsistencia: {
            lblAsistiendoClase.text = nombreClase
            idClaseAsistencia = idClase

            if (idClaseAsistencia !== -1 && comboMes.currentIndex !== -1){
                cargarFormulario()
            }
        }

        onClaseNoSeleccionada: {
            lblAsistiendoClase.text = strSinInfoDeClase
            idClaseAsistencia = -1
            limpiar()
        }
    }


    Connections {
        target: principal.enabled ? wrapper.managerAsistencias : null
        //target: wrapper.managerAsistencias
        ignoreUnknownSignals: true

        onSig_intentarRegistrarPresenteTablaInfantil: {
            if (btnRegistrarPresente.enabled)
                btnRegistrarPresente.intentarRegistrarPresente()
        }
    }

    Connections {
        target: wrapper.classManagementManager

        onClienteSeleccionadoChanged: {
            recordClienteSeleccionado = clienteSeleccionado
        }


    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
        z: 150
    }

    Rectangle {
        id: recFecha
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: -1
        anchors.rightMargin: -1
        anchors.right: parent.right
        height: 35
        color: backColorSubtitles
        z: 1
        border.color: "black"


        Row {
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.left: parent.left
            spacing: 3
            anchors.leftMargin: 3

            ComboBox {
                id: comboMes
                height: 28
                width: 110
                currentIndex: (new Date()).getMonth()

                model: ListModel {
                    ListElement { text: "1. Enero" }
                    ListElement { text: "2. Febrero" }
                    ListElement { text: "3. Marzo" }
                    ListElement { text: "4. Abril" }
                    ListElement { text: "5. Mayo" }
                    ListElement { text: "6. Junio" }
                    ListElement { text: "7. Julio" }
                    ListElement { text: "8. Agosto" }
                    ListElement { text: "9. Septiembre" }
                    ListElement { text: "10. Octubre" }
                    ListElement { text: "11. Noviembre" }
                    ListElement { text: "12. Diciembre" }
                }

                onCurrentIndexChanged: {
                    if (idClaseAsistencia !== -1 && comboMes.currentIndex !== -1){
                        cargarFormulario()
                    }
                }

            }

            Button {
                text: qsTrId("Seleccionar clase")
                width: 100
                height: 30
                y: -1

                onClicked: {
                    selectorDeDanza.visible = true
                }
            }

            Image {
                source: "qrc:/media/Media/actividades.PNG"
                fillMode: Image.PreserveAspectFit
                width: 28
            }

            Text {
                id: lblAsistiendoClase
                font.family: "verdana"
                font.pixelSize: 12
                text: strSinInfoDeClase
                y: 10
            }

            Text {
                id: lblTotalAlumnos
                font.family: "verdana"
                font.pixelSize: 10
                visible: columnaAlumnos.children.length > 0
                text: " || Se muestran alumnos con abono infantil. Total: " + columnaAlumnos.children.length
                y: 12
            }

        }


        Button {
            id: btnAceptar
            anchors.top: parent.top
            anchors.right: parent.right
            visible: false
            anchors.margins: 3
            text: "Aceptar / Recargar"
            enabled: idClaseAsistencia !== -1 && comboMes.currentIndex !== -1

            onClicked:  {
                cargarFormulario()
            }
        }

    }

    function recargar() {
        if (idClaseAsistencia !== -1 && comboMes.currentIndex !== -1)
            cargarFormulario()
    }

    function cargarFormulario() {
        limpiar()
        busyIndicator.running = true

        var arg = wrapper.managerAbonoInfantil.traerAlumnosQueCompraronAbonoInfantil(comboMes.currentIndex+1,nro_anio);
        var component, recComponenteDia


        /*component = Qt.createComponent("../components/TituloDiasDeSemana.qml");
        recComponenteDia = component.createObject(columnaAlumnos);*/

        var incremento;

        for (incremento=0;incremento<arg.length;incremento++){
            component = Qt.createComponent("../components/ClientesAsistidoresClase.qml");
            recComponenteDia = component.createObject(columnaAlumnos, {"recordCliente": arg[incremento],"id_clase": idClaseAsistencia, "nro_mes":comboMes.currentIndex+1, "nro_anio":2018});
        }

        /*if (arg.length > 0)
            color = "#9E9E9E"
        else
            color = "#F5F5F5"*/

        //        flick.contentWidth = 31 * 60 //31 dias del mes por 45 de ancho
        //        flick.contentHeight = arg.length * 50
        intContentWidth = 31*63
        intContentHeight = arg.length * 60
        busyIndicator.running = false
    }


    /*


*/


    SplitView {
        anchors.top: recFecha.bottom
        anchors.left: parent.left
        anchors.leftMargin: -1
        anchors.right: parent.right
        anchors.rightMargin: -1
        anchors.bottom: parent.bottom
        orientation: Qt.Vertical


        Flickable {
            id: flick
            contentWidth: intContentWidth; contentHeight: intContentHeight
            Layout.fillHeight: true
            Layout.minimumHeight: 75
            z: 0

            Column {
                id: columnaAlumnos
                spacing: 5
                z: 0
            }
        }

        Rectangle {
            id: recInformacion
            height: 175
            Layout.minimumHeight: 150

            Button {
                id: btnRegistrarPresente
                text: qsTrId("Registrar presente")
                anchors.bottom: rowData.top
                anchors.rightMargin: 3
                anchors.bottomMargin: 3
                anchors.right: parent.right
                width: 200
                height: 30
                enabled: idClaseAsistencia !== -1 && recordClienteSeleccionado !== null && abonoInfantilDelMes.abono_infantil_compra !== null



                onClicked: {
                    intentarRegistrarPresente()
                }

                function intentarRegistrarPresente() {
                    if (abonoInfantilDelMes.estadoPresentePotencial === 2) {
                        if (abonoInfantilDelMes.montoDeudaPotencial > 0) {
                            messageDialogYesNo.text = "Límite de presentes ya alcanzado. Intentaremos mejorar el abono actual para que admita más clases por semana pero se debitarán $ " + abonoInfantilDelMes.montoDeudaPotencial + " de la cuenta del alumno por la diferencia de precio entre el abono que admite más clases y el que ya había adquirido el alumno.

Actualmente el saldo de la cuenta del alumno es de $ "+cuenta_alumno.credito_actual+" y de ese saldo se debitarán $ "+abonoInfantilDelMes.montoDeudaPotencial+" en concepto de mejora de abono, lo cual resultará en un saldo de cuenta de $ "+(cuenta_alumno.credito_actual-abonoInfantilDelMes.montoDeudaPotencial)+".

¿Seguro que desea continuar con el registro del presente?"

                            messageDialogYesNo.title = "Niños - Registro de presente no cubierto por abono"
                            messageDialogYesNo.icon = StandardIcon.Warning
                            messageDialogYesNo.open()
                        }
                        else {
                            messageDialogYesNoTwo.text = "Límite de presentes ya alcanzado. Actualmente no se encuentra habilitado un abono superior al que ya cuenta el alumno que le permita tomar más clases.

Para tener en cuenta:
1.- En las ofertas de abonos puede habilitar a alguno que admita más clases.
Si lo hace, es muy importante que cierre la pestaña de registro de presente infantil (luego puede volver a abrirla), de otra forma, los cambios que haga en las ofertas de abono puede que no se vean reflejados.

2.- Si cree que no es posible que el alumno haya podido sobrepasar el límite de clases, verifique los presentes registrados del alumno en busca de algún registro que se haya cargado accidentalmente más de una vez en un mismo día.

Si usted lo desea, puede registrar el presente con este abono de todas formas e ignorar el límite impuesto por dicho abono. No le cobraremos nada al alumno (ya que como no hay disponible un abono superior, se considera que el abono actual cubre el presente) pero si usted deseara cobrarle esta asistencia, puede hacerlo desde el módulo de cuenta del alumno.

¿Seguro que desea registrar el presente de todas formas?"

                            messageDialogYesNoTwo.title = "Niños - Registro de presente no cubierto por abono"
                            messageDialogYesNoTwo.icon = StandardIcon.Warning
                            messageDialogYesNoTwo.open()
                        }



                    }
                    else {
                        realizarRegistro()
                    }
                }

                function realizarRegistro() {
                    var id_presente = wrapper.managerAbonoInfantil.registrarPresenteInfantil(abonoInfantilDelMes.abono_infantil_compra.id, idClaseAsistencia)

                    if (id_presente !== -1) {
                        var strDatosDelRegistroDePresente = "Alumno/a: " + recordClienteSeleccionado.apellido + " " + recordClienteSeleccionado.primerNombre
                        messageDialog.text = "Registro de presente infantil Nº "+id_presente+" exitoso.\n" + strDatosDelRegistroDePresente
                        messageDialog.icon = StandardIcon.Information
                    }
                    else {
                        messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                        messageDialog.icon = StandardIcon.Warning
                    }
                    messageDialog.open()
                    limpiar()
                    recargar()
                }
            }

            AbonoInfantilDelMes {
                id: abonoInfantilDelMes
                anchors.top: parent.top
                anchors.left: parent.left
                height: 75
                x:3
            }

            Text {
                anchors.bottom: btnRegistrarPresente.top
                anchors.bottomMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignTop
                font.family: "verdana"
                font.pixelSize: 14
                text: recordClienteSeleccionado !== null ? recordClienteSeleccionado.apellido + ", " + recordClienteSeleccionado.primerNombre : ""
            }




            SplitView {
                id: rowData
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: abonoInfantilDelMes.bottom
                orientation: Qt.Horizontal

                SaldoMovimientos {
                    id: saldoMovimientos
                    width: parent.width / 2
                    Layout.minimumWidth: parent.width / 3
                    Layout.fillWidth: true
                }

                TableView {
                    id: tablaPresentes
                    Layout.minimumWidth: parent.width / 3
                    Layout.fillWidth: true

                    TableViewColumn {
                        role: "index"
                        title: ""
                        width: 10

                        delegate: Item {
                            Text {
                                x: 1
                                y: 1
                                text: tablaPresentes.model.length - styleData.row
                                color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                            }
                        }
                    }

                    TableViewColumn {
                        role: "id"
                        title: "Nro"
                        width: 45
                    }

                    TableViewColumn {
                        role: "nombre_actividad"
                        title: "Actividad"
                        width: 100
                    }

                    TableViewColumn {
                        role: "nombre_clase"
                        title: "Clase"
                        width: 100
                    }

                    TableViewColumn {
                        role: "fecha"
                        title: "Asistencias de este mes"
                        width: 215

                        delegate: Item {
                            Text {
                                x: 1
                                y: 1
                                //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                                text: wrapper.classManagementManager.calcularTiempoPasado(styleData.value)
                                color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                            }
                        }
                    }

                    TableViewColumn {
                        role: "estado"
                        title: "Estado"
                        width: 100
                    }
                }
            }

        }
    }

    MessageDialog {
        id: messageDialogYesNo
        title: "Niños"

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            wrapper.gestionBaseDeDatos.beginTransaction()

            var codigo_oculto = "MAI"+abonoInfantilDelMes.abono_infantil_compra.id
            var id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,abonoInfantilDelMes.montoDeudaPotencial*(-1),"Mejora abono a "+wrapper.managerAbonoInfantil.obtenerTotalClasesAbonoSuperior()+" clases/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto)
            if (id_movimiento !== -1) {
                //

                var id_abono_actual = abonoInfantilDelMes.abono_infantil_compra.id
                var id_nuevo_abono = wrapper.managerAbonoInfantil.obtenerIdAbonoSuperior();
                var precio_abono_a_sumar = abonoInfantilDelMes.montoDeudaPotencial

                if (wrapper.managerAbonoInfantil.actualizarAbonoComprado(id_abono_actual,id_nuevo_abono,precio_abono_a_sumar)){
                    wrapper.gestionBaseDeDatos.commitTransaction()
                    btnRegistrarPresente.realizarRegistro()
                }else {
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                    messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                    messageDialog.icon = StandardIcon.Warning
                    messageDialog.open()
                    limpiar()
                }
            }
            else {
                wrapper.gestionBaseDeDatos.rollbackTransaction()
                messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                messageDialog.icon = StandardIcon.Warning
                messageDialog.open()
                limpiar()
            }
        }
    }


    MessageDialog {
        id: messageDialogYesNoTwo
        title: "Niños"

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            btnRegistrarPresente.realizarRegistro()
        }

    }


    /*Column {
        id: columnaAlumnos
        spacing: 1
    }*/

}

