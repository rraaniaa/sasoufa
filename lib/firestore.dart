import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ChartData> temperatureData = [];
  List<ChartData> humidityData = [];

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  void _loadChartData() {
    _firestore.collection('weather_data').snapshots().listen((snapshot) {
      print('Number of documents: ${snapshot.docs.length}');
      temperatureData.clear();
      humidityData.clear();

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['timestamp'] as Timestamp?;
        if (timestamp != null) {
          final timestampValue = timestamp.millisecondsSinceEpoch.toDouble();

          // Check if 'temperature' and 'humidity' are not null before adding them to the list
          final temperature = data['temperature'] as double?;
          final humidity = data['humidity'] as double?;

          if (temperature != null && humidity != null) {
            temperatureData.add(ChartData(timestampValue, temperature));
            humidityData.add(ChartData(timestampValue, humidity));
          }
        }
      }

      setState(() {}); // Rebuild the widget with updated data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature and Humidity Chart'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Temperature Chart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              buildLineChart(temperatureData),
              const SizedBox(height: 20),
              const Text(
                'Humidity Chart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              buildLineChart(humidityData),
            ],
          ),
        ),
      ),
    );
  }

  SfCartesianChart buildLineChart(List<ChartData> data) {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(),
      primaryYAxis: NumericAxis(),
      series: <LineSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          dataSource: data,
          xValueMapper: (ChartData chartData, _) => chartData.timestamp,
          yValueMapper: (ChartData chartData, _) => chartData.value,
          dataLabelSettings: DataLabelSettings(isVisible: true), // Show data labels
        ),
      ],
    );
  }
}

class ChartData {
  final double timestamp;
  final double value;

  ChartData(this.timestamp, this.value);
}
