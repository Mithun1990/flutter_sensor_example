import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sensor_example/provider/sensor_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SensorProvider())
        ],
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late StreamSubscription<AccelerometerEvent> _accelerometerStreamSubscription;
  late StreamSubscription<GyroscopeEvent> _gyroscopeStreamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Listen accelerometer changes
    _accelerometerStreamSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      double x = double.parse(event.x.toStringAsPrecision(2));
      double y = double.parse(event.y.toStringAsPrecision(2));
      double z = double.parse(event.z.toStringAsPrecision(2));
      context.read<SensorProvider>().setAccelerometerData(x, y, z);
    });
    //Listen Gyro Changes
    _gyroscopeStreamSubscription =
        gyroscopeEventStream().listen((GyroscopeEvent event) {
      double x = double.parse(event.x.toStringAsPrecision(2));
      double y = double.parse(event.y.toStringAsPrecision(2));
      double z = double.parse(event.z.toStringAsPrecision(2));
      context.read<SensorProvider>().setGyroScopeData(x, y, z);
    }, onError: (error) {});
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Accelerometer Data x, y, z:',
            ),
            Text(
              '${context.watch<SensorProvider>().accelerometer.x} ${context.watch<SensorProvider>().accelerometer.y} ${context.watch<SensorProvider>().accelerometer.z} ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'GyroScope Data x, y, z:',
            ),
            Text(
              '${context.watch<SensorProvider>().gyroScope.x} ${context.watch<SensorProvider>().gyroScope.y} ${context.watch<SensorProvider>().gyroScope.z} ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            // LineChart(
            //   LineChartData(
            //     borderData: FlBorderData(show: false),
            //     lineBarsData: [
            //       // The red line
            //       LineChartBarData(
            //         spots: context.watch<SensorProvider>().accelerometerXs,
            //         isCurved: true,
            //         barWidth: 2,
            //         color: Colors.greenAccent,
            //         show: true,
            //       ),
            //     ],
            //     titlesData: FlTitlesData(
            //       leftTitles: AxisTitles(
            //         axisNameWidget: const Text('Accelero [g]',
            //             textAlign: TextAlign.center,
            //             style: TextStyle(fontWeight: FontWeight.bold)),
            //         sideTitles: SideTitles(
            //           showTitles: true,
            //           reservedSize: 0,
            //         ),
            //       ),
            //       topTitles: AxisTitles(
            //         sideTitles: SideTitles(
            //           showTitles: false,
            //           reservedSize: 0,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _accelerometerStreamSubscription.cancel();
    _gyroscopeStreamSubscription.cancel();
  }
}
