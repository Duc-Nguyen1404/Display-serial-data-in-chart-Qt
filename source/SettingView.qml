import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5

Rectangle {
    id:root
    property bool sendRadionBtnStatus: true
    property bool recRadionBtnStatus: true
    function setModel(s){
        myModel.append({s})
    }
    function rescan_list(){
        myModel.clear()
    }

    function getSetting(state){
        var value=portComBox.currentText+'/'+baudCombox.currentText+'/'+databaseCombox.currentText
        return value
    }

    onRecRadionBtnStatusChanged:{
        cpp_obj.recDataModel=recRadionBtnStatus
    }
//    Component.onCompleted: { //on the first start nothing is display in the combo box
//        baudCombox.displayText=" ";
//        databaseCombox.displayText=" ";
//    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 10
        anchors.margins: 2
        RowLayout{
            Text {
                text: qsTr("Port  ")
                height: 100
            }
            ComboBox {
                id:portComBox
                Layout.leftMargin: 19
                Layout.minimumHeight: 30
                Layout.maximumHeight: 30

                model: ListModel{
                    id:myModel
                }

                delegate: ItemDelegate{
                    id:itmdlg
                    height: 30
                    width: portComBox.width
                    text: modelData
                    background: Rectangle{
                        id:bacRect
                        anchors.fill: parent
                        color:itmdlg.hovered?"#507BF6":"white";
                    }
                }


            }
        }

        RowLayout{
            Text {
                text: qsTr("Baud rate")
                //Layout.fillHeight: true
            }
            ComboBox {
                id:baudCombox
                Layout.minimumHeight: 30
                Layout.maximumHeight: 30
                model: ["2400","4800", "9600","19200","38400"]
                //model: ["9600"]
                delegate: ItemDelegate{
                    id:itmdlg1
                    height: 30
                    width: parent.width
                    text: modelData
                    background: Rectangle{
                        anchors.fill: parent
                        color:itmdlg1.hovered?"#507BF6":"white";
                    }
                }
                onCurrentTextChanged: {
                    cpp_obj.setBaud(Number(currentText))
                    //cpp_obj.setBaud(9600)
                }
            }
        }
        RowLayout{
            Text {
                text: qsTr("Data bits")
                //Layout.fillHeight: true
            }

            ComboBox {
                id:databaseCombox
                Layout.minimumHeight: 30
                Layout.maximumHeight: 30
                model: [ "5", "6", "7", "8"]
                //model: [ "8"]
                delegate: ItemDelegate{
                    id:itmdlg2
                    height: 30
                    width: parent.width
                    text: modelData
                    background: Rectangle{
                        anchors.fill: parent
                        color:itmdlg2.hovered?"#507BF6":"white";

                    }
                }
                onCurrentTextChanged: {
                    cpp_obj.setDataBase(Number(currentText))
                    //cpp_obj.setDataBase(8)
                }
            }
        }

        ColumnLayout{
            //height: 10
            GroupBox {
                Layout.columnSpan:2
                Layout.fillWidth: true
                background: Rectangle {
                    anchors.fill: parent
                    Rectangle{
                        id: frame1
                        border.color: "gray"
                        border.width: 1
                        anchors.topMargin: 5
                        anchors.fill:  parent
                        radius: 10//rounded corner
                    }

                    Rectangle{
                        id:titleBackground
                        width: title.width
                        height: title.height
                        anchors.top:parent.top
                        color: "transparent"
                        //x:20
                        anchors.centerIn: parent
                        Text{
                            id:title
                            text: "Send setting"
                            anchors.bottom: parent.bottom
                            font.pixelSize: 15
                            anchors.bottomMargin: 18
                        }
                    }
                }

                RowLayout{
                    anchors.fill: parent
                    Layout.fillWidth: true
                    RadioButton{
                        text: "ASCII"
                        Layout.topMargin: 6
                        anchors.leftMargin: 7
                        font.pointSize :12;
                        font.family: "Helvetica";
                        font.bold: true
                        checked: sendRadionBtnStatus
                        onClicked: {
                            sendRadionBtnStatus=true
                        }
                    }

                    RadioButton{
                        text: "HEX"
                        Layout.topMargin: 6
                        //Layout.alignment: parent.right
                        //Layout.leftMargin: 3
                        font.pointSize :12;
                        font.family: "Helvetica";
                        font.bold: true
                        checked: ~sendRadionBtnStatus
                        onClicked: {
                            sendRadionBtnStatus=false
                        }
                    }

                }

            }
/*
            GroupBox {
                id:groupRec
                Layout.columnSpan:2
                Layout.fillWidth: true

                background: Rectangle {
                    anchors.fill: parent
                    Rectangle{
                        border.color: "gray"
                        border.width: 1
                        anchors.topMargin: 5
                        anchors.fill:  parent
                        radius: 10//rounded corners
                    }
                    Rectangle{
                        id:titleBackground1
                        width: title1.width
                        height: title1.height
                        anchors.top:parent.top
                        x:20

                        Text{
                            id:title1
                            text: "Accept settings"
                            font.pixelSize: 15
                        }
                    }
                }

                RowLayout{
                    //anchors.fill:parent
                    RadioButton{
                        text: "ASCII"
                        font.pointSize :12;
                        font.family: "Helvetica";
                        font.bold: true
                        checked: recRadionBtnStatus
                        onClicked: {
                            recRadionBtnStatus=true
                        }
                    }

                    RadioButton{
                        text: "HEX"
                        font.pointSize :12;
                        font.family: "Helvetica";
                        font.bold: true
                        checked: ~recRadionBtnStatus
                        onClicked: {
                            recRadionBtnStatus=false
                        }
                    }
                }
            }
            */
        }      
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
