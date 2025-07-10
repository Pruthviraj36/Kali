import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/student_controller.dart';
import '../model/student.dart';

class EditScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  final int studentId;

  const EditScreen({super.key, required this.student, required this.studentId});

  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  final controller = Get.find<StudentController>();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final collegeIdController = TextEditingController();
  final ageController = TextEditingController();
  final twelfthPercentageController = TextEditingController();
  final tenthPercentageController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.student['name'] ?? '';
    surnameController.text = widget.student['surname'] ?? '';
    collegeIdController.text = widget.student['college_id']?.toString() ?? '';
    ageController.text = widget.student['age']?.toString() ?? '';
    twelfthPercentageController.text =
        widget.student['twelfth_percentage']?.toString() ?? '';
    tenthPercentageController.text =
        widget.student['tenth_percentage']?.toString() ?? '';
    emailController.text = widget.student['email'] ?? '';
    phoneController.text = widget.student['phone'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
      body: SingleChildScrollView(
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
              decoration: const InputDecoration(labelText: 'College ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: twelfthPercentageController,
              decoration: const InputDecoration(labelText: '12th Percentage'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: tenthPercentageController,
              decoration: const InputDecoration(labelText: '10th Percentage'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
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
                final collegeId = int.tryParse(collegeIdController.text.trim());
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
                if (!await controller.repository.isValidCollegeId(collegeId)) {
                  return;
                }

                final updatedStudent = Student1(
                  studentId: widget.studentId,
                  name: nameController.text.trim(),
                  surname: surnameController.text.trim(),
                  collegeId: collegeId,
                  age: age,
                  twelfthPercentage: twelfthPercentage,
                  tenthPercentage: tenthPercentage,
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim(),
                );

                await controller.updateStudent(updatedStudent);
                Get.back();
              },
              child: const Text('Update Student'),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/student_controller.dart';
// import '../model/student.dart';
// import '../model/college.dart';
//
// class EditScreen extends StatefulWidget {
//   final Map<String, dynamic>? student;
//   final int? studentId;
//   final College1? college;
//
//   EditScreen({this.student, this.studentId, this.college});
//
//   @override
//   _EditScreenState createState() => _EditScreenState();
// }
//
// class _EditScreenState extends State<EditScreen> {
//   final controller = Get.find<StudentController>();
//   final nameController = TextEditingController();
//   final surnameController = TextEditingController();
//   final collegeIdController = TextEditingController();
//   final ageController = TextEditingController();
//   final twelfthPercentageController = TextEditingController();
//   final tenthPercentageController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final collegeNameController = TextEditingController();
//   final degreeController = TextEditingController();
//   late int currentPage;
//   late PageController pageController;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.student != null) {
//       nameController.text = widget.student!['name'] ?? '';
//       surnameController.text = widget.student!['surname'] ?? '';
//       collegeIdController.text = widget.student!['college_id']?.toString() ?? '';
//       ageController.text = widget.student!['age']?.toString() ?? '';
//       twelfthPercentageController.text = widget.student!['twelfth_percentage']?.toString() ?? '';
//       tenthPercentageController.text = widget.student!['tenth_percentage']?.toString() ?? '';
//       emailController.text = widget.student!['email'] ?? '';
//       phoneController.text = widget.student!['phone'] ?? '';
//       currentPage = 0;
//       pageController = PageController(initialPage: 0);
//     } else if (widget.college != null) {
//       collegeNameController.text = widget.college!.collegeName;
//       degreeController.text = widget.college!.degree;
//       currentPage = 1;
//       pageController = PageController(initialPage: 1);
//     } else {
//       currentPage = 0;
//       pageController = PageController(initialPage: 0);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit ${currentPage == 0 ? 'Student' : 'College'}'),
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
//                   setState(() {
//                     currentPage = 0;
//                   });
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: currentPage == 0 ? Colors.blue : Colors.grey[300],
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     'Student',
//                     style: TextStyle(
//                       color: currentPage == 0 ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               GestureDetector(
//                 onTap: () {
//                   pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
//                   setState(() {
//                     currentPage = 1;
//                   });
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: currentPage == 1 ? Colors.blue : Colors.grey[300],
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     'College',
//                     style: TextStyle(
//                       color: currentPage == 1 ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: PageView(
//               controller: pageController,
//               onPageChanged: (index) {
//                 setState(() {
//                   currentPage = index;
//                 });
//               },
//               children: [
//                 // Student1 Form
//                 SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: nameController,
//                         decoration: const InputDecoration(labelText: 'Name'),
//                       ),
//                       TextField(
//                         controller: surnameController,
//                         decoration: const InputDecoration(labelText: 'Surname'),
//                       ),
//                       TextField(
//                         controller: collegeIdController,
//                         decoration: const InputDecoration(labelText: 'College ID'),
//                         keyboardType: TextInputType.number,
//                       ),
//                       TextField(
//                         controller: ageController,
//                         decoration: const InputDecoration(labelText: 'Age'),
//                         keyboardType: TextInputType.number,
//                       ),
//                       TextField(
//                         controller: twelfthPercentageController,
//                         decoration: const InputDecoration(labelText: '12th Percentage'),
//                         keyboardType: TextInputType.number,
//                       ),
//                       TextField(
//                         controller: tenthPercentageController,
//                         decoration: const InputDecoration(labelText: '10th Percentage'),
//                         keyboardType: TextInputType.number,
//                       ),
//                       TextField(
//                         controller: emailController,
//                         decoration: const InputDecoration(labelText: 'Email'),
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                       TextField(
//                         controller: phoneController,
//                         decoration: const InputDecoration(labelText: 'Phone'),
//                         keyboardType: TextInputType.phone,
//                       ),
//                     ],
//                   ),
//                 ),
//                 // College1 Form
//                 SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: collegeNameController,
//                         decoration: const InputDecoration(labelText: 'College Name'),
//                       ),
//                       TextField(
//                         controller: degreeController,
//                         decoration: const InputDecoration(labelText: 'Degree'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () async {
//                 if (currentPage == 0 && widget.student != null) {
//                   if (nameController.text.trim().isEmpty ||
//                       surnameController.text.trim().isEmpty ||
//                       collegeIdController.text.trim().isEmpty ||
//                       ageController.text.trim().isEmpty ||
//                       twelfthPercentageController.text.trim().isEmpty ||
//                       tenthPercentageController.text.trim().isEmpty ||
//                       emailController.text.trim().isEmpty ||
//                       phoneController.text.trim().isEmpty) {
//                     return;
//                   }
//                   final collegeId = int.tryParse(collegeIdController.text.trim());
//                   final age = int.tryParse(ageController.text.trim());
//                   final twelfthPercentage = double.tryParse(twelfthPercentageController.text.trim());
//                   final tenthPercentage = double.tryParse(tenthPercentageController.text.trim());
//                   if (collegeId == null || age == null || twelfthPercentage == null || tenthPercentage == null) {
//                     return;
//                   }
//                   if (!await controller.repository.isValidCollegeId(collegeId)) {
//                     return;
//                   }
//
//                   final updatedStudent = Student1(
//                     studentId: widget.studentId!,
//                     name: nameController.text.trim(),
//                     surname: surnameController.text.trim(),
//                     collegeId: collegeId,
//                     age: age,
//                     twelfthPercentage: twelfthPercentage,
//                     tenthPercentage: tenthPercentage,
//                     email: emailController.text.trim(),
//                     phone: phoneController.text.trim(),
//                   );
//
//                   await controller.updateStudent(updatedStudent);
//                 } else if (currentPage == 1 && widget.college != null) {
//                   if (collegeNameController.text.trim().isEmpty || degreeController.text.trim().isEmpty) {
//                     return;
//                   }
//
//                   final updatedCollege = College1(
//                     collegeId: widget.college!.collegeId,
//                     collegeName: collegeNameController.text.trim(),
//                     degree: degreeController.text.trim(),
//                   );
//
//                   await controller.updateCollege(updatedCollege);
//                 }
//                 Get.back();
//               },
//               child: const Text('Update'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
