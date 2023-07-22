import 'dart:convert';
import 'dart:typed_data';

import '../../domain/entities/employee_details_entity.dart';

class EmployeeDetailsModel extends EmployeeDetailsEntity {
  EmployeeDetailsModel({
    required super.id,
    required super.name,
    required super.personalId,
    required super.biometric,
    required super.pic,
    required super.createdAt,
  });

  factory EmployeeDetailsModel.fromJson(Map<String, dynamic> json) => EmployeeDetailsModel(
        id: json['id'],
        name: json['name'],
        personalId: json['personalId'],
        biometric: List<List<double>>.from(
            json['biometric'].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
        pic: _decodeImage(List<int>.from(json['pic']['data'])),
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'personalId': personalId,
        'biometric':
            List<List<double>>.from(biometric.map((x) => List<double>.from(x.map((x) => x)))),
        'pic': {
          'type': 'Buffer',
          'data': _encodeImage(pic),
        },
        'createdAt': createdAt.toIso8601String(),
      };

  static Uint8List _decodeImage(List<int> imageData) {
    final base64String = String.fromCharCodes(imageData);
    return base64Decode(base64String.replaceAll('data:image/png;base64,', ''));
  }

  List<int> _encodeImage(Uint8List img) {
    final base64String = base64Encode(img);
    final encodedImage = 'data:image/png;base64,$base64String';
    final encodedImageData = encodedImage.codeUnits;
    return encodedImageData;
  }
}
