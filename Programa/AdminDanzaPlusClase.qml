import QtQuick.Controls 1.4
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.0
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0
    enabled: false
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}
    property int textFieldHeight: 35
    property int textFieldPixelSize : 13
    property string textFieldFontFamily : "verdana"
    property color textFieldTextColor : "#585858"
    property bool cambiarNombreDeDanza : true

    property string dia1: "";
    property string dia2: "";
    property string dia3: "";
    property string dia4: "";
    property string dia5: "";
    property string dia6: "";
    property string dia7: "";
    property string dias: "";

    property color backColorSubtitles: "#FFE0B2"
    property bool retrievingClassInformation: false

    property int lastCurrentRowClase: -1

    property bool escuchandoSignal: false

    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted:
        pedirTodasLasDanzas()

    function pedirTodasLasDanzas() {
        escuchandoSignal = true
        wrapper.managerDanza.obtenerTodasLasDanzas()
        tablaClase.model = 0
    }

    function pedirTodasLasClases() {
        escuchandoSignal = true
        wrapper.managerClase.obtenerTodasLasClasesPorIdDanza(tablaDanza.model[tablaDanza.currentRow].id)
    }

    function limpiar() {
        dia1 = "0"
        dia2 = "0"
        dia3 = "0"
        dia4 = "0"
        dia5 = "0"
        dia6 = "0"
        dia7 = "0"
        dias = ""

        checkLunes.checked = false
        checkMartes.checked = false
        checkMiercoles.checked = false
        checkJueves.checked = false
        checkViernes.checked = false
        checkSabado.checked = false
        checkDomingo.checked = false

        //radioCategoriaMixta.checked = true
        //radioCualquierDia.checked = true
    }

    function actualizarDias(sin_especificar) {
        retrievingClassInformation = true
        if (sin_especificar)
            dias = "-1"
        else
            dias = dia1+dia2+dia3+dia4+dia5+dia6+dia7
        if (wrapper.managerClase.actualizarDiasClase(tablaClase.model[tablaClase.currentRow].id,dias)){
            lastCurrentRowClase = tablaClase.currentRow
            pedirTodasLasClases()
        }
    }

    MessageDialog {
        id: message
        icon: StandardIcon.Information
        title: qsTrId("Administración general")
    }

    Connections {
        target: parent.enabled ? wrapper.managerDanza : null
        ignoreUnknownSignals: true

        onSig_listaDanzas: {
            if (escuchandoSignal) {
                tablaDanza.model = arg
                tablaDanza.currentRow = -1
                tablaClase.model = 0
                tablaClase.currentRow = -1

                escuchandoSignal = false
            }

        }
    }

    Connections {
        target: parent.enabled ? wrapper.managerClase : null
        ignoreUnknownSignals: true

        onSig_listaClases: {
            if (escuchandoSignal) {
                retrievingClassInformation = true
                limpiar()
                tablaClase.model = arg
                if (lastCurrentRowClase !== -1){
                    tablaClase.currentRow = lastCurrentRowClase
                    tablaClase.selection.select(tablaClase.currentRow)
                    tablaClase.focus = true
                    lastCurrentRowClase = -1
                }
                else {
                    tablaClase.currentRow = 0
                }
                if (tablaClase.currentRow !== -1)
                    tablaClase.selection.select(tablaClase.currentRow)

                escuchandoSignal = false
            }

        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTrId("Actividades")
        icon: StandardIcon.Critical
        text: qsTrId("Ups! Algo no fue bien.")

        onAccepted: {
            close()
        }
    }

    MessageDialog {
        id: messageYesNoDanza
        title: "Dar de baja danza"
        icon: StandardIcon.Question
        standardButtons: StandardButton.Yes | StandardButton.No

        text: qsTrId("La actividad no se borrará sino que permanecerá completamente oculta \"para siempre\". Si borras una actividad por error, vas a poder recuperarla (junto a todas sus clases y registros de presente asociados), pero para tal recuperación, por ahora será necesario que te contactes con el autor del programa. ¿Estás seguro que querés dar de baja la actividad?")

        onYes: {
            wrapper.managerDanza.eliminarDanza(tablaDanza.model[tablaDanza.currentRow].id)
            pedirTodasLasDanzas()
        }
    }

    MessageDialog {
        id: messageYesNoClase
        title: "Dar de baja clase"
        standardButtons: StandardButton.Yes | StandardButton.No
        icon: StandardIcon.Question
        text: qsTrId("La clase no se borrará sino que permanecerá completamente oculta \"para siempre\". Si borras una clase por error, vas a poder recuperarla (junto a todos sus registros de presente asociados), pero para tal recuperación, por ahora será necesario que te contactes con el autor del programa. ¿Estás seguro que querés dar de baja la clase?")

        onYes: {
            wrapper.managerClase.eliminarClase(tablaClase.model[tablaClase.currentRow].id)

            pedirTodasLasClases()
        }
    }

    InputDialog {
        id: inputDialog
        z: 10

        onTextoIngresado: {
            if (cambiarNombreDeDanza) {
                if (wrapper.managerDanza.cambiarNombreDanza(tablaDanza.model[tablaDanza.currentRow].id,arg)) {
                    pedirTodasLasDanzas()
                }
                else {
                    messageDialog.open()
                }
            }
            else {
                if (wrapper.managerClase.cambiarNombreClase(tablaClase.model[tablaClase.currentRow].id,arg)) {
                    pedirTodasLasClases()
                }
                else {
                    messageDialog.open()
                }
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 2
        spacing: 10

        Row {
            spacing: 10

            TextField {
                placeholderText: qsTrId("Nueva actividad... Ejemplo: 'Ballet'")
                height: textFieldHeight
                width: tablaDanza.width - 70
                font.pixelSize: textFieldPixelSize
                font.family: textFieldFontFamily
                focus: true
                textColor: textFieldTextColor
                property bool validado : false

                onAccepted: {
                    if (text.length > 0)
                        if (wrapper.managerDanza.agregarDanza(text)) {
                            pedirTodasLasDanzas()
                            text = ""
                        }
                }
            }

            Row {
                height: 30
                z: 2

                ToolButton {
                    iconSource: "qrc:/media/Media/actualizar_blanco_negro.png"
                    opacity: 0.8
                    enabled: tablaDanza.currentRow !== -1

                    onClicked: {
                        message.icon = StandardIcon.Warning
                        message.text = "¡Cuidado!\n¡No se guarda un registro histórico con los distintos nombres! Se cauto con los cambios de nombre. NORMALMENTE NO DEBERÍAS TENER QUE CAMBIARLOS (ejemplo: la actividad 'Ballet Clásico' o la actividad 'Inglés', muy difícilmente dejen de llamarse así), aunque si fuera el caso, dichos cambios de nombre deberían ser PEQUEÑOS y LÓGICOS (siguiendo con el ejemplo anterior, quizás ahora quieras llamar a la actividad 'Danza Clásica' en lugar de 'Ballet Clásico', o bien, 'English' en lugar de 'Inglés'). Recordá que probablemente ya se registraron muchos presentes asociados a la actividad. Si la misma se llamaba \"Ballet\" y querés cambiarle el nombre a \"Pastelería\", lo que en realidad tenés que hacer es crear una nueva actividad con el nombre \"Pastelería\"."
                        message.open()
                        inputDialog.strMensaje = "Cambiar nombre de actividad seleccionada"
                        inputDialog.visible = true
                        inputDialog.strTxtFieldText = tablaDanza.model[tablaDanza.currentRow].nombre
                        cambiarNombreDeDanza = true
                    }
                }

                ToolButton {
                    iconSource: "qrc:/media/Media/salir.png"
                    opacity: 0.8
                    enabled: tablaDanza.currentRow !== -1

                    onClicked: {
                        message.text = "¡Antes de dar de baja una actividad, primero tenés que dar de baja todas sus clases!"
                        message.icon = StandardIcon.Information
                        if (tablaClase.rowCount > 0)
                            message.open()
                        else
                            messageYesNoDanza.open()
                    }
                }
            }
        }

        TableView {
            id: tablaDanza
            width: parent.width
            height: 100

            TableViewColumn {
                role: "nombre"
                title: "ACTIVIDADES QUE ENSEÑAMOS"
            }

            onCurrentRowChanged: {
                if (currentRow !== -1) {
                    retrievingClassInformation = true
                    limpiar()
                    pedirTodasLasClases()
                }
            }
        }

        Row {
            spacing: 10

            TextField {
                placeholderText: {
                    if (tablaDanza.currentRow !== -1)
                        "Nueva clase de " + tablaDanza.model[tablaDanza.currentRow].nombre + "... Ejemplo: 'Principiante' o 'Principiante. Profe Mariela'"
                    else
                        "Nueva clase... Ejemplo: 'Principiante' o 'Principiante. Profe Mariela'"
                }
                height: textFieldHeight
                width: tablaDanza.width - 70
                font.pixelSize: textFieldPixelSize
                font.family: textFieldFontFamily
                focus: true
                textColor: textFieldTextColor
                enabled: tablaDanza.currentRow !== -1

                onAccepted: {
                    if (text.length > 0)
                        if (wrapper.managerClase.agregarClase(tablaDanza.model[tablaDanza.currentRow].id,text)) {
                            pedirTodasLasClases()
                            text = ""
                        }
                        else {
                            messageDialog.open()
                        }
                }
            }

            Row {
                height: 30
                z: 2

                ToolButton {
                    iconSource: "qrc:/media/Media/actualizar_blanco_negro.png"
                    enabled: tablaClase.currentRow !== -1
                    opacity: 0.8

                    onClicked: {
                        message.icon = StandardIcon.Warning
                        message.text = "¡Cuidado!\n¡No se guarda un registro histórico con los distintos nombres! Se cauto con los cambios de nombre. NORMALMENTE NO DEBERÍAS TENER QUE CAMBIARLOS (ejemplo: la clase 'Principiantes' difícilmente deje de llamarse así), aunque si fuera el caso, dichos cambios de nombre deberían ser PEQUEÑOS y LÓGICOS (siguiendo con el ejemplo anterior, quizás ahora quieras llamar a la clase 'Nivel Básico' en lugar de 'Principiantes'). Recordá que probablemente ya se registraron muchos presentes asociados a la clase. Si la misma se llamaba \"Principiantes\" y querés cambiarle el nombre a \"Puntas\", lo que en realidad tenés que hacer es crear una nueva clase con el nombre \"Puntas\"."
                        message.open()
                        inputDialog.strMensaje = "Cambiar nombre de clase seleccionada"
                        inputDialog.visible = true
                        inputDialog.strTxtFieldText = tablaClase.model[tablaClase.currentRow].nombre
                        cambiarNombreDeDanza = false
                    }
                }

                ToolButton {
                    iconSource: "qrc:/media/Media/salir.png"
                    enabled: tablaClase.currentRow !== -1
                    opacity: 0.8

                    onClicked: {
                        messageYesNoClase.open()
                    }
                }
            }
        }

        TableView {
            id: tablaClase
            width: parent.width
            height: 100
            property string aux: ""

            TableViewColumn {
                role: "nombre"
                title: "CLASES DE LA ACTIVIDAD SELECCIONADA"
            }

            onCurrentRowChanged: {
                if (currentRow != -1) {
                    aux = ""
                    retrievingClassInformation = true
                    limpiar()

                    var clase_seleccionada = model[currentRow]

                    if (clase_seleccionada.categoria === "Kids"){
                        radioSoloNinios.checked = true
                    }
                    else if (clase_seleccionada.categoria === "Adults"){
                        radioSoloAdultos.checked = true
                    }
                    else if (clase_seleccionada.categoria === "KidsAdults"){
                        radioCategoriaMixta.checked = true
                    }

                    if (clase_seleccionada.dias_semana === "-1"){
                        radioCualquierDia.checked = true
                    }
                    else {
                        radioSiguientesDias.checked = true

                        dias = clase_seleccionada.dias_semana

                        checkLunes.checked = dias.search("1") !== -1
                        checkMartes.checked = dias.search("2") !== -1
                        checkMiercoles.checked = dias.search("3") !== -1
                        checkJueves.checked = dias.search("4") !== -1
                        checkViernes.checked = dias.search("5") !== -1
                        checkSabado.checked = dias.search("6") !== -1
                        checkDomingo.checked = dias.search("7") !== -1


                    }

                    retrievingClassInformation = false
                }
            }

            /*
            onCurrentRowChanged: {
                if (currentRow != -1) {
                    recordClienteSeleccionado = model[currentRow]
                    wrapper.classManagementGestionDeAlumnos.recordAlumnoSeleccionado = model[currentRow]
                }
            }
*/
        }

        Rectangle {
            height: 29
            width: parent.width
            color: backColorSubtitles

            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.family: "verdana";
                font.pixelSize: 14
                text: tablaClase.model.length > 0 ? "Más información sobre la clase " + tablaClase.model[tablaClase.currentRow].nombre + " de " + tablaDanza.model[tablaDanza.currentRow].nombre : "Más información sobre la clase"
            }
        }

        Rectangle {
            height: 29
            width: parent.width
            color: "transparent"

            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                font.family: "verdana";
                font.pixelSize: 12
                text: "Brindando la siguiente información, podremos luego mostrarle solamente las clases que un alumno puede tomar en lugar de todas, dependiendo si el presente se registra desde el modulo de niños o adultos."
            }
        }

        Row {
            spacing: 5
            enabled: tablaClase.currentRow !== -1 && tablaClase.model.length > 0

            RadioButton {
                id: radioSoloNinios
                text: "Pueden asistir únicamente niños"
                exclusiveGroup: groupCategoriaClase
                y: 12

                onCheckedChanged: {
                    if (checked) {
                        if (!retrievingClassInformation) {
                            retrievingClassInformation = true
                            if (wrapper.managerClase.actualizarCategoriaClase(tablaClase.model[tablaClase.currentRow].id,1)) {

                                lastCurrentRowClase = tablaClase.currentRow
                                pedirTodasLasClases()
                            }
                        }
                    }
                }
            }

            Image {
                source: "qrc:/media/Media/niños.PNG"
                width: 32
                fillMode: Image.PreserveAspectFit
            }

            RadioButton {
                id: radioSoloAdultos
                text: "Pueden asistir únicamente adultos"
                exclusiveGroup: groupCategoriaClase
                y: 12

                onCheckedChanged: {
                    if (checked) {
                        if (!retrievingClassInformation) {
                            retrievingClassInformation = true
                            if (wrapper.managerClase.actualizarCategoriaClase(tablaClase.model[tablaClase.currentRow].id,2)){

                                lastCurrentRowClase = tablaClase.currentRow
                                pedirTodasLasClases()
                            }
                        }
                    }
                }
            }

            Image {
                source: "qrc:/media/Media/adultos.PNG"
                width: 56
                fillMode: Image.PreserveAspectFit
            }

            RadioButton {
                id: radioCategoriaMixta
                text: "Pueden asistir tanto niños como adultos"
                exclusiveGroup: groupCategoriaClase
                checked: true
                y: 12

                onCheckedChanged: {
                    if (checked) {
                        if (!retrievingClassInformation) {
                            retrievingClassInformation = true
                            if (wrapper.managerClase.actualizarCategoriaClase(tablaClase.model[tablaClase.currentRow].id,3)){

                                lastCurrentRowClase = tablaClase.currentRow
                                pedirTodasLasClases()
                            }
                        }
                    }
                }
            }

            Image {
                source: "qrc:/media/Media/niños.PNG"
                width: 32
                fillMode: Image.PreserveAspectFit
            }

            Image {
                source: "qrc:/media/Media/adultos.PNG"
                width: 56
                fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            height: 29
            width: parent.width
            color: backColorSubtitles

            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.family: "verdana";
                font.pixelSize: 14
                text: "Días de clase"
            }
        }

        RadioButton {
            id: radioCualquierDia
            enabled: tablaClase.currentRow !== -1 && tablaClase.model.length > 0
            text: "No especificar (si no se especifica, la clase estará disponible para recibir presentes cualquier día de la semana)"
            checked: true
            exclusiveGroup: groupDiasClase

            onCheckedChanged: {
                if (checked){
                    if (!retrievingClassInformation) {
                        actualizarDias(1)
                    }
                }
            }
        }

        Row {
            spacing: 10
            enabled: tablaClase.currentRow !== -1 && tablaClase.model.length > 0

            RadioButton {
                id: radioSiguientesDias
                text: "Los siguientes días:"
                exclusiveGroup: groupDiasClase

                onCheckedChanged: {
                    if (checked){
                        if (!retrievingClassInformation) {
                            actualizarDias(0)
                        }
                    }
                }
            }

            CheckBox {
                id: checkLunes
                text: "Lunes"
                enabled: radioSiguientesDias.checked

                onCheckedChanged: {

                    if (checked){
                        dia1 = "1"
                    }else{
                        dia1 = "0"
                    }

                    if (!retrievingClassInformation) {
                        actualizarDias(0)
                    }
                }
            }

            CheckBox {
                id: checkMartes
                text: "Martes"
                enabled: radioSiguientesDias.checked

                onCheckedChanged: {
                    if (checked){
                        dia2 = "2"
                    }else{
                        dia2 = "0"
                    }

                    if (!retrievingClassInformation) {
                        actualizarDias(0)
                    }
                }
            }
            CheckBox {
                id: checkMiercoles
                text: "Miércoles"
                enabled: radioSiguientesDias.checked

                onCheckedChanged: {
                    if (checked){
                        dia3 = "3"
                    }else{
                        dia3 = "0"
                    }

                    if (!retrievingClassInformation) {
                        actualizarDias(0)
                    }
                }
            }
            CheckBox {
                id: checkJueves
                text: "Jueves"
                enabled: radioSiguientesDias.checked

                onCheckedChanged: {
                    if (checked){
                        dia4 = "4"
                    }else{
                        dia4 = "0"
                    }

                    if (!retrievingClassInformation) {
                        actualizarDias(0)
                    }
                }
            }
            CheckBox {
                id: checkViernes
                text: "Viernes"
                enabled: radioSiguientesDias.checked

                onCheckedChanged: {
                    if (checked){
                        dia5 = "5"
                    }else{
                        dia5 = "0"
                    }

                    if (!retrievingClassInformation) {
                        actualizarDias(0)
                    }
                }
            }
            CheckBox {
                id: checkSabado
                text: "Sábado"
                enabled: radioSiguientesDias.checked

                onCheckedChanged: {
                    if (checked){
                        dia6 = "6"
                    }else{
                        dia6 = "0"
                    }

                    if (!retrievingClassInformation) {
                        actualizarDias(0)
                    }
                }
            }
            CheckBox {
                id: checkDomingo
                text: "Domingo"
                enabled: radioSiguientesDias.checked

                onCheckedChanged: {
                    if (checked){
                        dia7 = "7"
                    }else{
                        dia7 = "0"
                    }

                    if (!retrievingClassInformation) {
                        actualizarDias(0)
                    }
                }
            }
        }
    }

    ExclusiveGroup {
        id: groupCategoriaClase
    }

    ExclusiveGroup {
        id: groupDiasClase
    }
}

