import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs.dart';
import '../../constants/app_space.dart';

class InformationApp extends StatefulWidget {
  const InformationApp({super.key});

  @override
  State<InformationApp> createState() => _InformationAppState();
}

class _InformationAppState extends State<InformationApp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Paragraph(
          content: 'Mọi thắc mắc liện hệ hỗ trợ:',
          style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w700),
        ),
        InkWell(
          onTap: (){
           Clipboard.setData(const ClipboardData(text: '0944010499')).then((_){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Paragraph(
                    content: BookingLanguage.contentCopyPhone,
                    style: STYLE_MEDIUM.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),),);
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryVerySmall),
            child: const Paragraph(
              content: 'SĐT: 0944 01 04 99',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Paragraph(
                content: 'Tên GroupFb: ',
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w700),
              ),
               Paragraph(
                content: 'Hỗ trợ sử dụng ApCare',
                style: STYLE_MEDIUM.copyWith(),
              ),
            ],
          ),
        ),
        Paragraph(
          content: 'GroupFb: ',
          style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryVerySmall),
          child: const Paragraph(
            content: 'https://www.facebook.com/groups/1010848453326853',
          ),
        )
      ],
    );
  }
}
