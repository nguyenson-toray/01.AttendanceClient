// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class ShiftRegister {
  String objectId;
  DateTime fromDate;
  DateTime toDate;
  String empId;
  String name;
  String shift;
  ShiftRegister({
    required this.objectId,
    required this.fromDate,
    required this.toDate,
    required this.empId,
    required this.name,
    required this.shift,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // '_id': ObjectId(),
      'fromDate': fromDate,
      'toDate': toDate,
      'empId': empId,
      'name': name,
      'shift': shift,
    };
  }

  factory ShiftRegister.fromMap(Map<String, dynamic> map) {
    return ShiftRegister(
      objectId: map['_id'].toString(),
      fromDate: map['fromDate'],
      toDate: map['toDate'],
      empId: map['empId'] as String,
      name: map['name'] as String,
      shift: map['shift'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftRegister.fromJson(String source) =>
      ShiftRegister.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ShiftRegister other) {
    if (identical(this, other)) return true;

    return other.objectId == objectId &&
        other.fromDate == fromDate &&
        other.toDate == toDate &&
        other.empId == empId &&
        other.name == name &&
        other.shift == shift;
  }

  @override
  int get hashCode {
    return fromDate.hashCode ^ toDate.hashCode ^ empId.hashCode ^ name.hashCode;
  }

  @override
  String toString() {
    return 'ShiftRegister(from: $fromDate, to: $toDate, empId: $empId, name: $name, shift: $shift)';
  }
}
