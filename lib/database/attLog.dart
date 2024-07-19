// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AttLog {
  String objectId;
  int attFingerId;
  String empId;
  String name;
  DateTime timestamp;
  int machineNo;
  AttLog({
    required this.objectId,
    required this.attFingerId,
    required this.empId,
    required this.name,
    required this.timestamp,
    required this.machineNo,
  });

  AttLog copyWith({
    String? objectId,
    int? attFingerId,
    String? empId,
    String? name,
    DateTime? timestamp,
    int? machineNo,
  }) {
    return AttLog(
      objectId: objectId ?? this.objectId,
      attFingerId: attFingerId ?? this.attFingerId,
      empId: empId ?? this.empId,
      name: name ?? this.name,
      timestamp: timestamp ?? this.timestamp,
      machineNo: machineNo ?? this.machineNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'objectId': objectId,
      'attFingerId': attFingerId,
      'empId': empId,
      'name': name,
      'timestamp': timestamp,
      'machineNo': machineNo,
    };
  }

  factory AttLog.fromMap(Map<String, dynamic> map) {
    return AttLog(
      objectId: map['_id'].toString(),
      attFingerId: map['attFingerId'] as int,
      empId: map['empId'] as String,
      name: map['name'] as String,
      timestamp: map['timestamp'],
      machineNo: map['machineNo'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttLog.fromJson(String source) =>
      AttLog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttLog(objectId: $objectId, attFingerId: $attFingerId, empId: $empId, name: $name, timestamp: $timestamp, machineNo: $machineNo)';
  }

  @override
  bool operator ==(covariant AttLog other) {
    if (identical(this, other)) return true;

    return other.objectId == objectId &&
        other.attFingerId == attFingerId &&
        other.empId == empId &&
        other.name == name &&
        other.timestamp == timestamp &&
        other.machineNo == machineNo;
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        attFingerId.hashCode ^
        empId.hashCode ^
        name.hashCode ^
        timestamp.hashCode ^
        machineNo.hashCode;
  }
}
