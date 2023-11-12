class CalendarModel {
  CalendarModel({
    this.day, 
    this.moneyPay, 
    this.isDayCurrent=false, 
    this.revenue, 
    this.isWeekend=false,
  });
  final num? day;
  final num? revenue;
  final num? moneyPay;
  final bool isDayCurrent;
  final bool isWeekend;
}
