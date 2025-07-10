class ItemModel {
  String title;
  bool isFavorite;

  ItemModel({required this.title, this.isFavorite = false});

  Map<String, dynamic> toMap() => {'title': title, 'isFavorite': isFavorite};
  factory ItemModel.fromMap(Map<String, dynamic> map) =>
      ItemModel(title: map['title'], isFavorite: map['isFavorite']);
}
