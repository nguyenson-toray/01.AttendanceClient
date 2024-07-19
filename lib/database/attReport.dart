// ignore_for_file: public_member_api_docs, sort_constructors_first

class _AttReport {
  late DateTime? date;
  late _AttReportDetail? direct;
  late _AttReportDetail? inDirect;
  late _AttReportDetail? management;
  late _AttReportDetail? total;

  @override
  String toString() {
    return '_AttReport( date: $date, direct: $direct, inDirect: $inDirect, management: $management, total: $total)';
  }
}

class _AttReportDetail {
  late int newlyJoined;
  late int maternityComeback;
  late int resigned;
  late int maternityLeave;
  late int working;
  late int enrolledTotal;
  late int actualWorking;
  late int absent;
  late double absentPercent;

  @override
  String toString() {
    return '_AttReportDetail(newlyJoined: $newlyJoined, maternityComeback: $maternityComeback, resigned: $resigned, maternityLeave: $maternityLeave, working: $working, enrolledTotal: $enrolledTotal, actualWorking: $actualWorking, absent: $absent, absentPercent: $absentPercent)';
  }
}
