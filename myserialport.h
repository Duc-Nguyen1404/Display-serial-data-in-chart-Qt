#ifndef MYSERIALPORT_H
#define MYSERIALPORT_H

#include <QObject>
#include <QSerialPort>
#include <QColor>
#include <QDateTime>
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
    void receiveData(double);

public slots:
    void setPort();
    void setBaud(int);
    void setDataBase(int);
    void initPort();
    void openPort(QString value);
    double readData_slot();  //Receive data
    void writeData(QString ,bool);   //send data
    bool readIsMyPortOpen();
    qint64 updater();
private:
    QString serialBuffer;
    QString parsed_data;
    double temperature_value;


};

#endif // MYSERIALPORT_H
