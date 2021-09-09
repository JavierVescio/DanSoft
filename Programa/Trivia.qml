import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.0
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    color: "#FCFCFC"
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}


    WrapperClassManagement {
        id: wrapper
    }

}

