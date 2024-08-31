String calculatePlantHealth(Map<String, dynamic> sensorData) {
  double temperature = sensorData['temperature'] ?? 0;
  double waterTankLevel = sensorData['waterTankLevel'] ?? 0;
  double airQuality = sensorData['airQuality'] ?? 0;
  double light = sensorData['light'] ?? 0;
  double humidity = sensorData['humidity'] ?? 0;
  double soilMoisture = sensorData['soilMoisture'] ?? 0;

  // Simple equation for plant health
  double healthScore = (temperature * 0.2) +
      (waterTankLevel * 0.2) +
      (airQuality * 0.1) +
      (light * 0.1) +
      (humidity * 0.2) +
      (soilMoisture * 0.2);

  if (healthScore > 75) {
    return 'Good';
  } else if (healthScore > 50) {
    return 'Moderate';
  } else {
    return 'Needs Attention';
  }
}
