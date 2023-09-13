class RadioModel {
  RadioModel({
    required this.isSelected,
    this.id,
    this.secondTitle = "",
    this.text,
  });

  bool isSelected;
  dynamic id;
  String? text;
  String? secondTitle;
}