// import 'package:realm/realm.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiqn/database/history.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/leaveRegister.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/shift.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:tiqn/database/timeSheetDate.dart';
import 'package:tiqn/database/timeSheetMonthYear.dart';
import 'package:tiqn/gValue.dart';

class MyFuntion {
  // static void calculateLastId(RealmResults<Employee> employees) {
  //   for (var element in employees) {
  //     final finger = element.attFingerId!;
  //     final id = int.tryParse(element.empId.toString().split('TIQN-')[1])!;
  //     if (finger > gValue.lastFingerId) {
  //       gValue.lastFingerId = finger;
  //     }
  //     if (id > gValue.lastEmpId) {
  //       gValue.lastEmpId = id;
  //     }
  //   }
  // }

  // static List<Employee> convertRealmEmployeeToList(
  //     RealmResults<Employee> realmResults) {
  //   List<Employee> result = [];
  //   for (var element in realmResults) {
  //     result.add(element);
  //   }
  //   return result;
  // }
/*
  static AttReport createAttGeneralReport(
      DateTime dateInput, List<AttLog> attLogs) {
    late DateTime date;
    late AttReportDetail direct;
    late AttReportDetail inDirect;
    late AttReportDetail management;
    late AttReportDetail total;
    AttReport report;
    List<String> listEmpIdpresent = [];
    for (var log in attLogs) {
      listEmpIdpresent.add(log.empId!);
    }
    listEmpIdpresent = listEmpIdpresent.toSet().toList();
    print(
        'createAttGeneralReport -dateInput: $dateInput    Total att record : ${attLogs.length}');
    print('present : ${listEmpIdpresent.length}');
    //--
    late int newlyJoinedD = 0,
        newlyJoinedI = 0,
        newlyJoinedM = 0,
        newlyJoinedT = 0;
    late int maternityComebackD = 0,
        maternityComebackI = 0,
        maternityComebackM = 0,
        maternityComebackT = 0;
    late int resignedD = 0, resignedI = 0, resignedM = 0, resignedT = 0;
    late int maternityLeaveD = 0,
        maternityLeaveI = 0,
        maternityLeaveM = 0,
        maternityLeaveT = 0;
    late int workingD = 0, workingI = 0, workingM = 0, workingT = 0;
    late int enrolledTotalD = 0,
        enrolledTotalI = 0,
        enrolledTotalM = 0,
        enrolledTotalT = 0;
    late int actualWorkingD = 0,
        actualWorkingI = 0,
        actualWorkingM = 0,
        actualWorkingT = 0;
    late int absentD = 0, absentI = 0, absentM = 0, absentT = 0;
    late double absentPercentD = 0,
        absentPercentI = 0,
        absentPercentM = 0,
        absentPercentT = 0;

    date = dateInput;

    for (var emp in gValue.employees) {
      switch (emp.directIndirect) {
        case 'Direct':
          if (date.difference(emp.joiningDate!).inDays == 0) newlyJoinedD++;
          if (emp.maternityComebackDate != null) if (date
                  .difference(emp.maternityComebackDate!)
                  .inDays ==
              0) {
            maternityComebackD++;
          }
          if (emp.resignDate !=
              null) if (date.difference(emp.resignDate!).inDays == 0) {
            resignedD++;
          }
          if (emp.workStatus == 'Maternity') maternityLeaveD++;
          if (emp.workStatus == 'Working') workingD++;
          if (listEmpIdpresent.contains(emp.empId)) actualWorkingD++;
          break;
        case 'Indirect':
          if (date.difference(emp.joiningDate!).inDays == 0) newlyJoinedI++;
          if (emp.maternityComebackDate != null) if (date
                  .difference(emp.maternityComebackDate!)
                  .inDays ==
              0) {
            maternityComebackI++;
          }
          if (emp.resignDate !=
              null) if (date.difference(emp.resignDate!).inDays == 0) {
            resignedI++;
          }
          if (emp.workStatus == 'Maternity') maternityLeaveI++;
          if (emp.workStatus == 'Working') workingI++;
          if (listEmpIdpresent.contains(emp.empId)) actualWorkingI++;
          break;
        case 'Management':
          if (date.difference(emp.joiningDate!).inDays == 0) newlyJoinedM++;
          if (emp.maternityComebackDate != null) if (date
                  .difference(emp.maternityComebackDate!)
                  .inDays ==
              0) {
            maternityComebackM++;
          }
          if (emp.resignDate !=
              null) if (date.difference(emp.resignDate!).inDays == 0) {
            resignedM++;
          }
          if (emp.workStatus == 'Maternity') maternityLeaveM++;
          if (emp.workStatus == 'Working') workingM++;
          if (listEmpIdpresent.contains(emp.empId)) actualWorkingM++;
          break;
        default:
      }
    }
    enrolledTotalD = maternityLeaveD + workingD;
    absentD = workingD - actualWorkingD;
    absentPercentD =
        listEmpIdpresent.isEmpty ? 0 : absentD / (workingD - maternityLeaveD);

    direct = AttReportDetail(
        newlyJoinedD,
        maternityComebackD,
        resignedD,
        maternityLeaveD,
        workingD,
        enrolledTotalD,
        actualWorkingD,
        absentD,
        absentPercentD);
    //-----------
    enrolledTotalI = maternityLeaveI + workingI;
    absentI = workingI - actualWorkingI;
    absentPercentI =
        listEmpIdpresent.isEmpty ? 0 : absentI / (workingI - maternityLeaveI);
    inDirect = AttReportDetail(
        newlyJoinedI,
        maternityComebackI,
        resignedI,
        maternityLeaveI,
        workingI,
        enrolledTotalI,
        actualWorkingI,
        absentI,
        absentPercentI);
    //-----------
    enrolledTotalM = maternityLeaveM + workingM;
    absentM = workingM - actualWorkingM;
    absentPercentM =
        listEmpIdpresent.isEmpty ? 0 : absentM / (workingM - maternityLeaveM);
    management = AttReportDetail(
        newlyJoinedM,
        maternityComebackM,
        resignedM,
        maternityLeaveM,
        workingM,
        enrolledTotalM,
        actualWorkingM,
        absentM,
        absentPercentM);
    //-----------

    newlyJoinedT = newlyJoinedD + newlyJoinedI + newlyJoinedM;
    maternityComebackT =
        maternityComebackD + maternityComebackI + maternityComebackM;
    resignedT = resignedD + resignedI + resignedM;
    maternityLeaveT = maternityLeaveD + maternityLeaveI + maternityLeaveM;
    workingT = workingD + workingI + workingM;
    enrolledTotalT = enrolledTotalD + enrolledTotalI + enrolledTotalM;
    actualWorkingT = actualWorkingD + actualWorkingI + actualWorkingM;
    enrolledTotalT = gValue.employees
        .where((element) => element.workStatus != 'Resigned')
        .length;
    absentT = absentD + absentI + absentM;
    absentPercentT =
        listEmpIdpresent.isEmpty ? 0 : absentT / (workingT - maternityLeaveT);
    total = AttReportDetail(
        newlyJoinedT,
        maternityComebackT,
        resignedT,
        maternityLeaveT,
        workingT,
        enrolledTotalT,
        actualWorkingT,
        absentT,
        absentPercentT);
    //-------------------------
    report = AttReport(
      // ObjectId(),
        date: date,
        direct: direct,
        inDirect: inDirect,
        management: management,
        total: total);

    return report;
  }
*/
  static Widget showLoading() {
    return Container(
        alignment: Alignment.center,
        color: Colors.white,
        width: gValue.screenWidth,
        height: gValue.screenHeight,
        child: SizedBox(
          width: 100,
          height: 200,
          child: Column(children: [
            Image.asset('assets/images/logo.png'),
            Image.asset('assets/images/loading.gif'),
          ]),
        ));
  }

