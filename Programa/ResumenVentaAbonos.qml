import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import com.mednet.CuentaAlumno 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4


Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}

    property string strSinInformacion: qsTrId("Sin información disponible")

    property color backColorSubtitles: "#C8E6C9"
    property color backColorSubtitlesAdults: "#BBDEFB"
    property color backColorSubtitlesKids: "#FFCDD2"
    property color backColorSubtitlesGeneral: "#C8E6C9"
    property color colorSubtitles: "black"


    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: {
        listViewAdulto.model = wrapper.managerCuentaAlumno.traerMovimientosAdultosPorFecha()
        listViewInfantil.model = wrapper.managerCuentaAlumno.traerMovimientosInfantilesPorFecha()

        lblInfoAdultoTotalAlumnos.text = "Total alumnos/as adultos: " + listViewAdulto.model.length
        lblInfoInfantilTotalAlumnos.text = "Total alumnos/as infantiles: " + listViewInfantil.model.length
        lblInfoGeneralTotalAlumnos.text = "Total alumnos/as: " + (listViewInfantil.model.length + listViewAdulto.model.length)

        lblInfoAdultoTotalIngresos.text = "Ingresos adultos por abono: <font color=\"green\">$ " + wrapper.managerCuentaAlumno.traerTotalIngresosAdultos()+"</font>"
        lblInfoInfantilTotalIngresos.text = "Ingresos infantiles por abono: <font color=\"green\">$ " + wrapper.managerCuentaAlumno.traerTotalIngresosInfantiles()+"</font>"
        lblInfoGeneralTotalIngresos.text = "Ingresos totales por abono: <font color=\"green\">$ " + (wrapper.managerCuentaAlumno.traerTotalIngresosInfantiles()+wrapper.managerCuentaAlumno.traerTotalIngresosAdultos())+"</font>"
    }

    Calendar {
        id: calendar
        minimumDate: new Date(2018, 0, 1)
        anchors.left: parent.left
        anchors.top: parent.top

        onClicked: {
            listViewAdulto.model = wrapper.managerCuentaAlumno.traerMovimientosAdultosPorFecha(date)
            listViewInfantil.model = wrapper.managerCuentaAlumno.traerMovimientosInfantilesPorFecha(date)

            lblInfoAdultoTotalAlumnos.text = "Total alumnos/as adultos: " + listViewAdulto.model.length
            lblInfoInfantilTotalAlumnos.text = "Total alumnos/as infantiles: " + listViewInfantil.model.length
            lblInfoGeneralTotalAlumnos.text = "Total alumnos/as: " + (listViewInfantil.model.length + listViewAdulto.model.length)

            lblInfoAdultoTotalIngresos.text = "Ingresos adultos por abono: <font color=\"green\">$ " + wrapper.managerCuentaAlumno.traerTotalIngresosAdultos()+"</font>"
            lblInfoInfantilTotalIngresos.text = "Ingresos infantiles por abono: <font color=\"green\">$ " + wrapper.managerCuentaAlumno.traerTotalIngresosInfantiles()+"</font>"
            lblInfoGeneralTotalIngresos.text = "Ingresos totales por abono: <font color=\"green\">$ " + (wrapper.managerCuentaAlumno.traerTotalIngresosInfantiles()+wrapper.managerCuentaAlumno.traerTotalIngresosAdultos())+"</font>"

        }
    }

    Rectangle {
        id: titleInfoAdultos
        anchors.left: parent.left
        anchors.top: calendar.bottom
        height: 29
        width: calendar.width
        color: backColorSubtitlesAdults

        Text {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 3
            font.family: "verdana"; color: colorSubtitles;
            font.pixelSize: 14
            text: qsTrId("Adultos")

        }
    }

    Text {
        id: lblInfoAdultoTotalAlumnos
        anchors.top: titleInfoAdultos.bottom
        x: 3
        anchors.topMargin: 10
        font.family: "verdana"
        font.pixelSize: 12
        text: strSinInformacion
    }

    Text {
        id: lblInfoAdultoTotalIngresos
        anchors.top: lblInfoAdultoTotalAlumnos.bottom
        anchors.topMargin: 10
        x: 3
        font.family: "verdana"
        font.pixelSize: 12
        text: strSinInformacion
    }

    Rectangle {
        id: titleInfoInfantil
        anchors.left: parent.left
        anchors.top: lblInfoAdultoTotalIngresos.bottom
        anchors.topMargin: 10
        height: 29
        width: calendar.width
        color: backColorSubtitlesKids

        Text {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 3
            font.family: "verdana"; color: colorSubtitles;
            font.pixelSize: 14
            text: qsTrId("Infantil")

        }
    }

    Text {
        id: lblInfoInfantilTotalAlumnos
        anchors.top: titleInfoInfantil.bottom
        x: 3
        anchors.topMargin: 10
        font.family: "verdana"
        font.pixelSize: 12
        text: strSinInformacion
    }

    Text {
        id: lblInfoInfantilTotalIngresos
        anchors.top: lblInfoInfantilTotalAlumnos.bottom
        x: 3
        anchors.topMargin: 10
        font.family: "verdana"
        font.pixelSize: 12
        text: strSinInformacion
    }

    Rectangle {
        id: titleInfoGeneral
        anchors.left: parent.left
        anchors.top: lblInfoInfantilTotalIngresos.bottom
        anchors.topMargin: 10
        height: 29
        width: calendar.width
        color: backColorSubtitlesGeneral

        Text {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 3
            font.family: "verdana"; color: colorSubtitles;
            font.pixelSize: 14
            text: qsTrId("General")

        }
    }

    Text {
        id: lblInfoGeneralTotalAlumnos
        anchors.top: titleInfoGeneral.bottom
        x: 3
        anchors.topMargin: 10
        font.family: "verdana"
        font.pixelSize: 12
        text: strSinInformacion
    }

    Text {
        id: lblInfoGeneralTotalIngresos
        anchors.top: lblInfoGeneralTotalAlumnos.bottom
        x: 3
        anchors.topMargin: 10
        font.family: "verdana"
        font.pixelSize: 12
        text: strSinInformacion
    }

    Rectangle {
        id: panelDerecha
        anchors.left: calendar.right
        anchors.margins: -1
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        border.color: "black"

        Rectangle {
            id: recAbonoAdulto
            //color: "#E1F5FE"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width / 2

            Rectangle {
                id: recInfoAdulto
                height: 0
                //color: "#c7e0ea"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
            }

            ListView {
                id: listViewAdulto
                anchors.top: recInfoAdulto.bottom
                anchors.topMargin: 3
                anchors.bottomMargin: 3
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                clip: true
                spacing: 10
                delegate: ResumenDelDiaAlumno{
                    border.color: "#c7e0ea"
                    border.width: 2
                    radius: 3
                    record: listViewAdulto.model[index]
                    width: parent.width - 3
                    //aliasApellidoNombre: listViewInfantil.model[index].apellido
                }
            }
        }

        Rectangle {
            id: recAbonoInfantil
            //color: "#FFEBEE"
            anchors.left: recAbonoAdulto.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right

            Rectangle {
                id: recInfoInfantil
                height: 0
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                //color: "#eacbd0"
            }

            ListView {
                id: listViewInfantil
                anchors.top: recInfoInfantil.bottom
                anchors.topMargin: 3
                anchors.bottomMargin: 3
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                clip: true
                spacing: 10
                delegate: ResumenDelDiaAlumno{
                    border.color: "#eacbd0"
                    border.width: 2
                    radius: 3
                    record: listViewInfantil.model[index]
                    width: parent.width - 3
                    //aliasApellidoNombre: listViewInfantil.model[index].apellido
                }
            }
        }
    }

}
