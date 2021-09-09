import QtQuick 2.0
import QtQuick.Controls 1.2
import QtMultimedia 5.4
import QtQuick.Controls.Styles 1.4
//import com.mednet.WrapperClassManagement 1.0

Rectangle {
    height: 360
    width: 400
    opacity: 0
    enabled: false
    border.color: "grey"
    border.width: 3
    color: "black"
    radius: 0
    /*gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#2E2E2E";
        }
        GradientStop {
            position: 1.00;
            color: "#2E2E2E";
        }
    }*/
    signal imageReady(var arg)
    signal cerrarCamara()
    
    Behavior on opacity {PropertyAnimation{duration:150}}
    
    Component.onCompleted: {
        opacity = 1
        enabled = true
    }
    
    Text {
        anchors.left: recCamara.left
        anchors.bottom: recCamara.top
        font.family: "Verdana"
        font.pixelSize: 14
        font.bold: true
        color: "white"
        visible: (listView.model !== null) && listView.model.length > 1
        text: qsTrId("Cámaras disponibles: " + listView.model.length)
    }
    
    Rectangle {
        id: recCamara
        width: 350
        height: 300
        color: "black"
        anchors.centerIn: parent
        //border.color: "lightgrey"
        //border.width: 2
        //radius: 5
        
        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 50
            model: QtMultimedia.availableCameras
            orientation: ListView.Vertical
            clip: true
            spacing: 3
            highlightFollowsCurrentItem: false
            z: 150
            opacity: 0
            enabled: opacity !== 0
            verticalLayoutDirection: ListView.BottomToTop
            
            Behavior on opacity {PropertyAnimation{}}
            
            highlight: Component {
                RecHighLightDos {
                    y: listView.currentItem !== null ? listView.currentItem.y : -1
                    height: 40
                    width: listView.width
                    z: 10
                }
            }
            
            delegate: Rectangle {
                width: parent.width
                //radius: 10
                height: 38
                clip: true
                color: "black"
                
                Text {
                    anchors.centerIn: parent
                    text: modelData.displayName
                    color: "white"
                    font.bold: true
                    font.family: "verdana"
                    font.pixelSize: 12
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index
                        console.debug("Before Camera.deviceId: " + camera.deviceId)
                        camera.deviceId = modelData.deviceId
                        console.debug("After Camera.deviceId: " + camera.deviceId)
                        listView.opacity = 0
                    }
                }
            }
        }
        
        Item {
            anchors.fill: parent
            anchors.leftMargin: 2
            anchors.rightMargin: 2
            
            Camera {
                id: camera
                
                imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
                
                exposure {
                    exposureCompensation: -1.0
                    exposureMode: Camera.ExposurePortrait
                }
                
                flash.mode: Camera.FlashRedEyeReduction
                
                imageCapture {
                    onImageCaptured: {
                        photoPreview.source = preview  // Show the preview in an Image
                    }
                    onImageSaved:
                    {
                        console.log("Image Saved Callback : Save Path : "+ path)
                        imageReady("file:///"+path)
                    }
                }
            }
            
            VideoOutput {
                id: viewFinder
                source: camera
                anchors.fill: parent
                focus : visible // to receive focus and capture key events when visible
            }
            
            Item {
                id: itemfoto
                anchors.fill: parent
                visible: false
                Image {
                    id: photoPreview
                    anchors.fill : parent
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }
        }
    }
    
    /*Button {
            text: qsTrId("Cerrar")
            visible
            
            onClicked: {
                cerrarCamara()
            }
        }*/
    
    Button {
        id: btnMostrarCamara
        text: qsTrId("Mostrar u ocultar cámaras")
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: 28
        width: (listView.model !== null) && listView.model.length > 1 ? 150 : 0
        style: ButtonStyle {
            background: Rectangle {
                //implicitWidth: 100
                //implicitHeight: 25
                border.width: control.activeFocus ? 2 : 1

                radius: 0
                color: "black"

                gradient: Gradient {
                    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                }
            }
        }
        
        onClicked:
            listView.opacity == 1 ?  listView.opacity = 0 :  listView.opacity = 1
    }
    
    Button {
        text: qsTrId("Capturar fotografía")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: btnMostrarCamara.left
        height: 28
        style: ButtonStyle {
            background: Rectangle {
                //implicitWidth: 100
                //implicitHeight: 25
                border.width: control.activeFocus ? 2 : 1

                radius: 0
                color: "black"

                gradient: Gradient {
                    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                }
            }
        }
        
        onClicked: {
            camera.imageCapture.capture()
            viewFinder.visible = false
            itemfoto.visible = true
        }
    }
    
    
}

