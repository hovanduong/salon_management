// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import '../../resource/model/calendar_model.dart';
import '../base/base.dart';

class CalendarViewModel extends BaseViewModel{

  bool isLoading=false;

  String? monthOfYear;

  int month=DateTime.now().month;
  int year=DateTime.now().year;

  num revenue=0;
  num spendingMoney=0;
  num total=0;

  dynamic init(){
    if(monthOfYear!=null){
      month= int.parse(monthOfYear!.split('/')[0] );
      year= int.parse(monthOfYear!.split('/')[1] );
    }
    notifyListeners();
  }

  void subMonth(){
    if(month>1){
      month--;
    }else{
      month=12;
      year--;
    }
    notifyListeners();
  }

  void addMonth(){
    if(month<12){
      month++;
    }else{
      month=1;
      year++;
    }
    notifyListeners();
  }

  List<CalendarModel> getListDay(){
    final listDay=<CalendarModel>[];
    final lastDay= DateTime(year, month+1, 0).day;
    final date= DateTime(year, month, 1);
    final lastDayOfMonthBefore= DateTime(year, month, 0).day;
    revenue=0;
    spendingMoney=0;
    total=0;
    if(date.weekday==1){
      for(var i=1; i<=lastDay; i++){
        listDay.add(
          CalendarModel(
            day: i,
            isDayCurrent: checkCurrentDay(i)?true:false,
          ),
        );
      }
      for(var i=1; i<=(35-lastDay); i++){
        listDay.add(CalendarModel(day: i));
      }
    }else{
      for(var i=date.weekday-2; i>=0; i--){
        listDay.add(CalendarModel(day: lastDayOfMonthBefore-i));
      }
      for(var i=1; i<=lastDay; i++){
        listDay.add(CalendarModel(
          day: i,
          isDayCurrent:checkCurrentDay(i)?true:false,
          moneyPay: 200000,
          revenue: 1000000,
        ),);
        revenue+= listDay.last.revenue??0;
        spendingMoney+= listDay.last.moneyPay??0;
      }
      for(var i=1; i<(35-lastDay-(date.weekday-2)); i++){
        listDay.add(CalendarModel(day: i));
      }
    }
    total=revenue-spendingMoney;
    return listDay;
  }

  bool checkCurrentDay(num day){
    final date= DateTime.now().toString();
    if(day<10){
      return date.contains('$year-$month-0$day');
    }else{
      return date.contains('$year-$month-$day');
    }
  }

}
