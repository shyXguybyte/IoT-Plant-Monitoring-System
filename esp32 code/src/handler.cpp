#include <handler.h>
#include<hivemq.h>
#include "sensors.h"
#include <wifi_setup.h>

QueueHandle_t xEventQueue;
const TickType_t xDelay = 15000 / portTICK_PERIOD_MS;

void handler_setup(){
    //setup tasks needed
    xTaskCreate(&sensor_reading, "ReadingSensors", 8192, NULL, 1, NULL); //sensor reading task
    xTaskCreate(&eventHandlerTask, "EventHandler", 8192, NULL, 1, NULL); //a task to handle incoming events from mqtt
    xTaskCreate(&keeping_connection, "MQTTKeeper", 8192, NULL, 1, NULL); // keep mqtt connection
    xTaskCreate(&wifiMonitoringTask, "WiFi Monitor", 4096, NULL, 1, NULL); //monitor wifi status and take action
    xEventQueue = xQueueCreate(10, sizeof(SystemEvent_t));
    Serial.println("Handler is ready.");
}

// activate the pumb when event is received 
void activatePumb(){
    Serial.println("Pumb Activated");
    digitalWrite(RELAY_PIN, HIGH);
    vTaskDelay( xDelay );
    digitalWrite(RELAY_PIN, LOW);
    Serial.println("Pumb Deactivated");

}

// a function to send system events to the handler queue
bool sendSystemEvent(SystemEvent_t event) {
    BaseType_t xStatus = xQueueSendToBack(xEventQueue, &event, (TickType_t) 10); 
    if (xStatus != pdPASS) {
        vTaskDelay(pdMS_TO_TICKS(500));
        return false;
    }
    vTaskDelay(pdMS_TO_TICKS(500));
    return true;
}

//takes action upon the received event
void eventHandlerTask(void* pvParameters){
  SystemEvent_t receivedEvent;
  while (1) {
    // take the event from the queue
        if (xQueueReceive(xEventQueue, &receivedEvent, portMAX_DELAY) == pdTRUE) {
            switch (receivedEvent) {
                case EVENT_ACTIVATE_PUMB:
                    activatePumb();
                    break;
                default:
                    Serial.println("Unusual event occured!");
                    break;
            }
        }
    }
}