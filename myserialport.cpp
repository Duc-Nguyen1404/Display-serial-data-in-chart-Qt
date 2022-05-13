#include "myserialport.h"
#include <QSerialPortInfo>
#include <QDebug>
#include <QTimer>
#include <QTime>
#include <QDateTime>
#include <math.h>

int count=0;
MySerialPort::MySerialPort(QObject *parent) : QObject(parent)
{
    myPort=new QSerialPort;
    serialBuffer = "";
    parsed_data = "";
    temperature_value = 0.0;

}

MySerialPort::~MySerialPort()
{
    delete myPort;
}

bool MySerialPort::readIsMyPortOpen()
{
    //qDebug()<<myPort->isOpen();
    return myPort->isOpen();

}

void MySerialPort::initPort()
{
    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts())
    {
        qDebug() << "Name : " << info.portName();
        emit portNameSignal(info.portName());
//        qDebug() << "Description : " << info.description();
//        qDebug() << "Manufacturer: " << info.manufacturer();
//        qDebug() << "Serial Number: " << info.serialNumber();
//        qDebug() << "System Location: " << info.systemLocation();
    }
}

void MySerialPort::openPort(QString value) //receive signal and get the variable from the signal method
{
    QStringList list=value.split('/');
    int btnState=list[0].toInt();
    QString port=list[1];

    if(btnState==1)   //1 serial port open flag
    {
        //Set serial port name
        myPort->setPortName(port);
        if(myPort->open(QIODevice::ReadWrite))
        {
            connect(myPort,&QSerialPort::readyRead,this,&MySerialPort::readData_slot);
            qDebug()<<myPort->portName()<<myPort->baudRate()<<myPort->dataBits();
        }


    }
    else
        if(btnState==0)
        {
            myPort->close();
        }
    emit returnOpenResultSignal(myPort->isOpen());

}

double MySerialPort::readData_slot()
{
    QByteArray buff;

    QStringList buffer_split = serialBuffer.split(","); //  split the serialBuffer string, parsing with ',' as the separator
    if(buffer_split.length() < 3){
        buff=myPort->readAll();
        serialBuffer = serialBuffer + QString::fromStdString(buff.toStdString());
        buff.clear();
    }
    else{
        // the second element of buffer_split is parsed correctly, update the temperature value on temp_lcdNumber
        serialBuffer = "";
        //qDebug() << buffer_split<< "\n";
        parsed_data = buffer_split[1];
        //temperature_value = (9/5.0) * (parsed_data.toDouble()) + 32; // convert to fahrenheit
        temperature_value = parsed_data.toDouble(); // celsius
        qDebug() << "Temperature: " << temperature_value << "\n";

        emit receiveData(temperature_value);
    }
    return temperature_value;

//    if(recDataModel==ASIIC_TYPE)  //ASIIC
//    {

//        emit displayRecDataSignal(buff.data());
//    }
//    else
//    {
//        QString str=buff.toHex();
//        QString str1;
//        for(int i = 0; i < str.length()/2;i++)
//        {
//            str1 += str.mid(i*2,2) + " ";
//        }

//        emit displayRecDataSignal(str1);
//    }
    //newly insert
//    QTime realtime(QTime::currentTime());
//    static double key=0;
//    if(abs(realtime.second()-key)>=1){
//        qDebug()<<realtime.second()<<"\n";
//        key=realtime.second();

//    }
//    QDateTime time;
//    qDebug()<<time.currentSecsSinceEpoch()<<"\n";


}

void MySerialPort::writeData(QString s,bool dataModel)
{qDebug()<<myPort->portName()<<myPort->baudRate()<<myPort->dataBits();
    QByteArray str;
    if(myPort->isOpen())
    {
        if(dataModel==ASIIC_TYPE)
        {
            str=s.toLatin1();
        }
        else
        {
            str=QByteArray::fromHex(s.toLatin1());
        }
        myPort->write(str);
    }
    else
    {
        //qDebug()<<"not open";
    }
}


void MySerialPort::setPort()
{

}

void MySerialPort::setBaud(int baud)
{
    myPort->setBaudRate(baud);
}

void MySerialPort::setDataBase(int dataBase)
{
    if(dataBase==5)
        myPort->setDataBits(QSerialPort::Data5);
    else if(dataBase==6)
        myPort->setDataBits(QSerialPort::Data6);
    else if(dataBase==7)
        myPort->setDataBits(QSerialPort::Data7);
    else if(dataBase==8)
        myPort->setDataBits(QSerialPort::Data8);

}

qint64 MySerialPort::updater()
{
//    return QDateTime::currentSecsSinceEpoch();
    QTime realtime(QTime::currentTime());
    return realtime.second();

}

