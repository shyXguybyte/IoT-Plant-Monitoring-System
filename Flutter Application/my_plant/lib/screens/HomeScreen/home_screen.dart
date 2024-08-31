import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_plant/MQTT/mqtt_provider.dart';
import 'package:my_plant/screens/Stats%20screen/google_sheets_data.dart';
import 'package:my_plant/screens/signIn.dart';
import 'package:my_plant/utils/colors.dart';
import 'package:provider/provider.dart';

import '../Stats screen/stats.dart';
import 'PlantHealth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<MQTTProvider>(
          builder: (context, mqttProvider, child) {
            final sensorData = mqttProvider.sensorData;

            // Calculate plant health based on sensor readings
            String plantHealth = calculatePlantHealth(sensorData);

            // Map health status to icons
            IconData healthIcon = plantHealth == 'Good'
                ? Icons.check_circle
                : plantHealth == 'Moderate'
                    ? Icons.warning
                    : Icons.error;

            // Map health status to colors
            Color healthColor = plantHealth == 'Good'
                ? Colors.green
                : plantHealth == 'Moderate'
                    ? Colors.orange
                    : Colors.red;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Overview',
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  _buildStatCard(
                                      '${sensorData['temperature']} °C',
                                      'Temperature',
                                      Colors.lightGreen.shade100,
                                      Icons.thermostat), // Added Icons
                                  _buildStatCard(
                                      '${sensorData['waterTankLevel']} liter',
                                      'Water Tank Level',
                                      Colors.lightGreen.shade100,
                                      Icons.local_drink),
                                  _buildStatCard(
                                      '${sensorData['airQuality']} ppm',
                                      'Air Quality',
                                      Colors.lightGreen.shade100,
                                      Icons.air),
                                  _buildStatCard(
                                      '${sensorData['light']} lux',
                                      'Light Intensity',
                                      Colors.lightGreen.shade100,
                                      Icons.light_mode),
                                  _buildStatCard(
                                      '${sensorData['humidity']}%',
                                      'Humidity',
                                      Colors.lightGreen.shade100,
                                      Icons.water),
                                  _buildStatCard(
                                      '${sensorData['soilMoisture']}%',
                                      'Soil Moisture',
                                      Colors.lightGreen.shade100,
                                      Icons.eco),
                                ],
                              ),
                              SizedBox(height: 15),
                              // Plant Health Status with Icon
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    healthIcon,
                                    color: healthColor,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Plant Health: ',
                                    style: GoogleFonts.lato(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    plantHealth,
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: healthColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Refresh at',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        mqttProvider.lastRefreshTimeFormatted,
                                        style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      Provider.of<MQTTProvider>(context,
                                              listen: false)
                                          .refreshData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 36, vertical: 10),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.refresh,
                                            color: Colors.white, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Refresh All',
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 31,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.login, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 31,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Stats(dataService: GoogleSheetsService()),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      textStyle: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bar_chart, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Stats',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Display connection status and loading indicator
                if (!mqttProvider.isLoading && !mqttProvider.sensorData.isEmpty)
                  Positioned(
                    bottom: 680,
                    left: 30,
                    child: Text(
                      "Connected",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                      ),
                    ),
                  )
                else
                  Positioned(
                    bottom: 680,
                    left: 30,
                    child: Text(
                      "Disconnected",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),
                if (mqttProvider.isLoading || mqttProvider.sensorData.isEmpty)
                  Positioned(
                    bottom: 680,
                    left: 130,
                    child: SizedBox(
                      width: 24, // Set the desired width
                      height: 24, // Set the desired height
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        strokeWidth:
                            3.0, // You can adjust the stroke width if needed
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Modified _buildStatCard to include an icon parameter
  Widget _buildStatCard(
      String value, String label, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 28, color: Colors.green.shade900), // Added icon
              SizedBox(width: 10),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
