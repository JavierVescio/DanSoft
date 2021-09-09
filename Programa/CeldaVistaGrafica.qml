import QtQuick 2.0

Rectangle {
    color: "transparent"
    property variant recordAsistencia: null
    property variant recordMovimiento: null

    Rectangle {
        color: "black"
        width: 1
        height: parent.height
    }

    /*Rectangle {
        color: "black"
        x: parent.width-1
        width: 1
        height: parent.height
    }*/


    /*Row {
        Image {
            id: imgPresente

            height: 25
            visible: recordAsistencia !== null
            source: "qrc:/media/Media/asistiendo.PNG"
            fillMode: Image.PreserveAspectFit
        }
    }*/



    Row {
        x: 0
        Image {
            y: 5
            height: 20
            fillMode: Image.PreserveAspectFit
            source: "qrc:/media/Media/Persona.png"
            visible: recordAsistencia !== null
            opacity: 0.7
        }

        /*Text {
            x: 3
            y: (parent.height / 2) - 8
            font.pixelSize: 12
            visible: recordAsistencia === null
            text: "-"
        }*/
    }

    Row {
        x: (parent.width / 2) + 3
        //layoutDirection: Qt.RightToLeft

        /*Image {
            height: 30
            fillMode: Image.PreserveAspectFit
            source: "qrc:/media/Media/cajero_automatico.PNG"
            visible: recordMovimiento !== null
        }*/

        Text {
            y: (parent.height / 2) - 2
            text: "$"
            color: "green"
            font.family: "verdana"
            font.pixelSize: 16
            font.bold: true
            visible: recordMovimiento !== null
            opacity: 0.7
        }

        /*Text {
            y: (parent.height / 2) - 8
            font.pixelSize: 12
            visible: recordMovimiento === null
            text: "-"
        }*/
    }
}
