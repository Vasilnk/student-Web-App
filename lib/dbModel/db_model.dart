import 'dart:typed_data';

class StudentModel {
  int? id;
  String name;
  String? age;
  String? guardian;
  String? contact;
  Uint8List? image;

  StudentModel({
    this.id,
    required this.name,
    required this.age,
    required this.guardian,
    required this.contact,

    // required this.image,
  });
  static StudentModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final age = map['age'] as String;
    final guardian = map['guardian'].toString();
    final contact = map['contact'].toString();
    // final image = map['image'] as Uint8List;

    return StudentModel(
      id: id,
      name: name,
      age: age,
      guardian: guardian,
      contact: contact,
      // image: image
    );
  }
}
