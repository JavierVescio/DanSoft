import QtQuick 2.0

Flickable {
    /*Es importante que haya un contentHeight o contentWidth. Si hay un contentHeight, entonces el hijo del
        flickable no tiene que tener definido un height, ya que va a ser variable dependiendo de la
    cantidad de elementos que el hijo tenga. Lo mismo aplica para contentWidth*/
    contentHeight: colInfo.height
    clip: true
    property var recordClienteSeleccionado : null

    Column {
        id: colInfo
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: -1
        //anchors.margins: 5
        property int heightInfo : 55

        RecConFormato {
            width: parent.width
            height: parent.heightInfo
            p_strTitulo: "GÉNERO"
            p_strTexto: recordClienteSeleccionado !== null ? recordClienteSeleccionado.genero : ""
        }

        RecConFormato {
            width: parent.width
            height: parent.heightInfo
            p_strTitulo: "NACIMIENTO"
            p_strTexto: recordClienteSeleccionado !== null ? Qt.formatDate(recordClienteSeleccionado.nacimiento,"ddd dd/MM/yyyy") : ""
        }

        RecConFormato {
            width: parent.width
            height: parent.heightInfo
            p_strTitulo: "TELÉFONO FIJO"
            p_strTexto: recordClienteSeleccionado !== null ?  recordClienteSeleccionado.telefonoFijo : ""
        }

        RecConFormato {
            width: parent.width
            height: parent.heightInfo
            p_strTitulo: "TELÉFONO CELULAR"
            p_strTexto: recordClienteSeleccionado !== null ? recordClienteSeleccionado.telefonoCelular : ""
        }

        RecConFormato {
            width: parent.width
            height: parent.heightInfo
            p_strTitulo: "CORREO ELECTRÓNICO"
            p_strTexto: recordClienteSeleccionado !== null ? recordClienteSeleccionado.correo : ""
            isMail: true
        }

        RecConFormato {
            width: parent.width
            height: parent.heightInfo
            p_strTitulo: "FECHA DE ALTA || Nº DE ALUMNO"
            p_strTexto: recordClienteSeleccionado !== null ? Qt.formatDate(recordClienteSeleccionado.fechaAlta,"dd/MM/yyyy") + " || " + recordClienteSeleccionado.id : ""
        }

        RecConFormato {
            width: parent.width
            height: parent.heightInfo
            p_strTitulo: "FECHA MATRICULACIÓN INFANTIL"
            p_strTexto:{
                if (recordClienteSeleccionado !== null ){
                    if (wrapper.classManagementGestionDeAlumnos.alumnoConMatriculaInfantilVigente(recordClienteSeleccionado.id)){
                        Qt.formatDate(recordClienteSeleccionado.fecha_matriculacion_infantil,"dd/MM/yyyy")
                    }
                    else {
                        "Sin matriculación infantil"
                    }
                }else {
                    "Sin matriculación infantil"
                }
            }
                // recordClienteSeleccionado !== null ? recordClienteSeleccionado.telefonoCelular : ""
        }

        RecConFormato {
            width: parent.width
            height: parent.heightInfo
            p_strTitulo: "ESTADO"
            p_strTexto: recordClienteSeleccionado !== null ? recordClienteSeleccionado.estado : ""
        }


        RecConFormato {
            width: parent.width
            height: parent.heightInfo * 2
            p_strTitulo: "COMENTARIO"
            p_strTexto: recordClienteSeleccionado !== null ? recordClienteSeleccionado.nota : ""
        }


    }
}
