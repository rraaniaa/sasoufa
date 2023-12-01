import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:picket/firestore.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TemperatureHumidityPage extends StatefulWidget {
  const TemperatureHumidityPage({Key? key}) : super(key: key);

  @override
  _TemperatureHumidityPageState createState() =>
      _TemperatureHumidityPageState();
}

class _TemperatureHumidityPageState extends State<TemperatureHumidityPage> {
  final DatabaseReference _databaseReference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child('picket-9e4f2-default-rtdb');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double temperature = 0.0;
  double humidity = 0.0;

  @override
  void initState() {
    super.initState();
    _databaseReference.child('temperature').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is double) {
        setState(() {
          temperature = data;
          // Mettez à jour Firestore avec la nouvelle valeur de température
          _updateFirestoreData('temperature', temperature);
        });
      }
    });
    _databaseReference.child('humidity').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is double) {
        setState(() {
          humidity = data;
          // Mettez à jour Firestore avec la nouvelle valeur d'humidité
          _updateFirestoreData('humidity', humidity);
        });
      }
    });
  }

  void _updateData(String field, double value) {
    _databaseReference.child(field).set(value);
  }

  void _updateFirestoreData(String field, double value) {
    _firestore.collection('weather_data').doc(field).set({
      'value': value,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 168, 179, 247),
      appBar: AppBar(
        title: const Text('Weather Conditions'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 157, 196, 219),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              buildGaugeWithLabel('Temperature', temperature, Colors.red),
              SizedBox(height: 20),
              buildGaugeWithLabel('Humidity', humidity, Colors.blue),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChartPage ()),
                  );
                },
                child: Text('Passer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGaugeWithLabel(String label, double value, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: value,
                    color: color,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: value,
                    enableAnimation: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
         child: Column(
          children: [
            SizedBox(height: 10), // Espace de 10 pixels
            Text(
              '$label: $value',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        ),
      ],
    );
  }
}
