import 'package:flutter/cupertino.dart';
import 'package:flutter_sensor_example/model/accelerometer.dart';
import 'package:flutter_sensor_example/model/gyroscope.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorProvider with ChangeNotifier {
  List<FlSpot> accelerometerXs = <FlSpot>[];
  final int LIMIT = 50;
  double xValue = 0;
  double step = 0.1;

  Accelerometer accelerometer = Accelerometer(0, 0, 0);
  GyroScope gyroScope = GyroScope(0, 0, 0);

  void setAccelerometerData(double x, double y, double z) {
    // while (accelerometerXs.length > LIMIT) {
    //   accelerometerXs.removeAt(0);
    // }
    //addAccelerometerXValue(xValue + step, x);
    accelerometer.x = x;
    accelerometer.y = y;
    accelerometer.z = z;
    notifyListeners();
  }

  void addAccelerometerXValue(double xValue, double yValue) {
    accelerometerXs.add(FlSpot(xValue, yValue));
    notifyListeners();
  }

  void setGyroScopeData(double x, double y, double z) {
    gyroScope.x = x;
    gyroScope.y = y;
    gyroScope.z = x;
    notifyListeners();
  }
}
