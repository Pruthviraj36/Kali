import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/student_controller.dart';
import '../model/student.dart';
import '../model/college.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  FormScreenState createState() => FormScreenState();
}

class FormScreenState extends State<FormScreen> {
  final controller = Get.find<StudentController>();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final collegeIdController = TextEditingController();
  final ageController = TextEditingController();
  final twelfthPercentageController = TextEditingController();
  final tenthPercentageController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final collegeNameController = TextEditingController();
  final degreeController = TextEditingController();
  int currentPage = 0; // 0 for Student1, 1 for College1
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${currentPage == 0 ? 'Student' : 'College'}'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                  setState(() {
                    currentPage = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: currentPage == 0 ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Student',
                    style: TextStyle(
                      color: currentPage == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                  setState(() {
                    currentPage = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: currentPage == 1 ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'College',
                    style: TextStyle(
                      color: currentPage == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  nameController.clear();
                  surnameController.clear();
                  collegeIdController.clear();
                  ageController.clear();
                  twelfthPercentageController.clear();
                  tenthPercentageController.clear();
                  emailController.clear();
                  phoneController.clear();
                  collegeNameController.clear();
                  degreeController.clear();
                });
              },
              children: [
                // Student1 Form
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: surnameController,
                        decoration: const InputDecoration(labelText: 'Surname'),
                      ),
                      TextField(
                        controller: collegeIdController,
                        decoration: const InputDecoration(
                          labelText: 'College ID',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: ageController,
                        decoration: const InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: twelfthPercentageController,
                        decoration: const InputDecoration(
                          labelText: '12th Percentage',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: tenthPercentageController,
                        decoration: const InputDecoration(
                          labelText: '10th Percentage',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: 'Phone'),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                // College1 Form
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: collegeNameController,
                        decoration: const InputDecoration(
                          labelText: 'College Name',
                        ),
                      ),
                      TextField(
                        controller: degreeController,
                        decoration: const InputDecoration(labelText: 'Degree'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (currentPage == 0) {
                  if (nameController.text.trim().isEmpty ||
                      surnameController.text.trim().isEmpty ||
                      collegeIdController.text.trim().isEmpty ||
                      ageController.text.trim().isEmpty ||
                      twelfthPercentageController.text.trim().isEmpty ||
                      tenthPercentageController.text.trim().isEmpty ||
                      emailController.text.trim().isEmpty ||
                      phoneController.text.trim().isEmpty) {
                    return;
                  }
                  final collegeId = int.tryParse(
                    collegeIdController.text.trim(),
                  );
                  final age = int.tryParse(ageController.text.trim());
                  final twelfthPercentage = double.tryParse(
                    twelfthPercentageController.text.trim(),
                  );
                  final tenthPercentage = double.tryParse(
                    tenthPercentageController.text.trim(),
                  );
                  if (collegeId == null ||
                      age == null ||
                      twelfthPercentage == null ||
                      tenthPercentage == null) {
                    return;
                  }
                  if (!await controller.repository.isValidCollegeId(
                    collegeId,
                  )) {
                    return;
                  }

                  final newStudent = Student1(
                    studentId: 0,
                    name: nameController.text.trim(),
                    surname: surnameController.text.trim(),
                    collegeId: collegeId,
                    age: age,
                    twelfthPercentage: twelfthPercentage,
                    tenthPercentage: tenthPercentage,
                    email: emailController.text.trim(),
                    phone: phoneController.text.trim(),
                  );

                  await controller.addStudent(newStudent);
                } else {
                  if (collegeNameController.text.trim().isEmpty ||
                      degreeController.text.trim().isEmpty) {
                    return;
                  }

                  final newCollege = College1(
                    collegeId: 0,
                    collegeName: collegeNameController.text.trim(),
                    degree: degreeController.text.trim(),
                  );

                  await controller.addCollege(newCollege);
                }
                Get.back();
              },
              child: Text('Add ${currentPage == 0 ? 'Student' : 'College'}'),
            ),
          ),
        ],
      ),
    );
  }
}
