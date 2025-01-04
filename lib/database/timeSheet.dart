// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TimeSheet {
  DateTime date;
  String empId;
  int attFingerId;
  String name;
  String department;
  String section;
  String group;
  String lineTeam;
  String shift;
  DateTime? firstIn;
  DateTime? lastOut;
  double normalHours;
  double workingDay;
  double otHours;
  double otHoursApproved;
  TimeSheet({
    required this.date,
    required this.empId,
    required this.attFingerId,
    required this.name,
    required this.department,
    required this.section,
    required this.group,
    required this.lineTeam,
    required this.shift,
    this.firstIn,
    this.lastOut,
    required this.normalHours,
    required this.workingDay,
    required this.otHours,
    required this.otHoursApproved,
  });

  TimeSheet copyWith({
    DateTime? date,
    String? empId,
    int? attFingerId,
    String? name,
    String? department,
    String? section,
    String? group,
    String? lineTeam,
    DateTime? firstIn,
    DateTime? lastOut,
    double? normalHours,
    double? workingDay,
    double? otHours,
    double? otHoursApproved,
  }) {
    return TimeSheet(
      date: date ?? this.date,
      empId: empId ?? this.empId,
      attFingerId: attFingerId ?? this.attFingerId,
      name: name ?? this.name,
      department: department ?? this.department,
      section: section ?? this.section,
      group: group ?? this.group,
      lineTeam: lineTeam ?? this.lineTeam,
      shift: shift ?? shift,
      firstIn: firstIn ?? this.firstIn,
      lastOut: lastOut ?? this.lastOut,
      normalHours: normalHours ?? this.normalHours,
      workingDay: workingDay ?? this.workingDay,
      otHours: otHours ?? this.otHours,
      otHoursApproved: otHours ?? this.otHoursApproved,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'empId': empId,
      'attFingerId': attFingerId,
      'name': name,
      'department': department,
      'section': section,
      'group': group,
      'lineTeam': lineTeam,
      'shift': shift,
      'firstIn': firstIn,
      'lastOut': lastOut,
      'normalHours': normalHours,
      'workingDay': workingDay,
      'otHours': otHours,
      'otHoursApproved': otHoursApproved,
    };
  }

  factory TimeSheet.fromMap(Map<String, dynamic> map) {
    return TimeSheet(
      date: DateTime.parse(map['date']),
      empId: map['empId'] as String,
      attFingerId: map['attFingerId'] as int,
      name: map['name'] as String,
      department: map['department'] as String,
      section: map['section'] as String,
      group: map['group'] as String,
      lineTeam: map['lineTeam'] as String,
      shift: map['shift'] as String,
      firstIn: map['firstIn'] != null ? DateTime.parse(map['firstIn']) : null,
      lastOut: map['lastOut'] != null ? DateTime.parse(map['lastOut']) : null,
      normalHours: map['normalHours'] as double,
      workingDay: map['workingDay'] as double,
      otHours: map['otHours'] as double,
      otHoursApproved: map['otHoursApproved'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSheet.fromJson(String source) =>
      TimeSheet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TimeSheet(date: $date, empId: $empId, attFingerId: $attFingerId, name: $name, department: $department, section: $section, group: $group, lineTeam: $lineTeam,  shift: $shift, firstIn: $firstIn, lastOut: $lastOut, normalHours: $normalHours, workingDay: $workingDay, otHours: $otHours,  otHoursApproved: $otHoursApproved)';
  }

  @override
  bool operator ==(covariant TimeSheet other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.empId == empId &&
        other.attFingerId == attFingerId &&
        other.name == name &&
        other.department == department &&
        other.section == section &&
        other.group == group &&
        other.lineTeam == lineTeam &&
        other.shift == shift &&
        other.firstIn == firstIn &&
        other.lastOut == lastOut &&
        other.normalHours == normalHours &&
        other.workingDay == workingDay &&
        other.otHours == otHours &&
        other.otHoursApproved == otHoursApproved;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        empId.hashCode ^
        attFingerId.hashCode ^
        name.hashCode ^
        department.hashCode ^
        section.hashCode ^
        group.hashCode ^
        lineTeam.hashCode ^
        firstIn.hashCode ^
        lastOut.hashCode ^
        normalHours.hashCode ^
        workingDay.hashCode ^
        otHours.hashCode ^
        otHoursApproved.hashCode;
  }
}
