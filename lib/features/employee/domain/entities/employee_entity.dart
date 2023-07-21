class EmployeeEntity {
  String id;
  String name;
  int personalId;
  List<List<double>> biometric;
  List<int> pic;
  DateTime createdAt;

  EmployeeEntity({
    required this.id,
    required this.name,
    required this.personalId,
    required this.biometric,
    required this.pic,
    required this.createdAt,
  });
}
