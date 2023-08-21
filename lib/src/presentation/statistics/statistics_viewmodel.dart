import '../base/base.dart';

class StatisticsViewModel extends BaseViewModel {
  List<ChartData> data = [];

  dynamic init() {
    fetchData();
  }

  void fetchData() {
    data = [
      ChartData('20', 3500),
      ChartData('21', 1600),
      ChartData('22', 2500),
      ChartData('23', 3000),
      ChartData('24', 2930),
      ChartData('25', 4000),
      ChartData('26', 1000),
    ];
    notifyListeners();
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
