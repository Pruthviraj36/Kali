import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab10/repository/database_repository.dart';
import 'package:lab10/view/student_list_screen.dart';
import 'controller/student_controller.dart';

void main() {
  Get.put(StudentController());
  Get.lazyPut(() => DatabaseRepository());
  runApp(StudentListScreen());
}
