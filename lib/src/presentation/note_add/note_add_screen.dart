// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/note_language.dart';
import '../../resource/model/model.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'note_add.dart';

class NoteAddScreen extends StatefulWidget {
  const NoteAddScreen({super.key});

  @override
  State<NoteAddScreen> createState() => _NoteAddScreenState();
}

class _NoteAddScreenState extends State<NoteAddScreen> {
  NoteAddViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final noteModel = ModalRoute.of(context)?.settings.arguments;
    return BaseWidget(
      viewModel: NoteAddViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!
        ..init(
          noteModel as NoteModel?,
        ),
      builder: (context, viewModel, child) => buildNoteAddScreen(),
    );
  }

  Future noteColorPicker() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.BLACK_500,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Paragraph(
                content: NoteLanguage.selectColor,
                style: STYLE_MEDIUM.copyWith(
                  color: AppColors.COLOR_WHITE,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
                child: SelectNoteColor(
                  onTap: (color){
                    _viewModel!.changedSelectColor(color);
                    Navigator.pop(context);
                  } 
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildButtonHeader() {
    return Row(
      children: [
        Showcase(
          key: _viewModel!.selectColorKey,
          description: NoteLanguage.chooseNoteBackground,
          child: InkWell(
            onTap: noteColorPicker,
            child: SvgPicture.asset(
              AppImages.icSelectColor,
              color: _viewModel!.selectColor!=AppColors.COLOR_WHITE?
                _viewModel!.selectColor: AppColors.COLOR_WHITE.withOpacity(0.7),
            ),
          ),
        ),
        SizedBox(
          width: SizeToPadding.sizeBig,
        ),
        InkWell(
          onTap: () async {
            await _viewModel!.onButton();
          },
          child: Paragraph(
            content: _viewModel!.noteModel != null
                ? NoteLanguage.update
                : NoteLanguage.save,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.COLOR_WHITE,
            ),
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
        right: SizeToPadding.sizeSmall,
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

  Widget buildFileTitle() {
    return FieldWidget(
      // color: _viewModel!.selectColor,
      textEditingController: _viewModel!.titleTextController,
      fontSize: FONT_SIZE_BIG,
      hintText: NoteLanguage.title,
    );
  }

  Widget buildFieldNote() {
    return FieldWidget(
      color: _viewModel!.selectColor,
      // onChange: (value) => _viewModel!..validNote(value)..onEnableButton(),
      textEditingController: _viewModel!.noteTextController,
      fontSize: FONT_SIZE_MEDIUM,
      hintText: '${NoteLanguage.typeSomething}...',
    );
  }

  Widget buildFieldNoteQuill() {
    return Expanded(
      child: QuillEditor.basic(
        configurations: QuillEditorConfigurations(
          controller: _viewModel!.quillController,
          readOnly: false,
          placeholder: '${NoteLanguage.typeSomething}...',
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('de'),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Showcase(
      key: _viewModel!.enterInformationKey,
      description: NoteLanguage.enterCompleteInformation,
      child: Container(
        height: MediaQuery.sizeOf(context).height - 160,
        margin: EdgeInsets.only(top: SizeToPadding.sizeVerySmall),
        padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFileTitle(),
            const SizedBox(
              height: 12,
            ),
            // buildFieldNote(),
            buildFieldNoteQuill(),
          ],
        ),
      ),
    );
  }

  Widget buildItemEditTextNote() {
    return Showcase(
      description: NoteLanguage.formatNoteContent,
      key: _viewModel!.editContentNoteKey,
      child: QuillToolbar.simple(
        configurations: QuillSimpleToolbarConfigurations(
          toolbarIconCrossAlignment: WrapCrossAlignment.end,
          toolbarIconAlignment: WrapAlignment.start,
          axis: Axis.horizontal,
          multiRowsDisplay: false,
          showCenterAlignment: true,
          showRedo: false,
          showUndo: false,
          showBackgroundColorButton: false,
          showFontFamily: false,
          showStrikeThrough: true,
          showColorButton: true,
          showListCheck: false,
          controller: _viewModel!.quillController,
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('de'),
          ),
        ),
      ),
    );
  }

  Widget buildNoteAddScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildBody(),
          ],
        ),
      ),
      floatingActionButton: buildItemEditTextNote(),
    );
  }
}
