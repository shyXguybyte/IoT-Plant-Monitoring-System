import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_plant/screens/home_screen.dart';
import 'package:my_plant/utils/colors.dart';
import 'package:page_transition/page_transition.dart'; // Import your constants

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plant Metrics Overview',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Constants.primaryColor, // Use your primary color
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: const HomeScreen(),
                type: PageTransitionType.leftToRight,
              ),
            ); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add your widgets here
            // For example, charts or data metrics

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Example of a stat card, customize as needed
                    _buildStatCard('104.2 lux', 'Light Intensity'),
                    SizedBox(height: 16),
                    _buildStatCard('29.5°C', 'Temperature'),
                    SizedBox(height: 16),
                    _buildStatCard('17.0%', 'Moderate Humidity'),
                    // Add more stat cards or widgets here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
