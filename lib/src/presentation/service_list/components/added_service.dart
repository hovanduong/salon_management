import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class AddedServiceWidget extends StatelessWidget {
  const AddedServiceWidget({
    this.color,
    this.serviceTopic,
    this.serviceDescription,
    this.serviceMoney,
    this.svgPicture,
    this.button,
    super.key,
  });

  final Color? color;
  final String? serviceTopic;
  final String? serviceDescription;
  final String? serviceMoney;
  final SvgPicture? svgPicture;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeBig,
        vertical: SizeToPadding.sizeBig,
      ),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: double.infinity,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(99),
                ),
                color: color,
              ),
              child: 
              // Align(
              //   alignment: Alignment.center,
              //   child: Paragraph(
              //     content: serviceName?.substring(0, 1).toUpperCase() ?? '',
              //     style: STYLE_VERY_BIG.copyWith(
              //       color: AppColors.PRIMARY_PINK,
              //     ),
              //   ),
              // ),
              svgPicture,
            ),
            SizedBox(
              width: SpaceBox.sizeBig,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: SpaceBox.sizeVerySmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Paragraph(
                      content: serviceTopic,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: STYLE_LARGE_BOLD,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      // width: 100,
                      child: Paragraph(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        content: serviceDescription,
                        style: STYLE_MEDIUM,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: SizeToPadding.sizeMedium),
              child: Paragraph(
                content: serviceMoney,
                style: STYLE_SMALL_BOLD.copyWith(color: AppColors.PRIMARY_PINK),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeToPadding.sizeMedium,
              ),
              child: SizedBox(
                child: button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
