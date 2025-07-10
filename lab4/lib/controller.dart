import './import_export.dart';

class UserController extends GetxController {
  var users = <User>[
    User(name: "John Doe", email: "john@example.com"),
    User(name: "Jane Smith", email: "jane@example.com"),
  ].obs;

  void addUser(String name, String email) {
    users.add(User(name: name, email: email));
  }
}
