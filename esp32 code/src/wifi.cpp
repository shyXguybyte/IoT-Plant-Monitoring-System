#include <wifi_setup.h>
#include <handler.h>

#define WIFI_SSID "Tigers"
#define WIFI_PASSWORD "WKZ6Z8RLBZELB"

void start_wifi() {
    WiFi.mode(WIFI_STA);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();
}
static bool wifiConnected = false;  // wifi status to know the previous status

void wifiMonitoringTask(void* pvParameters) {
  while (1) {
    if (WiFi.status() == WL_CONNECTED) {
      // WiFi is connected
      if (!wifiConnected) { // Check if we were previously disconnected
        wifiConnected = true; 
      }
    } else {
      // WiFi is disconnected
      if (wifiConnected) { // Check if we were previously connected
        wifiConnected = false;
      }
      start_wifi();
    }
    vTaskDelay(2000 / portTICK_PERIOD_MS); // Check every 2 seconds
  }
}


