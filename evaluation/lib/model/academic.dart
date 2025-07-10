class Academic {
  int? id;
  int studentId;
  String schoolname;
  String percetage;
  String? grade12;
  String? diploma;

  Academic({
    this.id,
    required this.studentId,
    required this.schoolname,
    required this.percetage,
    this.grade12,
    this.diploma,
  });

  factory Academic.fromMap(Map<String, dynamic> map) => Academic(
    id: map['id'],
    studentId: map['studentId'],
    schoolname: map['schoolname'],
    percetage: map['percetage'],
    grade12: map['grade12'],
    diploma: map['diploma'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'studentId': studentId,
    'schoolname': schoolname,
    'percetage': percetage,
    'grade12': grade12,
    'diploma': diploma,
  };
}
