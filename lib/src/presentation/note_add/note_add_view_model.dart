import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/note_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/service/note_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class NoteAddViewModel extends BaseViewModel{

  TextEditingController titleTextController = TextEditingController();
  TextEditingController noteTextController = TextEditingController();

  String? messageTitle;
  String? messageNote;

  bool enableButton=false;

  NoteApi noteApi = NoteApi();

  Future<void> init()async{

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
    await addNote();
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
    notifyListeners();
  }

  Future<void> addNote() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await noteApi.postNotes(
      NoteParams(
        title: titleTextController.text.trim(),
        note: noteTextController.text.trim(),
        // color: color,
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
}
