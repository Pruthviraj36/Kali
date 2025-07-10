class Subject {
  String subjectname;
  int studentId;
  int semester;
  int credits;
  int? id;

  Subject({
    this.id,
    required this.studentId,
    required this.subjectname,
    required this.semester,
    required this.credits,
  });

  factory Subject.fromMap(Map<String, dynamic> map) => Subject(
    id: map['id'],
    studentId: map['studentId'],
    subjectname: map['subjectname'],
    semester: map['semester'],
    credits: map['credits'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'studentId': studentId,
    'subjectname': subjectname,
    'semester': semester,
    'credits': credits,
  };
}
