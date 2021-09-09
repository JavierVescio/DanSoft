import QtQuick 2.3
import "qrc:/components"
import "qrc:/estudiante"
import "qrc:/agenda"
import "qrc:/estadisticas"
import "qrc:/tesoreria"
import "qrc:/adultos"
import "qrc:/presentes"
import "qrc:/birthday"
import "qrc:/danzas"
import "qrc:/infantil"
import "qrc:/ofertas"

Flickable {
    id: flick
    contentWidth: gridView.width
    contentHeight: gridView.height

    Grid {
        id: gridView
        columns: flick.width < 280 ? 1 : flick.width / 280
        //rows: height / 200
        property int heightMetro: 200
        property int widthMetro: 280
        opacity: 0

        Component.onCompleted: {
            opacity = 1
        }

        Behavior on opacity {PropertyAnimation{}}

        MetroEstudiante {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }

        MetroInfantil {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }

        MetroAdultos {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }

        MetroTesoreria {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }

        MetroOfertas {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }

        MetroDanzas {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }

        MetroPresentes {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }


        /*MetroAgenda {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }*/

        MetroBirthday {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }







        /*MetroEstadisticas {
            height: gridView.heightMetro
            width: gridView.widthMetro
        }*/
    }
}


