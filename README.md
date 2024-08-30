# 🌱 IoT Plant Monitoring System

Welcome to our IoT Plant Monitoring System project, developed as part of the 2024 summer training at the Faculty of Computers and Data Science, Alexandria University.
---

## Table of Contents

1. [📚 Team Members](#-team-members)
2. [🌍 Project Overview](#-project-overview)
3. [🛠️ Hardware Components](#️-hardware-components)
4. [📹 Project Demo](#-project-demo)
5. [🔄 Circuit Diagram](#-circuit-diagram)
6. [💻 Software Components](#-software-components)
7. [🏗️ System Architecture](#️-system-architecture)
8. [🧩 Data Flow Architecture](#-data-flow-architecture)
9. [📱 Flutter Application](#-flutter-application)
10. [🔗 Useful Resources](#-useful-resources)

---
## 📚 Team Members
- **Shehab Magdy Elsayed**         - ID: 22011558
- **Samy Adel**                    - ID: 22010107
- **Ahmed Fekry Abd-Elhamid**      - ID: 22010317
- **Abdulrahman Mohamed Mahmoud**  - ID: 22011460
- **Khaled Rabie**                 - ID: 22010332

---

## 🌍 Project Overview

Our IoT Plant Monitoring System helps users maintain the health of their plants by monitoring various environmental factors such as humidity and soil moisture. With real-time data available on a Flutter application, users can:

- **💧 Monitor**: Receive live updates on plant conditions, including when to water the plant or refill the water tank.
- **🔔 Get Notified**: Receive notifications through the app or via hardware alerts (LEDs, buzzers) when the plant requires attention.
- **📊 Visualize Data**: View historical data, visualizations, and predictive analytics to understand the overall health of the plant.
- **💻 Control Hardware**: Use the app to remotely control hardware components like the water pump, or use local controls like the keypad and push button.

---

## 🛠️ Hardware Components

### Microcontroller
- **ESP32**

### Sensors
- **🌱 Soil Moisture Sensor**
- **🌫️ MQ135 (Air Quality)**
- **💡 LDR (Light Dependent Resistor)**
- **🌡️ DHT11 (Temperature & Humidity)**
- **📏 Ultrasonic Sensor**

### Actuators
- **🚰 Water Pump**
- **🖥️ LCD I2C**
- **💡 LED**
- **🔊 Buzzer**

### Modules & Accessories
- **🔌 Relay**
- **🔋 9V Battery & Cap**
- **🎛️ Keypad**
- **🔧 Breadboard**
- **🔗 I2C**
- **🪢 Jumper Wires**
- **🔘 Push Button**
- **⚙️ Potentiometer**
  
---

## 📹 Project Demo

Check out the video below for a demonstration of the project:

  [![Watch the video](https://img.youtube.com/vi/x0xBuETWe_w/hqdefault.jpg)](https://youtu.be/x0xBuETWe_w)

---

## 🔄 Circuit Diagram

[![Circuit Diagram](https://github.com/user-attachments/assets/337df08a-8086-4c6a-934b-1cb8cfbdcfb2)](https://wokwi.com/)
- **Simulation**: [Wokwi](https://wokwi.com/)

---

## 💻 Software Components

![image](https://github.com/user-attachments/assets/fab72802-c4a7-4658-8c16-70ea020d4e6d)

1. **Visual Studio Code**
   - [Visual Studio Code](https://code.visualstudio.com/) (VS Code) is our recommended Integrated Development Environment (IDE) for ESP32 programming
   - Download and install [here](https://code.visualstudio.com/download)

2. **PlatformIO on Visual Studio Code**
   - A powerful, open-source ecosystem for IoT development. It provides a seamless experience similar to Arduino but with enhanced features and flexibility.
   - Integrated development environment within **Visual Studio Code**
   - Robust platform for ESP32 programming
   - Extensive library management and board support
   - Read my Medium article : [Getting Started with ESP32 and PlatformIO: A Step-by-Step Guide](https://medium.com/@shehab2003magdy/getting-started-with-esp32-and-platformio-a-step-by-step-guide-5713e16f3c4b).

3. **HiveMQ**
   - Used for MQTT communication between the ESP32 and the app.
   - Read my Medium article [Connecting ESP32 to HiveMQ for Real-Time IoT Data Streaming with MQTT](https://medium.com/@shehab2003magdy/connecting-esp32-to-hivemq-for-real-time-iot-data-streaming-with-mqtt-8813f48cb1a4).

4. **Node-RED**
   - For data logging and automation.

5. **Google Sheets API**
   - To store and manage historical sensor data.

6. **Flutter**
   - Front-end application development framework.
   - installation guide [here](https://youtu.be/5Z8EpASF1Dg?si=5uNI8PtjoZVQK1E_)

7. **Firebase**
   - Backend services for authentication and database management.

8. **Grafana**
   - For advanced data visualization and dashboards.
     
![Untitled design (5)](https://github.com/user-attachments/assets/19fef212-ab03-4492-a099-5a87504491d9)




---

## 🏗️ System Architecture

![image](https://github.com/user-attachments/assets/e1f078a8-4495-4e2e-af6c-3d5e4c206305)

- **Diagram**: [Draw.io](https://app.diagrams.net/)
---
## 🧩 Data Flow Architecture

Our system utilizes a multi-component architecture to ensure efficient data collection, processing, and visualization. Here's an overview of the data flow:

### 1. ESP32 Microcontroller
- **Role**: Data acquisition and transmission
- **Function**: Collects sensor readings (e.g., soil moisture, temperature)
- **Protocol**: Publishes data to HiveMQ broker using MQTT which is a lightweight, publish-subscribe, machine-to-machine network protocol used for message queuing services
- **Topic**: `sensor/data` (example)

### 2. Node-RED
- **Role**: Data processing and automation
- **Functions**:
  - Subscribes to the ESP32's MQTT topic `sensor/data`
  - Processes incoming sensor data
  - Handles data logging
  - Manages automation tasks
- **Integration**: Interacts with Google Sheets for data storage
 ![image](https://github.com/user-attachments/assets/7dad1ecd-4d86-4f8a-8bab-4357b5d79f7f)

### 3. Flutter Mobile Application
- **Role**: User interface and data visualization
- **Functions**:
  - Subscribes to the same MQTT topic as Node-RED
  - Displays real-time sensor data to users
  - Retrieves and visualizes historical data using `syncfusion_flutter_charts` library
- **Integration**: 
  - Connects to HiveMQ for live data
  - Interfaces with Google Sheets for historical data access
  - Uses Firebase Authentication for user login and registration
---

## 📱 Flutter Application




https://github.com/user-attachments/assets/3b13b05a-6c41-40dc-b1b4-806cb5ede608





Our Flutter app provides a smooth, user-friendly experience:

- **🌟 Onboarding**: Simple and intuitive onboarding screens.
- **🔐 Authentication**: Secure login/signup with email/password or Google login.
- **🌡️ Real-Time Data**: View real-time sensor data on the Home screen, with automatic updates every 5 minutes or manual refresh.
- **📊 Stats Page**: Navigate to view historical data and charts retreived from the Google sheet.

| Onboarding 1                                                                                             | Onboarding 2                                                                                             | Onboarding 3                                                                                             |
|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| <img src="https://github.com/user-attachments/assets/57b8ba34-1ac1-4592-b4fd-cb35494ff6f3" width="200"/>  | <img src="https://github.com/user-attachments/assets/e6ace5c1-a6d5-4f20-87f5-512f1dc01cef" width="200"/>  | <img src="https://github.com/user-attachments/assets/6bd0daf7-0391-4acb-a99a-1d3ec3a41588" width="200"/>  |

| Login                                                                                                     | Forget Password                                                                                           | Signup                                                                                                    |
|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| <img src="https://github.com/user-attachments/assets/11de68b8-1d60-4087-b567-ea2f999d3064" width="200"/>  | <img src="https://github.com/user-attachments/assets/dc6e317b-c54f-4907-ae7b-8803d9658a7e" width="200"/>  | <img src="https://github.com/user-attachments/assets/ba62074f-d21a-4ec7-b9ef-d414dcf8bdcb" width="200"/>  |

| Home                                                                                                      | Stats                                                                                                     |                                                                                                           |
|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| <img src="https://github.com/user-attachments/assets/447f7996-fbc8-42ac-82d1-9e75f2fb0e54" width="200"/>  | <img src="https://github.com/user-attachments/assets/0a396308-aeb5-4184-8e06-fd484c6056f7" width="200"/>  |                                                                                                           |



---

## 🔗 Useful Resources

- **Connecting ESP32 to HiveMQ**: [Shehab Magdy on Medium](https://medium.com/@shehab2003magdy/connecting-esp32-to-hivemq-for-real-time-iot-data-streaming-with-mqtt-8813f48cb1a4)
- **Getting Started with ESP32 and PlatformIO**: [Shehab Magdy on Medium](https://medium.com/@shehab2003magdy/getting-started-with-esp32-and-platformio-a-step-by-step-guide-5713e16f3c4b)
- **Flutter & Google Sheets**: [Mitch Koko](https://youtu.be/ZSSERiYLv3c?si=epo_v371MWGSFaB5)
- **Rotato for Flutter Screen Display**: [Rotato App](https://app.rotato.app/)
- **Flutter Home page Design Theme**: [GitHub Repository](https://github.com/NinadRao0707/Plant-Monitoring-App)
- **Plant App - Flutter UI - Speed Code**: [The Flutter Way](https://youtu.be/LN668OAUrK4?si=FvD7_jbB3qGzvQRN)
- **Adding Firebase to Flutter**: [Firebase Docs](https://firebase.google.com/docs/android/setup)
- **Firebase Email & Password Login**: [Dear Programmer](https://youtu.be/qqWzE5TjgQo?si=b0hkSDP5wzBnXDMP)
- **Google Login with Firebase**: [Droidmonk](https://youtu.be/VCrXSFqdsoA?si=mBqnk8wCuj6L5m_b)
- **Grafana Dashboards**: [Grafana Docs](https://grafana.com/docs/grafana/latest/dashboards/)
- **Grafana Dashboards and google sheet setup**: [Thetips4you](https://youtu.be/GnWZsHjM5To?si=OKpXtIV3T9UK2aPt)
- **Connect and record data to Google Sheets from Node-RED**: [Yaser Ali Husen](https://youtu.be/JKh9qn0fxew?si=aFuNjgU23I0JpSqh)

---

We welcome contributions to improve this plant care system! Feel free to explore our project, open issues, or submit pull requests. 🌿
