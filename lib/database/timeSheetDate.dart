// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tiqn/database/leaveRegister.dart';

class TimeSheetDate {
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
  double otHours;
  double otHoursApproved;
  double otHoursFinal;
  String attNote;
  String leaveRegisterType;
  String leaveRegisterInfo;
  TimeSheetDate({
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
    required this.otHours,
    required this.otHoursApproved,
    required this.otHoursFinal,
    required this.attNote,
    required this.leaveRegisterType,
    required this.leaveRegisterInfo,
  });

  @override
  String toString() {
    return 'TimeSheetDate(date: $date, empId: $empId, attFingerId: $attFingerId, name: $name, department: $department, section: $section, group: $group, lineTeam: $lineTeam,  shift: $shift, firstIn: $firstIn, lastOut: $lastOut, normalHours: $normalHours, otHours: $otHours,  otHoursApproved: $otHoursApproved, otHoursFinal: $otHoursFinal, attNote: $attNote), leaveRegisterType:  $leaveRegisterType, leaveRegisterInfo: $leaveRegisterInfo';
  }

  @override
  bool operator ==(covariant TimeSheetDate other) {
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
        other.otHours == otHours &&
        other.otHoursApproved == otHoursApproved &&
        other.otHoursFinal == otHoursFinal &&
        other.attNote == attNote &&
        other.leaveRegisterType == leaveRegisterType &&
        other.leaveRegisterInfo == leaveRegisterInfo;
  }
}
