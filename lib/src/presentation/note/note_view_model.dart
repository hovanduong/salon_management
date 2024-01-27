// ignore_for_file: parameter_assignments

import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/note_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/note_api.dart';
import '../../utils/app_handle_hex_color.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class NoteViewModel extends BaseViewModel {
  final tileCounts = [
    [2, 2],
    [2, 2],
    [4, 2],
    [2, 3],
    [2, 2],
    [2, 3],
    [2, 2],
  ];

  Color? selectColor;

  ScrollController scrollController = ScrollController();

  bool isLoading = true;
  bool isGridView = true;
  bool isLoadMore = false;

  String? color;
  String? search;

  int? idUser;
  int page = 1;

  NoteApi noteApi = NoteApi();

  List<NoteModel> listNote = [];
  List<NoteModel> listCurrent = [];

  Future<void> init() async {
    idUser = int.parse(await AppPref.getDataUSer('id') ?? '0');
    await AppPref.getShowCase('isGridView$idUser').then(
      (value) => isGridView = value ?? true,
    );
    scrollController.addListener(
      scrollListener,
    );
    await getNotes();
    listCurrent = listNote;
    notifyListeners();
  }

  dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      isLoadMore = true;
      Future.delayed(const Duration(seconds: 2), () {
        loadMoreData();
        isLoadMore = false;
      });
      notifyListeners();
    }
  }

  Future<void> loadMoreData() async {
    page += 1;
    await getNotes();
    listCurrent = [...listCurrent, ...listNote];
    isLoading = false;
    notifyListeners();
  }

  Future<void> gotoAddNote() async {
    await Navigator.pushNamed(
      context,
      Routers.noteAddScreen,
    );
    await pullRefresh();
    notifyListeners();
  }

  Future<void> gotoDetailNote(NoteModel noteModel) async {
    await Navigator.pushNamed(
      context,
      Routers.noteDetailScreen,
      arguments: noteModel,
    );
    await pullRefresh();
    notifyListeners();
  }

  Future<void> onChangeViewScreen(String value) async {
    if (value == NoteLanguage.listView) {
      await AppPref.setShowCase('isGridView$idUser', false);
    } else {
      await AppPref.setShowCase('isGridView$idUser', true);
    }
    isGridView = (await AppPref.getShowCase('isGridView$idUser'))!;
    notifyListeners();
  }
  

  Future<void> onSearchNotes({String? value, Color? color}) async {
    // final searchCustomer = TiengViet.parse(value.toLowerCase());
    page = 1;
    search = value;
    selectColor = color;
    await getNotes();
    listCurrent = listNote;
    notifyListeners();
  }

  dynamic showDialogDeleteNote(int id) {
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
            await deleteNote(id);
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
    await pullRefresh();
  }

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> pullRefresh() async {
    listCurrent.clear();
    page = 1;
    selectColor = null;
    search = null;
    await getNotes();
    listCurrent = listNote;
    notifyListeners();
  }

  Future<void> getNotes() async {
    final result = await noteApi.getNotes(
      NoteParams(
        page: page,
        search: search,
        color: selectColor != null
            ? selectColor?.toHex().toString().split('#')[1]
            : null,
      ),
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
      listNote = value as List<NoteModel>;
    }
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await noteApi.deleteNote(id);

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
}
