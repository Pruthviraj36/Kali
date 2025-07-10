import 'package:get/get.dart';
import '../model/item_model.dart';

class ItemController extends GetxController {
  RxList<ItemModel> itemList = <ItemModel>[].obs;

  void addItem(String title) {
    itemList.add(ItemModel(title: title));
  }

  void removeItem(int index) {
    itemList.removeAt(index);
  }

  void toggleFavorite(int index) {
    itemList[index].isFavorite = !itemList[index].isFavorite;
    itemList.refresh(); // Notify UI
  }

  // CRUD using RxList<Map>
  RxList<Map<String, dynamic>> itemMapList = <Map<String, dynamic>>[].obs;

  void addMapItem(String title) {
    itemMapList.add({'title': title, 'isFavorite': false});
  }

  void toggleMapFavorite(int index) {
    itemMapList[index]['isFavorite'] = !(itemMapList[index]['isFavorite']);
    itemMapList.refresh();
  }

  void deleteMapItem(int index) {
    itemMapList.removeAt(index);
  }
}
