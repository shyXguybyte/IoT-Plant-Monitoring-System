#include "sensors.h"
#include <DHT.h> 

int moistureData;
int gasData;
int lightData;
float distanceData;
float humidityData;
float temperatureData;

DHT dht(DHT_PIN, DHT11);

float readTemperature() { //reading from DHT11
    return dht.readTemperature(); 
}

float readHumidity() { //reading from DHT11
    return dht.readHumidity();
}

int readSoilMoisture() { //reading from soil moisture sensor
    int soilData = analogRead(SOIL_PIN);
    return 100 - ((soilData / 4095.00) * 100); 
}

int readGas() {
    int gasData = analogRead(GAS_PIN); //reading from gas sensor
    return 100 - ((gasData / 4095.00) * 100); 
}

int readLightIntensity() {
    int lightData = analogRead(LIGHT_PIN); // reading from light sensor
    return 100 - ((lightData / 4095.00) * 100); 
}

float readDistance() { // calculating distance using the ultrasonic sensor
    digitalWrite(TRIG_PIN, LOW);
    delayMicroseconds(5);
    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG_PIN, LOW);
    int duration = pulseIn(ECHO_PIN, HIGH);
    return (duration * 0.034) / 2;
}