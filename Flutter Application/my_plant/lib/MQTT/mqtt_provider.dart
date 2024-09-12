import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_plant/screens/HomeScreen/PlantHealth.dart';
import 'mqtt_service.dart';
import 'package:intl/intl.dart';

class MQTTProvider with ChangeNotifier {
  PlantHealthResult _plantHealth = PlantHealthResult('Unknown', []);
  PlantHealthResult get plantHealth => _plantHealth;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final MQTTService _mqttService = MQTTService();
  Map<String, dynamic> _sensorData = {};
  Map<String, dynamic> _latestData = {};

  Map<String, dynamic> get sensorData => _sensorData;

  DateTime? _lastRefreshTime;
  DateTime? _nextWateringTime;
  Timer? _autoRefreshTimer;

  bool _buzzerOn = false;
  bool _greenLEDOn = false;
  bool _redLEDOn = false;

  bool get buzzerOn => _buzzerOn;
  bool get greenLEDOn => _greenLEDOn;
  bool get redLEDOn => _redLEDOn;

  MQTTProvider() {
    _setupAutoRefresh();
    waterPlantBy();
    _plantHealth = PlantHealthResult('Unknown', []);
  }

  void _setupAutoRefresh() {
    // sensors readings will be refreshed every 1 minute
    _autoRefreshTimer = Timer.periodic(Duration(minutes: 1), (_) {
      refreshData();
    });
  }

  Future<void> connectAndSubscribe() async {
    _isLoading = true;
    notifyListeners();
    await _connect();
    await refreshData();
  }

  Future<void> _connect() async {
    await _mqttService.connect();
    _mqttService.dataStream.listen((data) {
      _latestData = data;
    });
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    await _connect();

    await Future.delayed(Duration(seconds: 1)); // Simulate refresh delay

    // Parse numeric values to ensure they're stored as numbers
    _sensorData = Map.from(_latestData.map((key, value) {
      if (value is String) {
        return MapEntry(key, double.tryParse(value) ?? value);
      }
      return MapEntry(key, value);
    }));

    _lastRefreshTime = DateTime.now(); // Update the last refresh time

    // Calculate plant health
    _plantHealth = calculatePlantHealth(_sensorData);

    waterPlantBy(); // Call this after updating _sensorData

    _isLoading = false;
    notifyListeners();
  }

  String get lastRefreshTimeFormatted {
    return _lastRefreshTime == null
        ? "Never refreshed"
        : DateFormat('EEE, MMM d, hh:mm a').format(_lastRefreshTime!);
  }

  void waterPlantBy() {
    // Parse the soil moisture value to a double, defaulting to 0.0 if it can't be parsed
    double soilMoisture =
        double.tryParse(_sensorData['soilMoisture'].toString()) ?? 0.0;

    const double highMoistureThreshold = 70.0;
    const double mediumMoistureThreshold = 50.0;
    const double lowMoistureThreshold = 30.0;

    int hoursUntilNextWatering;

    if (soilMoisture >= highMoistureThreshold) {
      hoursUntilNextWatering = 48;
    } else if (soilMoisture >= mediumMoistureThreshold) {
      hoursUntilNextWatering = 24;
    } else if (soilMoisture >= lowMoistureThreshold) {
      hoursUntilNextWatering = 12;
    } else {
      hoursUntilNextWatering = 6;
    }

    _nextWateringTime =
        DateTime.now().add(Duration(hours: hoursUntilNextWatering));
    notifyListeners();
  }

  String get wateringTimeFormatted {
    return _nextWateringTime == null
        ? "Undetermined"
        : DateFormat('EEE, MMM d, hh:mm a').format(_nextWateringTime!);
  }


  void waterPlant() {
    _mqttService.publishMessage('sensor/event', '100');
    print('Sent message "ON" to the topic: sensor/event');
    // Reset the next watering time
    _nextWateringTime = null;
    waterPlantBy();
    notifyListeners();
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }
}
