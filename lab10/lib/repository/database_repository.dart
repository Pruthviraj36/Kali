import '../database/database_helper.dart';
import '../model/student.dart';
import '../model/college.dart';

class DatabaseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> getStudentWithCollege() async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT student1.student_id, student1.name, student1.age, student1.college_id, college1.college_name,
             student1.surname, student1.twelfth_percentage, student1.tenth_percentage, student1.email, student1.phone
      FROM student1
      INNER JOIN college1 ON student1.college_id = college1.college_id
    ''');
  }

  Future<List<College1>> getColleges() async {
    final db = await _dbHelper.database;
    final result = await db.query('college1');
    return result.map((map) => College1.fromMap(map)).toList();
  }

  Future<bool> isValidCollegeId(int collegeId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'college1',
      where: 'college_id = ?',
      whereArgs: [collegeId],
    );
    return result.isNotEmpty;
  }

  Future<void> addStudent(Student1 student) async {
    final db = await _dbHelper.database;
    await db.insert('student1', student.toMap());
  }

  Future<void> updateStudent(Student1 student) async {
    final db = await _dbHelper.database;
    await db.update(
      'student1',
      student.toMap(),
      where: 'student_id = ?',
      whereArgs: [student.studentId],
    );
  }

  Future<void> deleteStudent(int studentId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'student1',
      where: 'student_id = ?',
      whereArgs: [studentId],
    );
  }

  Future<void> addCollege(College1 college) async {
    final db = await _dbHelper.database;
    await db.insert('college1', college.toMap());
  }

  Future<void> updateCollege(College1 college) async {
    final db = await _dbHelper.database;
    await db.update(
      'college1',
      college.toMap(),
      where: 'college_id = ?',
      whereArgs: [college.collegeId],
    );
  }

  Future<void> deleteCollege(int collegeId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'college1',
      where: 'college_id = ?',
      whereArgs: [collegeId],
    );
  }
}
