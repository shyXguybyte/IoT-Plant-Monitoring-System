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
    await _mqttService.connect();
    _mqttService.dataStream.listen((data) {
      _latestData = data; // Store the latest data without notifying
    });
    await refreshData(); // Initial data fetch
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();
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
    _mqttService.publishMessage('sensor/event', 'on');
    print('sent message "on" to the topic: sensor/event');
  }

  void waterPlantBy() {
    // Assume soil moisture is a key indicator
    double soilMoisture = _sensorData['soilMoisture'] ?? 0.0;

    // Define thresholds for soil moisture levels (these are arbitrary)
    int hoursUntilNextWatering;
    if (soilMoisture > 70) {
      hoursUntilNextWatering = 48; // Next watering in 2 days
    } else if (soilMoisture > 50) {
      hoursUntilNextWatering = 24; // Next watering in 1 day
    } else if (soilMoisture > 30) {
      hoursUntilNextWatering = 12; // Next watering in 12 hours
    } else {
      hoursUntilNextWatering = 6; // Next watering in 6 hours
    }

    // Calculate the next watering time
    DateTime now = DateTime.now();
    DateTime nextWateringTime =
        now.add(Duration(hours: hoursUntilNextWatering));

    notifyListeners();
  }

  String get WateringTimeFormatted {
    if (_nextWateringTime == null) return "-----";
    return DateFormat('EEE, MMM d, hh:mm a').format(_nextWateringTime!);
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }
}
