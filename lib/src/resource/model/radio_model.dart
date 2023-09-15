class RadioModel {
  RadioModel({
    required this.isSelected,
    this.id,
    this.secondTitle = '',
    this.name,
  });

  bool isSelected;
  dynamic id;
  String? name;
  String? secondTitle;
}
