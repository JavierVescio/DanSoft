import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    //color: "#BBDEFB"
    property color backColorSubtitles: "#BBDEFB"
    property color colorSubtitles: "black"

    property variant p_objPestania
    property bool quieroLaFechaInicial : true
    property string tipo : "Normal"
    property int cantidad_clases : 4
    property int cantidad_restante : -1
    property string strAlDia : qsTrId("\tNo hay firmas pendientes")
    property string strSinInformacion: qsTrId("\tSin información disponible")
    property string strNoAbono : qsTrId("\tNo existe ningún abono vigente a la fecha del alumno/a")
    property string strPorFavorFirmeLaCredencial : qsTrId("Primero firme las clases que quedaron pendientes de firmar (si hubiera).\nLuego firme la credencial al alumno/a por la clase a la que se está presentando ahora:")
    property string strNoEsNecesarioFirmarLaCredencial : qsTrId("No es necesario firmar la credencial")
    property string strLaClaseNoFuePagada : qsTrId("Podrá dar el presente al alumno/a, aunque se registrará que la clase no fue pagada")
    property bool debitarClase : true
    property string strDatosDelRegistroDePresente
    property int cantidadDeClasesEnDeuda : 0
    property int idClaseAsistencia : -1

    property string strAlDiaDeuda : qsTrId("\tNinguna")
    property string strDeuda : qsTrId("\t") + cantidadDeClasesEnDeuda + qsTrId(" clase/s")

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null

    Behavior on opacity {PropertyAnimation{}}

    WrapperClassManagement {
        id: wrapper
    }

    function switchOnOffDatos(logico) {
        if (logico) {
            columnaDatos.opacity = 1
            columnaDatos.enabled = true
            //radioTrajoCredencial.checked = true
        }
        else {
            columnaDatos.opacity = 0.7
            columnaDatos.enabled = false
        }
    }

    /*obtenerPresentesDelAlumno(int id_cliente, int limite) {
        sig_listaClaseAsistencias*/

    Connections {
        target: principal.enabled ? wrapper.managerAsistencias : null
        ignoreUnknownSignals: true

        onSig_listaClaseAsistencias: {
            tablaPresentes.model = arg
            tablaPresentes.currentRow = -1
            tablaPresentes.resizeColumnsToContents()
        }
    }

    Connections {
        target: principal.enabled ? wrapper.managerAbono : null
        ignoreUnknownSignals: true

        onSig_abonosDeAlumno: {
            selectorDeAbono.p_modelAbonos = arg
            selectorDeAbono.visible = true
            debitarClase = true
            lblInfoAbono.visible = false
            btnDarPresenteSinAbonoConDeuda.visible = false
        }

        onSig_noHayAbonosDelAlumno: {
            lblInfoAbono.visible = true
            lblInfoAbono.text = strNoAbono
            selectorDeAbono.p_modelAbonos = 0
            selectorDeAbono.visible = false
            debitarClase = false

            //console.debug("hoola")
            //radioNoTrajoCredencial.checked = true
            radioTrajoCredencial.enabled = false
            lblFirmasCredencial.text = strSinInformacion
            btnDarPresenteSinAbonoConDeuda.visible = true
        }
    }

    function limpiarFormulario() {
        lblInfoAbono.text = strSinInformacion
        lblInfoAbono.visible = true
        lblFirmasCredencial.text = strSinInformacion
        txtCuentaAlumno.text = strSinInformacion
        selectorDeAbono.visible = false
        //buscador.modeloAlumnos = 0
        //buscador.recordClienteSeleccionado = null
        tablaPresentes.model = 0
        saldoMovimientos.tableViewMovimientos.model = 0
        checkDarPresenteConOtraFecha.checked = false
        buscador.focoEnDNI()
        if (buscador.recordClienteSeleccionado !== null)
            buscador.onClienteSeleccionado()
        else
            switchOnOffDatos(false)
    }

    /*function limpiarFormulario() {
        //Lo comento para que no tenga que cargar la clase por cada vez.
        //lblAsistiendoClase.text = strSinInformacion
        //idClaseAsistencia = -1
        lblInfoAbono.text = strSinInformacion
        lblInfoAbono.visible = true
        lblFirmasCredencial.text = strSinInformacion
        txtCuentaAlumno.text = strSinInformacion
        selectorDeAbono.visible = false
        buscador.modeloAlumnos = 0
        buscador.recordClienteSeleccionado = null
        tablaPresentes.model = 0
        saldoMovimientos.tableViewMovimientos.model = 0
        checkDarPresenteConOtraFecha.checked = false
        switchOnOffDatos(false)
        buscador.focoEnDNI()
    }*/

    MessageDialog {
        id: messageDialog
        title: "Asistencias"
    }

    MessageDialog {
        id: messageError
        title: "Registrar presente adulto"
        icon: StandardIcon.Critical
        text: qsTrId("Ups! Algo no fue bien.")
    }

    MessageDialog {
        id: messageDialogYesNoTwo
        title: "Niños"

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            btnDarPresenteAbonado.darPresenteConAbono()
        }

    }


    MessageDialog {
        id: messageDialogYesNo
        title: "Niños"

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            wrapper.gestionBaseDeDatos.beginTransaction()

            var codigo_oculto = "MAA"+selectorDeAbono.idAbonoSeleccionado
            var id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,selectorDeAbono.montoDeudaPotencial*(-1),"Mejora abono a "+wrapper.managerAbono.obtenerTotalClasesAbonoSuperior()+" clases",cuenta_alumno,resumen_mes_alumno,codigo_oculto)
            if (id_movimiento !== -1) {
                //

                var id_abono_actual = selectorDeAbono.idAbonoSeleccionado
                var id_nuevo_abono = wrapper.managerAbono.obtenerRecordAbonoSuperior().id;
                var precio_abono_a_sumar = selectorDeAbono.montoDeudaPotencial

                //property alias p_modelAbonos : listaDeAbonos.model
                //property alias aliasListaDeAbonos : listaDeAbonos
                var clases_compradas_actual = selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].cantidad_comprada
                var clases_restantes = selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].cantidad_restante
                var cantidad_clases_a_sumar = (wrapper.managerAbono.obtenerRecordAbonoSuperior().total_clases - clases_compradas_actual)

                var resultadoActualizacion;
                if (wrapper.managerAbono.obtenerRecordAbonoSuperior().total_clases === 99)
                    resultadoActualizacion = wrapper.managerAbono.actualizarHaciaAbonoLibre(id_abono_actual,id_nuevo_abono,precio_abono_a_sumar,99-(1+clases_compradas_actual-clases_restantes))
                else
                    resultadoActualizacion = wrapper.managerAbono.actualizarAbonoNormalComprado(id_abono_actual,id_nuevo_abono,precio_abono_a_sumar,cantidad_clases_a_sumar,(cantidad_clases_a_sumar-1))

                if (resultadoActualizacion){
                    wrapper.gestionBaseDeDatos.commitTransaction()
                    btnDarPresenteAbonado.darPresenteConAbono()
                }else {
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                    messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                    messageDialog.icon = StandardIcon.Warning
                    messageDialog.open()
                    limpiarFormulario()
                }
            }
            else {
                wrapper.gestionBaseDeDatos.rollbackTransaction()
                messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                messageDialog.icon = StandardIcon.Warning
                messageDialog.open()
                limpiarFormulario()
            }
        }
    }

    SelectorClaseDeDanza {
        id: selectorDeDanza
        z: 10
        visible: false
        filtroCategoria: "Adults"

        onClaseAsistencia: {
            lblAsistiendoClase.text = "\t" + nombreClase
            idClaseAsistencia = idClase
        }

        onClaseNoSeleccionada: {
            lblAsistiendoClase.text = strSinInformacion
            idClaseAsistencia = -1
        }
    }

    MessageDialog {
        id: messageAnularPresenteYAcreditar
        icon: StandardIcon.Question
        title: "Anular Presente"
        property int nro_presente: -1
        property var recordAbono: null
        text: "Anularemos el presente Nº "+nro_presente + " y acreditaremos una clase adicional al abono Nº "+(recordAbono !== null ? recordAbono.id : -1)+" del alumno, ya que con dicho abono se había registrado el presente.\n
El alumno podrá aprovechar la clase acreditada siempre y cuando el abono mantenga su vigencia.\n\n¿Seguro que desea anular el presente?"
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            wrapper.gestionBaseDeDatos.beginTransaction()
            if (wrapper.managerAsistencias.anularPresente(nro_presente)) {
                //tablaPresentes.model.remove(tablaPresentes.currentRow)

                if (wrapper.managerAbono.acreditarClasesAlAbono(selectorDeAbono.idAbonoSeleccionado, 1, false)){
                    wrapper.gestionBaseDeDatos.commitTransaction()
                    wrapper.managerAbono.obtenerAbonosPorClienteMasFecha(buscador.recordClienteSeleccionado.id,true,false,true)
                    wrapper.managerAsistencias.obtenerPresentesDelAlumno(buscador.recordClienteSeleccionado.id, 3)
                }
                else{
                    messageError.open()
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                }
            }else{
                wrapper.gestionBaseDeDatos.rollbackTransaction()
            }
        }
    }

    MessageDialog {
        id: messageAnularPresente
        icon: StandardIcon.Question
        title: "Anular Presente"
        property int nro_presente: -1

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            if (wrapper.managerAsistencias.anularPresente(nro_presente)) {
                wrapper.managerAsistencias.obtenerPresentesDelAlumno(buscador.recordClienteSeleccionado.id, 3)
            }
        }
    }

    BuscadorDeEstudiante {
        id: buscador
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: detallesDelCliente.left
        anchors.rightMargin: -1
        anchors.leftMargin: -1
        height: 250
        escucharSignals: principal.enabled
        dadosDeBaja: false

        function onClienteSeleccionado() {
            cuenta_alumno = null
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

                        //(int id_cliente, bool estado, bool incluirAbonosCompradosEnElFuturo = false, bool incluirAbonosConCeroClases = false, QString fecha = QDate::currentDate().toString("yyyy-MM-dd"));
                        if (!wrapper.managerAbono.obtenerAbonosPorClienteMasFecha(recordClienteSeleccionado.id,true,false,true)) {
                            messageDialog.text = "Ocurrió un problema al intentar obtener los abonos del cliente."
                            messageDialog.icon = StandardIcon.Critical
                            messageDialog.open()
                        }
                        cantidadDeClasesEnDeuda = wrapper.managerAsistencias.obtenerClasesSinPagarPorAlumno(recordClienteSeleccionado.id)
                        if (cantidadDeClasesEnDeuda > 0){
                            tableColumnDeudaClases.visible = true
                            txtCuentaAlumno.text = strDeuda
                        }
                        else{
                            tableColumnDeudaClases.visible = false
                            txtCuentaAlumno.text = strAlDiaDeuda
                        }

                        tablaPresentes.model = 0
                        wrapper.managerAsistencias.obtenerPresentesDelAlumno(recordClienteSeleccionado.id, 3)
                        switchOnOffDatos(true)
                    }
                }
                else {
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                }
            }
            else {
                limpiarFormulario()
            }
        }

        onRecordClienteSeleccionadoChanged: {
            onClienteSeleccionado()
        }
    }

    ScrollView {
        id: scroll
        contentItem: flickDatos
        anchors.top: buscador.bottom
        anchors.left: parent.left
        anchors.leftMargin: -1
        anchors.rightMargin: -1
        anchors.bottomMargin: 10
        anchors.right: detallesDelCliente.left
        anchors.bottom: rowButtons.top
    }

    Flickable {
        id: flickDatos
        parent: scroll
        anchors.fill: scroll
        contentHeight: columnaDatos.height
        contentWidth: columnaDatos.width
        clip: true

        Column {
            id: columnaDatos
            spacing: 10
            opacity: 0
            enabled: false
            z: 1
            property int separacionIzquierda: 3

            Behavior on opacity {PropertyAnimation{}}

            Rectangle {
                height: 29
                width: flickDatos.width
                color: backColorSubtitles

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: columnaDatos.separacionIzquierda
                    font.family: "verdana";
                    font.pixelSize: 14
                    text: qsTrId("Cuenta del alumno")
                    color: colorSubtitles
                }

                Text {
                    anchors.fill: parent
                    anchors.rightMargin: columnaDatos.separacionIzquierda
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    font.family: "verdana";
                    font.pixelSize: 14
                    property string frase: ""

                    text: {
                        if (cuenta_alumno !== null){
                            "$ " + cuenta_alumno.credito_actual + frase
                        }
                        else{
                            ""
                        }
                    }
                    color:{
                        if (cuenta_alumno !== null) {
                            if (cuenta_alumno.credito_actual > 0){
                                frase = " (dinero a favor)"
                                "green"
                            }else if (cuenta_alumno.credito_actual < 0){
                                frase = " (en deuda)"
                                "red"
                            }
                            else {
                                frase = " (al día)"
                                "black"
                            }
                        }else{
                            "black"
                        }
                    }
                }
            }

            SaldoMovimientos {
                id: saldoMovimientos
                height: 85
                width: flickDatos.width
            }

            Rectangle {
                height: 29
                width: flickDatos.width
                color: backColorSubtitles

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: columnaDatos.separacionIzquierda
                    font.family: "verdana"; color: colorSubtitles;
                    font.pixelSize: 14
                    text: qsTrId("Abonos vigentes del alumno")

                }
            }

            Text {
                id: lblInfoAbono
                font.family: "verdana"
                font.pixelSize: 12
                text: strSinInformacion
            }



            SelectorDeAbono {
                id: selectorDeAbono
                width: flickDatos.width
                height: 148
                visible: false
                color: principal.color
                mostrarInfoPosibilidadRegistrarPresente: true

                onIdAbono: {
                    if (idAbonoSeleccionado == -1) {
                        lblInfoAbono.text = strNoAbono
                        lblInfoAbono.visible = true
                        lblFirmasCredencial.text = strSinInformacion
                    }
                    else {
                        if (aliasListaDeAbonos.model[selectorDeAbono.aliasListaDeAbonos.currentIndex].tipo == "Libre") {
                            radioTrajoCredencial.enabled = false
                            radioTrajoCredencial.checked = true
                            //lblFirmeLaCredencial.text = strNoEsNecesarioFirmarLaCredencial
                            lblFirmasCredencial.text = strSinInformacion
                        }
                        else {
                            radioTrajoCredencial.enabled = true
                            radioTrajoCredencial.checked = true
                            //lblFirmeLaCredencial.text = strPorFavorFirmeLaCredencial
                            var cantidadClasesSinFirmar = wrapper.managerAbono.obtenerClasesSinFirmarDeAbono(idAbonoSeleccionado)
                            if (cantidadClasesSinFirmar > 0)
                                lblFirmasCredencial.text = "\t*Hay " + wrapper.managerAbono.obtenerClasesSinFirmarDeAbono(idAbonoSeleccionado) + " clase/s pendientes. (Abono: " + idAbonoSeleccionado+")";
                            else
                                lblFirmasCredencial.text = strAlDia
                        }
                    }

                }
            }

            Rectangle {
                height: 29
                width: flickDatos.width
                color: backColorSubtitles

                Text {
                    id: lblClase
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.family: "verdana"; color: colorSubtitles;
                    font.pixelSize: 14
                    text: qsTrId("Asistiendo a clase")
                    width: 55
                    anchors.leftMargin: columnaDatos.separacionIzquierda
                }
            }

            Row {
                spacing: 5

                Text {
                    id: lblAsistiendoClase
                    font.family: "verdana"
                    font.pixelSize: 12
                    y: 2
                    text: strSinInformacion
                }

                Button {
                    text: qsTrId("Seleccionar clase")
                    y: -2

                    onClicked: {
                        selectorDeDanza.visible = true
                    }
                }
            }

            Rectangle {
                height: 29
                width: flickDatos.width
                color: backColorSubtitles

                Text {
                    id: lblEstadoDeCredencial
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.family: "verdana"; color: colorSubtitles;
                    font.pixelSize: 14
                    text: qsTrId("Estado de las firmas correspondiente al abono seleccionado")
                    anchors.leftMargin: columnaDatos.separacionIzquierda
                }
            }
            /*Text {
                id: lblFirmeLaCredencial
                font.family: "tahoma"
                font.pixelSize: 14
                text: strPorFavorFirmeLaCredencial
            }*/

            ExclusiveGroup {
                id: group
            }

            Row {
                x: columnaDatos.separacionIzquierda *3
                spacing: 3
                RadioButton {
                    id: radioTrajoCredencial
                    checked: true
                    exclusiveGroup: group
                    text: qsTrId("¡Ya firmé la credencial!")
                }

                RadioButton {
                    id: radioNoTrajoCredencial
                    exclusiveGroup: group
                    text: qsTrId("No pude hacerlo.")
                    enabled: radioTrajoCredencial.enabled
                    width: 35
                }

                Text {
                    id: lblFirmasCredencial
                    font.family: "verdana"
                    font.pixelSize: 12
                    y: 1
                    text: strSinInformacion
                }
            }

            Rectangle {
                height: 29
                width: flickDatos.width
                color: backColorSubtitles
                visible: false              //Desde v5.1 no se usa mas

                Text {
                    id: lblCuentaAlumno
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.family: "verdana"; color: colorSubtitles;
                    font.pixelSize: 14
                    text: qsTrId("Total asistencias a clases del alumno/a sin respaldo de abono")
                    visible: true
                    width: 250
                    anchors.leftMargin: columnaDatos.separacionIzquierda
                }
            }

            Row {
                spacing: 5
                visible: false              //Desde v5.1 no se usa mas

                Text {
                    id: txtCuentaAlumno
                    font.family: "verdana"
                    font.pixelSize: 12
                    visible: true
                    y: 2
                    text: strSinInformacion
                }

                Image {
                    width: 16
                    height: width
                    visible: false              //Desde v5.1 no se usa mas
                    source: {
                        if (txtCuentaAlumno.text === strDeuda) {
                            "qrc:/media/Media/warning_sign.png"
                        }
                        else if (txtCuentaAlumno.text === strAlDiaDeuda){
                            "qrc:/media/Media/icoyes.png"
                        }
                        else {
                            ""
                        }
                    }

                }
            }


            Button {
                id: btnAnularPresente
                text: "Anular presente seleccionado"
                enabled: tablaPresentes.currentRow !== -1
                x: 3
                width: 175

                onClicked: {
                    if (tablaPresentes.currentRow !== -1) {
                        var id_presente = tablaPresentes.model[tablaPresentes.currentRow].id
                        var recordAbonoAdulto = wrapper.managerAbono.obtenerCompraDeAbonoAdultoPorIdAsistenciaAdulto(id_presente)

                        messageAnularPresente.nro_presente = id_presente

                        messageAnularPresenteYAcreditar.nro_presente = id_presente
                        messageAnularPresenteYAcreditar.recordAbono = recordAbonoAdulto

                        if (recordAbonoAdulto === null){
                            messageAnularPresente.text = "Anularemos el presente Nº "+id_presente + " pero no acreditaremos una clase adicional al abono del alumno.\n\n¿Seguro que desea anular el presente?"
                            messageAnularPresente.open()
                        }
                        else {
                            if (recordAbonoAdulto.tipo === "Libre"){
                                messageAnularPresente.text = "Anularemos el presente Nº "+id_presente + " registrado con el abono Nº "+recordAbonoAdulto.id + " pero como es un abono libre, no acreditaremos una clase adicional al abono del alumno.\n\n¿Seguro que desea anular el presente?"
                                messageAnularPresente.open()
                            }
                            else {
                                console.debug("Se anula el presente y se acredita uno nuevo")
                                messageAnularPresenteYAcreditar.open()
                            }
                        }
                    }
                }
            }


            TableView {
                id: tablaPresentes
                height: 85
                width: flickDatos.width

                TableViewColumn {
                    role: "id"
                    title: "Nro"
                    width: 45
                }

                TableViewColumn {
                    role: "nombre_actividad"
                    title: "Actividad"
                    delegate: Item {
                        Text {
                            x: 1
                            text: styleData.value
                            color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                        }
                    }
                }

                TableViewColumn {
                    role: "nombre_clase"
                    title: "Clase"
                    delegate: Item {
                        Text {
                            x: 1
                            text: styleData.value
                            color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                        }
                    }
                }

                TableViewColumn {
                    id: tableColumnDeudaClases
                    role: "clase_debitada"
                    title: "Clase tomada con abono"
                    visible: false

                    delegate: Item {
                        Image {
                            x: 1
                            source: {
                                if (styleData.value == "Si")
                                    "qrc:/media/Media/icoyes.png"
                                else if(styleData.value == "No")
                                    "qrc:/media/Media/icono.png"
                                else
                                    ""
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "credencial_firmada"
                    title: "Firma"
                    width: 33

                    delegate: Item {
                        Image {
                            x: 1
                            source: {
                                if (styleData.value == "Si")
                                    "qrc:/media/Media/icoyes.png"
                                else if(styleData.value == "No")
                                    "qrc:/media/Media/icono.png"
                                else
                                    ""
                            }
                        }
                    }
                }


                TableViewColumn {
                    role: "fecha"
                    title: "Fecha últimos 3 presentes"
                    width: 230
                    delegate: Item {
                        Text {
                            x: 1
                            //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                            text: wrapper.classManagementManager.calcularTiempoPasado(styleData.value)
                            color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                        }
                    }
                }
            }
        }

    }

    MessageDialog {
        id: messageLimite
        icon: StandardIcon.Critical
        title: qsTrId("¡Límite alcanzado!")
        text: ""//qsTrId("¡Lo lamento! El presente no fue registrado. Actualmente hay más de "+wrapper.classManagementManager.limiteDeAlumnos+" alumnos registrados en el sistema.\nPodés ponerte en contacto conmigo (menú 'Acerca de' -> 'Sobre la copia') y solicitar una versión de este programa que se adapte a tus necesidades.")
    }

    MessageDialog {
        id: messageSistemaBloqueado
        icon: StandardIcon.Critical
        title: qsTrId("¡Sistema bloqueado!")
        text: qsTrId("¡Lo lamento! El presente no fue registrado. Debe activar DanSoft para poder seguir registrando los presentes.\nPara más información de cómo realizar la activación, póngase en contacto conmigo (menú 'Acerca de' -> 'Sobre la copia').\nSi ya cuenta con una 'llave de activación', ingresela en el módulo 'Activación' (menú 'Acerca de' -> 'Activación')")
    }



    Row {
        id: rowButtons
        anchors.right: detallesDelCliente.left
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: -2
        anchors.bottomMargin: -2
        height: 40
        spacing: 10

        //layoutDirection: Qt.RightToLeft

        Button {
            id: btnDarPresenteSinAbonoConDeuda
            //text: qsTrId("Dar presente y registrar deuda")
            text: "Es necesario un abono para registrar el presente"
            //enabled: idClaseAsistencia !== -1 && buscador.recordClienteSeleccionado !== null
            enabled: false
            visible: false
            height: btnDarPresenteAbonado.height
            width: btnDarPresenteAbonado.width


            function darPresenteConDeuda() {
                //"yyyy-MM-dd HH:mm:ss"
                //"yyyy-MM-dd HH:mm:ss"
                var idPresente
                if (checkDarPresenteConOtraFecha.checked){
                    //var hora = spinHora.value >= 10 ? spinHora.value : "0"+spinHora.value
                    //var minuto = spinMinuto.value >= 10 ? spinMinuto.value : "0"+spinMinuto.value
                    var hora = spinHora.prefix + spinHora.value
                    var minuto = spinMinuto.prefix + spinMinuto.value
                    var hora_minuto = hora + ":" + minuto + ":00"
                    var nuevaFechaHora = txtFecha.text + " " + hora_minuto
                    idPresente = wrapper.managerAsistencias.darPresente(buscador.recordClienteSeleccionado.id, debitarClase, idClaseAsistencia, nuevaFechaHora)
                }
                else
                    idPresente = wrapper.managerAsistencias.darPresente(buscador.recordClienteSeleccionado.id, debitarClase, idClaseAsistencia)

                if (idPresente) { //O sea, si idPresente es igual a cualquier otro numero excepto el cero.
                    strDatosDelRegistroDePresente = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre
                    strDatosDelRegistroDePresente += ".\nEl presente fue registrado como sin abonar."
                    messageDialog.text = "Registro de presente exitoso. Número de presente: " + idPresente + ".\n" + strDatosDelRegistroDePresente
                    messageDialog.icon = StandardIcon.Warning
                    messageDialog.open()
                    limpiarFormulario()
                }
            }

            onClicked: {
                if (wrapper.classManagementManager.versionGratis){
                    if (wrapper.classManagementManager.seLlegoAlLimite())
                        messageLimite.open()
                    else
                        darPresenteConDeuda()
                }
                else { //Version paga
                    if (wrapper.classManagementManager.sistema_bloqueado)
                        messageSistemaBloqueado.open()
                    else
                        darPresenteConDeuda()
                }
            }
        }

        Button {
            id: btnDarPresenteAbonado
            text: selectorDeAbono.idAbonoSeleccionado !== -1 ? "Registrar presente usando abono Nº " + selectorDeAbono.idAbonoSeleccionado : "Registrar presente usando abono"
            enabled: idClaseAsistencia !== -1 && buscador.recordClienteSeleccionado !== null
            visible: !btnDarPresenteSinAbonoConDeuda.visible
            height: 40
            width: 300

            function darPresenteConAbono() {
                var transaccionComiteada = 0
                wrapper.gestionBaseDeDatos.beginTransaction()
                var idPresente
                if (checkDarPresenteConOtraFecha.checked){
                    var hora = spinHora.prefix + spinHora.value
                    var minuto = spinMinuto.prefix + spinMinuto.value
                    var hora_minuto = hora + ":" + minuto + ":00"
                    var nuevaFechaHora = txtFecha.text + " " + hora_minuto
                    idPresente = wrapper.managerAsistencias.darPresente(buscador.recordClienteSeleccionado.id, debitarClase, idClaseAsistencia, nuevaFechaHora)
                }
                else{
                    idPresente = wrapper.managerAsistencias.darPresente(buscador.recordClienteSeleccionado.id, debitarClase, idClaseAsistencia)
                }
                if (idPresente) { //O sea, si idPresente es igual a cualquier otro numero excepto el cero.
                    strDatosDelRegistroDePresente = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre + "."
                    if (debitarClase) {
                        var abonoSeleccionado = selectorDeAbono.aliasListaDeAbonos.model[selectorDeAbono.aliasListaDeAbonos.currentIndex]
                        if (wrapper.managerAbono.registrarPresenteAlAbono(abonoSeleccionado.id, idPresente, radioTrajoCredencial.checked ? "Si" : "No")){
                            strDatosDelRegistroDePresente += "\nAbono: " + abonoSeleccionado.id
                            if (abonoSeleccionado.tipo === "Normal") {
                                strDatosDelRegistroDePresente += " (normal)"
                            }
                            else{
                                strDatosDelRegistroDePresente += " (libre)"
                            }
                            if (wrapper.managerAbono.descontarClaseAlAbono(selectorDeAbono.idAbonoSeleccionado, abonoSeleccionado.cantidad_restante-1)){
                                wrapper.gestionBaseDeDatos.commitTransaction()
                                transaccionComiteada = 1
                            }
                            else {
                                wrapper.gestionBaseDeDatos.rollbackTransaction()
                            }
                        }
                        else {
                            wrapper.gestionBaseDeDatos.rollbackTransaction()
                        }
                    }
                    limpiarFormulario()

                    if (transaccionComiteada) {
                        messageDialog.text = "¡Registro de presente exitoso! Número de presente: " + idPresente + ".\n" + strDatosDelRegistroDePresente
                        messageDialog.icon = StandardIcon.Information
                    }
                    else {
                        messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                        messageDialog.icon = StandardIcon.Warning
                    }
                    messageDialog.open()
                }
                else {
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                }

                //switchOnOffDatos(false);

            }

            onClicked: {
                if (selectorDeAbono.estadoPresentePotencial === 2) {
                    if (selectorDeAbono.montoDeudaPotencial > 0) {
                        messageDialogYesNo.text = "Límite de presentes ya alcanzado. Intentaremos mejorar el abono Nº "+selectorDeAbono.idAbonoSeleccionado+" para que admita más clases pero se debitarán $ " + selectorDeAbono.montoDeudaPotencial + " de la cuenta del alumno por la diferencia de precio entre el abono que admite más clases y el que ya había adquirido el alumno. La vigencia del abono no cambiará.

Actualmente el saldo de la cuenta del alumno es de $ "+cuenta_alumno.credito_actual+" y de ese saldo se debitarán $ "+selectorDeAbono.montoDeudaPotencial+" en concepto de mejora de abono, lo cual resultará en un saldo de cuenta de $ "+(cuenta_alumno.credito_actual-selectorDeAbono.montoDeudaPotencial)+".

¿Seguro que desea continuar con el registro del presente?"

                        messageDialogYesNo.title = "Adultos - Registro de presente no cubierto por abono"
                        messageDialogYesNo.icon = StandardIcon.Warning
                        messageDialogYesNo.open()
                    }
                    else {
                        messageDialogYesNoTwo.text = "Límite de presentes ya alcanzado. Actualmente no se encuentra habilitado un abono superior al que ya cuenta el alumno que le permita tomar más clases.

    Para tener en cuenta:
    1.- En las ofertas de abonos puede habilitar a alguno que admita más clases.
    Si lo hace, es muy importante que cierre la pestaña de registro de presente adulto (luego puede volver a abrirla), de otra forma, los cambios que haga en las ofertas de abono puede que no se vean reflejados.

    2.- Si cree que no es posible que el alumno haya podido sobrepasar el límite de clases, verifique los presentes registrados del alumno en busca de algún registro que se haya cargado accidentalmente más de una vez en un mismo día.

    Si usted lo desea, puede registrar el presente con este abono de todas formas e ignorar el límite impuesto por dicho abono. No le cobraremos nada al alumno (ya que como no hay disponible un abono superior, se considera que el abono actual cubre el presente) pero si usted deseara cobrarle esta asistencia, puede hacerlo desde el módulo de cuenta del alumno.

    ¿Seguro que desea registrar el presente de todas formas?"

                        messageDialogYesNoTwo.title = "Adultos - Registro de presente no cubierto por abono"
                        messageDialogYesNoTwo.icon = StandardIcon.Warning
                        messageDialogYesNoTwo.open()
                    }
                }
                else {
                    darPresenteConAbono()
                }
            }
        }

        CheckBox {
            id: checkDarPresenteConOtraFecha
            text: "Con otra fecha"
            enabled: buscador.recordClienteSeleccionado !== null
            y: 3

            onCheckedChanged: {
                if (checked){
                    txtFecha.text = Qt.formatDate(txtFecha.fecha,"yyyy-MM-dd");
                    txtFecha.lastValidText = txtFecha.text
                    detallesDelCliente.aliasCalendar.selectedDate = txtFecha.fecha
                }
            }
        }

        Button {
            id: btnCalendarFinal
            width: 30
            height: 30
            visible: checkDarPresenteConOtraFecha.checked

            Image {
                anchors{    fill: parent;       margins: 3 }
                source: "qrc:/media/Media/calendar.png"
            }

            onClicked: {
                detallesDelCliente.aliasCalendarVisible = !detallesDelCliente.aliasCalendarVisible
            }
        }

        TextField {
            id: txtFecha
            property date fecha: wrapper.classManagementManager.nuevaFecha(wrapper.classManagementManager.obtenerFecha(),-1);
            property date lastValidDate: wrapper.classManagementManager.nuevaFecha(wrapper.classManagementManager.obtenerFecha(),-1);
            property string lastValidText
            y: 3
            inputMask: "0000-00-00;_"
            maximumLength: 10
            width: 82
            property var date
            readOnly: true
            height: 25
            visible: checkDarPresenteConOtraFecha.checked
            //text: Qt.formatDate(date,"yyyy-MM-dd");

            onFechaChanged: {
                var dif_dias = wrapper.classManagementManager.obtenerDiferenciaDias(fecha,wrapper.classManagementManager.obtenerFechaHora())
                if (dif_dias >= 0 && dif_dias <=14) {
                    lastValidDate = fecha
                    lastValidText = text
                    txtFecha.text = Qt.formatDate(fecha,"yyyy-MM-dd");
                }
                else {
                    fecha = lastValidDate
                    detallesDelCliente.aliasCalendar.selectedDate = txtFecha.fecha
                    txtFecha.text = Qt.formatDate(fecha,"yyyy-MM-dd");
                    //text = lastValidText
                    messageDialog.icon = StandardIcon.Warning
                    messageDialog.text = "No se puede viajar tanto en el tiempo y registrar un presente ocurrido hace más de 2 (dos) semanas; o bien registrar hoy un presente que ocurrirá mañana o en los siguientes días."
                    messageDialog.open()
                }
            }
        }

        Text {
            text: "Hora:"
            visible: checkDarPresenteConOtraFecha.checked
            y: 6
        }

        SpinBox {
            id: spinHora
            maximumValue: 23
            value: 18
            y: 3
            height: 25
            visible: checkDarPresenteConOtraFecha.checked
            prefix: value < 10 ? "0" : ""
        }

        SpinBox {
            id: spinMinuto
            maximumValue: 59
            y: spinHora.y
            height: spinHora.height
            visible: checkDarPresenteConOtraFecha.checked
            stepSize: 5
            value: 00
            prefix: value < 10 ? "0" : ""
        }
    }

    DetallesDelCliente {
        id: detallesDelCliente
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: -1
        //anchors.margins: 3
        width: 250
        aliasRecordClienteSeleccionado: buscador.recordClienteSeleccionado

        onSig_clickedFecha: {
            txtFecha.fecha = date
            detallesDelCliente.aliasCalendarVisible = false
        }
    }
}
