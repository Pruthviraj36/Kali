import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/student_controller.dart';
import 'college_student_form_screen.dart';
import 'edit_screen.dart';

class StudentListScreen extends StatelessWidget {
  final StudentController controller = Get.find<StudentController>();

  StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student List')),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.studentList.length,
          itemBuilder: (context, index) {
            final student = controller.studentList[index];
            return ListTile(
              title: Text(student['name'] ?? ''),
              subtitle: Text(
                'Age: ${student['age'] ?? 0} | College: ${student['college_name'] ?? ''}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.to(
                        () => EditScreen(
                          student: {
                            'student_id': student['student_id'],
                            'name': student['name'],
                            'surname': student['surname'],
                            'college_id': student['college_id'],
                            'age': student['age'],
                            'twelfth_percentage': student['twelfth_percentage'],
                            'tenth_percentage': student['tenth_percentage'],
                            'email': student['email'],
                            'phone': student['phone'],
                          },
                          studentId: student['student_id'],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteStudent(student['student_id']);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => FormScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
