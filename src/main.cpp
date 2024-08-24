#include <Arduino.h>
#include<DHT.h>
#include <ArduinoJson.h>
#include<hivemq_setup.h>
#define DHTTYPE DHT11


using namespace std;

int soilPin=4;
int airPin=34;
int lightPin=35;
int trigPin = 5;    // Trigger
int echoPin = 12;    // Echo
int DHTPin = 18;
DHT dht(DHTPin, DHTTYPE);

void setup() {
  Serial.begin(9600);
  pinMode(soilPin, INPUT);
  pinMode(airPin, INPUT);
  pinMode(lightPin, INPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(DHTPin, INPUT);
  hivemq_setup();
}

void loop() {
  delay(1000);

  // read data
  int soilData = analogRead(soilPin);
  int _moisture = 100 - ((soilData / 4095.00) * 100);
  int gasData = digitalRead(airPin); //HIGH or LOW
  int lightData = analogRead(lightPin);
  digitalWrite(trigPin, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  int duration = pulseIn(echoPin, HIGH);
  float distanceData = (duration * 0.034) / 2;
  float humidity = dht.readHumidity();        
  float temperature = dht.readTemperature();   

  //convert to json
  JsonDocument doc;
  doc["tmp"] = temperature;
  doc["distance"] = distanceData;
  doc["air"] = gasData;
  doc["light"] = lightData;
  doc["humidity"] = humidity;
  doc["soil moisture"] = _moisture;

  //convert json to c string
  String output;
  serializeJson(doc, output);
  const char* string_c = output.c_str();
  
  //send to hivemq
  send_hive(string_c);
}