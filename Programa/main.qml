import QtQuick 2.3
import QtQml 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import "qrc:/components"
import "qrc:/vistaPrincipal"
import com.mednet.WrapperClassManagement 1.0
import com.mednet.PestaniaTab 1.0
import com.mednet.GestionBaseDeDatos 1.0

ApplicationWindow {
    id: aplicacion
    visible: true
    minimumWidth: 766
    width: 842
    height: 677
    minimumHeight: 624
    color: "#FFFFFE"
    title: qsTr("DanSoft")
    property string strPathInicial : "qrc:/vistaPrincipal/VistaInicial.qml"
    property bool visualizandoPestania: false
    property int indexPestania : -1
    property string strRegistro : ""//"[nombre_de_tu_escuela]"
    property bool copiaDeEvaluacion : false
    property string strVersion : "6.1 Développé"
    property int cantidad_alumnos_soportados : -1
    property string strDanzaSoftNoActivado : " - DANSOFT NO ESTA ACTIVADO"
    property string strDanzaSoftBloqueado : " - DANSOFT ESTA BLOQUEADO"
    property bool software_activado : true
    //property bool software_bloqueado : false
    property string originalTitle : title
    property string originalStrRegistro : strRegistro
    property string strDateTime : ""
    property string strEstadoControlCaja: ""


    property color colorStatusBar: "#C8E6C9"
    opacity: 0

    Behavior on opacity {PropertyAnimation{duration:250}}

    function mostrarInicio() {
        contenedor.children[0].opacity = 1
        contenedor.children[0].enabled = true
        listaPestanias.currentIndex = 0
        for (var i=1;i<contenedor.children.length;i++){
            contenedor.children[i].opacity=0
            contenedor.children[i].enabled=false
        }
    }

    function ocultarInicio() {
        contenedor.children[0].z = 0
        contenedor.children[0].opacity = 0
        contenedor.children[0].enabled = false
    }

    function verificar_activacion() {
        software_activado = wrapper.managerActiviationSerial.verificarActivacion(wrapper.classManagementManager.obtenerFecha())
        if (software_activado) {
            aplicacion.title = originalTitle
            strRegistro = originalStrRegistro
            mostrar_marca_de_agua_sistema_bloqueado(false)
            //software_bloqueado = false
            wrapper.classManagementManager.sistema_bloqueado = false
        }
    }

    function mostrar_marca_de_agua_sistema_bloqueado(valor) {
        if (valor)
            recBloqueadoMarcaDeAgua.opacity = 1
        else
            recBloqueadoMarcaDeAgua.opacity = 0
    }

    function hacer_backup_si_corresponde() {
        //Me desconecto de la base de datos.
        //Hago un backup
        var recordInfoBackUp = wrapper.gestionBaseDeDatos.traerInfoBackUp()
        if (recordInfoBackUp != null) {
            if (recordInfoBackUp.al_cerrar_sistema) {
                if (wrapper.gestionBaseDeDatos.hacerBackUp(
                            recordInfoBackUp.ruta1,
                            recordInfoBackUp.ruta2,
                            false)){
                    Qt.quit()
                }
            }else{
                Qt.quit()
            }
        }else{
            wrapper.gestionBaseDeDatos.cerrarConexion()
            Qt.quit()
        }
    }

    onClosing: {
        close.accepted = false
        var record_ultima_caja = wrapper.managerCaja.traer_ultima_caja()
        if (record_ultima_caja != null && record_ultima_caja.estado == "Abierta"){
            messageDialogCajaAbierta.open()
        }
        else {
            closeProgram()
        }
    }

    function closeProgram(){
        hacer_backup_si_corresponde()
    }

    MessageDialog {
        id: messageDialogCajaAbierta
        title: "Caja abierta"
        text: "La caja está abierta y se va a cerrar el sistema. ¿Cerrar sistema?"
        icon: StandardIcon.Warning
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            closeProgram()
        }
    }


    Component.onCompleted: {
        opacity = 1
        copiaDeEvaluacion = wrapper.classManagementManager.versionGratis
        cantidad_alumnos_soportados = wrapper.classManagementManager.limiteDeAlumnos
        strDateTime = Qt.formatDateTime(wrapper.classManagementManager.obtenerFechaHora(),"dddd dd/MM/yyyy HH:mm:ss")

        var record_ultima_caja = wrapper.managerCaja.traer_ultima_caja()
        if (record_ultima_caja != null && record_ultima_caja.estado == "Abierta"){
            strEstadoControlCaja = " || Caja abierta el "+
                    Qt.formatDateTime(record_ultima_caja.fecha_inicio,"dddd d")+
                    " a las "+
                    Qt.formatDateTime(record_ultima_caja.fecha_inicio,"HH:mm")+"hs."  //
        }

        if (copiaDeEvaluacion) {
            strRegistro = ""

        }
        else {
            //strRegistro = "Estudio de Danzas Mariela Estrábaca"
        }
        wrapper.classManagementManager.cliente = strRegistro

        if (!wrapper.gestionBaseDeDatos.creacionDeTablasOk) {
            messageDialogGrave.text = "Ocurrió un percance al intentar acceder a la información.\n
Si colocaste una base de datos antigua en el directorio del programa es probable que la misma sea incompatible con la versión actual de DanSoft y por ende sea la causante de este inconveniente.
En tal caso, volvé a cargar la base de datos que utilizabas normalmente.\nSi no estás seguro/a sobre como proceder, por favor, reporta este problema.\n
El programa se cerrará."
            messageDialogGrave.requiereCerrarElPrograma = true
            messageDialogGrave.open()
        }
        else {
            var total_asistencias = wrapper.gestionBaseDeDatos.chequeoDeSeguridadDeLaHoraFecha()
            if (total_asistencias > 0){
                messageDialogGrave.text = "La fecha de hoy es \""+Qt.formatDate(wrapper.classManagementManager.obtenerFecha(),"dddd dd/MM/yyyy")+"\" según su computadora.\nSin embargo, en el sistema hay "+total_asistencias+" asistencia/s de adultos registrada/s en fecha posterior a la mencionada.\nPor favor, corrija la fecha (y también la hora de ser necesario) de su computadora y después vuelva a iniciar DanSoft.\n\nTIP: Para saber cuál es la fecha y hora exacta puede googlear \"hora oficial\".\nEs muy importante que la fecha y hora siempre sea la correcta para mantener la lógica de la información que se guarda y/o consulta en DanSoft."
                messageDialogGrave.requiereCerrarElPrograma = true
                messageDialogGrave.open()
            }

            if (!copiaDeEvaluacion) {
                verificar_activacion()
                if (!software_activado){
                    originalTitle = aplicacion.title
                    originalStrRegistro = strRegistro

                    var dia = Qt.formatDate(wrapper.classManagementManager.obtenerFecha(),"d")
                    if (dia > 0) {//if (dia > 10) {
                        //Bloquear sistema
                        //wrapper.managerPestanias.nuevaPestania("Activación","qrc:/plugins/Activacion.qml")
                        mostrar_marca_de_agua_sistema_bloqueado(true)
                        wrapper.classManagementManager.sistema_bloqueado = true
                        messageDialog.text = "¡DanSoft se ha bloqueado!\nLo lamento, pero no podrás registrar presentes hasta tanto actives el sistema.\nPor favor, ingresá en 'Activación' (menú 'Acerca de' -> 'Activación') una llave correspondiente al mes actual.\nSi todavía no tenés tu llave, solicitala enviando un mail a GestorIslasMalvinas@gmail.com o llamando al 11-6432-4949."
                        messageDialog.icon = StandardIcon.Critical
                        aplicacion.title += strDanzaSoftBloqueado
                        strRegistro += strDanzaSoftBloqueado
                    }
                    else {
                        messageDialog.text = "¡DanSoft no está activado!\nPor favor, ingresá en 'Activación' (menú 'Acerca de' -> 'Activación') una llave correspondiente al mes actual.\nSi todavía no tenés tu llave, solicitala enviando un mail a GestorIslasMalvinas@gmail.com o llamando al 11-6432-4949.\nAun sin la llave, el sistema podrá funcionar hasta el día 10 de este mes. Luego se bloqueará y no te permitirá continuar registrando presentes."
                        messageDialog.icon = StandardIcon.Warning
                        aplicacion.title += strDanzaSoftNoActivado
                        strRegistro += strDanzaSoftNoActivado
                    }
                    messageDialog.open()
                }
            }
        }
    }

    SplashScreen {
        id: splashScreen
        anchors.fill: parent
        z: 25
        opacity: 1
    }

    //Este componente permite visualizar una foto de perfil a "pantalla completa".
    //Se ubica en el main porque esta función debe estar disponible en cualquier modulo.
    ViewProfilePicture {
        id: compViewProfilePicture
        y: 30
        z: 10
    }

    Rectangle {
        id: recBloqueadoMarcaDeAgua
        anchors.fill: parent
        color: "transparent"
        opacity: 0
        z: 10

        Rectangle {
            anchors.fill: parent
            color: "grey"
            gradient: Gradient {
                GradientStop {
                    position: 0.00;
                    color: "transparent";
                }
                GradientStop {
                    position: 0.7;
                    color: "grey";
                }
                GradientStop {
                    position: 1.00;
                    color: "grey";
                }
            }
            z: 10
            opacity: recBloqueadoMarcaDeAgua.opacity == 1 ? 0.9: 0

            Behavior on opacity {PropertyAnimation{}}
        }

        Text {
            font.family: "Segoe UI"
            style: Text.Outline
            color: "white"
            styleColor: "red"
            font.pointSize: 17
            text: qsTrId("DANSOFT NO ESTÁ ACTIVADO")
            /*anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            rotation: -20*/
            anchors.bottom: parent.bottom
            height: 50
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            opacity: recBloqueadoMarcaDeAgua.opacity == 1 ? 1 : 0
            z: 11

            Behavior on opacity {PropertyAnimation{}}
        }
    }

    InputDialog {
        id: inputDialog
        property bool eventoParaHoy: true
        z: 10

        onTextoIngresado: {
            //arg
            if (eventoParaHoy) {
                wrapper.managerNuevoEvento.fechaSeleccionada = wrapper.classManagementManager.obtenerFecha()
                wrapper.managerNuevoEvento.guardarNuevoEvento(arg)
            }
            else {
                wrapper.managerNuevoEvento.fechaSeleccionada = wrapper.classManagementManager.nuevaFecha(wrapper.classManagementManager.obtenerFecha(),1)
                wrapper.managerNuevoEvento.guardarNuevoEvento(arg)
            }
        }
    }

    menuBar: MenuBar {
        id: menuSuperior
        //property bool menuVisible: splashScreen.opacity !== 1

        Menu {
            id: menuOpciones
            title: "Opciones"
            enabled: splashScreen.opacity !== 1 ? true : false

            MenuItem {
                text: "Inicio"
                shortcut: "ctrl+s"
                onTriggered: {
                    wrapper.classManagementManager.abrirModulo("qrc:/vistaPrincipal/VistaInicial.qml");
                }
            }

            Menu {
                id: menuAlumnos
                title: qsTr("Gestión de alumnos")
                property string colorPestania: "#FFF9C4"

                MenuItem {
                    text: "Alta"
                    shortcut: "f3"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Alta de alumno/a","qrc:/estudiante/PreAltaDeCliente.qml",menuAlumnos.colorPestania)
                    }
                }

                MenuItem {
                    text: "Administración"
                    shortcut: "f4"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Admin. de alumnos","qrc:/estudiante/ConsultaDeCliente.qml",menuAlumnos.colorPestania)
                    }
                }
            }

            Menu {
                id: menuNinios
                title: qsTr("Niños")
                property string colorPestania: "#FFCDD2"

                MenuItem {
                    text: "Dar presente"
                    shortcut: "f5"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Dar presente infantil","qrc:/infantil/RegistrarPresenteInfantil.qml", menuNinios.colorPestania)
                    }
                }

                MenuItem {
                    text: "Dar presente desde tabla gráfica"
                    shortcut: "f9"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Tabla gráfica presentes","qrc:/infantil/NuevaTablaGrafica.qml","#FFCDD2")
                        //wrapper.managerPestanias.nuevaPestania("Tabla gráfica presentes","qrc:/infantil/VistaGraficaPresentes.qml","#FFCDD2")
                    }
                }

                /*MenuItem {
                    text: "Nueva tabla gráfica"
                    shortcut: "f5"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Nueva tabla gráfica","qrc:/infantil/NuevaTablaGrafica.qml","#FFCDD2")
                    }
                }*/

                MenuItem {
                    text: "Vender abono"
                    shortcut: "f6"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Venta abono infantil","qrc:/infantil/ComprarAbonoInfantil.qml", menuNinios.colorPestania)
                    }
                }

                MenuItem {
                    text: "Mejorar o degradar abono"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Editar abono infantil","qrc:/infantil/AdministrarAbonosInfantiles.qml", menuNinios.colorPestania)
                    }
                }

                MenuItem {
                    text: "Oferta de abonos"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Oferta de abonos","qrc:/infantil/OfertaDeAbonos.qml",menuNinios.colorPestania)
                    }
                }

                MenuItem {
                    text: qsTrId("Gestionar matrículas")
                    visible: true
                    shortcut: "Shift+F6"

                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Gestionar matrículas","qrc:/infantil/GestionarMatriculacion.qml",menuNinios.colorPestania)
                    }
                }

                //
            }

            Menu {
                id: menuAdultos
                title: qsTr("Adultos")
                property string colorPestania: "#B3E5FC"

                MenuItem {
                    text: "Dar presente"
                    shortcut: "f7"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Dar presente adulto","qrc:/adultos/RegistrarPresente.qml", menuAdultos.colorPestania)
                    }
                }

                MenuItem {
                    text: "Vender abono"
                    shortcut: "f8"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Venta abono adulto","qrc:/adultos/ComprarAbono.qml", menuAdultos.colorPestania)
                    }
                }

                MenuItem {
                    text: "Mejorar o degradar abono"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Editar abono adulto","qrc:/adultos/AdministrarAbonos.qml", menuAdultos.colorPestania)
                    }
                }

                MenuItem {
                    text: "Oferta de abonos"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Ofertas de abono adulto","qrc:/adultos/OfertaDeAbonosAdulto.qml",menuAdultos.colorPestania)
                    }
                }
            }

            Menu {
                id: menuActividades
                title: qsTrId("Actividades y clases")
                property string colorPestania: "#FFE0B2"

                MenuItem {
                    text: qsTrId("Administración general")

                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Actividades y clases","qrc:/danzas/AdminDanzaPlusClase.qml",menuActividades.colorPestania)
                    }
                }

                MenuItem {
                    text: qsTrId("Rendimiento de las clases")

                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Rendimiento de clases","qrc:/danzas/EstadisticasDanza.qml",menuActividades.colorPestania)
                    }
                }

            }

            Menu {
                id: menuTesoreria
                title: qsTrId("Tesorería")
                property string colorPestania: "#C8E6C9"

                MenuItem {
                    text: qsTrId("Administrar cuenta alumno")

                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Admin. cuenta alumno","qrc:/tesoreria/AdministrarSaldo.qml",menuTesoreria.colorPestania)
                    }
                }

                MenuItem {
                    text: qsTrId("Administrar caja")

                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Administrar caja","qrc:/tesoreria/AdministrarCaja.qml",menuTesoreria.colorPestania)
                    }
                }

                MenuItem {
                    text: qsTrId("Control de caja")

                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Control de caja","qrc:/tesoreria/ControlCaja.qml",menuTesoreria.colorPestania)
                    }
                }

                MenuItem {
                    text: qsTrId("Rendimiento general")

                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Rendimiento general","qrc:/tesoreria/RendimientoEstablecimiento.qml",menuTesoreria.colorPestania)
                    }
                }

                //m_text: qsTrId("   Resumen sobre venta de abonos")
                //wrapper.managerPestanias.nuevaPestania("Resumen venta abonos","qrc:/tesoreria/ResumenVentaAbonos.qml",colorPestania)

                MenuItem {
                    text: qsTrId("Resumen sobre venta de abonos")

                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Resumen venta abonos","qrc:/tesoreria/ResumenVentaAbonos.qml",menuTesoreria.colorPestania)
                    }
                }
            }

            MenuItem {
                id: menuBackUp
                text: qsTrId("Copia de seguridad")

                onTriggered: {
                    wrapper.managerPestanias.nuevaPestania("Copia de seguridad","qrc:/plugins/BackUp.qml")
                }

            }

            MenuItem {
                text: "Calendario"
                onTriggered: {
                    wrapper.managerPestanias.nuevaPestania("Calendario","qrc:/fresh_calendar/FreshCalendar.qml")
                }
            }

            /*Menu {
                id: menuExtras
                title: qsTrId("Extras")

                MenuItem {
                    text: "Calendario"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Calendario","qrc:/fresh_calendar/FreshCalendar.qml")
                    }
                }

                MenuItem {
                    text: "Trivia"
                    onTriggered: {
                        wrapper.managerPestanias.nuevaPestania("Trivia","qrc:/trivia/Trivia.qml")
                    }
                }
            }*/
        }

        Menu {
            id: menuAcercaDe
            title: "Acerca de DanSoft"
            enabled: splashScreen.opacity !== 1 ? true : false
            //visible: menuSuperior.menuVisible

            /*MenuItem {
                text: "Historia"

                onTriggered: {
                    wrapper.managerPestanias.nuevaPestania("Historia","qrc:/components/Folleto.qml")
                }
            }*/


            MenuItem {
                text: "Sobre la copia"
                shortcut: "F1"

                onTriggered: {
                    messageSobreMi.open()
                }
            }

            /*MenuItem {
                id: menuRegistro
                text: "Información Importante"
                shortcut: "F2"
                //visible: !copiaDeEvaluacion


                onTriggered: {
                    messageLicencia.open()
                }
            }*/

            MenuItem {
                id: menuActivacion
                text: "Activación"
                visible: !copiaDeEvaluacion

                onTriggered: {
                    wrapper.managerPestanias.nuevaPestania("Activación","qrc:/plugins/Activacion.qml")
                }
            }

            MenuItem {
                text: "Qué hay de nuevo"

                onTriggered: {
                    messageNovedades.open()
                }
            }
        }
    }

    statusBar: StatusBar {
        id: statusBar
        //property bool statusBarVisible: !splashScreen.visible
        height: splashScreen.opacity === 0 ? 20 : 0

        /*style: StatusBarStyle {
            padding {
                //left: 8
                //right: 8
                top: 3
                bottom: 3
            }
            background: Rectangle {
                id: recColorStatusBar
                //color: colorStatusBar
                border.color: "red"
                border.width: 2
                implicitHeight: 16
                implicitWidth: 200
                Rectangle {
                    anchors.top: parent.top
                    width: parent.width
                    height: 1
                    color: "#999"
                }
            }
        }*/

        Behavior on height {PropertyAnimation{ easing.amplitude: 3; easing.type: Easing.Linear;duration: 1000}}


        RowLayout {

            Text {
                id: lblVersion
                text: "Versión " + strVersion + " || Hoy es " + strDateTime + strEstadoControlCaja
                //text: "Versión 6.0 || Hoy es sábado 01/12/2018 21:10:30"
            }

            Timer {
                id: timerDateTime
                interval: 500; running: true; repeat: true
                onTriggered: strDateTime = Qt.formatDateTime(wrapper.classManagementManager.obtenerFechaHora(),"dddd dd/MM/yyyy HH:mm:ss")
            }
        }
    }



    MessageDialog {
        id: messageSobreMi
        icon: StandardIcon.Information
        title: qsTrId("Sobre DanSoft")
        text: "DanSoft\nVersión: "+ strVersion +". GA 002 (06/04/2020)\nLanzamiento inicial: 26 de marzo de 2020.\nDesarrollador: Javier Agustín Vescio.\nCorreo: JavierVescio@gmail.com\nWeb: sites.google.com/view/gestordealumnos"
    }

    MessageDialog {
        id: messageNovedades
        icon: StandardIcon.Information
        title: "Lo nuevo de la versión " + strVersion
        text: "
002 (06/04/2020)
*Se agregó una pequeña mejora en el resumen sobre venta de abonos (se muestran totales generales).
*Desde el panel 'Detalles' de cualquier alumno/a podrás ver la fecha en que fue matriculado.
*Ahora en cualquier momento se puede matricular/inscribir sin cargo a un alumno/a infantil, sin necesidad de tener que venderle un abono (presionar Shift+F6 para acceder a la funcionalidad o ir a menú 'Opciones'->'Niños'->'Gestionar matrículas').

Nota: recordá que al vender un abono infantil se le cobrará también la matrícula/inscripción al alumno (en caso de no estar matriculado/inscripto).


001 (26/03/2020)
*Ahora se podrán matricular alumnos infantiles al momento de comprarse un abono.
*Se podrá cargar desde 'Oferta de abonos' el valor $ de la matrícula, la cual tendrá vigencia anual.
*Si se quisiera registrar un presente a un alumno/a infantil sin abono, el sistema automáticamente le cobrará uno a la cuenta del alumno. Si el alumno/a tampoco tuviera matrícula, se le cobrará también de forma automática.
*Se podrá consultar un resumen del día sobre la venta de abonos infantiles y de adultos.
"

    }

    MessageDialog {
        id: messageLicencia
        icon: {
            if (copiaDeEvaluacion)
                StandardIcon.Warning
            else
                StandardIcon.Information }
        title: qsTrId("Información Importante")
        text: {
            if (copiaDeEvaluacion)
                qsTrId("
Este programa (DanSoft) es provisto 'tal cual', sin garantía de ningún tipo expresa o implícita. Yo Javier Vescio, el creador de DanSoft, no me haré bajo ninguna circunstancia responsable ante ninguna persona, por cualquier daño o perjuicio especial, fortuito, indirecto o derivado, incluyendo de forma enunciativa y no limitativa, la pérdida accidental de información.

Esta copia gratuita y de libre distribución presenta todas las funcionalidades del programa. Es responsabilidad del usuario realizar las copias de seguridad correspondientes de la base de datos. Lea la documentación para un uso seguro del sistema.")
            //qsTrId("Esta copia gratuita y de libre distribución presenta todas las funcionalidades del programa y solamente se impone un límite de gestión de hasta "+cantidad_alumnos_soportados+" alumnos. El objetivo de esta copia es dar a conocer el sistema.")
            else
                qsTrId("Registro a nombre de ") + strRegistro + "."
        }
    }

    function eventoRapidoParaHoy() {
        inputDialog.strMensaje = "Escribí un evento rápido para hoy:"
        inputDialog.visible = true
        inputDialog.eventoParaHoy = true
    }

    function eventoRapidoParaManiana() {
        inputDialog.strMensaje = "Escribí un evento rápido para mañana:"
        inputDialog.visible = true
        inputDialog.eventoParaHoy = false
    }

    Connections {
        target: wrapper.managerNuevoEvento

        onSig_eventoRapidoParaHoy: {
            eventoRapidoParaHoy()
        }

        onSig_eventoRapidoParaManiana: {
            eventoRapidoParaManiana()
        }
    }

    Connections {
        target: wrapper.managerCaja

        onSig_cajaAbierta: {
            strEstadoControlCaja = " || Caja abierta el "+
                    Qt.formatDateTime(fecha_hora,"dddd d")+
                    " a las "+
                    Qt.formatDateTime(fecha_hora,"HH:mm")+"hs."
        }

        onSig_cajaAnulada: {
            strEstadoControlCaja = " || Caja anulada el "+
                    Qt.formatDateTime(fecha_hora,"dddd d")+
                    " a las "+
                    Qt.formatDateTime(fecha_hora,"HH:mm")+"hs."
        }

        onSig_cajaCerrada: {
            var recordInfoBackUp = wrapper.gestionBaseDeDatos.traerInfoBackUp()
            if (recordInfoBackUp != null) {
                if (recordInfoBackUp.al_cerrar_caja) {
                    wrapper.gestionBaseDeDatos.hacerBackUp(
                                recordInfoBackUp.ruta1,
                                recordInfoBackUp.ruta2)
                }
            }

            strEstadoControlCaja = " || Caja cerrada el "+
                    Qt.formatDateTime(fecha_hora,"dddd d")+
                    " a las "+
                    Qt.formatDateTime(fecha_hora,"HH:mm")+"hs."

            if (resultado_caja == 0)
                strEstadoControlCaja += " Caja perfecta"
            else if (resultado_caja > 0) {
                strEstadoControlCaja += " Faltarían $ " + resultado_caja
            }
            else {
                strEstadoControlCaja += " Sobran $ " + resultado_caja
            }
        }
    }



    Connections {
        target: wrapper.managerOferta

        onSig_comentarioVenta: {
            //comentario_venta
            messageDialog.title = "Compra en tienda Nº " + id_venta + " (CT"+id_venta+")"
            messageDialog.text = comentario_venta
            messageDialog.icon = StandardIcon.Information
            messageDialog.open()
            messageDialog.title = "DanSoft"
        }
    }

    Connections {
        target: wrapper.gestionBaseDeDatos

        onSig_problemaBackUp: {
            //comentario_venta
            messageDialog.closeTheProgram = true
            messageDialog.title = "Copia de seguridad"
            messageDialog.text = "No pudimos hacer la copia de seguridad en las rutas indicadas como conflictivas. Verificá que los directorios en donde se colocan las copias existan y que no hayan cambiado la dirección.
Si la copia la haces a un pendrive o cualquier otro dispositivo de almacenamiento extraíble, verificá que el mismo esté conectado.

Ruta/s que causaron conflicto:
"+arg+"

Ruta donde se pudo hacer la copia:
"+arg2
            messageDialog.icon = StandardIcon.Warning
            messageDialog.open()
        }
    }

    //s

    Connections {
        target: wrapper.managerActiviationSerial

        onSig_serial_loaded_successfully: {
            verificar_activacion()
        }
    }

    Connections {
        target: wrapper.classManagementManager

        onSig_abrirModulo: {
            mostrarInicio()//loaderMain.source = strPath
        }
    }

    Connections {
        target: wrapper.managerPestanias

        onSig_nuevaPestania: {
            modelPestanias.append(
                        {
                            "tituloPestania": arg.tituloPestania,
                            "source": arg.source,
                            "colorElegido": arg.color,
                            "objPestania": arg
                        }
                        )

            var component = Qt.createComponent(arg.source);
            var obj = component.createObject(contenedor, {"p_objPestania": arg});
            listaPestanias.currentIndex = listaPestanias.count-1
            listaPestanias.currentItem.pestaniaClicked(); //Hace que se entre a la pestaña que se acaba de crear
        }
    }

    Connections {
        target: wrapper.classManagementGestionDeAlumnos

        onSig_mostrarFotoDePerfil: {
            compViewProfilePicture.visible = true
            compViewProfilePicture.strSource = arg
        }

        onSig_mensajeError: {
            messageDialogGrave.text = msjError
            messageDialogGrave.requiereCerrarElPrograma = requiereCerrarElPrograma
            messageDialogGrave.open()
        }
    }

    MessageDialog {
        id: messageDialogGrave
        icon: StandardIcon.Critical
        title: "DanSoft"

        property bool requiereCerrarElPrograma : false

        onAccepted: {
            if (requiereCerrarElPrograma)
                Qt.quit()
        }

        onRejected: {
            if (requiereCerrarElPrograma)
                Qt.quit()
        }
    }


    MessageDialog {
        id: messageDialog
        title: "DanSoft"
        property bool closeTheProgram: false

        onAccepted: if (closeProgram())Qt.quit()

        onRejected: if (closeProgram())Qt.quit()
    }

    WrapperClassManagement {
        id: wrapper
    }

    ListModel {
        id: modelPestanias

        ListElement {
            tituloPestania: "Inicio"
            source: "Inicio"
        }
    }

    Rectangle {
        id: recListaPestanias
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 30
        clip: true
        color: "#F5FAF3"


        ListView {
            id: listaPestanias
            anchors.fill: parent
            orientation: ListView.Horizontal
            model: modelPestanias
            highlightFollowsCurrentItem: false

            highlight: Component {
                RecHighLight {
                    x: listaPestanias.currentItem.x
                    width: x == 0 ? 110 : 220 //si x== 0 es que se esta en la pestania de inicio.
                    height: 40
                    z:15
                }
            }

            delegate: Pestania {
                p_strTitulo: tituloPestania
                p_strSource: source

                Component.onCompleted: {
                    if (index === 0) {
                        width = 110 //Hacemos mas chiquita solamente a la pestania de inicio/vista inicial
                        p_principal = true
                    }

                    if (index > 0) {
                        p_objPestania = modelPestanias.get(index).objPestania
                        p_colorPestania = modelPestanias.get(index).colorElegido
                    }

                    if (p_objPestania !== null)
                        objConnexion.target = p_objPestania
                }

                onPestaniaClicked: {
                    listaPestanias.currentIndex = index
                    if (index === 0) {
                        mostrarInicio()
                        if (!copiaDeEvaluacion)
                            mostrar_marca_de_agua_sistema_bloqueado(wrapper.classManagementManager.sistema_bloqueado)
                    }
                    else {
                        ocultarInicio()
                        for (var i=1;i<contenedor.children.length;i++){
                            contenedor.children[i].opacity=0
                            contenedor.children[i].enabled=false
                            if (contenedor.children[i].p_objPestania === p_objPestania) {
                                contenedor.children[i].opacity=1
                                contenedor.children[i].enabled=true
                                if (!copiaDeEvaluacion)
                                    mostrar_marca_de_agua_sistema_bloqueado(p_objPestania.source != "qrc:/plugins/Activacion.qml" && wrapper.classManagementManager.sistema_bloqueado)
                            }
                        }
                    }
                }

                onCerrarClicked: {
                    if (wrapper.managerPestanias.eliminarPestania(p_objPestania)) {
                        indexPestania = index
                        visualizandoPestania = listaPestanias.currentIndex === index
                        contenedor.children[index].destroy()
                        modelPestanias.remove(index)

                        if (visualizandoPestania) {
                            //Si es estaba visualizando la pestania
                            //if (contenedor.children.length > 0) {
                            if (indexPestania+1 <= listaPestanias.count) {
                                contenedor.children[indexPestania+1].opacity=1
                                contenedor.children[indexPestania+1].enabled=true
                            }
                            else {
                                contenedor.children[indexPestania-1].opacity=1
                                contenedor.children[indexPestania-1].enabled=true
                            }

                            if (!copiaDeEvaluacion)
                                mostrar_marca_de_agua_sistema_bloqueado(listaPestanias.currentItem.source != "qrc:/plugins/Activacion.qml" && wrapper.classManagementManager.sistema_bloqueado)

                            //}
                        }
                    }
                }
            }
        }
    }

    LineaSeparadora {
        id: separador
        anchors.top: recListaPestanias.bottom
        width: parent.width
        color: "#0D47A1"
    }

    Image {
        source: "qrc:/media/Media/DanzaSoftLogop.png"
        //source: "qrc:/media/Media/MarielaLogo.jpg"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: false
    }

    Item {
        id: contenedor
        anchors.top: separador.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true

        VistaInicial {
            anchors.fill: parent
        }
    }
}

