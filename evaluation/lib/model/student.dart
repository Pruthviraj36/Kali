class Student {
  int? id;
  String fullname;
  String dob;
  String email;
  String phone;
  String gender;

  Student({
    this.id,
    required this.fullname,
    required this.dob,
    required this.email,
    required this.phone,
    required this.gender,
  });

  factory Student.fromMap(Map<String, dynamic> map) => Student(
    id: map['id'],
    fullname: map['fullname'],
    dob: map['dob'],
    email: map['email'],
    phone: map['phone'],
    gender: map['gender'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'fullname': fullname,
    'dob': dob,
    'email': email,
    'phone': phone,
    'gender': gender,
  };
}
