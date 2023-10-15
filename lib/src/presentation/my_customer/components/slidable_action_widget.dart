import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/category_language.dart';

class SlidableActionWidget extends StatelessWidget {
  const SlidableActionWidget({
    super.key, 
    this.child,
    this.onTapButtonFirst, 
    this.onTapButtonSecond, 
    this.isEdit=false,
  });

  final Widget? child;
  final Function(BuildContext context)? onTapButtonFirst;
  final Function(BuildContext context)? onTapButtonSecond;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context){
              onTapButtonFirst!(context);
            },
            backgroundColor: AppColors.PRIMARY_RED,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SpaceBox.sizeSmall), 
              bottomLeft: Radius.circular(SpaceBox.sizeSmall),
              topRight: Radius.circular(isEdit? 0 : SpaceBox.sizeSmall),
              bottomRight: Radius.circular(isEdit? 0 : SpaceBox.sizeSmall),),
            icon: Icons.delete,
            label: CategoryLanguage.delete,
          ),
          if(isEdit)
            SlidableAction(
              onPressed: (context){
                onTapButtonSecond!(context);
              },
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SpaceBox.sizeSmall), 
                bottomRight: Radius.circular(SpaceBox.sizeSmall),),
              backgroundColor: AppColors.FIELD_GREEN,
              icon: Icons.edit,
              label: CategoryLanguage.edit,
            ),
        ],
      ),
      child: child?? Container(),
    );
  }
}
