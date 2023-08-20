// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class Images {
  String? url;
  String? description;

  Images({
    this.url,
    this.description,
  });
}

abstract class ImagesFactory {
  static List<Images> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => ImagesFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static Images create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final images = _fromJson(jsonMap);
    return images;
  }

  static String toJson(Images model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    Images images,
  ) {
    final data = <String, dynamic>{};
    data['url'] = images.url;
    data['description'] = images.description;
    return data;
  }

  static Images _fromJson(Map<String, dynamic> json) {
    final images = Images()
      ..url = json['url']
      ..description = json['description'];
    return images;
  }
}
