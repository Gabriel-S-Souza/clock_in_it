import 'dart:convert';

import '../../domain/entities/employee_detail_entity.dart';

class EmployeeDetailModel extends EmployeeDetailEntity {
  EmployeeDetailModel({
    required super.id,
    required super.name,
    required super.personalId,
    required super.biometric,
    required super.pic,
    required super.createdAt,
  });

  factory EmployeeDetailModel.fromJson(Map<String, dynamic> json) => EmployeeDetailModel(
        id: json['id'],
        name: json['name'],
        personalId: json['personalId'],
        biometric: json['biometric'],
        pic: base64.decode(json['pic']),
        createdAt: DateTime.parse(json['createdAt']),
      );
}
