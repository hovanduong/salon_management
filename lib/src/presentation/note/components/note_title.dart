import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../resource/model/model.dart';
import '../../../utils/app_handel_color.dart';
import '../../../utils/date_format_utils.dart';

class NoteTitleWidget extends StatelessWidget {
  const NoteTitleWidget({
    super.key,
    this.note,
    this.color,
    this.onTap,
    this.onTapFavorite,
  });

  final NoteModel? note;
  final int? color;
  final Function()? onTap;
  final Function()? onTapFavorite;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: (note?.color != null && note?.color != '')
                  ? AppHandleColor.getColorFromHex(note!.color!)
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.BLACK_200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitleNote(context, constraints),
              SizedBox(
                height: SizeToPadding.sizeVerySmall,
              ),
              Paragraph(
                content: Document.fromJson(jsonDecode(note?.note ?? ''))
                    .toPlainText(),
                maxLines: 2,
                style: STYLE_SMALL.copyWith(
                  fontWeight: FontWeight.w300,
                  color: (note?.color != null && note?.color != '')
                      ? AppHandleColor.getColorFromHex(note!.color!) !=
                              AppColors.COLOR_WHITE
                          ? AppColors.BLACK_500
                          : AppColors.BLACK_500
                      : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              buildDateNote()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateNote() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: note?.color == '#FFFFFF'
            ? AppColors.PRIMARY_GREEN
            : AppColors.COLOR_WHITE,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppImages.icClock,
            height: 10,
            color: note?.color == '#FFFFFF' ? AppColors.COLOR_WHITE : null,
          ),
          const SizedBox(width: 7),
          Paragraph(
            content: note?.updatedAt != null
                ? AppDateUtils.splitHourDate(
                    AppDateUtils.formatDateLocal(
                      note!.updatedAt!,
                    ),
                  )
                : '',
            style: STYLE_SMALL.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: (note?.color != null)
                  ? AppHandleColor.getColorFromHex(
                            note!.color!,
                          ) !=
                          AppColors.COLOR_WHITE
                      ? AppColors.BLACK_500
                      : AppColors.COLOR_WHITE
                  : null,
            ),
          ),
        ],
      ),
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.,
    //   children: [
    //     Paragraph(
    //         content: note?.updatedAt != null
    //             ? AppDateUtils.splitHourDate(
    //                 AppDateUtils.formatDateLocal(
    //                   note!.updatedAt!,
    //                 ),
    //               )
    //             : '',
    //         style: STYLE_SMALL.copyWith(
    //           color: (note?.color != null && note?.color != '')
    //               ? AppHandleColor.getColorFromHex(note!.color!) !=
    //                       AppColors.COLOR_WHITE
    //                   ? AppColors.COLOR_WHITE
    //                   : AppColors.BLACK_500
    //               : null,
    //         )),
    //   ],
    // );
  }

  Widget buildTitleNote(BuildContext context, BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: constraints.maxWidth / 1.8,
          child: Paragraph(
            content: note?.title ?? '',
            maxLines: 1,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: (note?.color != null && note?.color != '')
                  ? AppHandleColor.getColorFromHex(note!.color!) !=
                          AppColors.COLOR_WHITE
                      ? AppColors.BLACK_500
                      : AppColors.BLACK_500
                  : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        buildButtonFavoriteNote()
      ],
    );
  }

  Widget buildButtonFavoriteNote() {
    return InkWell(
      onTap: () => onTapFavorite!(),
      child: CircleAvatar(
        radius: 17,
        backgroundColor: (note?.color != null)
            ? AppHandleColor.getColorFromHex(
                      note?.color ?? '',
                    ) !=
                    AppColors.COLOR_WHITE
                ? AppColors.COLOR_WHITE
                : AppColors.PRIMARY_GREEN
            : null,
        child: Center(
          child: Icon(
              (note?.pined ?? false) ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: (note?.pined ?? false)
                  ? AppColors.Red_Money
                  : (note?.color != '#FFFFFF'
                      ? AppColors.BLACK_500
                      : AppColors.COLOR_WHITE)),
        ),
      ),
    );
  }
}
