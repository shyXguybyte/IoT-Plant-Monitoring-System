#pragma once
#ifndef HANDLER_H
#define HANDLER_H

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

static void sendData();
static void activatePumb();

// define events types
typedef enum {
    EVENT_ACTIVATE_PUMB=1,
    EVENT_DATA_READY_FOR_HIVE_MQ=200,
    EVENT_WIFI_CONNECTED,
    EVENT_WIFI_DISCONNECTED
} SystemEvent_t;

void handler_setup();
void eventHandlerTask(void* pvParameters);
bool sendSystemEvent(SystemEvent_t event);
void sensor_reading(void* pvParameters);

#endif