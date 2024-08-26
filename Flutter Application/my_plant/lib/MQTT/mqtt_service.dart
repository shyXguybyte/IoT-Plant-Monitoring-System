import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  MqttServerClient? client;
  final String topic = 'sensor/data';
  final StreamController<Map<String, dynamic>> _dataStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get dataStream => _dataStreamController.stream;

  Future<void> connect() async {
    if (client != null &&
        client!.connectionStatus!.state == MqttConnectionState.connected) {
      return; // Already connected
    }

    client = MqttServerClient.withPort(
      '265546a0ac3d4a9f953424fc8325f520.s1.eu.hivemq.cloud',
      'flutter_client',
      8883,
    );

    client!.secure = true;
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.onConnected = onConnected;
    client!.onSubscribed = onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client!.connectionMessage = connMess;

    try {
      await client!.connect('samyadel604@gmail.com', 'SamyAdel359');
      print('MQTT connection successful');
      subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('MQTT connection failed: $e');
      client!.disconnect();
    }

    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received MQTT message: $payload');
      _dataStreamController.add(parseJson(payload));
    });
  }

  void onConnected() {
    print('Connected');
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void subscribeToTopic(String topic) {
    client!.subscribe(topic, MqttQos.atLeastOnce);
  }

  void disconnect() {
    client?.disconnect();
  }

  Map<String, dynamic> parseJson(String payload) {
    print('Parsing payload: $payload');
    try {
      // Attempt to parse the JSON string
      final Map<String, dynamic> jsonData = json.decode(payload);

      // Create a new map with the expected keys, using default values if keys are missing
      final parsedData = {
        'temperature': jsonData['tmp']?.toString() ?? 'N/A',
        'waterTankLevel': jsonData['distance']?.toString() ?? 'N/A',
        'airQuality': jsonData['air']?.toString() ?? 'N/A',
        'light': jsonData['light']?.toString() ?? 'N/A',
        'humidity': jsonData['humidity']?.toString() ?? 'N/A',
        'soilMoisture': jsonData['soil moisture']?.toString() ?? 'N/A',
      };

      print('Parsed data: $parsedData');
      return parsedData;
    } catch (e) {
      print('Error parsing JSON: $e');
      // Return a map with default 'N/A' values if parsing fails
      return {
        'light': 'N/A',
        'temperature': 'N/A',
        'humidity': 'N/A',
        'soilMoisture': 'N/A',
        'airQuality': 'N/A',
        'waterTankLevel': 'N/A',
      };
    }
  }
}
