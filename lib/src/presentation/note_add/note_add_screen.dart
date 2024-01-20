// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/note_language.dart';
import '../../resource/model/model.dart';
import '../base/base.dart';
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

  Widget buildHeader(){
    return Container(
      color: AppColors.PRIMARY_GREEN,
      child: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 30 : 40,
          left: SizeToPadding.sizeMedium, 
          right: SizeToPadding.sizeMedium,
          bottom: SizeToPadding.sizeVerySmall,
        ),
        child: CustomerAppBar(
          onTap: () => Navigator.pop(context),
          title: _viewModel!.noteModel==null? NoteLanguage.addNote
            : NoteLanguage.editNote,
          color: AppColors.COLOR_WHITE,
          style: STYLE_LARGE.copyWith(
            color: AppColors.COLOR_WHITE,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget buildFileTitle(){
    return AppFormField(
      textEditingController: _viewModel!.titleTextController,
      maxLines: 3,
      hintText: NoteLanguage.title,
      onChanged: (value) => _viewModel!..validTitle(value)..onEnableButton(),
      validator: _viewModel!.messageTitle,
    );
  }

  Widget buildFieldNote(){
    return AppFormField(
      textEditingController: _viewModel!.noteTextController,
      maxLines: 12,
      hintText: '${NoteLanguage.typeSomething}...',
      onChanged: (value) => _viewModel!..validNote(value)..onEnableButton(),
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

  Widget buildButton(){
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      child: AppButton(
        enableButton: _viewModel!.enableButton,
        content: NoteLanguage.confirm,
        onTap: ()=> _viewModel!.onButton(),
      ),
    );
  }

  Widget buildNoteAddScreen(){
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHeader(),
          buildBody(),
          buildButton(),
        ],
      ),
    );
  }
}
