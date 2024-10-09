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
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'GyroScope Data',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6, left: 6),
                      child: LineChart(
                          duration: const Duration(milliseconds: 250),
                          LineChartData(
                            backgroundColor: Colors.grey,
                            lineTouchData: lineTouchData1,
                            gridData: gridData,
                            titlesData: titlesData1,
                            borderData: borderData,
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                color: Colors.amber,
                                barWidth: 4,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                                spots:
                                    context.watch<SensorProvider>().gyroScopeXs,
                              ),
                              LineChartBarData(
                                isCurved: true,
                                color: Colors.pink,
                                barWidth: 4,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                                spots:
                                context.watch<SensorProvider>().gyroScopeYs,
                              ),
                              LineChartBarData(
                                isCurved: true,
                                color: Colors.white,
                                barWidth: 4,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                                spots:
                                context.watch<SensorProvider>().gyroScopeZs,
                              )
                            ],
                            maxY: 25,
                            minY: -25,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                    height: 15,
                  ),
                  LineGraphView(context.watch<SensorProvider>().accelerometerXs,
                      Colors.amberAccent, Colors.green, -25, 25),
                  const SizedBox(
                    height: 5,
                  ),
                  LineGraphView(context.watch<SensorProvider>().accelerometerYs,
                      Colors.grey, Colors.pink, -25, 25),
                  const SizedBox(
                    height: 5,
                  ),
                  LineGraphView(context.watch<SensorProvider>().accelerometerZs,
                      Colors.brown, Colors.white, -25, 25),
                ],
              ),
            )
          ],
        ));
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
          sideTitles: SideTitles(showTitles: false),
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
      case 25:
        text = '25.0';
        break;
      case -15:
        text = '-25.0';
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

  Widget LineGraphView(List<FlSpot> list, Color backgroundColor,
      Color lineColor, double? minY, double? maxY) {
    return Container(
      width: double.infinity,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(right: 6, left: 6),
        child: LineChart(
            duration: const Duration(milliseconds: 250),
            LineChartData(
              backgroundColor: backgroundColor,
              lineTouchData: lineTouchData1,
              gridData: gridData,
              titlesData: titlesData1,
              borderData: borderData,
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: lineColor,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                  spots: list,
                )
              ],
              maxY: maxY ?? 10,
              minY: minY ?? -10,
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
