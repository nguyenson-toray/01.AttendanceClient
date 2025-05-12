// ignore_for_file: public_member_api_docs, sort_constructors_first

class TimeSheetDate {
  DateTime date;
  String empId;
  int attFingerId;
  String name;
  String department;
  String section;
  String group;
  String shift;
  DateTime? firstIn;
  DateTime? lastOut;
  double normalHours;
  double otHours;
  double otHoursApproved;
  double otHoursFinal;
  String attNote1;
  String attNote2;
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
    required this.shift,
    this.firstIn,
    this.lastOut,
    required this.normalHours,
    required this.otHours,
    required this.otHoursApproved,
    required this.otHoursFinal,
    required this.attNote1,
    required this.attNote2,
    required this.leaveRegisterType,
    required this.leaveRegisterInfo,
  });

  @override
  String toString() {
    return 'TimeSheetDate(date: $date, empId: $empId, attFingerId: $attFingerId, name: $name, department: $department, section: $section, group: $group,  shift: $shift, firstIn: $firstIn, lastOut: $lastOut, normalHours: $normalHours, otHours: $otHours,  otHoursApproved: $otHoursApproved, otHoursFinal: $otHoursFinal, attNote1: $attNote1, attNote2: $attNote2, leaveRegisterType:  $leaveRegisterType, leaveRegisterInfo: $leaveRegisterInfo';
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
        other.shift == shift &&
        other.firstIn == firstIn &&
        other.lastOut == lastOut &&
        other.normalHours == normalHours &&
        other.otHours == otHours &&
        other.otHoursApproved == otHoursApproved &&
        other.otHoursFinal == otHoursFinal &&
        other.attNote1 == attNote1 &&
        other.attNote2 == attNote2 &&
        other.leaveRegisterType == leaveRegisterType &&
        other.leaveRegisterInfo == leaveRegisterInfo;
  }
}
