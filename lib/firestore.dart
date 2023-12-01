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
                'Temperature and Humidity Chart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: _fetchChartData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Erreur lors du chargement des données.');
                    } else {
                      return _buildChart(snapshot.data?['temperature'], snapshot.data?['humidity']);
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, List<ChartData>>> _fetchChartData() async {
    final snapshot = await _firestore.collection('weather_data').get();

    print('Number of documents: ${snapshot.docs.length}');

    List<ChartData> temperatureData = [];
    List<ChartData> humidityData = [];

    for (final doc in snapshot.docs) {
      print('Document Name: ${doc.id}, Data: ${doc.data()}');

      final data = doc.data() as Map<String, dynamic>;
      final timestamp = data['timestamp'] as Timestamp?;
      final value = data['value'] as double?;

      if (timestamp != null && value != null) {
        final timestampValue = timestamp.millisecondsSinceEpoch.toDouble();
        print('Timestamp: $timestampValue, Value: $value');

        if (doc.id == 'temperature') {
          temperatureData.add(ChartData(timestampValue, value));
        } else if (doc.id == 'humidity') {
          humidityData.add(ChartData(timestampValue, value));
        }
      }
    }

    return {'temperature': temperatureData, 'humidity': humidityData};
  }

 Widget _buildChart(List<ChartData>? temperatureData, List<ChartData>? humidityData) {
  if (temperatureData == null || humidityData == null) {
    // Gérer le cas où les données sont nulles
    return Text('Aucune donnée disponible.');
  }

  return SizedBox(
    height: 300,
    child: SfCartesianChart(
      key: UniqueKey(),
      primaryXAxis: NumericAxis(),
      primaryYAxis: NumericAxis(),
      series: <LineSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          dataSource: temperatureData,
          xValueMapper: (ChartData chartData, _) => chartData.timestamp,
          yValueMapper: (ChartData chartData, _) => chartData.value,
          name: 'Temperature',
          color: Colors.red,
        ),
        LineSeries<ChartData, double>(
          dataSource: humidityData,
          xValueMapper: (ChartData chartData, _) => chartData.timestamp,
          yValueMapper: (ChartData chartData, _) => chartData.value,
          name: 'Humidity',
          color: Colors.blue,
        ),
      ],
      legend: Legend(isVisible: true),
    ),
  );
}

}

class ChartData {
  final double timestamp;
  final double value;

  ChartData(this.timestamp, this.value);
}
