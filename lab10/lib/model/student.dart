class Student1 {
  final int studentId;
  final String name;
  final String surname;
  final int collegeId;
  final int age;
  final double twelfthPercentage;
  final double tenthPercentage;
  final String email;
  final String phone;

  Student1({
    required this.studentId,
    required this.name,
    required this.surname,
    required this.collegeId,
    required this.age,
    required this.twelfthPercentage,
    required this.tenthPercentage,
    required this.email,
    required this.phone,
  });

  factory Student1.fromMap(Map<String, dynamic> map) {
    return Student1(
      studentId: map['student_id'],
      name: map['name'],
      surname: map['surname'],
      collegeId: map['college_id'],
      age: map['age'],
      twelfthPercentage: map['twelfth_percentage'],
      tenthPercentage: map['tenth_percentage'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'surname': surname,
      'college_id': collegeId,
      'age': age,
      'twelfth_percentage': twelfthPercentage,
      'tenth_percentage': tenthPercentage,
      'email': email,
      'phone': phone,
    };
    if (studentId != 0) {
      map['student_id'] = studentId;
    }
    return map;
  }
}




