class Student {
  final int? id;
  final String name;
  final int age;
  final String course;

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.course,
  });

  // Convert a Student into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'course': course,
    };
  }

  // Extract a Student object from a Map.
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
      course: map['course'] as String,
    );
  }

  Student copyWith({
    int? id,
    String? name,
    int? age,
    String? course,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      course: course ?? this.course,
    );
  }
}
