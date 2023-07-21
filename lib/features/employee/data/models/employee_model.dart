import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  EmployeeModel({
    required super.id,
    required super.name,
    required super.personalId,
    required super.biometric,
    required super.pic,
    required super.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json['id'],
        name: json['name'],
        personalId: json['personalId'],
        biometric: List<List<double>>.from(
            json['biometric'].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
        //  List<int>
        pic: List<int>.from(json['pic']['data']),
        createdAt: DateTime.parse(json['createdAt']),
      );
}
