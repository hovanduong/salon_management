// ignore_for_file: cascade_invocations, parameter_assignments

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../configs/configs.dart';
import '../../configs/language/note_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/income_api.dart';
import '../../resource/service/note_api.dart';
import '../../utils/app_handel_color.dart';
import '../../utils/app_handle_hex_color.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class NoteAddViewModel extends BaseViewModel{

  TextEditingController titleTextController = TextEditingController();
  TextEditingController noteTextController = TextEditingController();

  QuillController quillController= QuillController.basic();

  String? messageTitle;
  String? messageNote;

  bool enableButton=false;

  Color selectColor= AppColors.COLOR_WHITE;

  NoteApi noteApi = NoteApi();

  NoteModel? noteModel;

  Timer? timer;

  Future<void> init(NoteModel? note)async{
    noteModel=note;
    await setData();
    notifyListeners();
  }

  Future<void> setData()async{
    titleTextController.text= noteModel?.title??'';
    noteTextController.text= noteModel?.note??'';
    selectColor= noteModel?.color!=null && noteModel?.color!=''?
    AppHandleColor.getColorFromHex(noteModel?.color??'')
    :AppColors.COLOR_WHITE;
    onEnableButton();
    notifyListeners();
  }

  void changedSelectColor(Color color){
    selectColor= color;
    notifyListeners();
  }

  void validTitle(String value) {
    if (titleTextController.text.trim().isEmpty) {
      messageTitle = NoteLanguage.titleEmpty;
    } else {
      messageTitle = '';
    }
    notifyListeners();
  }

   void validNote(String value) {
    if (noteTextController.text.trim().isEmpty) {
      messageNote = NoteLanguage.account;
    } else {
      messageNote = '';
    }
    notifyListeners();
  }

  void onEnableButton(){
    if(titleTextController.text.trim()!='' && noteTextController.text.trim()!=''){
      enableButton=true;
    }else{
      enableButton=false;
    }
    notifyListeners();
  }

  Future<void> onButton()async{
    if(titleTextController.text.trim()!='' && noteTextController.text.trim()!=''){
      if(noteModel!=null){
        await updateNote();
      }else{
        await addNote();
      }
    }
    notifyListeners();
  }

   dynamic showErrorDialog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
        );
      },
    );
  }

  dynamic showSuccessDiaglog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
        );
      },
    );
    if(noteModel!=null){
      timer= Timer(const Duration(seconds: 2), () { 
        Navigator.pushReplacementNamed(context, Routers.navigation, 
          arguments: const IncomeParams(page: 4),);
      });
    }
  }

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  void clearData(){
    noteTextController.text='';
    titleTextController.text='';
    selectColor= AppColors.COLOR_WHITE;
    notifyListeners();
  }

  Future<void> addNote() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await noteApi.postNotes(
      NoteParams(
        title: titleTextController.text.trim(),
        note: noteTextController.text.trim(),
        color: selectColor.toHex().toString(),
      ),
    );

    final value = switch (result) {
      Success(value: final listRevenueChart) => listRevenueChart,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      showSuccessDiaglog(context);
      clearData();
    }
    notifyListeners();
  }

  Future<void> updateNote() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await noteApi.putNote(
      NoteParams(
        id: noteModel?.id,
        title: titleTextController.text.trim(),
        note: noteTextController.text.trim(),
        color: selectColor.toHex().toString(),
      ),
    );

    final value = switch (result) {
      Success(value: final listRevenueChart) => listRevenueChart,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      showSuccessDiaglog(context);
      clearData();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    titleTextController.dispose();
    noteTextController.dispose();
    super.dispose();
  }
}
