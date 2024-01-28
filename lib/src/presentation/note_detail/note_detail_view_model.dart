import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/language/note_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/note_api.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class NoteDetailViewModel extends BaseViewModel{

  bool isLoading=false;
  bool isShowCase=false;
  
  NoteModel? noteModel;

  NoteApi noteApi= NoteApi();

  QuillController quillController= QuillController.basic();

  Timer? timer;

  int? idUser;

  GlobalKey editKey= GlobalKey();
  GlobalKey deleteKey= GlobalKey();
  GlobalKey favoriteKey= GlobalKey();

  Future<void> init(NoteModel? note) async{
    idUser = int.parse(await AppPref.getDataUSer('id') ?? '0');
    noteModel=note;
    quillController.document= Document.fromJson(jsonDecode(note?.note??''));
    await AppPref.getShowCase('detailsNote$idUser').then(
      (value) => isShowCase=value??true,);
    await startShowCase();
    await hideShowCase();
    notifyListeners();
  }

  Future<void> hideShowCase()async{
    await AppPref.setShowCase('detailsNote$idUser', false);
    isShowCase = false;
    notifyListeners();
  }

  Future<void> startShowCase()async{
    if(isShowCase){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        return ShowCaseWidget.of(context).startShowCase(
          [editKey, deleteKey, favoriteKey],
        );
      });
    }
  }

  Future<void> gotoUpdateNote()async{
    await Navigator.pushNamed(context, Routers.noteAddScreen,
      arguments: noteModel,);
    notifyListeners();
  }

  dynamic showDialogDeleteNote() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: NoteLanguage.notification,
          content: NoteLanguage.deleteNoteNotification,
          leftButtonName: NoteLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: NoteLanguage.confirm,
          onTapLeft: () {
            Navigator.pop(context,);
          },
          onTapRight: () async {
            Navigator.pop(context,);
            await deleteNote();
          },
        );
      },
    );
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

  dynamic showSuccessDiaglog(_) async{
    await showDialog(
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
    timer= Timer(const Duration(microseconds: 150), () {Navigator.pop(context);});
  }

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> deleteNote() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await noteApi.deleteNote(noteModel?.id??0);

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
    }
    notifyListeners();
  }

  Future<void> pinNote() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await noteApi.pinNote(noteModel?.id??0);

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
      isLoading=true;
      await getNotesDetails();
    }
    notifyListeners();
  }

  Future<void> getNotesDetails() async {
    final result = await noteApi.getNotesDetail(
      noteModel?.id??0
    );

    final value = switch (result) {
      Success(value: final listRevenueChart) => listRevenueChart,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      noteModel = value as NoteModel;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
