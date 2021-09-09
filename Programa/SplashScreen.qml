import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
    id: item
    anchors.fill: parent
    opacity: 1
    enabled: opacity === 1

    property int marginTopSplash: -50

    Behavior on opacity {PropertyAnimation{ easing.overshoot: 1; easing.period: 0.34; easing.type: Easing.OutQuart;duration:3000}}
    //Behavior on opacity {PropertyAnimation{ easing.overshoot: 0; easing.period: 0.34; easing.type: Easing.OutInCirc;duration:1000}}

    property int crecimientoProgreso: 10

    function cleanAndClose() {
        opacity = 0
    }

    Rectangle {
        id: recSplashScreen
        anchors.fill: parent
        anchors.topMargin: marginTopSplash
        color: "white"


        MouseArea {
            anchors.fill: parent

            onClicked: {
                item.opacity = 0
            }
        }

        /*Image {
            id: imgDecorativaLines
            x: parent.width / 3
            y: 0
            antialiasing: true
            //rotation: 180
            fillMode: Image.PreserveAspectFit
            source: "qrc:/media/Media/decorative_lines.png"
            opacity: 0.6
        }*/


        Image {
            id: imgLogo
            anchors.centerIn: parent
            source: "qrc:/media/Media/DanzaSoftLogop.png"
            //source: "qrc:/media/Media/MarielaLogo.jpg"
        }

        /*Timer {
            id: timerSplash
            interval: 3000; running: true; repeat: false
            onTriggered: item.opacity = 0
        }*/

        Rectangle {
            id: recVersionPrograma
            anchors.top: imgLogo.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.right: parent.right
            height: 90
            opacity: .7

            Text {
                anchors.centerIn: parent
                text: strVersion
                font.pixelSize: 24
                font.family: "verdana"
                font.letterSpacing: 0
            }
        }


        Rectangle {
            id: recHorario
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 3
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60
            opacity: .7

            Text {
                anchors.centerIn: parent
                text: strDateTime
                font.pixelSize: 18
                font.family: "georgia"
                font.letterSpacing: 5
            }
        }


        /*Rectangle {

        }*/
    }

}
