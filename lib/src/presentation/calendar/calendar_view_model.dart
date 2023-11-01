import '../base/base.dart';

class CalendarViewModel extends BaseViewModel{

  bool isLoading=false;

  dynamic init(){}

  List<int> getListDay(String monthOfYear){
    final listDay=<int>[];
    final month= int.parse(monthOfYear.split('/')[0]);
    final year= int.parse(monthOfYear.split('/')[1] );
    final lastDay= DateTime(year, month+1, 0).day;
    final dayOfWeek= DateTime(year, month, 1).weekday;
    final lastDayOfMonthBefore= DateTime(year, month, 0).day;
    if(dayOfWeek==1){
      for(var i=1; i<=lastDay; i++){
        listDay.add(i);
      }
      for(var i=1; i<(35-lastDay); i++){
        listDay.add(i);
      }
    }else{
      for(var i=dayOfWeek-2; i>=0; i--){
        listDay.add(lastDayOfMonthBefore-i);
      }
      for(var i=1; i<=lastDay; i++){
        listDay.add(i);
      }
      for(var i=1; i<(35-lastDay-(dayOfWeek-2)); i++){
        listDay.add(i);
      }
    }
    return listDay;
  }

}
