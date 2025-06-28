// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OtRegister {
  int id;
  String requestNo;
  DateTime requestDate;
  DateTime otDate;
  String otTimeBegin;
  String otTimeEnd;
  String empId;
  String name;
  OtRegister({
    required this.id,
    required this.requestNo,
    required this.requestDate,
    required this.otDate,
    required this.otTimeBegin,
    required this.otTimeEnd,
    required this.empId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'requestNo': requestNo,
      'requestDate': requestDate,
      'otDate': otDate,
      'otTimeBegin': otTimeBegin,
      'otTimeEnd': otTimeEnd,
      'empId': empId,
      'name': name,
    };
  }

  factory OtRegister.fromMap(Map<String, dynamic> map) {
    return OtRegister(
      id: map['_id'] as int,
      requestNo: map['requestNo'] as String,
      requestDate: map['requestDate'],
      otDate: map['otDate'],
      otTimeBegin: map['otTimeBegin'] as String,
      otTimeEnd: map['otTimeEnd'] as String,
      empId: map['empId'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OtRegister.fromJson(String source) =>
      OtRegister.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OtRegister(id: $id, requestNo: $requestNo, requestDate: $requestDate, otDate: $otDate, otTimeBegin: $otTimeBegin, otTimeEnd: $otTimeEnd, empId: $empId, name: $name)';
  }

  @override
  bool operator ==(covariant OtRegister other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.requestNo == requestNo &&
        other.requestDate == requestDate &&
        other.otDate == otDate &&
        other.otTimeBegin == otTimeBegin &&
        other.otTimeEnd == otTimeEnd &&
        other.empId == empId &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        requestNo.hashCode ^
        requestDate.hashCode ^
        otDate.hashCode ^
        otTimeBegin.hashCode ^
        otTimeEnd.hashCode ^
        empId.hashCode ^
        name.hashCode;
  }

  // Custom equality check without ID
  bool equalsWithoutId(OtRegister other) {
    return requestNo == other.requestNo &&
        requestDate == other.requestDate &&
        otDate == other.otDate &&
        otTimeBegin == other.otTimeBegin &&
        otTimeEnd == other.otTimeEnd &&
        empId == other.empId &&
        name == other.name;
  }

  // Custom hash code without ID
  int get hashCodeWithoutId {
    return requestNo.hashCode ^
        requestDate.hashCode ^
        otDate.hashCode ^
        otTimeBegin.hashCode ^
        otTimeEnd.hashCode ^
        empId.hashCode ^
        name.hashCode;
  }

  // Create a unique key without ID for deduplication
  String get uniqueKeyWithoutId {
    return '${requestNo}_${requestDate}_${otDate}_${otTimeBegin}_${otTimeEnd}_${empId}_${name}';
  }
}
