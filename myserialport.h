#ifndef MYSERIALPORT_H
#define MYSERIALPORT_H

#include <QObject>
#include <QSerialPort>
#include <QColor>
#define ASIIC_TYPE true
#define HEX_TYPE false

class MySerialPort : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool recDataModel READ readRecDataModel WRITE setRecDataModel)


public:
    explicit MySerialPort(QObject *parent = nullptr);
    ~MySerialPort();
    QSerialPort *myPort;

    bool recDataModel=ASIIC_TYPE;
    void setRecDataModel(bool s){recDataModel=s;}
    bool readRecDataModel(){return recDataModel;}

signals:
    void portNameSignal(QString portName);
    void displayRecDataSignal(QString);
    void authorChanged();
    void returnOpenResultSignal(bool);

public slots:
    void setPort();
    void setBaud(int);
    void setDataBase(int);
    void initPort();
    void openPort(QString value);
    void readData_slot();  //Receive data
    void writeData(QString ,bool);   //send data
    bool readIsMyPortOpen();




};

#endif // MYSERIALPORT_H
