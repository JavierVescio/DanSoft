import QtQuick.Controls 1.4
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import com.mednet.CuentaAlumno 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.2
import QtCharts 2.2
import com.mednet.EstadoAlumno 1.0

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}

    property color backColorSubtitles: "#C8E6C9"
    property color colorSubtitles: "black"

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null

    property string fechaInicial: ""; property string fechaFinal: ""
    property int duracionDeAbono : 30

    property bool quieroLaFechaInicial : true
    property bool fechaPersonalizada: false

    property int textFieldHeight: 28
    property int textFieldPixelSize : 15
    property string textFieldFontFamily : "verdana"
    property color textFieldTextColor : "#585858"


    property int total_presentes: 0
    property int porcentaje_presentes_adultos: 0
    property int porcentaje_presentes_infantiles: 0

    property int total_abonos: 0
    property int porcentaje_abonos_adultos: 0
    property int porcentaje_abonos_infantiles: 0

    property variant record_ultima_caja: null

    property string strDate : ""

    property string strFechaInicioCaja : ""
    property real caja_inicial : 0
    property real caja_final : 0
    property string strResultadoCaja
    property string strFechaCierreCaja
    property string strEstadoCaja
    property string strComentario

    property real totalDeuda: 0
    property real totalDeudaHoy: 0
    property real totalFavor: 0
    property real totalFavorHoy: 0

    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: {
        wrapper.managerDanza.obtenerTodasLasDanzas()
        strDate = Qt.formatDateTime(wrapper.classManagementManager.obtenerFechaHora(),"dddd dd/MM/yyyy")
        record_ultima_caja = wrapper.managerCaja.traer_ultima_caja()
        recCaja.visible = false
        console.debug("recodCaja: " + record_ultima_caja)
        if (record_ultima_caja !== null){
            strFechaInicioCaja = Qt.formatDateTime(record_ultima_caja.fecha_inicio,"dddd dd/MM HH:mm")+"hs."
            caja_inicial = record_ultima_caja.monto_inicial
            strEstadoCaja = record_ultima_caja.estado
            strComentario = record_ultima_caja.comentario
            recCaja.visible = true
            lblFechaCierreCaja.visible = false
            lblResultadoCaja.visible = false
            lblCajaFinal.visible = false
            if (record_ultima_caja.estado == "Cerrada"){
                lblFechaCierreCaja.visible = true
                lblResultadoCaja.visible = true
                lblCajaFinal.visible = true
                strFechaCierreCaja = Qt.formatDateTime(record_ultima_caja.fecha_cierre,"dddd dd/MM HH:mm")+"hs."
                caja_final = record_ultima_caja.monto_final
                if (record_ultima_caja.diferencia_monto > 0){
                    strResultadoCaja = "Faltarían $ " + record_ultima_caja.diferencia_monto
                }else if (record_ultima_caja.diferencia_monto == 0){
                    strResultadoCaja = "Excelente"
                }else{
                    strResultadoCaja = "Sobran $ " + (record_ultima_caja.diferencia_monto)*-1
                }
                if (wrapper.classManagementManager.obtenerDiferenciaDias(record_ultima_caja.fecha_cierre) !=0){
                    recCaja.visible = false
                }
            }
        }

        listViewDeudoresHoy.model = 0
        listViewDeudoresHoy.model = wrapper.managerEstadisticas.obtenerAlumnosDeudoresDeHoy()


        listViewDeudores.model = 0
        listViewDeudores.model = wrapper.managerEstadisticas.obtenerAlumnosDeudores()

        listViewMerecedoresHoy.model = 0
        listViewMerecedoresHoy.model = wrapper.managerEstadisticas.obtenerAlumnosMerecedoresDeHoy()

        listViewMerecedores.model = 0
        listViewMerecedores.model = wrapper.managerEstadisticas.obtenerAlumnosMerecedores()

        totalDeuda = wrapper.managerEstadisticas.obtenerTotalDeuda()
        totalDeudaHoy = wrapper.managerEstadisticas.obtenerTotalDeudaHoy()
        totalFavor = wrapper.managerEstadisticas.obtenerFavor()
        totalFavorHoy = wrapper.managerEstadisticas.obtenerFavorHoy()

    }

    function calcularDuracionDeAbono() {
        var dateInicial = wrapper.classManagementManager.obtenerFecha(fechaInicial)
        var dateFinal = wrapper.classManagementManager.obtenerFecha(fechaFinal)
        duracionDeAbono = wrapper.classManagementManager.obtenerDiferenciaDias(dateInicial,dateFinal)
    }

    ListModel {
        id: modelDanzas
    }

    ListModel {
        id: modelClases
    }

    Connections {
        target: parent.enabled ? wrapper.managerDanza : null
        ignoreUnknownSignals: true

        onSig_listaDanzas:{
            //arg
            modelDanzas.clear()
            var x
            for(x=0;x<arg.length;x++){
                modelDanzas.append({"id": arg[x].id, "text":arg[x].nombre})
            }
            comboActividad.model = modelDanzas
        }
    }

    Connections {
        target: parent.enabled ? wrapper.managerClase : null
        ignoreUnknownSignals: true

        onSig_listaClases: {
            console.debug("arg: " + arg)
            modelClases.clear()
            var x
            for(x=0;x<arg.length;x++){
                modelClases.append({"id": arg[x].id, "text":arg[x].nombre})
            }
            comboClase.model = modelClases
            comboClase.currentIndex = -1
        }
    }

    Calendar {
        id: calendar
        visible: false

        onClicked: {
            if (quieroLaFechaInicial){
                txtFechaInicial.text = Qt.formatDate(date, "dd/MM/yyyy")
            }
            else{
                txtFechaFinal.text = Qt.formatDate(date, "dd/MM/yyyy")
            }
            visible = false
        }
    }

    function cargar_vista() {
        graphLinePresentesAdultos.clear()
        graphLinePresentesInfantiles.clear()
        graphLineCantidadAlumnosAlta.clear()
        graphLineCantidadAlumnosBaja.clear()
        graphLineAbonosAdultos.clear()
        graphLineAbonosInfantiles.clear()

        var currentIndex = comboFecha.currentIndex

        if (cbItems.get(currentIndex).valor == -1){
            fechaPersonalizada = true
        }
        else {
            fechaPersonalizada = false

            var x;
            var listaPresentesAdultos, listaPresentesInfantiles

            while(categoriaX.count>0){
                categoriaX.remove(categoriaX.categoriesLabels[0])
            }
            while(categoriaXalumnosalta.count>0){
                categoriaXalumnosalta.remove(categoriaXalumnosalta.categoriesLabels[0])
            }
            while(categoriaXabonos.count>0){
                categoriaXabonos.remove(categoriaXabonos.categoriesLabels[0])
            }


            listaPresentesAdultos = wrapper.managerEstadisticas.obtenerCantidadPresentesAdultos(cbItems.get(currentIndex).valor)
            yAxis.min = 0
            yAxis.max = wrapper.managerEstadisticas.obtenerMaximo_presentes_adultos();

            categoriaX.min = 0
            categoriaX.max = listaPresentesAdultos.length-1
            categoriaXalumnosalta.min = 0
            categoriaXalumnosalta.max = listaPresentesAdultos.length-1
            categoriaXabonos.min = 0
            categoriaXabonos.max = listaPresentesAdultos.length-1

            for (x=0;x<listaPresentesAdultos.length;x++){
                graphLinePresentesAdultos.append(x,listaPresentesAdultos[x].valor)
                categoriaX.append(listaPresentesAdultos[x].nombre,x)
                categoriaXalumnosalta.append(listaPresentesAdultos[x].nombre,x)
                categoriaXabonos.append(listaPresentesAdultos[x].nombre,x)
            }

            graphLinePresentesAdultos.name = "Adultos ("+wrapper.managerEstadisticas.obtenerTotal_presentes_adultos()+")"

            listaPresentesInfantiles = wrapper.managerEstadisticas.obtenerCantidadPresentesInfantiles(cbItems.get(currentIndex).valor)
            yAxis.min = 0
            if (yAxis.max < wrapper.managerEstadisticas.obtenerMaximo_presentes_infantiles())
                yAxis.max = wrapper.managerEstadisticas.obtenerMaximo_presentes_infantiles();

            for (x=0;x<listaPresentesInfantiles.length;x++){
                graphLinePresentesInfantiles.append(x,listaPresentesInfantiles[x].valor)
                //categoriaX.append(listaPresentesInfantiles[x].nombre,x)
            }
            graphLinePresentesInfantiles.name = "Infantiles ("+wrapper.managerEstadisticas.obtenerTotal_presentes_infantiles()+")"


            yAxis.applyNiceNumbers()

            piePresentes.clear()

            total_presentes = wrapper.managerEstadisticas.obtenerTotal_presentes_adultos()+wrapper.managerEstadisticas.obtenerTotal_presentes_infantiles()
            chartCantidadPresentes.title = "Cantidad presentes registrados ("+total_presentes+")"
            if (total_presentes !=0){
                porcentaje_presentes_adultos = wrapper.managerEstadisticas.obtenerTotal_presentes_adultos()/total_presentes*100
                porcentaje_presentes_infantiles = wrapper.managerEstadisticas.obtenerTotal_presentes_infantiles()/total_presentes*100
            }else{
                porcentaje_presentes_adultos = 0
                porcentaje_presentes_infantiles = 0
            }

            piePresentes.append("Adultos "+porcentaje_presentes_adultos+"%",wrapper.managerEstadisticas.obtenerTotal_presentes_adultos())
            piePresentes.append("Infantiles "+porcentaje_presentes_infantiles+"%",wrapper.managerEstadisticas.obtenerTotal_presentes_infantiles())
            piePresentes.at(0).color = "blue";
            piePresentes.at(1).color = "red";
            if (total_presentes !=0){
                piePresentes.at(0).labelVisible = true
                piePresentes.at(1).labelVisible = true
            }



            var listaCantidadAlumnosAlta = wrapper.managerEstadisticas.obtenerCantidadAlumnos(true,cbItems.get(currentIndex).valor)
            yAxisAlumnos.min = 0
            yAxisAlumnos.max = wrapper.managerEstadisticas.obtenerMaximoCantidadAlumnosDelMes()

            for (x=0;x<listaCantidadAlumnosAlta.length;x++){
                graphLineCantidadAlumnosAlta.append(x,listaCantidadAlumnosAlta[x].valor)
            }
            var cantidadAlta = wrapper.managerEstadisticas.obtenerCantidadAlumnos()
            graphLineCantidadAlumnosAlta.name = "Alta ("+cantidadAlta+")"


            var listaCantidadAlumnosBaja = wrapper.managerEstadisticas.obtenerCantidadAlumnos(false,cbItems.get(currentIndex).valor)
            if (wrapper.managerEstadisticas.obtenerMaximoCantidadAlumnosDelMes()>yAxisAlumnos.max){
                yAxisAlumnos.max = wrapper.managerEstadisticas.obtenerMaximoCantidadAlumnosDelMes()
            }

            for (x=0;x<listaCantidadAlumnosBaja.length;x++){
                graphLineCantidadAlumnosBaja.append(x,listaCantidadAlumnosBaja[x].valor)
            }
            var cantidadBaja = wrapper.managerEstadisticas.obtenerCantidadAlumnos()
            graphLineCantidadAlumnosBaja.name = "Baja ("+cantidadBaja+")"

            chartCantidadAlumnos.title = "Cantidad alumnos registrados ("+(cantidadAlta-cantidadBaja)+")"



            var listaCantidadAbonosAdultos = wrapper.managerEstadisticas.obtenerCantidadAbonosAdultos(cbItems.get(currentIndex).valor)
            yAxisCantidadAbonos.min = 0
            yAxisCantidadAbonos.max = wrapper.managerEstadisticas.obtenerMaximoAbonosAdultosDelMes()

            for (x=0;x<listaCantidadAbonosAdultos.length;x++){
                graphLineAbonosAdultos.append(x,listaCantidadAbonosAdultos[x].valor)
            }
            graphLineAbonosAdultos.name = "Adultos ("+wrapper.managerEstadisticas.obtenerTotalAbonosAdultos()+")"


            var listaCantidadAbonosInfantiles = wrapper.managerEstadisticas.obtenerCantidadAbonosInfantiles(cbItems.get(currentIndex).valor)
            if (wrapper.managerEstadisticas.obtenerMaximoAbonosInfantilesDelMes()>yAxisCantidadAbonos.max){
                yAxisCantidadAbonos.max = wrapper.managerEstadisticas.obtenerMaximoAbonosInfantilesDelMes()
            }

            for (x=0;x<listaCantidadAbonosInfantiles.length;x++){
                graphLineAbonosInfantiles.append(x,listaCantidadAbonosInfantiles[x].valor)
            }
            graphLineAbonosInfantiles.name = "Infantiles ("+wrapper.managerEstadisticas.obtenerTotalAbonosInfantiles()+")"


            total_abonos = wrapper.managerEstadisticas.obtenerTotalAbonosInfantiles()+wrapper.managerEstadisticas.obtenerTotalAbonosAdultos()
            chartCantidadAbonos.title = "Cantidad abonos vendidos ("+total_abonos+")"
            if (total_abonos !=0){
                porcentaje_abonos_adultos = wrapper.managerEstadisticas.obtenerTotalAbonosAdultos()/total_abonos*100
                porcentaje_abonos_infantiles = wrapper.managerEstadisticas.obtenerTotalAbonosInfantiles()/total_abonos*100
            }else{
                porcentaje_abonos_adultos = 0
                porcentaje_abonos_infantiles = 0
            }

            pieAbonos.clear()
            pieAbonos.append("Adultos "+porcentaje_abonos_adultos+"%",wrapper.managerEstadisticas.obtenerTotalAbonosAdultos())
            pieAbonos.append("Infantiles "+porcentaje_abonos_infantiles+"%",wrapper.managerEstadisticas.obtenerTotalAbonosInfantiles())
            pieAbonos.at(0).color = "blue";
            pieAbonos.at(1).color = "red";
            if (total_abonos !=0){
                pieAbonos.at(0).labelVisible = true
                pieAbonos.at(1).labelVisible = true
            }


            yAxis.applyNiceNumbers()
            yAxisAlumnos.applyNiceNumbers()
            yAxisCantidadAbonos.applyNiceNumbers()
        }
    }


    Rectangle { ////Fecha
        id: recFechas
        height: 30
        anchors{
            top:parent.top
            topMargin: 3
            left: parent.left
            leftMargin: 3
            right:parent.right
            rightMargin: 3
        }
        color: "transparent"
        radius: 3
        //border.color: "grey"
        z: 1

        Row {
            anchors{   fill: parent;  }
            spacing: 5

            ComboBox {
                id: comboFecha
                height: 28
                width: 120
                model: ListModel {
                    id: cbItems
                    ListElement { text: "Hoy"; valor: 0}
                    ListElement { text: "Ayer"; valor: 1 }
                    ListElement { text: "Últimos 7 días"; valor: 7}
                    ListElement { text: "Últimos 14 días"; valor: 14}
                    ListElement { text: "Últimos 28 días"; valor: 28}
                    ListElement { text: "Últimos 30 días"; valor: 30}
                    ListElement { text: "Últimos 3 meses"; valor: 90}
                    ListElement { text: "Últimos 6 meses"; valor: 180}
                    ListElement { text: "Último año"; valor: 365}
                    //ListElement { text: "Personalizado"; valor: -1}
                }

                onCurrentIndexChanged: {
                    cargar_vista()
                }

            }

            TextField {
                id: txtFechaInicial
                inputMask: "00/00/0000;_"
                maximumLength: 10
                height: textFieldHeight
                font.pixelSize: textFieldPixelSize
                font.family: textFieldFontFamily
                width: 110
                enabled: fechaPersonalizada
                visible: enabled


                property string lastDate

                onTextChanged:  {
                    fechaInicial = text
                    calcularDuracionDeAbono()
                }
            }

            Button {
                width: 30
                height: width
                enabled: fechaPersonalizada
                visible: enabled

                Image {
                    anchors{    fill: parent;       margins: 3 }
                    source: "qrc:/media/Media/calendar.png"
                }

                onClicked: {
                    quieroLaFechaInicial = true
                    calendar.x = 222
                    calendar.y = 35
                    calendar.visible = !calendar.visible
                }
            }

            /*Text {
                y: 5
                font.family: "verdana";
                font.pixelSize: 14
                text: qsTrId("Fecha final")
            }*/

            TextField {
                id: txtFechaFinal
                inputMask: "00/00/0000;_"
                maximumLength: 10
                height: textFieldHeight
                font.pixelSize: textFieldPixelSize
                font.family: textFieldFontFamily
                width: 110
                enabled: fechaPersonalizada
                visible: enabled

                onTextChanged:  {
                    fechaFinal = text
                    calcularDuracionDeAbono()
                }
            }

            Button {
                width: 30
                height: width
                enabled: fechaPersonalizada
                visible: enabled

                Image {
                    anchors{    fill: parent;       margins: 3 }
                    source: "qrc:/media/Media/calendar.png"
                }

                onClicked: {
                    quieroLaFechaInicial = false
                    calendar.x = 450
                    calendar.y = 35
                    calendar.visible = !calendar.visible
                }
            }

            Button {
                text: ""
                width: 30
                height: width
                y: -1
                iconSource: "qrc:/media/Media/foto.png"

                property string dir1: ""
                property string dir2: ""
                onClicked: {
                    dir1 = ""
                    dir2 = ""
                    var recordBackUp = wrapper.gestionBaseDeDatos.traerInfoBackUp()
                    if (recordBackUp === null)
                        wrapper.classManagementManager.captureQml(columnaDatos)
                    else{
                        dir1 = recordBackUp.ruta1
                        dir2 = recordBackUp.ruta2

                        if (dir1.length == 0 && dir2.length == 0)
                            wrapper.classManagementManager.captureQml(columnaDatos)
                        else{
                            if (dir1.length > 0)
                                wrapper.classManagementManager.captureQml(columnaDatos, dir1)
                            if (dir2.length > 0)
                                wrapper.classManagementManager.captureQml(columnaDatos, dir2)
                        }



                    }
                }
            }
        }
    } //////////////Fecha

    LineaSeparadora {
        id: lineaSeparadora
        anchors.top: recFechas.bottom
        anchors.topMargin: 1
        width: flickDatos.width
        height: 1
    }

    ScrollView {
        id: scroll
        contentItem: flickDatos
        anchors.top: lineaSeparadora.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: -1
        anchors.rightMargin: 0
        anchors.bottomMargin: 10
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
            //spacing: 10
            enabled: true
            z: 1
            property int separacionIzquierda: 3

            Rectangle {
                height: 20
                width: 800

                Text {
                    x: columnaDatos.separacionIzquierda *3
                    font.family: "verdana";
                    font.pixelSize: 14
                    text: strDate
                }
            }


            Rectangle {
                id: recCaja
                height: 200
                width: 800
                visible: false
                color: "white"

                Column {
                    anchors.fill: parent
                    anchors.topMargin: 3

                    Image {
                        height: 50
                        fillMode: Image.PreserveAspectFit
                        opacity: 0.7
                        x: columnaDatos.separacionIzquierda *3
                        source: "qrc:/media/Media/icon-calculadora.png"
                    }

                    Text {
                        id: lblFechaInicioCaja
                        text: "Fecha inicio: \t" + strFechaInicioCaja
                        font.family: "verdana";
                        font.pixelSize: 14
                        y: 5
                        x: columnaDatos.separacionIzquierda *3
                    }

                    Text {
                        id: lblCajaInicial
                        text: "Caja inicial: \t$ " + caja_inicial
                        font.family: "verdana";
                        font.pixelSize: 14
                        x: columnaDatos.separacionIzquierda *3
                    }

                    Text {
                        id: lblCajaFinal
                        text: "Caja final:   \t$ " + caja_final
                        font.family: "verdana";
                        font.pixelSize: 14
                        x: columnaDatos.separacionIzquierda *3
                    }

                    Text {
                        id: lblResultadoCaja
                        text: "Resultado: \t" + strResultadoCaja
                        font.family: "verdana";
                        font.pixelSize: 14
                        x: columnaDatos.separacionIzquierda *3
                    }

                    Text {
                        id: lblFechaCierreCaja
                        text: "Fecha cierre: \t" + strFechaCierreCaja
                        font.family: "verdana";
                        font.pixelSize: 14
                        x: columnaDatos.separacionIzquierda *3
                    }

                    Text {
                        id: lblComentario
                        height: 45
                        width: 450
                        text: "Comentario: \t" + strComentario
                        font.family: "verdana";
                        font.pixelSize: 14
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        x: columnaDatos.separacionIzquierda *3
                    }

                    Text {
                        id: lblEstadoCaja
                        text: "Estado caja: \t" + strEstadoCaja
                        font.family: "verdana";
                        font.pixelSize: 14
                        x: columnaDatos.separacionIzquierda *3
                    }

                }
            }


            LineaSeparadora {
                visible: recCaja.visible
                width: 800
            }

            Rectangle {
                height: 320
                width: 800

                Column {
                    spacing: 10
                    y: 3

                    Image {
                        height: 50
                        fillMode: Image.PreserveAspectFit
                        opacity: 0.7
                        x: columnaDatos.separacionIzquierda *3
                        source: "qrc:/media/Media/icon-frasco-monedas.png"
                    }

                    Row {
                        y: 3
                        spacing: 176
                        x: columnaDatos.separacionIzquierda *3
                        width: flickDatos.width

                        Text {
                            text: "Con deuda\n($ " + totalDeuda+")"
                            font.family: "verdana";
                            font.pixelSize: 14
                            color: "red"
                            visible: listViewDeudores.model.length>0
                        }

                        Text {
                            text: "Con deuda desde hoy\n($ "+totalDeudaHoy+")"
                            font.family: "verdana";
                            font.pixelSize: 14
                            color: "red"
                            //visible: listViewDeudoresHoy.model.length>0
                        }
                    }

                    Row {
                        spacing: 3
                        x: columnaDatos.separacionIzquierda *3
                        width: flickDatos.width

                        ListView {
                            id: listViewDeudores
                            width: 250
                            height: model.length > 0 ? 75 : 0
                            clip: true
                            delegate: Text {
                                text: listViewDeudores.model[index].nombre_cliente + ": $ " + listViewDeudores.model[index].credito
                            }
                        }

                        ListView {
                            id: listViewDeudoresHoy
                            width: 250
                            height: model.length > 0 ? 75 : 0
                            clip: true
                            delegate: Text {
                                text: listViewDeudoresHoy.model[index].nombre_cliente + ": $ " + listViewDeudoresHoy.model[index].credito
                            }
                        }
                    }


                    Row {
                        spacing: 120
                        x: columnaDatos.separacionIzquierda *3
                        Text {
                            text: "Con dinero a favor\n($ "+totalFavor+")"
                            font.family: "verdana";
                            font.pixelSize: 14
                            color: "green"
                            visible: listViewMerecedores.model.length>0
                        }

                        Text {
                            text: "Con dinero a favor desde hoy\n($ "+totalFavorHoy+")"
                            font.family: "verdana";
                            font.pixelSize: 14
                            color: "green"
                            //visible: listViewMerecedoresHoy.model.length>0
                        }
                    }


                    Row {
                        spacing: 3
                        x: columnaDatos.separacionIzquierda *3

                        ListView {
                            id: listViewMerecedores
                            width: 250
                            height: model.length > 0 ? 75 : 0
                            clip: true
                            delegate: Text {
                                text: listViewMerecedores.model[index].nombre_cliente + ": $ " + listViewMerecedores.model[index].credito
                            }
                        }

                        ListView {
                            id: listViewMerecedoresHoy
                            width: 250
                            height: model.length > 0 ? 75 : 0
                            clip: true
                            delegate: Text {
                                text: listViewMerecedoresHoy.model[index].nombre_cliente + ": $ " + listViewMerecedoresHoy.model[index].credito
                            }
                        }
                    }
                }
            }




            LineaSeparadora {
                width: 800
            }

            Rectangle {
                width: 800
                height: 500

                //CategoryAxis QML Type :: places named ranges on the axis.

                ChartView {
                    id: chartCantidadPresentes
                    title: "Cantidad presentes registrados"
                    anchors.fill: parent
                    antialiasing: true

                    /*ValueAxis {
                        id: xAxis
                        min: 0
                        max: 10
                    }*/

                    ValueAxis {
                        id: yAxis
                        min: 0
                        max: 10
                    }

                    LineSeries {
                        id: graphLinePresentesAdultos
                        name: "Adultos"
                        color: "blue"
                        axisY: yAxis
                        pointsVisible: true

                        axisX: CategoryAxis {
                            id: categoriaX
                            labelsPosition: CategoryAxis.AxisLabelsPositionOnValue
                        }

                        onClicked: {
                            console.debug(point)
                        }
                    }

                    LineSeries {
                        id: graphLinePresentesInfantiles
                        name: "Infantiles"
                        axisY: yAxis
                        axisX: graphLinePresentesAdultos.axisX
                        color: "red"
                        pointsVisible: true

                        onClicked: {
                            console.debug(point)
                        }
                    }
                }
            }

            Row {
                Rectangle {
                    width: 400
                    height: 400

                    ChartView {
                        title: "Porcentaje presentes registrados"
                        anchors.fill: parent
                        theme: ChartView.ChartThemeLight
                        antialiasing: true

                        PieSeries {
                            id: piePresentes
                        }
                    }
                }

                Rectangle {
                    width: 400
                    height: 400

                    ChartView {
                        title: "Porcentaje abonos vendidos"
                        anchors.fill: parent
                        theme: ChartView.ChartThemeLight
                        antialiasing: true

                        PieSeries {
                            id: pieAbonos
                        }
                    }
                }
            }

            Rectangle {
                width: 800
                height: 500

                //CategoryAxis QML Type :: places named ranges on the axis.

                ChartView {
                    id: chartCantidadAbonos
                    title: "Cantidad abonos vendidos "
                    anchors.fill: parent
                    antialiasing: true

                    ValueAxis {
                        id: yAxisCantidadAbonos
                        min: 0
                        max: 10
                    }

                    LineSeries {
                        id: graphLineAbonosAdultos
                        name: "Adultos"
                        color: "blue"
                        axisX: CategoryAxis {
                            id: categoriaXabonos
                            labelsPosition: CategoryAxis.AxisLabelsPositionOnValue
                        }
                        axisY: yAxisCantidadAbonos
                        pointsVisible: true

                    }

                    LineSeries {
                        id: graphLineAbonosInfantiles
                        name: "Infantiles"
                        color: "red"
                        axisX: graphLineAbonosAdultos.axisX
                        axisY: yAxisCantidadAbonos
                        pointsVisible: true
                    }
                }
            }

            Rectangle {
                width: 800
                height: 500

                //CategoryAxis QML Type :: places named ranges on the axis.

                ChartView {
                    id: chartCantidadAlumnos
                    title: "Cantidad alumnos registrados"
                    anchors.fill: parent
                    antialiasing: true

                    ValueAxis {
                        id: yAxisAlumnos
                        min: 0
                        max: 10
                    }

                    LineSeries {
                        id: graphLineCantidadAlumnosAlta
                        name: "Alta"
                        color: "green"
                        axisX: CategoryAxis {
                            id: categoriaXalumnosalta
                            labelsPosition: CategoryAxis.AxisLabelsPositionOnValue
                        }
                        axisY: yAxisAlumnos
                        pointsVisible: true

                    }

                    LineSeries {
                        id: graphLineCantidadAlumnosBaja
                        name: "Baja"
                        color: "red"
                        axisX: graphLineCantidadAlumnosAlta.axisX
                        axisY: yAxisAlumnos
                        pointsVisible: true
                    }
                }
            }

            /* LineaSeparadora {
                width: flickDatos.width
            }*/

            Row {
                height: 50
                spacing: 5
                x: (columnaDatos.separacionIzquierda)*2
                visible: false
                enabled: false

                CheckBox {
                    id: checkTodasActividades
                    text: "Todas las actividades"
                    y: 4

                    onCheckedChanged: {
                        if (checked){

                        }
                    }
                }

                ComboBox {
                    id: comboActividad
                    height: 28
                    width: 120
                    enabled: !checkTodasActividades.checked

                    onCurrentIndexChanged: {
                        var id_danza = modelDanzas.get(currentIndex).id
                        wrapper.managerClase.obtenerTodasLasClasesPorIdDanza(id_danza)
                    }
                }


                ComboBox {
                    id: comboClase
                    height: 28
                    width: 120
                    enabled: comboActividad.enabled
                    visible: false
                }
            }



        }
    }

}
