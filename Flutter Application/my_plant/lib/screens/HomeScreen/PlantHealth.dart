import 'package:flutter/material.dart';

class PlantHealthResult {
  final String overallHealth;
  final List<String> issues;

  PlantHealthResult(this.overallHealth, this.issues);
}

PlantHealthResult calculatePlantHealth(Map<String, dynamic> sensorData) {
  double temperature =
      double.tryParse(sensorData['temperature']?.toString() ?? '0') ?? 0;
  double waterTankLevel =
      double.tryParse(sensorData['waterTankLevel']?.toString() ?? '0') ?? 0;
  double airQuality =
      double.tryParse(sensorData['airQuality']?.toString() ?? '0') ?? 0;
  double light = double.tryParse(sensorData['light']?.toString() ?? '0') ?? 0;
  double humidity =
      double.tryParse(sensorData['humidity']?.toString() ?? '0') ?? 0;
  double soilMoisture =
      double.tryParse(sensorData['soilMoisture']?.toString() ?? '0') ?? 0;

  double healthScore = 0;
  List<String> issues = [];

  // Check each parameter and add to health score and issues list
  if (temperature >= 25 && temperature <= 35) {
    healthScore += 20;
  } else {
    issues.add('Temperature is out of optimal range (25-35°C)');
  }

  // if the water tank level is > 20%
  if (waterTankLevel >= 20) {
    healthScore += 20;
  } else {
    issues.add('Water tank level is low');
  }

  if (airQuality <= 1000) {
    healthScore += 10;
  } else {
    issues.add('Air quality is poor (CO2 > 1000 ppm)');
  }

  if (light >= 1000) {
    healthScore += 10;
  } else {
    issues.add('Light intensity is poor');
  }

  if (humidity >= 40 && humidity <= 80) {
    healthScore += 20;
  } else {
    issues.add('Humidity is out of optimal range (40-80%)');
  }

  if (soilMoisture >= 40 && soilMoisture <= 80) {
    healthScore += 20;
  } else {
    issues.add('Soil moisture is out of optimal range (40-80%)');
  }

  String overallHealth;
  if (healthScore > 75) {
    overallHealth = 'Good';
  } else if (healthScore > 50) {
    overallHealth = 'Moderate';
  } else {
    overallHealth = 'Needs Attention';
  }

  return PlantHealthResult(overallHealth, issues);
}

class PlantHealthDisplay extends StatelessWidget {
  final PlantHealthResult healthResult;

  const PlantHealthDisplay({Key? key, required this.healthResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plant Health: ${healthResult.overallHealth}',
          style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (healthResult.issues.isNotEmpty) ...[
          Text(
            'Issues:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          ...healthResult.issues.map((issue) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('• $issue', style: TextStyle(fontSize: 16)),
              )),
        ],
      ],
    );
  }
}
