import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/model.dart';
import '../../resource/service/note_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class NoteViewModel extends BaseViewModel{

  final tileCounts = [
    [2, 2],
    [2, 2],
    [4, 2],
    [2, 3],
    [2, 2],
    [2, 3],
    [2, 2],
  ];

  bool isLoading=true;

  String? color;
  String? search;

  int page=1;

  NoteApi noteApi= NoteApi();

  List<NoteModel> listNote=[];

  Future<void> init()async{
    await getNotes();
  }

  Future<void> gotoAddNote()async{
    await Navigator.pushNamed(context, Routers.noteAddScreen,);
    await pullRefresh();
    notifyListeners();
  }

  Future<void> gotoDetailNote(NoteModel noteModel)async{
    await Navigator.pushNamed(context, Routers.noteDetailScreen,
      arguments: noteModel,);
    await pullRefresh();
    notifyListeners();
  }

  Future<void> onSearchNotes(String value) async {
    // final searchCustomer = TiengViet.parse(value.toLowerCase());
    search= value;
    await getNotes();
    notifyListeners();
  }

  Future<void> pullRefresh() async {
    await getNotes();
    notifyListeners();
  }

  Future<void> getNotes() async {
    final result = await noteApi.getNotes(
      NoteParams(
        page: page,
        search: search,
        color: color,
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
}
