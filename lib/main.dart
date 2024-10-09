import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sensor_example/provider/sensor_provider.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
  late Timer timer;

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

  final List<FlSpot> dummyData1 = List.generate(50, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

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
        body: AspectRatio(
          aspectRatio: 1.23,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 37,
                  ),
                  const Text(
                    'Accelerometer Data',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 37,
                  ),
                  newLineGraph(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        )

        //
        // SafeArea(
        //     child: Container(
        //   width: double.infinity,
        //   height: double.infinity,
        //   padding: const EdgeInsets.all(20),
        //   child: Center(
        //     // Center is a layout widget. It takes a single child and positions it
        //     // in the middle of the parent.
        //     child: Column(
        //       // Column is also a layout widget. It takes a list of children and
        //       // arranges them vertically. By default, it sizes itself to fit its
        //       // children horizontally, and tries to be as tall as its parent.
        //       //
        //       // Column has various properties to control how it sizes itself and
        //       // how it positions its children. Here we use mainAxisAlignment to
        //       // center the children vertically; the main axis here is the vertical
        //       // axis because Columns are vertical (the cross axis would be
        //       // horizontal).
        //       //
        //       // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
        //       // action in the IDE, or press "p" in the console), to see the
        //       // wireframe for each widget.
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         // const Text(
        //         //   'Accelerometer Data x, y, z:',
        //         // ),
        //         // Text(
        //         //   '${context.watch<SensorProvider>().accelerometer.x} ${context.watch<SensorProvider>().accelerometer.y} ${context.watch<SensorProvider>().accelerometer.z} ',
        //         //   style: Theme.of(context).textTheme.headlineMedium,
        //         // ),
        //         // const Text(
        //         //   'GyroScope Data x, y, z:',
        //         // ),
        //         // Text(
        //         //   '${context.watch<SensorProvider>().gyroScope.x} ${context.watch<SensorProvider>().gyroScope.y} ${context.watch<SensorProvider>().gyroScope.z} ',
        //         //   style: Theme.of(context).textTheme.headlineMedium,
        //         // ),
        //         LineChart(
        //             duration: Duration(milliseconds: 150), // Optional
        //             curve: Curves.linear, // Optional
        //             LineChartData(
        //               lineTouchData: lineTouchData1,
        //               gridData: gridData,
        //               titlesData: titlesData1,
        //               borderData: borderData,
        //               lineBarsData: lineBarsData1,
        //               minX: 0,
        //               maxX: 14,
        //               maxY: 4,
        //               minY: 0,
        //             )
        //         ),
        //         // LineChart(
        //         //   LineChartData(
        //         //     borderData: FlBorderData(show: false),
        //         //     lineBarsData: [
        //         //       // The red line
        //         //       LineChartBarData(
        //         //         spots: [
        //         //           FlSpot(0, 1),
        //         //           FlSpot(1, 2),
        //         //           FlSpot(2, 3),
        //         //           FlSpot(3, 1),
        //         //           FlSpot(4, 2)
        //         //         ],
        //         //         isCurved: true,
        //         //         barWidth: 2,
        //         //         color: Colors.greenAccent,
        //         //         show: true,
        //         //       ),
        //         //     ],
        //         //     titlesData: FlTitlesData(
        //         //       leftTitles: AxisTitles(
        //         //         axisNameWidget: const Text('Accelero [g]',
        //         //             textAlign: TextAlign.center,
        //         //             style: TextStyle(fontWeight: FontWeight.bold)),
        //         //         sideTitles: SideTitles(
        //         //           showTitles: true,
        //         //           reservedSize: 0,
        //         //         ),
        //         //       ),
        //         //       topTitles: AxisTitles(
        //         //         sideTitles: SideTitles(
        //         //           showTitles: false,
        //         //           reservedSize: 0,
        //         //         ),
        //         //       ),
        //         //     ),
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //   ),
        // )),
        );
  }

  List<LineChartBarData> get lineBarsData1 => [lineChartBarData1_1];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.greenAccent,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: context.watch<SensorProvider>().accelerometerXs,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '0.0';
        break;
      case 10:
        text = '10.0';
        break;
      case -10:
        text = '-10.0';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 7:
        text = const Text('OCT', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: Colors.pinkAccent.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  Widget newLineGraph() {
    return Container(
      width: double.infinity,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(right: 6, left: 6),
        child: LineChart(
            duration: const Duration(milliseconds: 250),
            LineChartData(
              backgroundColor: Colors.pinkAccent,
              lineTouchData: lineTouchData1,
              gridData: gridData,
              titlesData: titlesData1,
              borderData: borderData,
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.greenAccent,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                  spots: context.watch<SensorProvider>().accelerometerXs,
                )
              ],
              maxY: 10,
              minY: -10,
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _accelerometerStreamSubscription.cancel();
    _gyroscopeStreamSubscription.cancel();
  }
}
