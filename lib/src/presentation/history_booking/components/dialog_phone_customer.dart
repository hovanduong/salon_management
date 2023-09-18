// import 'package:clipboard/clipboard.dart';
// import 'package:easysalon_management_app/_shared/services/layout_notifier.dart';
// import 'package:easysalon_management_app/_shared/widgets/layout/space.dart';
// import 'package:easysalon_management_app/_shared/widgets/layout/toast.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class DiaLogPhoneCustomer extends StatefulWidget {
  final String? phone;
  final bool? isCopy;
  const DiaLogPhoneCustomer({Key? key, this.phone, this.isCopy = true})
      : super(key: key);

  @override
  State<DiaLogPhoneCustomer> createState() => _DiaLogPhoneCustomerState();
}

class _DiaLogPhoneCustomerState extends State<DiaLogPhoneCustomer> {
  Future<void> sendPhone(String phoneNumber, String scheme) async {
    print(phoneNumber);
    final launchUri = Uri(
      scheme: scheme,
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

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
              content: widget.phone,
              style: STYLE_MEDIUM_BOLD.copyWith(
                color: AppColors.PRIMARY_GREEN,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ));
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
                    content: widget.phone,
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
                    print('object');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(SpaceBox.sizeMedium),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Paragraph(
                          content: 'Gọi ${widget.phone ?? ''}',
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
                  onTap: () => sendPhone(widget.phone ?? '', 'sms'),
                  child: Padding(
                    padding: EdgeInsets.all(SpaceBox.sizeMedium),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Paragraph(
                          content: 'Nhắn tin',
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
                if (widget.isCopy == true)
                  GestureDetector(
                    onTap: () {
                      // FlutterClipboard.copy(phone).then((value) => showToast(
                      //     'Đã sao chép ',
                      //     gravity: Toast.bottom,
                      //     duration: Toast.lengthLong,
                      //     bgColor: Colors.black45));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(SpaceBox.sizeMedium),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Paragraph(
                            content: 'Sao chép số điện thoại',
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
