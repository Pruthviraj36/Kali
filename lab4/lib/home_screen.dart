import './import_export.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showSimpleInfoDialog(String message) {
    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void showAlertSnackbar() {
    Get.snackbar(
      'Alert',
      'simple Getx ALert',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void showAlertDialog() {
    Get.defaultDialog(
      title: "Alert",
      middleText: "This is a custom alert dialog",
      textConfirm: "OK",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  void showSimpleBottomSheet() {
    final userController = Get.find<UserController>();
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Obx(() {
          final users = userController.users;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        }),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(title: Text("Getx Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showSimpleInfoDialog("Processing your request...");
              },
              child: Text("Show Dialog"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showAlertSnackbar,
              child: Text("Show Alert Snackbar Dialog"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showAlertDialog,
              child: Text("Show Alert Dialog"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showSimpleBottomSheet,
              child: Text("Show Bottom Sheet"),
            ),
          ],
        ),
      ),
    );
  }
}
