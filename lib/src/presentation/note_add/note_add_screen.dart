// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:flutter/material.dart';

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
    final noteModel= ModalRoute.of(context)?.settings.arguments;
    return BaseWidget(
      viewModel: NoteAddViewModel(), 
      onViewModelReady: (viewModel) => _viewModel=viewModel!..init(
        noteModel as NoteModel?,
      ),
      builder: (context, viewModel, child) => buildNoteAddScreen(),
    );
  }

  Future noteColorPicker() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Paragraph(
                content: 'chon mau', 
                style: STYLE_MEDIUM,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
                child: SelectNoteColor(
                  onTap: (color) => _viewModel!.changedSelectColor(color),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildButtonHeader(){
    print(_viewModel!.selectColor.toHex());
    return Row(
      children: [
        InkWell(
          onTap: noteColorPicker,
          child: Icon(Icons.color_lens_outlined,
            color: _viewModel!.selectColor!=const Color(0xff2f4f4f)?
              AppColors.BLACK_500: AppColors.COLOR_WHITE)),
        SizedBox(width: SizeToPadding.sizeMedium,),
        InkWell(
          onTap: () => _viewModel!.onButton(),
          child: Paragraph(
            content: _viewModel!.noteModel!=null? NoteLanguage.update 
            : NoteLanguage.save,
            style: STYLE_BIG.copyWith(
              fontWeight: FontWeight.w600,
              color: _viewModel!.selectColor!=const Color(0xff2f4f4f)?
                AppColors.BLACK_500: AppColors.COLOR_WHITE
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeader(){
    return Container(
      margin: EdgeInsets.only(top: SizeToPadding.sizeBig*2),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonIconWidget(
            onTap: () => Navigator.pop(context),
            icon: Icons.keyboard_arrow_left,
          ),
          buildButtonHeader(),
        ],
      ),
    );
  }

  Widget buildFileTitle(){
    return FieldWidget(
      color: _viewModel!.selectColor,
      textEditingController: _viewModel!.titleTextController,
      fontSize: FONT_SIZE_BIG,
      hintText: NoteLanguage.title,
      validator: _viewModel!.messageTitle,
    );
  }

  Widget buildFieldNote(){
    return FieldWidget(
      color: _viewModel!.selectColor,
      // onChange: (value) => _viewModel!..validNote(value)..onEnableButton(),
      textEditingController: _viewModel!.noteTextController,
      fontSize: FONT_SIZE_MEDIUM,
      hintText: '${NoteLanguage.typeSomething}...',
      validator: _viewModel!.messageNote,
    );
  }

  Widget buildBody(){
    return Container(
      margin: EdgeInsets.only(top: SizeToPadding.sizeVerySmall),
      padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFileTitle(),
          const SizedBox(
            height: 12,
          ),
          buildFieldNote(),
        ],
      ),
    );
  }

  Widget buildNoteAddScreen(){
    return Scaffold(
      backgroundColor: _viewModel!.selectColor??AppColors.COLOR_WHITE,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildBody(),
          ],
        ),
      ),
    );
  }
}
