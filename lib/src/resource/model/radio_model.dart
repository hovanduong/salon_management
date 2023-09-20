class RadioModel {
  RadioModel({
    this.isSelected = false,
    this.id,
    this.secondTitle = '',
    this.name,
    this.price,
  });

  bool isSelected;
  dynamic id;
  String? name;
  String? secondTitle;
  num? price;
}
