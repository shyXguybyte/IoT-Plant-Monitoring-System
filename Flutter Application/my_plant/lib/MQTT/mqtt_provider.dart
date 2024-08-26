import 'dart:async';
import 'package:flutter/foundation.dart';
import 'mqtt_service.dart';
import 'package:intl/intl.dart';

class MQTTProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final MQTTService _mqttService = MQTTService();
  Map<String, dynamic> _sensorData = {};
  Map<String, dynamic> _latestData = {};

  Map<String, dynamic> get sensorData => _sensorData;

  DateTime? _lastRefreshTime;
  DateTime? _nextWateringTime;
  Timer? _autoRefreshTimer;

  MQTTProvider() {
    _setupAutoRefresh();
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
    await refreshData(); // Initial data fetch
  }

  Future<void> _connect() async {
    await _mqttService.connect();
    _mqttService.dataStream.listen((data) {
      _latestData = data; // Store the latest data without notifying
    });
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    // Disconnect and reconnect to ensure fresh connection
    //await _mqttService.disconnect();
    await _connect();

    await Future.delayed(Duration(seconds: 1)); // Simulate refresh delay
    _sensorData = Map.from(_latestData); // Copy the latest data
    _lastRefreshTime = DateTime.now(); // Update the last refresh time
    _isLoading = false;
    notifyListeners();
  }

  String get lastRefreshTimeFormatted {
    if (_lastRefreshTime == null) return "Never refreshed";
    return DateFormat('EEE, MMM d, hh:mm a').format(_lastRefreshTime!);
  }

  void waterPlant() {
    _mqttService.publishMessage('sensor/event', '1');
    print('sent message "ON" to the topic: sensor/event');
  }

  void waterPlantBy() {
    // Extract the soil moisture value from the sensor data
    double soilMoisture = _sensorData['soilMoisture'] ?? 0.0;

    // Define thresholds and watering intervals
    const double highMoistureThreshold = 70.0;
    const double mediumMoistureThreshold = 50.0;
    const double lowMoistureThreshold = 30.0;

    int hoursUntilNextWatering;

    // Determine the watering interval based on soil moisture level
    if (soilMoisture >= highMoistureThreshold) {
      hoursUntilNextWatering = 48; // Next watering in 2 days
    } else if (soilMoisture >= mediumMoistureThreshold) {
      hoursUntilNextWatering = 24; // Next watering in 1 day
    } else if (soilMoisture >= lowMoistureThreshold) {
      hoursUntilNextWatering = 12; // Next watering in 12 hours
    } else {
      hoursUntilNextWatering = 6; // Next watering in 6 hours
    }

    // Calculate the next watering time
    DateTime now = DateTime.now();
    _nextWateringTime = now.add(Duration(hours: hoursUntilNextWatering));

    // Notify listeners to update the UI or other dependent components
    notifyListeners();
  }

  String get WateringTimeFormatted {
    if (_nextWateringTime == null) return "DATE";
    return DateFormat('EEE, MMM d, hh:mm a').format(_nextWateringTime!);
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }
}
