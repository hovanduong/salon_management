// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/note_language.dart';
import '../../resource/model/model.dart';
import '../../utils/app_handel_color.dart';
import '../../utils/date_format_utils.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'note_detail.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  NoteDetailViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final noteModel = ModalRoute.of(context)?.settings.arguments;
    return BaseWidget(
      viewModel: NoteDetailViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!
        ..init(
          noteModel as NoteModel?,
        ),
      builder: (context, viewModel, child) => buildLoading(),
    );
  }

  Widget buildLoading() {
    return Scaffold(
      body: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.online,
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          offlineChild: const ThreeBounceLoading(),
          onlineChild: Container(
            color: AppColors.COLOR_WHITE,
            child: Stack(
              children: [
                buildNoteDetailScreen(),
                if (_viewModel!.isLoading)
                  const Positioned(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: ThreeBounceLoading(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonFavoriteNote(){
    print(_viewModel!.noteModel?.id);
    return InkWell(
      onTap: () => _viewModel!.pinNote(),
      child: Center(
        child: Icon(
          (_viewModel!.noteModel?.pined??false)? 
          Icons.favorite
          :Icons.favorite_border,
          size: 30,
          color:  (_viewModel!.noteModel?.pined??false)? 
            AppColors.Red_Money : AppColors.COLOR_WHITE,
        ),
      ),
    );
  }

  Widget buildButtonHeader() {
    return Row(
      children: [
        buildButtonFavoriteNote(),
        SizedBox(
          width: SizeToPadding.sizeVeryVerySmall,
        ),
        IconButton(
          onPressed: () => _viewModel!.showDialogDeleteNote(),
          icon: const Icon(
            Icons.delete,
            size: 30,
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Container(
      color: AppColors.PRIMARY_GREEN,
      padding: EdgeInsets.only(
        left: SizeToPadding.sizeSmall,
        top: Platform.isAndroid ? 30 : 60,
        bottom: SizeToPadding.sizeVerySmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              AppImages.icArrowLeft,
              height: 30,
              color: AppColors.COLOR_WHITE,
            ),
          ),
          buildButtonHeader(),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(
        right: SizeToPadding.sizeMedium,
        left: SizeToPadding.sizeMedium,
        top: SizeToPadding.sizeSmall,
      ),
      child: Paragraph(
        content: _viewModel!.noteModel?.title ?? '',
        style: STYLE_LARGE_BIG.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildDate() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVerySmall,
        horizontal: SizeToPadding.sizeMedium,
      ),
      child: Paragraph(
        content: _viewModel!.noteModel?.updatedAt != null
            ? AppDateUtils.splitHourDate(
                AppDateUtils.formatDateLocal(
                  _viewModel!.noteModel!.updatedAt!,
                ),
              )
            : '',
        style: STYLE_SMALL.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildNote() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeSmall,
        horizontal: SizeToPadding.sizeMedium,
      ),
      width: double.maxFinite,
      height: MediaQuery.sizeOf(context).height - 170,
      child: SingleChildScrollView(
        child: Paragraph(
          content: _viewModel!.noteModel?.note ?? '',
          style: STYLE_MEDIUM.copyWith(
            fontWeight: FontWeight.w500,
            color: _viewModel!.noteModel?.color != '#2F4F4F'
                ? AppColors.BLACK_500
                : AppColors.COLOR_WHITE,
          ),
        ),
      ),
    );
  }

  Widget buildFieldNoteQuill() {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.sizeOf(context).height - 180,
      padding: EdgeInsets.only(
        right: SizeToPadding.sizeMedium,
        left: SizeToPadding.sizeMedium,
      ),
      child: QuillEditor.basic(
        configurations: QuillEditorConfigurations(
          controller: _viewModel!.quillController,
          readOnly: true,
          enableInteractiveSelection: false,
          enableSelectionToolbar: false,
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('de'),
          ),
        ),
      ),
    );
  }

  Widget buildNoteDetailScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            buildTitle(),
            buildDate(),
            // buildNote(),
            buildFieldNoteQuill(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
        child: FloatingActionButton(
          backgroundColor: AppColors.PRIMARY_GREEN,
          onPressed: () => _viewModel!.gotoUpdateNote(),
          child: const Icon(
            Icons.edit,
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
    );
  }
}
