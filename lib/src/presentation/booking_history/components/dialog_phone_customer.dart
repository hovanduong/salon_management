// import 'package:clipboard/clipboard.dart';
// import 'package:easysalon_management_app/_shared/services/layout_notifier.dart';
// import 'package:easysalon_management_app/_shared/widgets/layout/space.dart';
// import 'package:easysalon_management_app/_shared/widgets/layout/toast.dart';

import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class DiaLogPhoneCustomer extends StatelessWidget {
  const DiaLogPhoneCustomer({Key? key, 
    this.phone, 
    this.isCopy = true, 
    this.onTapCall, 
    this.onTapText, 
    this.onTapCopy,
  })
  : super(key: key);

  final String? phone;
  final bool isCopy;
  final Function()? onTapCall;
  final Function()? onTapText;
  final Function()? onTapCopy;

  Widget buildHeaderPhone(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SpaceBox.sizeMedium),
          color: AppColors.COLOR_WHITE,
        ),
        padding: EdgeInsets.all(SpaceBox.sizeSmall),
        child: Row(
          children: [
            const Icon(
              Icons.account_circle,
              size: 50,
              color: AppColors.PRIMARY_GREEN,
            ),
            SizedBox(
              width: SpaceBox.sizeVerySmall,
            ),
            Paragraph(
              content: phone,
              style: STYLE_MEDIUM_BOLD.copyWith(
                color: AppColors.PRIMARY_GREEN,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeaderPhone(context),
          SizedBox(
            height: SpaceBox.sizeMedium,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 2 / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.COLOR_WHITE,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(SpaceBox.sizeMedium),
                  child: Paragraph(
                    content: phone,
                    color: AppColors.PRIMARY_GREEN,
                    style: STYLE_SMALL.copyWith(
                      color: AppColors.PRIMARY_GREEN,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const Divider(height: 0, thickness: 1),
                GestureDetector(
                  onTap: () {
                    onTapCall!();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(SpaceBox.sizeMedium),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Paragraph(
                          content: 
                            '${HistoryLanguage.call} ${phone ?? ''}',
                          style: STYLE_MEDIUM_BOLD.copyWith(
                            color: AppColors.PRIMARY_GREEN,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const Icon(
                          Icons.local_phone_outlined,
                          size: 20,
                          color: AppColors.PRIMARY_GREEN,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 0, thickness: 1),
                GestureDetector(
                  onTap: () {
                    onTapText!();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(SpaceBox.sizeMedium),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Paragraph(
                          content: HistoryLanguage.text,
                          style: STYLE_MEDIUM_BOLD.copyWith(
                            color: AppColors.PRIMARY_GREEN,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const Icon(
                          Icons.messenger_outline,
                          size: 20,
                          color: AppColors.PRIMARY_GREEN,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 0, thickness: 1),
                if (isCopy)
                  GestureDetector(
                    onTap: () {
                      onTapCopy!();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(SpaceBox.sizeMedium),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Paragraph(
                            content: HistoryLanguage.copyPhoneNumber,
                            style: STYLE_MEDIUM_BOLD.copyWith(
                              color: AppColors.PRIMARY_GREEN,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const Icon(
                            Icons.copy,
                            size: 20,
                            color: AppColors.PRIMARY_GREEN,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
