// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class NoteParams {
  const NoteParams({
    this.id,
    this.note,
    this.title,
    this.money,
    this.color,
    this.search,
    this.page,
  });
  final int? id;
  final String? note;
  final String? title;
  final String? color;
  final num? money;
  final int? page;
  final String? search;
}

class NoteApi {
  Future<Result<List<NoteModel>, Exception>> getNotes(NoteParams params) async {
    try {
      final response = await HttpRemote.get(
        url: '/notes?pageSize=10&page=${params.page}&color=${
          params.color ?? ''}&search=${params.search ?? ''}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final notes = NoteFactory.createList(data);
          return Success(notes);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> postNotes(NoteParams? params) async {
    try {
      final response = await HttpRemote.post(
        url: '/notes',
        body: {
          'title': params?.title,
          'color': params?.color??'',
          'note': params?.note,
          'password': null,
        },
      );
      switch (response?.statusCode) {
        case 201:
          return const Success(true);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> deleteNote(int idNote,) async {
    try {
      final response = await HttpRemote.delete(
        url: '/notes/$idNote',
      );
      switch (response?.statusCode) {
        case 200:
          return const Success(true);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> putNote(NoteParams? params,) async {
    try {
      final response = await HttpRemote.put(
        url: '/notes/${params?.id??0}',
        body: {
          'title': params?.title,
          'color': params?.color??'',
          'note': params?.note,
          'password': null,
          'oldPassword': null,
        },
      );
      switch (response?.statusCode) {
        case 200:
          return const Success(true);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
