import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_plant/MQTT/mqtt_provider.dart';
import 'package:my_plant/screens/signIn.dart';
import 'package:my_plant/screens/stats.dart';
import 'package:my_plant/utils/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

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
            print('Building HomeScreen with sensor data: $sensorData');

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
                                      '${sensorData['light']} lux',
                                      'Light Intensity',
                                      Colors.lightGreen.shade100),
                                  _buildStatCard(
                                      '${sensorData['temperature']}°C',
                                      'Temperature',
                                      Colors.lightGreen.shade100),
                                  _buildStatCard('${sensorData['humidity']}%',
                                      'Humidity', Colors.lightGreen.shade100),
                                  _buildStatCard(
                                      '${sensorData['soilMoisture']}%',
                                      'Soil Moisture',
                                      Colors.lightGreen.shade100),
                                  _buildStatCard(
                                      '${sensorData['airQuality']}%',
                                      'Air Quality',
                                      Colors.lightGreen.shade100),
                                  _buildStatCard(
                                      '${sensorData['waterTankLevel']}%',
                                      'Water Tank Level',
                                      Colors.lightGreen.shade100),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Water the Plant by',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        mqttProvider.WateringTimeFormatted,
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
                                      mqttProvider.waterPlant();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.water_drop,
                                            color: Colors.white, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Water the plant',
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
                        PageTransition(
                          child: const StatsScreen(),
                          type: PageTransitionType.rightToLeft,
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

  Widget _buildStatCard(String value, String label, Color color) {
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
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