  static Widget showError(String error) {
    return Container(
        alignment: Alignment.center,
        color: Colors.white,
        width: gValue.screenWidth,
        height: gValue.screenHeight,
        child: SizedBox(
          width: 100,
          height: 200,
          child: Column(
              children: [Image.asset('assets/images/error.png'), Text(error)]),
        ));
  }

  static Widget showErrorPermission() {
    return Container(
        alignment: Alignment.center,
        color: Colors.black87,
        width: gValue.screenWidth,
        height: gValue.screenHeight,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Bạn không có quyền sử dụng phần mềm này !\nVui lòng liên hệ Mr. Sơn - IT',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
              Image.asset('assets/images/error.png'),
            ]));
  }

  static List<String> getMonthYearList(String year) {
    DateTime endDate = DateTime.now();
    List<String> list = [];
    int lastMonth = endDate.month;
    if (endDate.day > 25) lastMonth += 1;
    for (int i = 1; i <= lastMonth; i++) {
      list.add(DateFormat('yMMMM').format(DateTime.utc(int.parse(year), i, 1)));
    }
    return list.reversed.toList();
  }

  static void calculateAttendanceStatus() {
    gValue.employeeIdPresents.clear();
    gValue.employeeIdAbsents.clear();
    var temp = gValue.attLogs.map((e) => e.empId).toList();
    gValue.employeeIdPresents = temp.toSet().toList();
    gValue.employeeIdPresents.removeWhere((element) => element == 'No Emp Id');
    gValue.employeeIdAbsents = gValue.employeeIdWorkings
        .toSet()
        .difference(gValue.employeeIdPresents.toSet())
        .toList();

    print(
        'calculateAttendanceStatus :employeeIdPresents.length: ${gValue.employeeIdPresents.length}     \nemployeeIdAbsents.length: ${gValue.employeeIdAbsents.length}');
  }

  static void calculateEmployeeStatus() {
    gValue.enrolled = 0;
    gValue.employeeIdNames.clear();
    gValue.employeeIdMaternityLeaves.clear();
    gValue.employeeIdPregnantYoungchilds.clear();
    gValue.employeeIdWorkings.clear();
    for (var element in gValue.employees) {
      if (element.workStatus != 'Resigned') {
        gValue.enrolled++;
        gValue.employeeIdNames.add('${element.empId!}   ${element.name!}');
        if (element.workStatus == 'Maternity leave') {
          gValue.employeeIdMaternityLeaves.add(element.empId!);
        } else {
          gValue.employeeIdWorkings.add(element.empId!);
          if (element.workStatus.toString().contains('pregnant') ||
              element.workStatus.toString().contains('young')) {
            gValue.employeeIdPregnantYoungchilds.add(element.empId!);
          }
        }
      }
    }
    print(
        'calculateEmployeeStatus : employeeIdNames.length: ${gValue.employeeIdNames.length}     employeeIdWorkings.length: ${gValue.employeeIdWorkings.length} employeeIdMaternityLeaves.length: ${gValue.employeeIdMaternityLeaves.length}  employeeIdPregnantYoungchilds.length: ${gValue.employeeIdPregnantYoungchilds.length}');
  }

  static List<TimeSheetMonthYear> createTimeSheetsYear(
      Map<String, List<TimeSheetMonthYear>> timeSheetMonths, String year) {
    List<TimeSheetMonthYear> result = [];
    List<TimeSheetMonthYear> dataYear = [];
    List<String> empIdYear = [];
    timeSheetMonths.forEach((monthName, monthData) {
      if (monthName != '2025') {
        empIdYear.addAll(monthData.map((e) => e.empId).toSet().toList());
        for (var data in monthData) {
          dataYear.add(data);
        }
      }
    });
    empIdYear = empIdYear.toSet().toList();
    for (var empId in empIdYear) {
      final empInfo =
          gValue.employees.firstWhere((element) => element.empId == empId);
      final double totalNormalHours = dataYear
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.normalHours);
      final double totalOtHours = dataYear
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.otHours);
      final double totalOtHoursApproved = dataYear
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.otHoursApproved);
      final double totalOtHoursFinal = dataYear
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.otHoursFinal);
      result.add(
        TimeSheetMonthYear(
            monthYear: year,
            lastUpdate: DateTime.now(),
            empId: empId,
            attFingerId: empInfo.attFingerId!,
            name: empInfo.name!,
            department: empInfo.department!,
            section: empInfo.section!,
            group: empInfo.group!,
            lineTeam: empInfo.lineTeam!,
            normalHours: roundDouble(totalNormalHours, 1),
            otHours: roundDouble(totalOtHours, 1),
            otHoursApproved: roundDouble(totalOtHoursApproved, 1),
            otHoursFinal: roundDouble(totalOtHoursFinal, 1)),
      );
    }

    return result;
  }

  static List<TimeSheetMonthYear> createTimeSheetsMonth(
      List<TimeSheetDate> timeSheetDates, String monthYear) {
    List<TimeSheetMonthYear> result = [];

    final empIds = timeSheetDates.map((e) => e.empId).toSet().toList();
    for (var empId in empIds) {
      final empInfo =
          gValue.employees.firstWhere((element) => element.empId == empId);
      final double totalNormalHours = timeSheetDates
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.normalHours);
      final double totalOtHours = timeSheetDates
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.otHours);
      final double totalOtHoursApproved = timeSheetDates
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.otHoursApproved);
      final double totalOtHoursFinal = timeSheetDates
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.otHoursFinal);
      result.add(
        TimeSheetMonthYear(
            monthYear: monthYear,
            lastUpdate: DateTime.now(),
            empId: empId,
            attFingerId: empInfo.attFingerId!,
            name: empInfo.name!,
            department: empInfo.department!,
            section: empInfo.section!,
            group: empInfo.group!,
            lineTeam: empInfo.lineTeam!,
            normalHours: roundDouble(totalNormalHours, 1),
            otHours: roundDouble(totalOtHours, 1),
            otHoursApproved: roundDouble(totalOtHoursApproved, 1),
            otHoursFinal: roundDouble(totalOtHoursFinal, 1)),
      );
    }

    return result;
  }

  static List<TimeSheetDate> createTimeSheetsDate(
      List<Employee> employees,
      List<Shift> shifts,
      List<ShiftRegister> shiftRegisters,
      List<OtRegister> otRegisters,
      List<LeaveRegister> leaveRegisters,
      List<AttLog> attLogs,
      DateTime timeBegin,
      DateTime timeEnd) {
    List<TimeSheetDate> result = [];
    DateTime dateTemp = timeBegin;
    List<DateTime> dates = [];
    if (employees.isEmpty || attLogs.isEmpty) {
      return result;
    }
    while (dateTemp.isBefore(timeEnd)) {
      dates.add(dateTemp);
      dateTemp = dateTemp.add(const Duration(days: 1));
    }
    List<OtRegister> otRegistersOnDate = [];
    List<LeaveRegister> leaveRegisteronDate = [];
    for (var date in dates) {
      otRegistersOnDate.clear();
      List<AttLog> dayLogs =
          attLogs.where((log) => (log.timestamp.day == date.day)).toList();
      if (dayLogs.isEmpty) continue;
      List<String> empIdShift1 = [],
          empIdShift2 = [],
          // empIdCanteen = [],
          empIdOT = [];
      for (var element in shiftRegisters) {
        if (element.fromDate.isAtSameMomentAs(date) ||
            (element.fromDate.isBefore(date) && element.toDate.isAfter(date)) ||
            element.toDate.isAtSameMomentAs(date)) {
          if (element.shift == 'Shift 1') {
            empIdShift1.add(element.empId);
          } else if (element.shift == 'Shift 2') {
            empIdShift2.add(element.empId);
          }
        }
      }
      for (var element in otRegisters) {
        if (element.otDate.day == date.day &&
            element.otDate.month == date.month &&
            element.otDate.year == date.year) {
          otRegistersOnDate.add(element);
        }
      }
      for (var element in leaveRegisters) {
        if (date.isAtSameMomentAs(element.fromDate) ||
            date.isAtSameMomentAs(element.toDate) ||
            (date.isAfter(element.fromDate) && date.isBefore(element.toDate))) {
          leaveRegisteronDate.add(element);
        }
      }
      empIdOT = otRegisters
          .where((ot) => (ot.otDate.day == date.day &&
              ot.otDate.month == date.month &&
              ot.otDate.year == date.year))
          .toList()
          .map((e) => e.empId)
          .toList();
      for (var emp in employees.where((element) =>
          (!element.workStatus.toString().contains('Resigned') ||
              (element.workStatus.toString().contains('Resigned') &&
                  date.isBefore(element.resignOn!))))) {
        String leaveRegisterType = '',
            leaveRegisterInfo = '',
            attNote1 = '',
            attNote2 =
                ''; //attNote1 = vào trễ, ra sớm, thiếu chấm công //attNote2 = chế độ
        if (date.isBefore(emp.joiningDate!)) {
          continue;
        }
        if (gValue.empsByPass.contains(emp.empId)) {
          // nhung nguoi da nghi viec nhung khong co co theo doi - bom hang
          continue;
        }
        List<DateTime>? logsTime;
        List<AttLog> logs =
            dayLogs.where((log) => (log.empId == emp.empId)).toList();
        logsTime = logs.map((e) => e.timestamp).cast<DateTime>().toList();

        double normalHours = 8, otActual = 0, otApproved = 0, otFinal = 0;
        String shift = 'Day';
        int restHour = 1;
        DateTime shiftTimeBegin =
            DateTime.utc(date.year, date.month, date.day, 8);
        DateTime shiftTimeEnd =
            DateTime.utc(date.year, date.month, date.day, 17);

        if (emp.group == 'Canteen') {
          shift = 'Canteen';
        } else if (empIdShift1.contains(emp.empId)) {
          shift = 'Shift 1';
        } else if (empIdShift2.contains(emp.empId)) {
          shift = 'Shift 2';
        }
        restHour =
            shifts.firstWhere((element) => element.shift == shift).restHour;
        final hourBegin = int.parse(shifts
            .firstWhere((element) => element.shift == shift)
            .begin
            .split(':')[0]);
        final minuteBegin = int.parse(shifts
            .firstWhere((element) => element.shift == shift)
            .begin
            .split(':')[1]);
        final hourEnd = int.parse(shifts
            .firstWhere((element) => element.shift == shift)
            .end
            .split(':')[0]);
        final minuteEnd = int.parse(shifts
            .firstWhere((element) => element.shift == shift)
            .end
            .split(':')[1]);

        shiftTimeBegin = DateTime.utc(
            date.year, date.month, date.day, hourBegin, minuteBegin);
        shiftTimeEnd =
            DateTime.utc(date.year, date.month, date.day, hourEnd, minuteEnd);
        DateTime firstIn = DateTime.utc(2000);
        DateTime lastOut = DateTime.utc(2000);
        DateTime restBegin = shiftTimeBegin.add(const Duration(hours: 4));
        DateTime restEnd = restBegin.add(Duration(hours: restHour));

        if (logs.isEmpty) {
          {
            normalHours = 0;
            otApproved = 0;
            otActual = 0;
            otFinal = 0;
          }
        } else if (logs.length == 1) {
          firstIn = logs.first.timestamp;
          normalHours = 0;
          otApproved = 0;
          otActual = 0;
          otFinal = 0;
        } else {
          firstIn = logsTime.reduce((a, b) => a.isBefore(b) ? a : b);
          lastOut = logsTime.reduce((a, b) => a.isAfter(b) ? a : b);
          if (emp.maternityBegin != null &&
              date.compareTo(emp.maternityBegin!) >= 0 &&
              emp.maternityEnd != null &&
              date.compareTo(emp.maternityEnd!) <= 0) {
            shiftTimeEnd = shiftTimeEnd.subtract(const Duration(hours: 1));
            attNote2 += 'Chế độ mang thai/ nuôi con nhỏ';
          }
          if (firstIn.isBefore(shiftTimeBegin) &&
              lastOut.isBefore(shiftTimeBegin)) {
            normalHours = 0;
            otApproved = 0;
            otActual = 0;
            attNote1 += 'Không chấm công RA';
          } else if (firstIn.isAfter(shiftTimeEnd) &&
              lastOut.isAfter(shiftTimeEnd)) {
            normalHours = 0;
            otApproved = 0;
            otActual = 0;
            attNote1 += 'Không chấm công VÀO';
          } else if (firstIn.isAtSameMomentAs(lastOut)) {
            normalHours = 0;
            otApproved = 0;
            otActual = 0;
          } else {
            normalHours = 8;
            // NORMAL
            if (firstIn.isAfter(shiftTimeBegin) &&
                (lastOut.isAtSameMomentAs(shiftTimeEnd) ||
                    lastOut.isAfter(shiftTimeEnd))) {
              // vao tre, ra dung gio
              if (firstIn.isBefore(restBegin)) {
                // truoc 12h
                normalHours -=
                    firstIn.difference(shiftTimeBegin).inMinutes / 60;
              } else if (firstIn.isBefore(restEnd)) {
                // 12h .. 13h
                normalHours = 4;
              } else {
                //sau 13h
                normalHours = shiftTimeEnd.difference(firstIn).inMinutes / 60;
              }
            } else if ((firstIn.isBefore(shiftTimeBegin) ||
                    firstIn.isAtSameMomentAs(shiftTimeBegin)) &&
                lastOut.isBefore(shiftTimeEnd)) {
              // vao dung gio, ra som
              if (lastOut.isBefore(restBegin)) {
                //ra truoc 12h :
                normalHours = lastOut.difference(shiftTimeBegin).inMinutes / 60;
              } else if (lastOut.isBefore(restEnd)) {
                // ra sau 12h & truoc 13h
                normalHours = 4;
              } else {
                // ra sau 13h : 8- so gio ra som
                if (shiftTimeEnd.difference(lastOut).inSeconds > 0 &&
                    shiftTimeEnd.difference(lastOut).inSeconds < 60) {
                  normalHours -= 0.1;
                } else {}
                normalHours -= shiftTimeEnd.difference(lastOut).inMinutes / 60;
              }
            } else {
              // vao tre, ra som truoc 12h
              if (firstIn.isAfter(shiftTimeBegin) &&
                  (lastOut.isBefore(restBegin) ||
                      lastOut.isAtSameMomentAs(restBegin))) {
                normalHours = lastOut.difference(firstIn).inMinutes / 60;
              }
              // vao tre sau 12h, ra som truoc 17h
              else if ((firstIn.isAfter(restBegin) ||
                      firstIn.isAtSameMomentAs(restBegin)) &&
                  (lastOut.isBefore(shiftTimeEnd))) {
                normalHours = lastOut.difference(restEnd).inMinutes / 60;
              } else if (firstIn.isAfter(shiftTimeBegin) &&
                  lastOut.isBefore(shiftTimeEnd) &&
                  !empIdShift1.contains(emp.empId) &&
                  !empIdShift2.contains(emp.empId)) {
                // vao tre sau 8h, ra som truoc 17h
                // normalHours = lastOut.difference(firstIn).inMinutes / 60 - 1;
                normalHours = lastOut.difference(firstIn).inMinutes / 60;
              }
            }
            // -> Tính OT
            // Ca 1 & 2 không tính OT
            if (empIdShift1.contains(emp.empId) ||
                empIdShift2.contains(emp.empId)) {
              otActual = 0;
              otApproved = 0;
            } else {
              // Fix lỗi thiếu otActual nếu không có trong ds đăng ký OT
              otActual = lastOut.difference(shiftTimeEnd).inMinutes / 60;
              otActual = otActual < gValue.minOtMinutes / 60 ? 0 : otActual;
              // Fix lỗi thiếu tăng ca thực tế nếu không có trong ds đăng ký OT

              // emp có trong DS OT
              if (empIdOT.contains(emp.empId)) {
                List<OtRegister> otRegisterEmpOnDates = [];
                String beginH = '', beginM = '', endH = '', endM = '';
                OtRegister otRegisterEmp;
                otRegisterEmpOnDates = otRegistersOnDate
                    .where((otRecord) => otRecord.empId == emp.empId)
                    .toList();
                if (otRegisterEmpOnDates.length == 1) {
                  otRegisterEmp = otRegisterEmpOnDates.first;
                  beginH = otRegisterEmp.otTimeBegin.split(':')[0];
                  beginM = otRegisterEmp.otTimeBegin.split(':')[1];
                  endH = otRegisterEmp.otTimeEnd.split(':')[0];
                  endM = otRegisterEmp.otTimeEnd.split(':')[1];
                  //
                  DateTime beginTimeOTRegister = DateTime.utc(
                      date.year,
                      date.month,
                      date.day,
                      int.parse(beginH),
                      int.parse(beginM));
                  DateTime endTimeOTRegister = DateTime.utc(date.year,
                      date.month, date.day, int.parse(endH), int.parse(endM));

                  otApproved = endTimeOTRegister
                          .difference(beginTimeOTRegister)
                          .inMinutes /
                      60;
                  // đăng ký OT trước 8h
                  if (int.parse(beginH) < shiftTimeBegin.hour) {
                    var beginOTAllow = shiftTimeBegin
                        .subtract(Duration(minutes: otApproved.toInt()));
                    if (firstIn.isBefore(beginOTAllow)) {
                      otActual = otApproved;
                    } else {
                      otActual =
                          shiftTimeBegin.difference(firstIn).inMinutes / 60;
                    }
                    otFinal = otActual >= otApproved ? otApproved : otActual;
                    attNote1 += "OT trước ca làm việc ; ";
                  } else if (int.parse(beginH) >= shiftTimeEnd.hour) {
                    // đăng ký OT sau ca làm việc (sau 16h hoặc 17h)
                    if (lastOut.isAfter(shiftTimeEnd
                        .add(Duration(minutes: gValue.minOtMinutes)))) {
                      if (lastOut.isBefore(endTimeOTRegister)) {
                        // OT ra som
                        otActual =
                            lastOut.difference(shiftTimeEnd).inMinutes / 60;
                      } else {
                        // OT ra dung gio
                        otActual =
                            lastOut.difference(beginTimeOTRegister).inMinutes /
                                60;
                      }
                    }
                  }
                } else if (otRegisterEmpOnDates.length == 2) {
                  // max 2 bản ghi OT / ngày
                  otRegisterEmpOnDates
                      .sort((a, b) => a.otTimeEnd.compareTo(b.otTimeEnd));
                  beginH = otRegisterEmpOnDates.first.otTimeBegin.split(':')[0];
                  beginM = otRegisterEmpOnDates.first.otTimeBegin.split(':')[1];
                  endH = otRegisterEmpOnDates.last.otTimeEnd.split(':')[0];
                  endM = otRegisterEmpOnDates.last.otTimeEnd.split(':')[1];
                  if (int.parse(beginH) >= shiftTimeBegin.hour &&
                      int.parse(endH) >= shiftTimeBegin.hour) {
                    // Cả 2 bản ghi sau ca làm việc => cộng dồn 2 bản ghi
                    DateTime beginTimeOTRegister = DateTime.utc(
                        date.year,
                        date.month,
                        date.day,
                        int.parse(beginH),
                        int.parse(beginM));
                    DateTime endTimeOTRegister = DateTime.utc(date.year,
                        date.month, date.day, int.parse(endH), int.parse(endM));
                    otApproved = endTimeOTRegister
                            .difference(beginTimeOTRegister)
                            .inMinutes /
                        60;
                    if (lastOut.isAfter(shiftTimeEnd
                        .add(Duration(minutes: gValue.minOtMinutes)))) {
                      if (lastOut.isBefore(endTimeOTRegister)) {
                        // OT ra som
                        otActual =
                            lastOut.difference(shiftTimeEnd).inMinutes / 60;
                      } else {
                        // OT ra dung gio
                        otActual =
                            lastOut.difference(beginTimeOTRegister).inMinutes /
                                60;
                      }
                    }
                  } else if (int.parse(beginH) < shiftTimeBegin.hour &&
                      int.parse(endH) >= shiftTimeEnd.hour) {
                    attNote1 += "OT trước & sau ca làm việc ; ";
                    // 1 bản ghi trước & 1 sau ca làm việc
                    double otActual1, otActual2, otApproved1, otApproved2 = 0;

                    // trước
                    DateTime beginTimeOTRegister1 = DateTime.utc(
                        date.year,
                        date.month,
                        date.day,
                        int.parse(beginH),
                        int.parse(beginM));
                    otApproved1 = shiftTimeBegin
                            .difference(beginTimeOTRegister1)
                            .inMinutes /
                        60;
                    if (firstIn.isBefore(beginTimeOTRegister1)) {
                      otActual1 = otApproved1;
                    } else {
                      otActual1 =
                          shiftTimeBegin.difference(firstIn).inMinutes / 60;
                    }
                    otFinal = otActual >= otApproved ? otApproved : otActual;
                    // sau
                    DateTime endTimeOTRegister2 = DateTime.utc(date.year,
                        date.month, date.day, int.parse(endH), int.parse(endM));
                    otApproved2 =
                        endTimeOTRegister2.difference(shiftTimeEnd).inMinutes /
                            60;
                    if (lastOut.isAfter(shiftTimeEnd) &&
                        lastOut.isBefore(endTimeOTRegister2)) {
                      // OT ra som
                      otActual2 =
                          lastOut.difference(shiftTimeEnd).inMinutes / 60;
                    } else {
                      // OT ra dung gio
                      otActual2 =
                          lastOut.difference(shiftTimeEnd).inMinutes / 60;
                    }
                    otActual = otActual1 + otActual2;
                    otApproved = otApproved1 + otApproved2;
                  }
                }
              }
            }
            otFinal = (otActual <= otApproved) ? otActual : otApproved;
            // <- Tính OT
          }
        }

        if (logs.length >= 2 && firstIn.isAfter(shiftTimeBegin)) {
          attNote1 += 'Vào trễ ; ';
        }
        if (logs.length >= 2 &&
            lastOut.isBefore(shiftTimeEnd) &&
            firstIn.isAfter(shiftTimeBegin)) {
          attNote1 += 'Ra sớm ; ';
        }
        for (var record in leaveRegisteronDate) {
          if (record.empId == emp.empId && record.fromDate == date) {
            leaveRegisterType = record.type;
            leaveRegisterInfo =
                '# ${record.no}: from ${record.fromTime} to ${record.toTime},  ${record.note}';
            break;
          }
        }
        if (date.weekday == DateTime.sunday) {
          var ot = normalHours + otActual;
          otActual = ot;
          normalHours = 0;
          otFinal = (otActual <= otApproved) ? otActual : otApproved;
          if (otActual > 0) {
            attNote1 = 'OT ngày CN ; ';
            if (otActual > 4 && lastOut.isAfter(restEnd)) {
              attNote1 += 'Có phụ cấp cơm trưa ; ';
            }
          }
        }
        if (attNote1.endsWith(' ; ')) {
          attNote1 = attNote1.substring(0, attNote1.length - 3);
        }

        result.add(TimeSheetDate(
            date: date,
            empId: emp.empId!,
            attFingerId: emp.attFingerId!,
            name: emp.name!,
            department: emp.department!,
            section: emp.section!,
            group: emp.group ?? '',
            // lineTeam: emp.lineTeam ?? "",
            shift: shift,
            firstIn: firstIn.year == 2000 ? null : firstIn,
            lastOut: lastOut.year == 2000 ? null : lastOut,
            normalHours: normalHours,
            otHours: otActual,
            otHoursApproved: otApproved,
            otHoursFinal: otFinal,
            attNote1: attNote1,
            attNote2: attNote2,
            leaveRegisterType: leaveRegisterType,
            leaveRegisterInfo: leaveRegisterInfo));
      }
    }

    return result;
  }

  static Future<void> insertHistory(String log) async {
    var history = History(
        pcName: gValue.pcName,
        time: DateTime.now().add(const Duration(hours: 7)),
        log: log);
    await gValue.mongoDb.insertHistory([history]);
  }
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}
