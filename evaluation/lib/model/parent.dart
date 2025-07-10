class Parent {
  int? id;
  int studentId;
  String guardianName;
  String relation;
  String contact;

  Parent({
    this.id,
    required this.studentId,
    required this.guardianName,
    required this.relation,
    required this.contact,
  });

  factory Parent.fromMap(Map<String, dynamic> map) => Parent(
    id: map['id'],
    studentId: map['student_id'],
    guardianName: map['guardian_name'],
    relation: map['relation'],
    contact: map['contact'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'student_id': studentId,
    'guardian_name': guardianName,
    'relation': relation,
    'contact': contact,
  };
}
