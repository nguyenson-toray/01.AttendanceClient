import 'dart:convert';

import 'package:intl/intl.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LeaveRegister {
  int no;
  String name;
  String empId;
  DateTime fromDate;
  String fromTime;
  DateTime toDate;
  String toTime;
  String type;
  String note;
  LeaveRegister({
    required this.no,
    required this.name,
    required this.empId,
    required this.fromDate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.type,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'no': no,
      'name': name,
      'empId': empId,
      'fromDate': fromDate,
      'fromTime': fromTime,
      'toDate': toDate,
      'toTime': toTime,
      'type': type,
      'note': note,
    };
  }

  factory LeaveRegister.fromMap(Map<String, dynamic> map) {
    return LeaveRegister(
      no: map['no'] as int,
      name: map['name'] as String,
      empId: map['empId'] as String,
      fromDate: map['fromDate'] as DateTime,
      fromTime: map['fromTime'] as String,
      toDate: map['toDate'] as DateTime,
      toTime: map['toTime'] as String,
      type: map['type'] as String,
      note: map['note'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LeaveRegister.fromJson(String source) =>
      LeaveRegister.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant LeaveRegister other) {
    if (identical(this, other)) return true;

    return other.no == no &&
        other.name == name &&
        other.empId == empId &&
        other.fromDate == fromDate &&
        other.fromTime == fromTime &&
        other.toDate == toDate &&
        other.toTime == toTime &&
        other.type == type &&
        other.note == note;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        empId.hashCode ^
        fromDate.hashCode ^
        fromTime.hashCode ^
        toDate.hashCode ^
        toTime.hashCode ^
        note.hashCode;
  }

  @override
  String toString() {
    return 'No: $no, Name: $name, Emp ID: $empId, From: ${DateFormat('dd-MMM-yyyy').format(fromDate)} : $fromTime, To: ${DateFormat('dd-MMM-yyyy').format(toDate)} :  $toTime, Type: $type, Note: $note)';
  }
}
