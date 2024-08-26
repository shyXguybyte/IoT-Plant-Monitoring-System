import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_plant/screens/Stats%20screen/google_sheets_data.dart';
import 'package:my_plant/screens/home_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class Stats extends StatefulWidget {
  final GoogleSheetsService dataService;

  Stats({required this.dataService});

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<List<String>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await widget.dataService.fetchData();
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  double calculatePlantHealth(ChartData data) {
    // These weights should be adjusted based on domain knowledge or more sophisticated analysis
    const double tempWeight = 0.2;
    const double moistureWeight = 0.3;
    const double humidityWeight = 0.2;
    const double lightWeight = 0.2;
    const double gasWeight = 0.1;

    // Normalize each parameter to a 0-100 scale (you may need to adjust these ranges)
    double tempScore =
        100 - (((data.temperature - 20).abs() / 10) * 100).clamp(0, 100);
    double moistureScore = data.soilMoisture.clamp(0, 100);
    double humidityScore = data.humidity.clamp(0, 100);
    double lightScore = (data.lightIntensity / 1000 * 100).clamp(0, 100);
    double gasScore =
        100 - data.gas.clamp(0, 100); // Assuming lower gas is better

    // Calculate weighted average
    return (tempScore * tempWeight +
            moistureScore * moistureWeight +
            humidityScore * humidityWeight +
            lightScore * lightWeight +
            gasScore * gasWeight)
        .clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading Data')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<ChartData> chartData = _getChartData();

    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0), // Custom height
            child: AppBar(
              backgroundColor: Colors.lightGreen.shade100, // Example color
              title: Align(
                alignment: Alignment.center, // Center horizontally
                child: Container(
                  margin:
                      EdgeInsets.only(top: 10.0), // Adjust vertical position
                  child: Text(
                    'Sensor Data Visualization',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            color: Colors.lightGreen.shade100, // Set the background color here
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSingleParameterChart(chartData, 'Temperature'),
                    _buildSingleParameterChart(chartData, 'WaterTankLevel'),
                    _buildSingleParameterChart(chartData, 'Gas'),
                    _buildSingleParameterChart(chartData, 'LightIntensity'),
                    _buildSingleParameterChart(chartData, 'Humidity'),
                    _buildSingleParameterChart(chartData, 'SoilMoisture'),
                    _buildCombinedChart(chartData),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 34,
          left: 10,
          child: IconButton(
            icon: Icon(Icons.login, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlantHealthChart(List<ChartData> chartData) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          height: 300,
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'Predicted Plant Health Over Time',
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('MM/dd HH:mm'),
              intervalType: DateTimeIntervalType.auto,
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 2),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: 'Plant Health Score',
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              majorGridLines: MajorGridLines(width: 0.5),
              minimum: 0,
              maximum: 100,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enableDoubleTapZooming: true,
              enablePanning: true,
            ),
            series: <ChartSeries>[
              LineSeries<ChartData, DateTime>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.timestamp,
                yValueMapper: (ChartData data, _) => calculatePlantHealth(data),
                name: 'Plant Health',
                color: Colors.green,
                width: 2,
                markerSettings: MarkerSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleParameterChart(
      List<ChartData> chartData, String parameter) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          height: 300,
          child: SfCartesianChart(
            title: ChartTitle(
              text: '$parameter Over Time',
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('MM/dd HH:mm'),
              intervalType: DateTimeIntervalType.auto,
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 2),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: parameter,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              majorGridLines: MajorGridLines(width: 0.5),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enableDoubleTapZooming: true,
              enablePanning: true,
            ),
            series: <ChartSeries>[
              LineSeries<ChartData, DateTime>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.timestamp,
                yValueMapper: (ChartData data, _) =>
                    data.getParameterValue(parameter),
                name: parameter,
                color: Colors.green,
                width: 2,
                markerSettings: MarkerSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedChart(List<ChartData> chartData) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          height: 400,
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'All Sensor Data',
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('MM/dd HH:mm'),
              intervalType: DateTimeIntervalType.auto,
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 2),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: 'Values',
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              majorGridLines: MajorGridLines(width: 0.5),
            ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              textStyle: TextStyle(fontSize: 12),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enableDoubleTapZooming: true,
              enablePanning: true,
            ),
            series: _getChartSeries(chartData),
          ),
        ),
      ),
    );
  }

  List<ChartSeries<ChartData, DateTime>> _getChartSeries(
      List<ChartData> chartData) {
    return [
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.temperature,
        name: 'Temperature',
        color: Colors.redAccent,
        width: 2,
        markerSettings: MarkerSettings(isVisible: true),
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.waterTankLevel,
        name: 'WaterTankLevel',
        color: Colors.green,
        width: 2,
        markerSettings: MarkerSettings(isVisible: true),
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.gas,
        name: 'Gas',
        color: Colors.greenAccent,
        width: 2,
        markerSettings: MarkerSettings(isVisible: true),
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.lightIntensity,
        name: 'LightIntensity',
        color: const Color.fromARGB(255, 255, 77, 0),
        width: 2,
        markerSettings: MarkerSettings(isVisible: true),
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.humidity,
        name: 'Humidity',
        color: Colors.purpleAccent,
        width: 2,
        markerSettings: MarkerSettings(isVisible: true),
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.soilMoisture,
        name: 'SoilMoisture',
        color: Colors.orangeAccent,
        width: 2,
        markerSettings: MarkerSettings(isVisible: true),
      ),
    ];
  }

  List<ChartData> _getChartData() {
    List<ChartData> chartData = [];
    for (var row in _data.skip(1)) {
      // Skip header row
      if (row.length >= 7) {
        DateTime timestamp = DateTime.parse(row[0]);
        chartData.add(ChartData(
          timestamp: timestamp,
          temperature: double.tryParse(row[1]) ?? 0,
          waterTankLevel: double.tryParse(row[2]) ?? 0,
          gas: double.tryParse(row[3]) ?? 0,
          lightIntensity: double.tryParse(row[4]) ?? 0,
          humidity: double.tryParse(row[5]) ?? 0,
          soilMoisture: double.tryParse(row[6]) ?? 0,
        ));
      }
    }
    return chartData;
  }
}

class ChartData {
  final DateTime timestamp;
  final double temperature;
  final double waterTankLevel;
  final double gas;
  final double lightIntensity;
  final double humidity;
  final double soilMoisture;

  ChartData({
    required this.timestamp,
    required this.temperature,
    required this.waterTankLevel,
    required this.gas,
    required this.lightIntensity,
    required this.humidity,
    required this.soilMoisture,
  });

  double? getParameterValue(String parameter) {
    switch (parameter) {
      case 'Temperature':
        return temperature;
      case 'WaterTankLevel':
        return waterTankLevel;
      case 'Gas':
        return gas;
      case 'LightIntensity':
        return lightIntensity;
      case 'Humidity':
        return humidity;
      case 'SoilMoisture':
        return soilMoisture;
      default:
        return null;
    }
  }
}
