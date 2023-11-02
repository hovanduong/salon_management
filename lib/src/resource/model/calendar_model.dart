class CalendarModel {
  CalendarModel({
    this.day, 
    this.moneyPay, 
    this.isDayCurrent=false, 
    this.revenue, 
  });
  final num? day;
  final num? revenue;
  final num? moneyPay;
  final bool isDayCurrent;
}
