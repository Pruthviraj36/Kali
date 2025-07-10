import 'package:get/get.dart';
import '../model/student.dart';
import '../model/college.dart';
import '../repository/database_repository.dart';

class StudentController extends GetxController {
  final DatabaseRepository repository = Get.find<DatabaseRepository>();
  var studentList = <Map<String, dynamic>>[].obs;
  var colleges = <College1>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
    fetchColleges();
  }

  Future<void> fetchStudents() async {
    studentList.value = await repository.getStudentWithCollege();
  }

  Future<void> fetchColleges() async {
    colleges.value = await repository.getColleges();
  }

  Future<void> addStudent(Student1 student) async {
    await repository.addStudent(student);
    await fetchStudents();
  }

  Future<void> updateStudent(Student1 student) async {
    await repository.updateStudent(student);
    await fetchStudents();
  }

  Future<void> deleteStudent(int studentId) async {
    await repository.deleteStudent(studentId);
    await fetchStudents();
  }

  Future<void> addCollege(College1 college) async {
    await repository.addCollege(college);
    await fetchColleges();
    await fetchStudents();
  }

  Future<void> updateCollege(College1 college) async {
    await repository.updateCollege(college);
    await fetchColleges();
    await fetchStudents();
  }

  Future<void> deleteCollege(int collegeId) async {
    await repository.deleteCollege(collegeId);
    await fetchColleges();
    await fetchStudents();
  }
}