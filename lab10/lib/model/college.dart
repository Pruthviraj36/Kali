class College1 {
  final int collegeId;
  final String collegeName;
  final String degree;

  College1({
    required this.collegeId,
    required this.collegeName,
    required this.degree,
  });

  factory College1.fromMap(Map<String, dynamic> map) {
    return College1(
      collegeId: map['college_id'],
      collegeName: map['college_name'],
      degree: map['degree'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'college_name': collegeName,
      'degree': degree,
    };
    if (collegeId != 0) {
      map['college_id'] = collegeId.toString();
    }
    return map;
  }
}