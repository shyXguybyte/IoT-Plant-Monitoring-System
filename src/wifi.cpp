#include <WiFi.h>
#include <wifi_setup.h>

#define WIFI_SSID "Tigers"
#define WIFI_PASSWORD "WKZ6Z8RLBZELB"

void start_wifi() {
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