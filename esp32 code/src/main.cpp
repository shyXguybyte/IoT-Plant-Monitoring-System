#include <wifi_setup.h>
#include<hivemq.h>
#include <handler.h>
#include <sensors.h>
#include <ArduinoJson.h>

using namespace std;


//send the data to hivemq when ready
void sendData(){
    JsonDocument doc;
    doc["tmp"] = temperatureData;
    doc["distance"] = distanceData;
    doc["air"] = gasData;
    doc["light"] = lightData;
    doc["humidity"] = humidityData;
    doc["soil moisture"] = moistureData;

  //convert json to c string
  String output;
  serializeJson(doc, output);
  
  //send to hivemq
  send_hive(output.c_str());
}


void sensor_reading(void* pvParameters){
  while(1) {
    // reading sensors values
    moistureData = readSoilMoisture();
    gasData = readGas();
    lightData = readLightIntensity();
    distanceData = readDistance();
    humidityData = readHumidity();
    temperatureData = readTemperature();
    Serial.println("Sensors read successfully.");

  //take action upon sensor readings
    if(moistureData < 20 || temperatureData>35) {
      sendSystemEvent(EVENT_ACTIVATE_PUMB);
    }
    //send the data to hive
    sendData();
    //wait 15 seconds for next readings
    vTaskDelay(15000 / portTICK_PERIOD_MS);
  }
}



void setup() {
  Serial.begin(115200); //UART
  // setup pins
  pinMode(SOIL_PIN, INPUT);
  pinMode(GAS_PIN, INPUT);
  pinMode(LIGHT_PIN, INPUT);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  pinMode(DHT_PIN, INPUT);
  pinMode(RELAY_PIN, OUTPUT);

  //initialize the components
  start_wifi();
  hivemq_setup();
  handler_setup();
}

void loop() {}