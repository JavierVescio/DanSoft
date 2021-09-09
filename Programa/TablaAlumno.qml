import QtQuick 2.0
import QtQuick.Controls 1.2

TableView {
    id: tablaInterna

    property bool mostrarColumnaInscripcion: false
    property bool mostrarColumnaMatricula: false

    TableViewColumn {
        role: "index"
        title: ""
        width: 45

        delegate: Item {
            Text {
                x: 1
                y: 1
                text: tablaInterna.model !== null ? tablaInterna.model.length - styleData.row : ""
                color: styleData.selected && tablaInterna.focus ? "white" : "black"
            }
        }
    }
    TableViewColumn{ role: "dni" ; title: "DNI" ; width: 100 }
    TableViewColumn{ role: "apellido" ; title: "Apellido" ; width: 150 }
    TableViewColumn{ role: "primerNombre" ; title: "Primer Nombre" ; width: 150 }
    TableViewColumn{ visible: (!mostrarColumnaInscripcion && !mostrarColumnaMatricula); role: "segundoNombre" ; title: "Segundo Nombre" ; width: 110 }
    TableViewColumn{
        visible: mostrarColumnaInscripcion;
        role: "inscripto_a_clase"
        title: "Inscripto a clase" ;
        width: 90

        delegate: Item {
            Image {
                x: (parent.width / 2) - (width/2)
                source: styleData.value === false ? "qrc:/media/Media/icono.png" : "qrc:/media/Media/icoyes.png"
            }
        }
    }
    TableViewColumn{
        visible: mostrarColumnaMatricula;
        role: "matriculado"
        title: "Matriculado" ;
        width: 80

        delegate: Item {
            Image {
                x: (parent.width / 2) - (width/2)
                //source: !wrapper.classManagementGestionDeAlumnos.alumnoConMatriculaInfantilVigente(styleData.value) ? "qrc:/media/Media/icono.png" : "qrc:/media/Media/icoyes.png"
                source: !styleData.value ? "qrc:/media/Media/icono.png" : "qrc:/media/Media/icoyes.png"
            }
        }
    }

    /*TableViewColumn{ role: "telefonoFijo" ; title: "Teléfono fijo" ; width: 80 }
    TableViewColumn{ role: "telefonoCelular" ; title: "Teléfono móvil" ; width: 80 }
    TableViewColumn{ role: "estado" ; title: "Estado" ; width: 80 }*/
}
