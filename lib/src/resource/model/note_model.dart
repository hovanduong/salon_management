import 'dart:convert';

class NoteModel {
  int? id;
  String? title;
  String? color;
  String? note;
  String? createdAt;
  String? updatedAt;
  bool? pined;
  int? userId;
  bool? password;

  NoteModel({
    this.id,
    this.title,
    this.color,
    this.note,
    this.userId,
    this.createdAt,
    this.password,
  });
  

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      createdAt: json['createdAt'],

    );
  }

  Map<String, dynamic> toJson() {
    final note = <String, dynamic>{};
    note['title'] = title;
    note['note'] = note;
    note['createdAt'] = createdAt;
    return note;
  }
}

abstract class NoteFactory {
  static List<NoteModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => NoteFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static NoteModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final myService = _fromJson(jsonMap);
    return myService;
  }

  static String toJson(NoteModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    NoteModel note,
  ) {
    final data = <String, dynamic>{};
    data['id'] = note.id;
    data['userId'] = note.userId;
    data['title'] = note.title;
    data['createdAt'] = note.createdAt;
    return data;
  }

  static NoteModel _fromJson(Map<String, dynamic> json) {
    final myService = NoteModel()
      ..id = json['id']
      ..color = json['color']
      ..userId = json['userId']
      ..note = json['note']
      ..password = json['password'] 
      ..pined = json['pined']
      ..createdAt = json['createdAt']
      ..updatedAt= json['updatedAt']
      ..title = json['title'];
    return myService;
  }
}
