import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/item_controller.dart';

class HomePage extends StatelessWidget {
  final ItemController controller = Get.put(ItemController());
  final TextEditingController textCtrl = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lab 7 RxList MVC')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: textCtrl,
              decoration: InputDecoration(
                hintText: 'Enter item name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    controller.addItem(textCtrl.text);
                    controller.addMapItem(textCtrl.text);
                    textCtrl.clear();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.itemList.length,
              itemBuilder: (context, index) {
                final item = controller.itemList[index];
                return ListTile(
                  title: Text(item.title),
                  trailing: IconButton(
                    icon: Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border),
                    onPressed: () => controller.toggleFavorite(index),
                  ),
                  onLongPress: () => controller.removeItem(index),
                );
              },
            )),
          ),
          Divider(),
          Text('CRUD with RxList<Map>', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.itemMapList.length,
              itemBuilder: (context, index) {
                final item = controller.itemMapList[index];
                return ListTile(
                  title: Text(item['title']),
                  trailing: IconButton(
                    icon: Icon(item['isFavorite'] ? Icons.star : Icons.star_border),
                    onPressed: () => controller.toggleMapFavorite(index),
                  ),
                  onLongPress: () => controller.deleteMapItem(index),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
