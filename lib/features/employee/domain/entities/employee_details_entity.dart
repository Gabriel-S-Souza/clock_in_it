import 'dart:typed_data';

class EmployeeDetailsEntity {
  String id;
  String name;
  int personalId;
  List<List<double>> biometric;
  Uint8List pic;
  DateTime createdAt;

  EmployeeDetailsEntity({
    required this.id,
    required this.name,
    required this.personalId,
    required this.biometric,
    required this.pic,
    required this.createdAt,
  });
}
