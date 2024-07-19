// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TimeSheetMonthYear {
  String monthYear;
  DateTime lastUpdate;
  String empId;
  int attFingerId;
  String name;
  String department;
  String section;
  String group;
  String lineTeam;
  double normalHours;
  double otHours;
  double otHoursApproved;
  double otHoursFinal;
  TimeSheetMonthYear({
    required this.monthYear,
    required this.lastUpdate,
    required this.empId,
    required this.attFingerId,
    required this.name,
    required this.department,
    required this.section,
    required this.group,
    required this.lineTeam,
    required this.normalHours,
    required this.otHours,
    required this.otHoursApproved,
    required this.otHoursFinal,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'monthYear': monthYear,
      'lastUpdate': lastUpdate,
      'empId': empId,
      'attFingerId': attFingerId,
      'name': name,
      'department': department,
      'section': section,
      'group': group,
      'lineTeam': lineTeam,
      'normalHours': normalHours,
      'otHours': otHours,
      'otHoursApproved': otHoursApproved,
      'otHoursFinal': otHoursFinal,
    };
  }

  factory TimeSheetMonthYear.fromMap(Map<String, dynamic> map) {
    return TimeSheetMonthYear(
      monthYear: map['monthYear'] as String,
      lastUpdate: map['lastUpdate'],
      empId: map['empId'] as String,
      attFingerId: map['attFingerId'] as int,
      name: map['name'] as String,
      department: map['department'] as String,
      section: map['section'] as String,
      group: map['group'] as String,
      lineTeam: map['lineTeam'] as String,
      normalHours: map['normalHours'] as double,
      otHours: map['otHours'] as double,
      otHoursApproved: map['otHoursApproved'] as double,
      otHoursFinal:
          map['otHoursFinal'] == null ? 0 : map['otHoursFinal'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSheetMonthYear.fromJson(String source) =>
      TimeSheetMonthYear.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TimeSheetMonth(monthYear: $monthYear, lastUpdate: $lastUpdate, empId: $empId, attFingerId: $attFingerId, name: $name, department: $department, section: $section, group: $group, lineTeam: $lineTeam, normalHours: $normalHours, otHours: $otHours, otHoursApproved: $otHoursApproved,  otHoursFinal: $otHoursFinal)';
  }

  @override
  bool operator ==(covariant TimeSheetMonthYear other) {
    if (identical(this, other)) return true;

    return other.monthYear == monthYear &&
        other.lastUpdate == lastUpdate &&
        other.empId == empId &&
        other.attFingerId == attFingerId &&
        other.name == name &&
        other.department == department &&
        other.section == section &&
        other.group == group &&
        other.lineTeam == lineTeam &&
        other.normalHours == normalHours &&
        other.otHours == otHours &&
        other.otHoursApproved == otHoursApproved &&
        other.otHoursFinal == otHoursFinal;
  }

  @override
  int get hashCode {
    return monthYear.hashCode ^
        lastUpdate.hashCode ^
        empId.hashCode ^
        attFingerId.hashCode ^
        name.hashCode ^
        department.hashCode ^
        section.hashCode ^
        group.hashCode ^
        lineTeam.hashCode ^
        normalHours.hashCode ^
        otHours.hashCode ^
        otHoursApproved.hashCode ^
        otHoursFinal.hashCode;
  }
}
