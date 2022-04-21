import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import QtCharts 2.15
Item {
    id:root
    signal sendSettingInfoSignal(int state)
    signal sendDataSignal(string data)

    function clearDisplayText(){ //xoa du lieu xuat tren man hinh
        displaText.clear()
    }

    function setDisplyText(data){
        displaText.insert(displaText.length,data)
    }

    function setOpenBtnText(station){
        openBtn.btnStation=station
        console.log("get result:"+openBtn.btnStation)
    }
    Component.onCompleted: { //display when environment is completely established
        cpp_obj.returnOpenResultSignal.connect(setOpenBtnText)
    }

    GridLayout{
        columns: 2
        anchors.fill: parent
        anchors.margins: 1

        Rectangle{ //create border
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan:2
            border.width: 1
            border.color: "gray"
            height: 4

            //display data in string type to the screen

            ScrollView { //when the text is too long to display ScrollBar will appear
                anchors.fill:parent
                clip: true
                background: Rectangle {
                    anchors.fill: parent
                    border.color: "gray"
                    radius: 5
                }

                TextArea { //display measured data
                    id: displaText
                    x: -7
                    y: 0
                    width: 638
                    height: 376
                    wrapMode:TextArea.Wrap
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 2
                    //Layout.RightMargin: 100
                    font.family: "Courier New"
                    font.pointSize: 14

                }
            }

        }


        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.width: 1
            border.color: "gray"
            width: 4

            ScrollView {
                anchors.fill:parent
                clip: true
                TextArea {
                    id:sendView
                    font.pointSize: 15
                    wrapMode:TextArea.Wrap
                    focus: true
                    selectByMouse: true
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true

            Button{
                id:openBtn
                height: parent.height/2-5
                width: parent.width
                text: btnStation==false?"Open serial port":"Close serial port"
                property bool btnStation: false
                font.pointSize :11
                font.family: "Helvetica";
                font.bold: true
                onClicked: {
                    btnStation=!btnStation
                    if(cpp_obj.readIsMyPortOpen()){
                        emit: sendSettingInfoSignal(0)

                    }
                    else{
                        emit: sendSettingInfoSignal(1)   //1 open 0 close
                    }
                }
            }

            Button{
                //anchors.bottom: parent
                anchors.bottom: parent.bottom
                height: parent.height/2-5
                width: parent.width
                text: "Send"
                font.pointSize :12;
                font.family: "Helvetica";
                font.bold: true
                enabled: openBtn.btnStation?true:false
                onClicked: {
                    emit: sendDataSignal(sendView.text)
                }

            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
