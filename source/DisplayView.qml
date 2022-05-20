import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import QtCharts 2.15
Item {
    id:root
    signal sendSettingInfoSignal(int state)
    signal sendDataSignal(string data)
    property double rmsec:-0.1
    property double rsec: 0
    property int count:-1
    function clearDisplayText(){ //xoa du lieu xuat tren man hinh
        line.clear()
        timer.restart()
        rmsec=-0.1
        rsec=0
        count=-1
        chartView.animationOptions=ChartView.NoAnimation
    }

//    function setDisplyText(data){
//        //displaText.insert(displaText.length,data)
//        line.append(cpp_obj.update(),data)
//    }


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
//            gradient: Gradient {
//                GradientStop { position: 0.0; color: "#82DBD8" }
//            }

/*
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
            */

            //display chart in the screen
            ChartView {
                id: chartView
                anchors.fill:parent
                antialiasing: true
                //animationOptions: ChartView.AllAnimations
//                backgroundColor: "#00F5F1"
//                plotAreaColor: "#FFFFFF"
                SplineSeries {
                    id: line
                    name: "Realtime data chart"
                    width: 3
                    color: "blue"
                    axisY: ValuesAxis{
                        min: 0.0
                        max: 40.0
                        tickCount: 9
                        labelFormat: "%.0f"
                        titleText: "Data"
                        labelsColor: "#301A4B"
                    }
//                    axisX: DateTimeAxis{
//                        tickCount: 5
//                        format: "hh:mm:ss"
////                        max: new Date(2022,5,6,9,49,00)
////                        min: new Date(2022,5,6,9,48,00)
//                    }
                    axisX: ValuesAxis{
                        titleText: "Second"
                        labelsColor: "red"
                        min: 0
                        max: 10
                        tickCount: 11
                        //labelFormat: "%.1f"
                    }

                }


            }

        }
        //update time with data
        Timer{
            id: timer
            interval: 10 //100hz
            running: false
            repeat: true
            onTriggered: {
                rmsec+=0.01; //realtime variable count 0.01s=10ms
                count++;
                if(count%100==0){
                    rsec++;
                }

                if(cpp_obj.readIsMyPortOpen()){
                line.append(rmsec,cpp_obj.readData_slot());
                } else {
                    line.append(rmsec,0);
                }
                //scroll
                if(rsec>=10){
                    chartView.axisX().max=rsec+1;
                    chartView.axisX().min=chartView.axisX().max-10;
                } else
                {
                    chartView.axisX().max=10;
                    chartView.axisX().min=0;
                }
                chartView.axisX().tickCount=11;

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

                    if(btnStation)
                        timer.start()
                    else{
                        timer.stop()
                        chartView.animationOptions = ChartView.AllAnimations;
                        chartView.axisX().min = 0;
                        chartView.axisX().max = rmsec;
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
