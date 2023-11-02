
import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class MonthCalendarWidget extends StatelessWidget {
  const MonthCalendarWidget({
    super.key, 
    this.month, 
    this.subMonth, 
    this.addMonth,
  });

  final String? month;
  final Function()? subMonth;
  final Function()? addMonth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium,
        horizontal: SizeToPadding.sizeSmall,
      ),
      child: Container(
        height: 100,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.all(
            Radius.circular(BorderRadiusSize.sizeMedium),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: SpaceBox.sizeMedium,
              color: AppColors.BLACK_400,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: ()=> subMonth!(), 
                icon: const Icon(
                  Icons.arrow_back_ios_new, 
                  color: AppColors.LINEAR_GREEN,
                  size: 40,
                ),
              ),
              buildMonth(context),
              IconButton(
                onPressed: ()=> addMonth!(), 
                alignment: Alignment.topLeft,
                icon: const Icon(
                  Icons.arrow_forward_ios_sharp, 
                  color: AppColors.LINEAR_GREEN,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMonth(BuildContext context){
    final monthOfYear= int.parse(month?.split('/')[0] ?? '${DateTime.now().month}');
    final year= int.parse(month?.split('/')[1] ?? '${DateTime.now().year}');
    final lastDay= DateTime(year, monthOfYear+1, 0).day;
    return Container(
      margin: EdgeInsets.only(
        left: SizeToPadding.sizeVerySmall,
        top: SizeToPadding.sizeVerySmall,
        bottom: SizeToPadding.sizeVerySmall,
      ),
      alignment: Alignment.center,
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width-150,
      decoration: BoxDecoration(
        color: AppColors.LINEAR_GREEN,
        borderRadius: BorderRadius.all(
          Radius.circular(BorderRadiusSize.sizeMedium),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Paragraph(
              content: month??'',
              style: STYLE_LARGE.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Paragraph(
              content: '(01/$monthOfYear - $lastDay/$monthOfYear)',
              style: STYLE_SMALL.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
