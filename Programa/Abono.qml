import QtQuick 2.0
import QtQuick.Dialogs 1.2
import com.mednet.WrapperClassManagement 1.0

/*
int m_id;
int m_id_cliente;
QDate m_fecha_vigente;
QDate m_fecha_vencimiento;
QString m_tipo;
int m_cantidad_clases;
int m_cantidad_restante;

20/05/2018
Estaba trabajando en una funcion para que reintegre el dinero del abono a un alumno si se elimininaba el abono.
Finalmente aborté el trabajo, dado que resulta complicado saber si debe o no reintegrarse el dinero.
Por ej, si compro un abono de $500 de forma accidental al alumno A, lo mas probable es que la cuenta de A este en $0,
ya que habra quedado como que A cargo saldo y luego se le debito dicho saldo por la compra del abono.
Si luego elimino el abono y se hace un reintegro, entonces A ahora pasaria a tener $500 a favor sin haber hecho nada.
El reintegro solo aplicaria si la compra se hizo debitando directamente del saldo de la cuenta del alumno.
Pero es complicado y costoso saberlo. De modo que se permitira eliminar un abono y se dejara que el usuario
arregle manualmente la cuenta del alumno si esta sufrio una modificacion importante.
*/

Rectangle {
    id: principal
    height: 116
    width: 300
    property variant record: null
    signal clicked;
    color: "#FBEFFB"
    property bool mostrarLeyendaDeVigentes : false
    property bool permitirEliminar : false

    Behavior on opacity {PropertyAnimation{}}

    onRecordChanged: {
        if (record !== null) {
            if (record.tipo === "Libre") {
                color = "#E6F8E0"
                lblCantidadClasesRestante.text = "L"
                lblTipo.text += "Libre"+"</i>"
                //lblCompradas.text += "-"+"</i>"
                lblCompradas.visible = false
                lblCantidad.text += "-"+"</i>"
                lblClasesTomadas.text += record.cantidad_comprada - record.cantidad_restante
                //lblRestante.text += "-"+"</i>"
                lblRestante.visible = false
                lblClasesTomadas.visible = true
            }
            else {
                lblCantidadClasesRestante.text = record.cantidad_restante
                lblTipo.text += "Normal"+"</i>"
                lblCompradas.text += record.cantidad_comprada+"</i>"
                lblCantidad.text += record.cantidad_clases+"</i>"
                lblRestante.text += record.cantidad_restante+"</i>"

                /*17/05/2018- Con la version 5.1 ya no tiene sentido lblCantidad. Se lo mantiene un momento por razones de compatibilidad
Desde la version 5.1 en adelante, siempre los nuevos abonos comprados tendran el mismo valor
en clases compradas y acreditadas. En versiones anteriores, uno podia comprar 4 clases pero se le
acreditaban 3 porque habia tomado una clase sin abono. Como desde la v5.1 ya no es posible tomar una
clase de adultos sin abono, jamas se presentara nuevamente un escenario donde las clases acreditadas
sean menores a las compradas. Por lo tanto, se oculta el lblCantidad pero para mantener compatibilidad
previa, se lo mostrara solo si se advierte un abono viejo cuya cantidad de clases acreditadas
y compradas difieran.
*/
                if (record.cantidad_comprada !== record.cantidad_clases){
                    lblCantidad.visible = true
                }
            }
            lblId.text += record.id+"</i>"
            lblValor.text += record.precio_abono
            lblCompra.text += Qt.formatDateTime(record.fecha_compra,"dd/MM/yyyy")+"</i>-"
            lblAlta.text += Qt.formatDate(record.fecha_vigente,"ddd dd/MM/yyyy")//+"</i>"
            lblVencimiento.text += Qt.formatDate(record.fecha_vencimiento,"ddd dd/MM/yyyy") + " (En " + wrapper.classManagementManager.obtenerDiferenciaDias(wrapper.classManagementManager.obtenerFecha(),record.fecha_vencimiento) + " día/s)"+"</i>"
            if (mostrarLeyendaDeVigentes) {
                var vigencia = wrapper.classManagementManager.obtenerDiferenciaDias(wrapper.classManagementManager.obtenerFecha(),record.fecha_vigente)
                if (vigencia <= 0) {
                    lblEstadoVigencia.text = "Vigente"
                }
                else {
                    lblEstadoVigencia.text = "Aun no vigente"
                    lblEstadoVigencia.color = "red"
                }
            }
        }
    }

    Rectangle {
        id: recEliminado
        anchors.fill: parent
        color: "transparent"
        visible: false
        z: 10

        Rectangle {
            anchors.fill: parent
            color: "yellow"
            z: 10
            opacity: recEliminado.visible ? 0.2 : 0

            Behavior on opacity {PropertyAnimation{}}
        }

        Text {
            id: lblEliminado
            font.family: "Segoe UI"
            style: Text.Outline
            color: "white"
            styleColor: "red"
            font.pixelSize: 16
            text: qsTrId("ELIMINADO")
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            rotation: -20
            opacity: recEliminado.visible ? 1 : 0
            z: 1

            Behavior on opacity {PropertyAnimation{}}
        }
    }

    WrapperClassManagement {
        id: wrapper
    }

    MessageDialog {
        id: messageDialog
        title: "Administración de abonos"
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            //
            if (wrapper.managerAbono.darDeBajaAbono(record.id)) {
                recEliminado.visible = true
                principal.enabled = false
                //DESTROY
            }
            else {
                messageDialogDos.open()
            }
        }
    }

    MessageDialog {
        id: messageDialogEliminarAbonoReintegrarDinero
        title: "Administración de abonos"
        text: {
            if (record.cantidad_clases === record.cantidad_restante){
                "Se dará de baja el abono Nº " + record.id + ".\n¿Desea reintegrar al alumno el valor del abono de $ " + record.precio_abono
            + "?\n\nsí\t\t= baja de abono + reintegro de dinero\nno\t\t= baja de abono\ncancelar\t= me arrepentí, no quiero hacer nada"
            }
            else {
                "Se dará de baja el abono Nº " + record.id + ".\nParece que el alumno ya ha tomado clases con este abono, así que: realmente desearía reintegrar al alumno el valor del abono de $ " + record.precio_abono
            + "?\n\nsí\t\t= baja de abono + reintegro de dinero\nno\t\t= baja de abono\ncancelar\t= me arrepentí, no quiero hacer nada"
            }
        }
        standardButtons: StandardButton.Yes | StandardButton.No | StandardButton.Cancel

        onYes: {

        }

        onNo: {
            //
            if (wrapper.managerAbono.darDeBajaAbono(record.id)) {
                recEliminado.visible = true
                principal.enabled = false
                //DESTROY
            }
            else {
                messageDialogDos.open()
            }
        }
    }

    MessageDialog {
        id: messageDialogDos
        title: "Administración de abonos"
        icon: StandardIcon.Critical
        text: qsTrId("Lamentablemente ha ocurrido un error al intentar eliminar el abono.\nIntente nuevamente más tarde.")
    }

    Rectangle {
        id: recBotonCerrar
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.rightMargin: 3
        height: 17
        width: 17
        anchors.margins: 5
        //radius: 5
        border.width: 1
        border.color: "grey"
        color: "red"
        opacity: 0
        enabled: permitirEliminar
        visible: enabled
        z: 1

        Behavior on opacity {PropertyAnimation{}}

        Text {
            id: lblCruz
            text: "x"
            x: 6
            y: 2
            opacity: 0.9
            font.pixelSize: 9
        }


        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                recBotonCerrar.opacity = 0.3
            }

            onExited: {
                recBotonCerrar.opacity = 0
            }

            onClicked: {
                if (record.cantidad_clases === record.cantidad_restante){
                    messageDialog.text = "¿Está seguro que desea dar de baja el abono Nº "+record.id+
"?\n\nImportante: no le reintegraremos el precio del abono al alumno.\nSi la compra del abono fue reciente y accidental, verifique desde el modulo de cuenta de alumno cuál era el crédito del alumno (Crédito Cuenta) antes de la Adquisición del Abono Adulto (el código debería ser 'AAA"+record.id+"') o si hubiera, preferentemente antes de la Carga de Saldo para pagar el Abono Adulto (código='CSAA"+record.id+"') y, en base a ello, haga los ajustes correspondientes."

                }else{
                    messageDialog.text = "Parece que el alumno ya ha tomado clases con este abono.\n¿Realmente desea dar de baja el abono Nº "+record.id+
"?\n\nImportante: no le reintegraremos el precio del abono al alumno.\nSi la compra del abono fue reciente y accidental, verifique desde el modulo de cuenta de alumno cuál era el crédito del alumno (Crédito Cuenta) antes de la Adquisición del Abono Adulto (el código debería ser 'AAA"+record.id+"') o si hubiera, preferentemente antes de la Carga de Saldo para pagar el Abono Adulto (código='CSAA"+record.id+"') y, en base a ello, haga los ajustes correspondientes."
                }

                    messageDialog.icon = StandardIcon.Question
                    messageDialog.open()
            }
        }
    }

    Text {
        id: lblEstadoVigencia
        font.family: "Segoe UI"
        style: Text.Outline
        styleColor: "grey"
        font.pixelSize: 14
        opacity: 0.3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        anchors.right: lblCantidadClasesRestante.left
        anchors.rightMargin: 3
        visible: mostrarLeyendaDeVigentes
    }

    Text {
        id: lblCantidadClasesRestante
        text: record !== null ? record.id : ""
        font.family: "Segoe UI"
        style: Text.Outline
        styleColor: "grey"
        font.pixelSize: 65
        opacity: 0.3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -13
        anchors.right: parent.right
        anchors.rightMargin: 3
    }

    Column {
        anchors.fill: parent
        anchors.leftMargin: 3

        Row {
            spacing: 3

            Text {
                id: lblId
                font.family: "Segoe UI"
                font.pixelSize: 14
                text: qsTrId("Número: <i>")
            }

            Text {
                id: lblTipo
                font.family: "Segoe UI"
                font.pixelSize: 14
                text: qsTrId("- Tipo: <i>")
            }
        }

        Row {
            Text {
                id: lblCompra
                font.family: "Segoe UI"
                font.pixelSize: 14
                text: qsTrId("Compra: <i>")
            }

            Text {
                id: lblAlta
                font.family: "Segoe UI"
                font.pixelSize: 14
                text: qsTrId("Alta: <i>")
            }
        }

        Text {
            id: lblVencimiento
            font.family: "Segoe UI"
            font.pixelSize: 14
            text: qsTrId("Vence: <i>")
        }

        Text {
            id: lblCompradas
            font.family: "Segoe UI"
            font.pixelSize: 14
            text: qsTrId("Clases compradas: <i>")
        }

        Text {
            id: lblClasesTomadas
            font.family: "Segoe UI"
            font.pixelSize: 14
            text: qsTrId("Clases ya tomadas: <i>")
            visible: false
        }

        Text {
            id: lblCantidad
            font.family: "Segoe UI"
            font.pixelSize: 14
            text: qsTrId("Clases acreditadas: <i>")
            visible: false
        }

        Text {
            id: lblRestante
            font.family: "Segoe UI"
            font.pixelSize: 14
            text: qsTrId("Clases restantes: <i>")
        }

        Text {
            id: lblValor
            font.family: "Segoe UI"
            font.pixelSize: 14
            text: qsTrId("Valor: $ <i>")
            visible: {
                if (record !== null){
                    record.precio_abono !== -1
                }
                else {
                    false
                }
            }
        }

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            recBotonCerrar.opacity = 0.3
        }

        onExited: {
            recBotonCerrar.opacity = 0
        }

        onClicked: {
            parent.clicked();
        }
    }
}
