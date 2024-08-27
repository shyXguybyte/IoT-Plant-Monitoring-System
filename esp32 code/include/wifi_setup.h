#ifndef WIFI_H
#define WIFI_H
#include <WiFi.h>

void start_wifi();
void wifiMonitoringTask(void* pvParameters);

#endif