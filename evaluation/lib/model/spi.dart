class Spi {
  int? id;
  int studentId;
  int semester;
  double spi;

  Spi({
    this.id,
    required this.studentId,
    required this.semester,
    required this.spi,
  });

  factory Spi.fromMap(Map<String, dynamic> map) => Spi(
    id: map['id'],
    studentId: map['studentId'],
    semester: map['semester'],
    spi: map['spi'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'studentId': studentId,
    'semester': semester,
    'spi': spi,
  };
}
