import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import QtCharts 2.15
Window{
    width: 600
    height: 400
    title: "Version"

    Rectangle{
        anchors.fill:parent
        Text {
            anchors.fill: parent
            text: "Serial port "+"\n"+"\n"+"Version v1.0.1"
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter

       }

    }

}
