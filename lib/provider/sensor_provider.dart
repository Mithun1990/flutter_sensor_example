import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sensor_example/model/accelerometer.dart';
import 'package:flutter_sensor_example/model/gyroscope.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorProvider with ChangeNotifier {
  List<FlSpot> accelerometerXs = <FlSpot>[];
  List<FlSpot> accelerometerYs = <FlSpot>[];
  List<FlSpot> accelerometerZs = <FlSpot>[];

  final int LIMIT = 50;
  double xValue = 1;
  double yValue = 1;
  double zValue = 1;
  double step = 0.1;

  List<FlSpot> gyroScopeXs = <FlSpot>[];
  List<FlSpot> gyroScopeYs = <FlSpot>[];
  List<FlSpot> gyroScopeZs = <FlSpot>[];

  double gxValue = 1;
  double gyValue = 1;
  double gzValue = 1;

  Accelerometer accelerometer = Accelerometer(0, 0, 0);
  GyroScope gyroScope = GyroScope(0, 0, 0);

  void setAccelerometerData(double x, double y, double z) {
    while (accelerometerXs.length > LIMIT) {
      accelerometerXs.removeAt(0);
      accelerometerYs.removeAt(0);
      accelerometerZs.removeAt(0);
    }

    xValue = xValue + step;
    yValue = yValue + step;
    zValue = zValue + step;

    accelerometerXs.add(FlSpot(xValue, x));
    accelerometerYs.add(FlSpot(yValue, y));
    accelerometerZs.add(FlSpot(zValue, z));
    //print(accelerometerZs);
    notifyListeners();
  }

  void addAccelerometerXValue(double xValue, double yValue) {
    accelerometerXs.add(FlSpot(xValue, yValue));
  }

  void setGyroScopeData(double x, double y, double z) {
    while (gyroScopeXs.length > LIMIT) {
      gyroScopeXs.removeAt(0);
      gyroScopeYs.removeAt(0);
      gyroScopeZs.removeAt(0);
    }

    gxValue = gxValue + step;
    gyValue = gyValue + step;
    gzValue = gzValue + step;

    gyroScopeXs.add(FlSpot(gxValue, x));
    gyroScopeYs.add(FlSpot(gyValue, y));
    gyroScopeZs.add(FlSpot(gzValue, z));
    //print(accelerometerZs);
    notifyListeners();
  }
}
