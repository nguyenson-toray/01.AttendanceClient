import 'dart:ffi';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/employeeWO.dart';
import 'package:tiqn/database/leaveRegister.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:tiqn/database/timeSheetDate.dart';
import 'package:tiqn/database/timeSheetMonthYear.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/main.dart';
import 'package:tiqn/tools/myFunction.dart';

class MyFile {
  static Future<File> getFile() async {
    File file = File('path');
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
    return file;
  }

  static Future<Directory> getDir() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    return appDocumentsDir;
  }

  // static Future<List<Employee>> readExcelEmployee() async {
  //   print('readExcelEmployee'); //sheet Name
  //   gValue.logs.clear();
  //   List<Employee> emps = [];
  //   try {
  //     File file = await getFile();
  //     var bytes = file.readAsBytesSync();
  //     var excel = Excel.decodeBytes(bytes);
  //     gValue.logs.add('File : ${file.path}');
  //     for (var table in excel.tables.keys) {
  //       print('Sheet Name: $table'); //sheet Name
  //       print('maxColumns: ${excel.tables[table]?.maxColumns}');
  //       print('maxRows: ${excel.tables[table]?.maxRows}');
  //       gValue.logs.add(
  //           'Sheet Name: $table   Columns: ${excel.tables[table]?.maxColumns}   Rows: ${excel.tables[table]?.maxRows}\n');
  //       for (int rowIndex = 1;
  //           rowIndex < excel.tables[table]!.maxRows;
  //           rowIndex++) {
  //         var row = excel.tables[table]!.rows[rowIndex];
  //         if (row[2] == null || row[3] == null || row[4] == null) {
  //           gValue.logs.add(
  //               'ERROR : Row $rowIndex: Finger ID or Employee ID is empty\n');
  //           continue;
  //         }

  //         Employee emp = Employee(
  //           empId: row[1]?.value.toString(),
  //           attFingerId: int.tryParse(row[2]!.value.toString()),
  //           name: row[3]?.value.toString(),
  //           department: row[4]?.value.toString(),
  //           section: row[5]?.value.toString(),
  //           group: row[6]?.value.toString() ?? "",
  //           lineTeam: row[7]?.value.toString(),
  //           gender: row[8]?.value.toString(),
  //           positionE: row[9]?.value.toString(),
  //           level: row[10]?.value.toString(),
  //           directIndirect: row[11]?.value.toString(),
  //           sewingNonSewing: row[12]?.value.toString(),
  //           supporting: row[13]?.value.toString() ?? "",
  //           dob: DateTime.tryParse(row[14]!.value.toString()),
  //           joiningDate: DateTime.tryParse(row[15]!.value.toString()),
  //           workStatus: row[16]?.value.toString(),
  //           maternityBegin: row[17]?.value != null
  //               ? DateTime.tryParse(row[17]!.value.toString())
  //               : null,
  //           maternityEnd: row[18]?.value != null
  //               ? DateTime.tryParse(row[18]!.value.toString())
  //               : null,
  //         );
  //         emps.add(emp);
  //         gValue.logs.add('OK : Row $rowIndex: ${emp.empId}  ${emp.name}\n');
  //       }
  //     }
  //   } catch (e) {}

  //   return emps;
  // }

  static Future<void> createExcelEmployee(
      List<Employee> emps, bool isMini, String fileName) async {
//Create an Excel document.
//Creating a workbook.
    final Workbook workbook = Workbook();
    workbook.worksheets[0];
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Employees';
    Range range = sheet.getRangeByName('A2:S2');
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 174, 210, 239);
// Set the text value.
    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('Employee ID');
    sheet.getRangeByName('C1').setText('Finger ID');
    sheet.getRangeByName('D1').setText('Full name');
    sheet.getRangeByName('E1').setText('Department');
    sheet.getRangeByName('F1').setText('Section');
    sheet.getRangeByName('G1').setText('Group');
    sheet.getRangeByName('H1').setText('Line Team');
    if (!isMini) {
      sheet.getRangeByName('I1').setText('Gender');
      sheet.getRangeByName('J1').setText('Position E');
      sheet.getRangeByName('K1').setText('Level');
      sheet.getRangeByName('L1').setText('Direct Indirect');
      sheet.getRangeByName('M1').setText('Sewing NonSewing');
      sheet.getRangeByName('N1').setText('Supporting');
      sheet.getRangeByName('O1').setText('DOB');
      sheet.getRangeByName('P1').setText('Joining Date');
      sheet.getRangeByName('Q1').setText('Work status');
      sheet.getRangeByName('R1').setText('Resign Date');
      sheet.getRangeByName('A1:R1').cellStyle = styleHeader;
    } else {
      sheet.getRangeByName('A1:H1').cellStyle = styleHeader;
    }

    int row = 1;
    for (var emp in emps) {
      row++;
      sheet.getRangeByName('A$row').setNumber((row - 1).toDouble());
      sheet.getRangeByName('B$row').setText('${emp.empId}');
      sheet.getRangeByName('C$row').setNumber(emp.attFingerId?.toDouble());
      sheet.getRangeByName('D$row').setText('${emp.name}');
      sheet.getRangeByName('E$row').setText('${emp.department}');
      sheet.getRangeByName('F$row').setText('${emp.section}');
      sheet.getRangeByName('G$row').setText('${emp.group}');
      sheet.getRangeByName('H$row').setText('${emp.lineTeam}');
      if (!isMini) {
        sheet.getRangeByName('I$row').setText('${emp.gender}');
        sheet.getRangeByName('J$row').setText('${emp.positionE}');
        sheet.getRangeByName('K$row').setText('${emp.level}');
        sheet.getRangeByName('L$row').setText('${emp.directIndirect}');
        sheet.getRangeByName('M$row').setText('${emp.sewingNonSewing}');
        sheet.getRangeByName('N$row').setText('${emp.supporting}');
        sheet
            .getRangeByName('O$row')
            .setDateTime(emp.dob?.year == 1900 ? null : emp.dob);
        sheet.getRangeByName('P$row').setDateTime(
            emp.joiningDate?.year == 1900 ? null : emp.joiningDate);
        sheet.getRangeByName('Q$row').setText('${emp.workStatus}');
        sheet
            .getRangeByName('R$row')
            .setDateTime(emp.resignOn?.year == 2099 ? null : emp.resignOn);
        range = sheet.getRangeByName('A2:R2');
      } else {
        range = sheet.getRangeByName('A2:H2');
      }
    }
    // Assigning text to cells

// Auto-Fit column the range
    range.autoFitColumns();
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(4);
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(Platform.isWindows
        ? '$path\\$fileName ${DateFormat('yyyyMMdd hhmmss').format(DateTime.now())}.xlsx'
        : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  static Future<void> createExcelEmployeeAbsent(List<Employee> emps,
      List<ShiftRegister> shiftRegisters, String fileName) async {
//Create an Excel document.
//Creating a workbook.
    final Workbook workbook = Workbook();
    workbook.worksheets[0];
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Employees Absent';
    Range range = sheet.getRangeByName('A2:S2');
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 174, 210, 239);
    sheet.getRangeByName('K1').setText(
        'Export at ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(DateTime.now())}');
// Set the text value.
    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('Employee ID');
    sheet.getRangeByName('C1').setText('Finger ID');
    sheet.getRangeByName('D1').setText('Full name');
    sheet.getRangeByName('E1').setText('Department');
    sheet.getRangeByName('F1').setText('Section');
    sheet.getRangeByName('G1').setText('Group');
    sheet.getRangeByName('H1').setText('Line Team');
    sheet.getRangeByName('I1').setText('Shift');

    sheet.getRangeByName('A1:I1').cellStyle = styleHeader;
    int row = 1;
    DateTime today =
        DateTime.now().appliedFromTimeOfDay(TimeOfDay(hour: 0, minute: 0));
    for (var emp in emps) {
      row++;
      sheet.getRangeByName('A$row').setNumber((row - 1).toDouble());
      sheet.getRangeByName('B$row').setText('${emp.empId}');
      sheet.getRangeByName('C$row').setNumber(emp.attFingerId?.toDouble());
      sheet.getRangeByName('D$row').setText('${emp.name}');
      sheet.getRangeByName('E$row').setText('${emp.department}');
      sheet.getRangeByName('F$row').setText('${emp.section}');
      sheet.getRangeByName('G$row').setText('${emp.group}');
      sheet.getRangeByName('H$row').setText('${emp.lineTeam}');
      String shift = 'Day';
      if (emp.group == 'Canteen') {
        shift = 'Canteen';
      } else
        try {
          ShiftRegister shiftTemps = shiftRegisters
              .firstWhere((shift) => shift.empId == emp.empId, orElse: null);
          if (shiftTemps != null &&
              (shiftTemps.fromDate.compareTo(today) <= 0 &&
                  shiftTemps.toDate.compareTo(today) >= 0)) {
            shift = shiftTemps.shift;
          }
        } catch (e) {
          print(e);
        }
      sheet.getRangeByName('I$row').setText(shift);
    }
    // Assigning text to cells

// Auto-Fit column the range
    range = sheet.getRangeByName('A2:I2');
    range.autoFitColumns();
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(4);
    sheet.autoFitColumn(8);
    sheet.autoFitColumn(9);
    final ExcelTable tableSummary = sheet.tableCollection
        .create('table_absent', sheet.getRangeByName('A1:I$row'));
    tableSummary.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight1;
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(Platform.isWindows
        ? '$path\\$fileName ${DateFormat('yyyyMMdd hhmmss').format(DateTime.now())}.xlsx'
        : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  //---------------
  static Future<void> createExcelAttLog(
      List<AttLog> logsInput, String fileName) async {
//Create an Excel document.
//Creating a workbook.
    Iterable<AttLog> logs = logsInput.reversed;
    final Workbook workbook = Workbook();
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Attendance Log';
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 160, 168, 174);
// Set the text value.
    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('Finger ID');
    sheet.getRangeByName('C1').setText('Employee ID');
    sheet.getRangeByName('D1').setText('Name');
    sheet.getRangeByName('E1').setText('Group');
    sheet.getRangeByName('F1').setText('Time');
    sheet.getRangeByName('G1').setText('Machine');
    sheet.getRangeByName('A1:G1').cellStyle = styleHeader;
    sheet.getRangeByName('I1').setText(
        'Export at ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(DateTime.now())}');
    int row = 1;
    for (var log in logs) {
      row++;
      sheet.getRangeByName('A$row').setNumber((row - 1));
      sheet.getRangeByName('B$row').setNumber(log.attFingerId.toDouble());
      sheet.getRangeByName('C$row').setText(log.empId);
      sheet.getRangeByName('D$row').setText(log.name);
      String? group = '';
      try {
        group = gValue.employees
            .firstWhere((element) => element.empId == log.empId)
            .group;
      } catch (e) {
        print('Error finding group for empId ${log.empId}: $e');
      }
      sheet.getRangeByName('E$row').setText(group);
      sheet.getRangeByName('F$row').numberFormat = 'dd-MMM-yyyy hh:mm';
      sheet.getRangeByName('F$row').setDateTime(log.timestamp);

      sheet.getRangeByName('G$row').setNumber(log.machineNo.toDouble());
    }
    // Assigning text to cells
    final Range range = sheet.getRangeByName('A2:G2');

// Auto-Fit column the range
    range.autoFitColumns();
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(4);
    sheet.autoFitColumn(5);
    sheet.autoFitColumn(6);
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

/*
  static Future<void> createExcelAttReport(
      List<AttReport> attReportsInput) async {
    print('createExcelAttReport');
    Iterable<AttReport> attReports = attReportsInput.reversed;
    String fileName =
        'Attendance report ${DateFormat('MMM-yyyy hhmmss').format(DateTime.now())}';
    //Create an Excel document.
//Creating a workbook.
    final Workbook workbook = Workbook();
    workbook.worksheets[0];
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name =
        'Attendance report ${DateFormat('MMM-yyyy').format(DateTime.now())}';

// Set the  value.
    sheet.getRangeByName('A1').setText('Date');
    sheet.getRangeByName('A1:A3').merge();
    sheet.getRangeByName('B1').setText('Direct');
    sheet.getRangeByName('B1:J1').merge();
    sheet.getRangeByName('K1').setText('Indirect');
    sheet.getRangeByName('K1:S1').merge();
    sheet.getRangeByName('T1').setText('Management');
    sheet.getRangeByName('T1:AB1').merge();
    sheet.getRangeByName('AC1').setText('Total');
    sheet.getRangeByName('AC1:AK1').merge();
    //-------------
    sheet
        .getRangeByName('B2')
        .setText('Newly joined\nMaternity return to work');
    sheet.getRangeByName('B3').setText('N');
    sheet.getRangeByName('C2').setText('Resigned');
    sheet.getRangeByName('C3').setText('R');
    sheet.getRangeByName('D2').setText('Maternity leave');
    sheet.getRangeByName('D3').setText('M');
    sheet.getRangeByName('E2').setText('Working');
    sheet.getRangeByName('E3').setText('W');
    sheet.getRangeByName('F2').setText('Enrolled Total');
    sheet.getRangeByName('F3').setText('E');
    sheet.getRangeByName('G2').setText('Actual working');
    sheet.getRangeByName('G3').setText('W');
    sheet.getRangeByName('H2').setText('Absent');
    sheet.getRangeByName('H3').setText('A');
    sheet.getRangeByName('I2').setText('Total working');
    sheet.getRangeByName('I3').setText('T');
    sheet.getRangeByName('J2').setText('Absent percent\n(No Maternity)');
    sheet.getRangeByName('J3').setText('P');
    //-------------
    sheet
        .getRangeByName('K2')
        .setText('Newly joined\nMaternity return to work');
    sheet.getRangeByName('K3').setText('N');
    sheet.getRangeByName('L2').setText('Resigned');
    sheet.getRangeByName('L3').setText('R');
    sheet.getRangeByName('M2').setText('Maternity leave');
    sheet.getRangeByName('M3').setText('M');
    sheet.getRangeByName('N2').setText('Working');
    sheet.getRangeByName('N3').setText('W');
    sheet.getRangeByName('O2').setText('Enrolled Total');
    sheet.getRangeByName('O3').setText('E');
    sheet.getRangeByName('P2').setText('Actual working');
    sheet.getRangeByName('P3').setText('W');
    sheet.getRangeByName('Q2').setText('Absent');
    sheet.getRangeByName('Q3').setText('A');
    sheet.getRangeByName('R2').setText('Total working');
    sheet.getRangeByName('R3').setText('T');
    sheet.getRangeByName('S2').setText('Absent percent\n(No Maternity)');
    sheet.getRangeByName('S3').setText('P');
    //-------------
    sheet
        .getRangeByName('T2')
        .setText('Newly joined\nMaternity return to work');
    sheet.getRangeByName('T3').setText('N');
    sheet.getRangeByName('U2').setText('Resigned');
    sheet.getRangeByName('U3').setText('R');
    sheet.getRangeByName('V2').setText('Maternity leave');
    sheet.getRangeByName('V3').setText('M');
    sheet.getRangeByName('W2').setText('Working');
    sheet.getRangeByName('W3').setText('W');
    sheet.getRangeByName('X2').setText('Enrolled Total');
    sheet.getRangeByName('X3').setText('E');
    sheet.getRangeByName('Y2').setText('Actual working');
    sheet.getRangeByName('Y3').setText('W');
    sheet.getRangeByName('Z2').setText('Absent');
    sheet.getRangeByName('Z3').setText('A');
    sheet.getRangeByName('AA2').setText('Total working');
    sheet.getRangeByName('AA3').setText('T');
    sheet.getRangeByName('AB2').setText('Absent percent\n(No Maternity)');
    sheet.getRangeByName('AB3').setText('P');
    //-------------
    sheet
        .getRangeByName('AC2')
        .setText('Newly joined\nMaternity return to work');
    sheet.getRangeByName('AC3').setText('N');
    sheet.getRangeByName('AD2').setText('Resigned');
    sheet.getRangeByName('AD3').setText('R');
    sheet.getRangeByName('AE2').setText('Maternity leave');
    sheet.getRangeByName('AE3').setText('M');
    sheet.getRangeByName('AF2').setText('Working');
    sheet.getRangeByName('AF3').setText('W');
    sheet.getRangeByName('AG2').setText('Enrolled Total');
    sheet.getRangeByName('AG3').setText('E');
    sheet.getRangeByName('AH2').setText('Actual working');
    sheet.getRangeByName('AH3').setText('W');
    sheet.getRangeByName('AI2').setText('Absent');
    sheet.getRangeByName('AI3').setText('A');
    sheet.getRangeByName('AJ2').setText('Total working');
    sheet.getRangeByName('AJ3').setText('T');
    sheet.getRangeByName('AK2').setText('Absent percent\n(No Maternity)');
    sheet.getRangeByName('AK3').setText('P');

    int row = 3;
    for (var report in attReports) {
      row++;
      sheet.getRangeByName('A$row').setDateTime(report.date?.toLocal());
      //---
      sheet.getRangeByName('B$row').setNumber(
          (report.direct!.newlyJoined + report.direct!.maternityComeback)
              .toDouble());
      sheet
          .getRangeByName('C$row')
          .setNumber(report.direct!.resigned.toDouble());
      sheet
          .getRangeByName('D$row')
          .setNumber(report.direct!.maternityLeave.toDouble());
      sheet
          .getRangeByName('E$row')
          .setNumber(report.direct!.working.toDouble());
      sheet
          .getRangeByName('F$row')
          .setNumber(report.direct!.enrolledTotal.toDouble());
      sheet
          .getRangeByName('G$row')
          .setNumber(report.direct!.actualWorking.toDouble());
      sheet.getRangeByName('H$row').setNumber(report.direct!.absent.toDouble());
      sheet
          .getRangeByName('I$row')
          .setNumber(report.direct!.working.toDouble());
      sheet
          .getRangeByName('J$row')
          .setNumber(report.direct!.absentPercent.toDouble());
      //-------------
      sheet.getRangeByName('K$row').setNumber(
          (report.inDirect!.newlyJoined + report.direct!.maternityComeback)
              .toDouble());
      sheet
          .getRangeByName('L$row')
          .setNumber(report.inDirect!.resigned.toDouble());
      sheet
          .getRangeByName('M$row')
          .setNumber(report.inDirect!.maternityLeave.toDouble());
      sheet
          .getRangeByName('N$row')
          .setNumber(report.inDirect!.working.toDouble());
      sheet
          .getRangeByName('O$row')
          .setNumber(report.inDirect!.enrolledTotal.toDouble());
      sheet
          .getRangeByName('P$row')
          .setNumber(report.inDirect!.actualWorking.toDouble());
      sheet
          .getRangeByName('Q$row')
          .setNumber(report.inDirect!.absent.toDouble());
      sheet
          .getRangeByName('R$row')
          .setNumber(report.inDirect!.working.toDouble());
      sheet
          .getRangeByName('S$row')
          .setNumber(report.inDirect!.absentPercent.toDouble());
      //-------------
      sheet.getRangeByName('T$row').setNumber((report.management!.newlyJoined +
              report.management!.maternityComeback)
          .toDouble());
      sheet
          .getRangeByName('U$row')
          .setNumber(report.management!.resigned.toDouble());
      sheet
          .getRangeByName('V$row')
          .setNumber(report.management!.maternityLeave.toDouble());
      sheet
          .getRangeByName('W$row')
          .setNumber(report.management!.working.toDouble());
      sheet
          .getRangeByName('X$row')
          .setNumber(report.management!.enrolledTotal.toDouble());
      sheet
          .getRangeByName('Y$row')
          .setNumber(report.management!.actualWorking.toDouble());
      sheet
          .getRangeByName('Z$row')
          .setNumber(report.management!.absent.toDouble());
      sheet
          .getRangeByName('AA$row')
          .setNumber(report.management!.working.toDouble());
      sheet
          .getRangeByName('AB$row')
          .setNumber(report.management!.absentPercent.toDouble());
      //-------------
      sheet.getRangeByName('AC$row').setNumber((report.management!.newlyJoined +
              report.management!.maternityComeback)
          .toDouble());
      sheet
          .getRangeByName('AD$row')
          .setNumber(report.total!.maternityLeave.toDouble());
      sheet
          .getRangeByName('AE$row')
          .setNumber(report.total!.maternityLeave.toDouble());
      sheet
          .getRangeByName('AF$row')
          .setNumber(report.total!.working.toDouble());
      sheet
          .getRangeByName('AG$row')
          .setNumber(report.total!.enrolledTotal.toDouble());
      sheet
          .getRangeByName('AH$row')
          .setNumber(report.total!.actualWorking.toDouble());
      sheet.getRangeByName('AI$row').setNumber(report.total!.absent.toDouble());
      sheet
          .getRangeByName('AJ$row')
          .setNumber(report.total!.working.toDouble());
      sheet
          .getRangeByName('AK$row')
          .setNumber(report.total!.absentPercent.toDouble());
    }

//Creating a new style with all properties.
    final Style styleDate = workbook.styles.add('styleDate');
    final Style styleDateRow = workbook.styles.add('styleDateRow');
    final Style styleHeader1 = workbook.styles.add('styleHeader1');
    final Style styleHeader2 = workbook.styles.add('styleHeader2');
    final Style styleHeader3 = workbook.styles.add('styleHeader3');
    final Style styleDirect = workbook.styles.add('styleDirect');
    final Style styleIndrect = workbook.styles.add('styleIndrect');
    final Style styleManagement = workbook.styles.add('styleManagement');
    final Style styleTotal = workbook.styles.add('styleTotal');
    styleHeader1.bold = true;
    styleDate.bold = true;
    styleDate.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleDateRow.bold = true;
    styleDateRow.bold = true;
    styleDateRow.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleHeader1.vAlign = VAlignType.center;
    styleHeader1.hAlign = HAlignType.center;
    styleHeader1.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleHeader2.vAlign = VAlignType.top;
    styleHeader2.hAlign = HAlignType.center;
    styleHeader2.wrapText = true;
    styleHeader2.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleHeader3.vAlign = VAlignType.center;
    styleHeader3.hAlign = HAlignType.center;
    styleHeader3.bold = true;
    styleHeader3.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleDirect.backColorRgb = const Color.fromARGB(255, 187, 188, 187);
    styleIndrect.backColorRgb = const Color.fromARGB(255, 224, 226, 224);
    styleManagement.backColorRgb = const Color.fromARGB(255, 172, 203, 173);
    styleTotal.backColorRgb = const Color.fromARGB(255, 135, 158, 135);
    sheet.getRangeByName('A1:A3').cellStyle = styleDate;
    sheet.getRangeByName('B1:AK1').cellStyle = styleHeader1;
    sheet.getRangeByName('B2:AK2').columnWidth = 7;
    sheet.getRangeByName('B2:AK2').rowHeight = 72;
    sheet.getRangeByName('B2:AK2').cellStyle = styleHeader2;
    sheet.getRangeByName('A3:AK3').rowHeight = 16;
    sheet.getRangeByName('B3:AK3').cellStyle = styleHeader3;
    sheet.getRangeByName('B4:J$row').cellStyle = styleDirect;
    sheet.getRangeByName('K4:S$row').cellStyle = styleIndrect;
    sheet.getRangeByName('T4:AB$row').cellStyle = styleManagement;
    sheet.getRangeByName('AC4:AK$row').cellStyle = styleTotal;
    sheet.showGridlines = true;
// Auto-Fit column the range
    // range.autoFitColumns();
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }
*/
  static Future<List<AttLog>> readExcelAttLog() async {
    List<AttLog> logs = [];
    print('readExcelAttLog'); //sheet Name
    gValue.logs.clear();
    List<Employee> emps = [];
    try {
      File file = await getFile();
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      gValue.logs.add('File : ${file.path}');
      for (var table in excel.tables.keys) {
        print('Sheet Name: $table'); //sheet Name
        print('maxColumns: ${excel.tables[table]?.maxColumns}');
        print('maxRows: ${excel.tables[table]?.maxRows}');
        gValue.logs.add(
            'Sheet Name: $table   Columns: ${excel.tables[table]?.maxColumns}   Rows: ${excel.tables[table]?.maxRows}\n');
        for (int rowIndex = 1;
            rowIndex < excel.tables[table]!.maxRows;
            rowIndex++) {
          var row = excel.tables[table]!.rows[rowIndex];
          if (row[1] == null ||
              row[2] == null ||
              row[3] == null ||
              row[5] == null) {
            gValue.logs.add('ERROR : Row $rowIndex: is not enought infor\n');
            continue;
          }
          AttLog log = AttLog(
              objectId: '',
              attFingerId: int.parse(row[1]!.value.toString()),
              empId: row[2]!.value.toString(),
              name: row[3]!.value.toString(),
              timestamp: DateTime.parse(row[5]!.value.toString()),
              machineNo: int.parse(row[6]!.value.toString()));

          logs.add(log);
          gValue.logs.add(
              'OK : Row $rowIndex: ${log.empId}  ${log.name}  ${log.timestamp}\n');
        }
      }
    } catch (e) {}
    return logs;
  }

  static Future<void> createExcelTimeSheetYear(
      List<TimeSheetMonthYear> timeSheets, String year) async {
    final Workbook workbook = Workbook();
    workbook.worksheets[0];
    final Worksheet sheetSummary = workbook.worksheets[0];
    sheetSummary.name = 'Year Summary - $year';
    final Style styleHeader = workbook.styles.add('styleHeader');
    final Style styleHeaderTime = workbook.styles.add('styleHeaderTime');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 174, 210, 239);
    styleHeaderTime.bold = true;
    styleHeaderTime.backColorRgb = const Color.fromARGB(255, 73, 183, 77);
    sheetSummary.getRangeByName('A1:I1').cellStyle = styleHeader;
    sheetSummary.getRangeByName('J1:J1').cellStyle = styleHeaderTime;
    sheetSummary.getRangeByName('H1').columnWidth = 15;
    sheetSummary.getRangeByName('I1').columnWidth = 10;
    sheetSummary.getRangeByName('J1').columnWidth = 15;
    sheetSummary.getRangeByName('A1:J1').cellStyle.wrapText = true;
    sheetSummary.getRangeByName('A1').setText('No');
    sheetSummary.getRangeByName('B1').setText('Employee ID');
    sheetSummary.getRangeByName('C1').setText('Full name');
    sheetSummary.getRangeByName('D1').setText('Department');
    sheetSummary.getRangeByName('E1').setText('Section');
    sheetSummary.getRangeByName('F1').setText('Group');
    sheetSummary.getRangeByName('G1').setText('Total Working hours');
    sheetSummary.getRangeByName('H1').setText('Total OT hours');
    sheetSummary.getRangeByName('I1').setText('Total OT hours (approved)');
    sheetSummary.getRangeByName('L1').setText(
        'Export at ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(DateTime.now())}');
    final empIds = timeSheets.map((e) => e.empId).toSet().toList();
    timeSheets.sort((a, b) => b.otHours.round().compareTo(a.otHours.round()));
    int row = 1;
    for (var element in timeSheets) {
      row += 1;
      sheetSummary.getRangeByName('A$row').setNumber((row - 1));
      sheetSummary.getRangeByName('B$row').setText(element.empId);
      sheetSummary.getRangeByName('C$row').setText(element.name);
      sheetSummary.getRangeByName('D$row').setText(element.department);
      sheetSummary.getRangeByName('E$row').setText(element.section);
      sheetSummary.getRangeByName('F$row').setText(element.group);
      sheetSummary
          .getRangeByName('G$row')
          .setNumber(roundDouble(element.normalHours, 1));
      sheetSummary
          .getRangeByName('H$row')
          .setNumber(roundDouble(element.otHours, 1));
      sheetSummary
          .getRangeByName('I$row')
          .setNumber(roundDouble(element.otHoursApproved, 1));
    }

    sheetSummary.autoFitColumn(1);
    sheetSummary.autoFitColumn(2);
    sheetSummary.autoFitColumn(3);
    sheetSummary.autoFitColumn(4);
    final ExcelTable tableSummary = sheetSummary.tableCollection
        .create('tableSummary', sheetSummary.getRangeByName('A1:I$row'));
    tableSummary.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight1;

//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook
        .dispose(); //Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(Platform.isWindows
        ? '$path\\Summary $year.xlsx'
        : '$path/Summary $year.xlsx.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  static Future<void> createExcelTimeSheet(
      List<TimeSheetDate> timeSheets, String fileName) async {
    final Workbook workbook = Workbook();
    // Create sheets in the desired order - Important Note first (will be active)
    workbook.worksheets[0];
    final Worksheet sheetImportantNote = workbook.worksheets[0];
    workbook.worksheets.add();
    final Worksheet sheetDetail = workbook.worksheets[1];
    workbook.worksheets.add();
    final Worksheet sheetSummary = workbook.worksheets[2];
    sheetImportantNote.name = 'Important Note';
    sheetDetail.name = 'Detail';
    sheetSummary.name = 'Summary';
    // Range range = sheetDetail.getRangeByName('A2:N2');
    //Creating a new style for header.
    final Style styleHeader = workbook.styles.add('styleHeader');
    final Style styleHeaderTime = workbook.styles.add('styleHeaderTime');
    final Style styleHeaderLeave = workbook.styles.add('styleHeaderLeave');
    final Style styleHeaderDateJoiningResign =
        workbook.styles.add('styleDateJoiningResign');
    final Style styleAttNote = workbook.styles.add('styleAttNote');
    final Style styleAttNote2 = workbook.styles.add('styleAttNote2');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 174, 210, 239);
    styleHeaderTime.bold = true;
    styleHeaderTime.backColorRgb = const Color.fromARGB(255, 73, 183, 77);
    styleHeaderLeave.backColorRgb = const Color.fromARGB(255, 157, 73, 183);
    styleAttNote.backColorRgb = Color.fromARGB(255, 39, 241, 90);
    styleAttNote2.backColorRgb = Color.fromARGB(255, 250, 207, 13);
    styleHeaderDateJoiningResign.backColorRgb = Color.fromARGB(90, 253, 63, 63);
    sheetDetail.getRangeByName('A1:H1').cellStyle = styleHeader;
    sheetDetail.getRangeByName('A1:H1').cellStyle = styleHeader;
    sheetDetail.getRangeByName('I1:P1').cellStyle = styleHeaderTime;
    sheetDetail.getRangeByName('S1:T1').cellStyle =
        styleHeaderDateJoiningResign;
    sheetDetail.getRangeByName('C1').columnWidth = 10;
    sheetDetail.getRangeByName('D1').columnWidth = 6;
    sheetDetail.getRangeByName('H1').columnWidth = 17;
    sheetDetail.getRangeByName('J1').columnWidth = 6;
    sheetDetail.getRangeByName('K1').columnWidth = 6;
    sheetDetail.getRangeByName('L1').columnWidth = 6;
    sheetDetail.getRangeByName('M1').columnWidth = 7.3;
    sheetDetail.getRangeByName('N1').columnWidth = 7.3;
    sheetDetail.getRangeByName('O1').columnWidth = 7.3;
    sheetDetail.getRangeByName('P1').columnWidth = 7.3;
    sheetDetail.getRangeByName('Q1').columnWidth = 10;
    sheetDetail.getRangeByName('R1').columnWidth = 10;
    sheetDetail.getRangeByName('A1:R1').cellStyle.wrapText = true;
    sheetDetail.getRangeByName('A1').setText('No');
    sheetDetail.getRangeByName('B1').setText('Date');
    sheetDetail.getRangeByName('C1').setText('Employee ID');
    sheetDetail.getRangeByName('D1').setText('Finger ID');
    sheetDetail.getRangeByName('E1').setText('Full name');
    sheetDetail.getRangeByName('F1').setText('Department');
    sheetDetail.getRangeByName('G1').setText('Section');
    sheetDetail.getRangeByName('H1').setText('Group');
    sheetDetail.getRangeByName('I1').setText('Shift');
    sheetDetail.getRangeByName('J1').setText('Fist In');
    sheetDetail.getRangeByName('K1').setText('Last Out');
    sheetDetail.getRangeByName('L1').setText('Working (hour)');
    sheetDetail.getRangeByName('M1').setText('Working (day)');
    sheetDetail.getRangeByName('N1').setText('OT Actual (hours)');
    sheetDetail.getRangeByName('O1').setText('OT Approved (hours)');
    sheetDetail.getRangeByName('P1').setText('OT Final');
    sheetDetail.getRangeByName('Q1').setText('Attendance Note');
    sheetDetail.getRangeByName('R1').setText('Chế độ mang thai/ nuôi con nhỏ');
    sheetDetail.getRangeByName('S1').setText('Joining Date');
    sheetDetail.getRangeByName('T1').setText('Resign Date');
    sheetDetail.getRangeByName('U1').setText(
        'Export at ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(DateTime.now())}');
    int row = 1;
    for (var i = 0; i < timeSheets.length; i++) {
      var timeSheet = timeSheets[i];
      DateTime joiningDate = gValue.employees
          .firstWhere((emp) => emp.empId == timeSheet.empId)
          .joiningDate!;
      DateTime resignDate;
      try {
        resignDate = gValue.employees
            .firstWhere((emp) => emp.empId == timeSheet.empId)
            .resignOn!;
      } catch (e) {
        resignDate = DateTime(2099, 1, 1);
      }

      row++;
      sheetDetail.getRangeByName('A$row').setNumber((row - 1));
      sheetDetail.getRangeByName('B$row').numberFormat = 'dd-MMM-yyyy';
      sheetDetail.getRangeByName('B$row').setDateTime(timeSheet.date);
      sheetDetail.getRangeByName('C$row').setText(timeSheet.empId);
      sheetDetail
          .getRangeByName('D$row')
          .setNumber(timeSheet.attFingerId.toDouble());
      sheetDetail.getRangeByName('E$row').setText(timeSheet.name);
      sheetDetail.getRangeByName('F$row').setText(timeSheet.department);
      sheetDetail.getRangeByName('G$row').setText(timeSheet.section);
      sheetDetail.getRangeByName('H$row').setText(timeSheet.group);
      sheetDetail.getRangeByName('I$row').setText(timeSheet.shift);
      sheetDetail.getRangeByName('J$row').numberFormat = 'hh:mm';
      sheetDetail.getRangeByName('J$row').setDateTime(
          timeSheet.firstIn?.year == 2000 ? null : timeSheet.firstIn);
      //
      sheetDetail.getRangeByName('K$row').numberFormat = 'hh:mm';
      sheetDetail.getRangeByName('K$row').setDateTime(
          timeSheet.lastOut?.year == 2000 ? null : timeSheet.lastOut);
      if (timeSheet.normalHours >= 7.9 && timeSheet.normalHours < 8) {
        timeSheets[i].normalHours = 7.9;
        sheetDetail.getRangeByName('L$row').setNumber(7.9);
        sheetDetail.getRangeByName('M$row').setNumber(0.99);
      } else {
        timeSheets[i].normalHours = roundDouble(timeSheet.normalHours, 1);
        sheetDetail
            .getRangeByName('L$row')
            .setNumber(roundDouble(timeSheet.normalHours, 1));

        sheetDetail
            .getRangeByName('M$row')
            .setNumber(roundDouble(timeSheet.normalHours / 8, 2));
      }

      timeSheets[i].otHours = (timeSheet.otHours * 10).floor() / 10;
      sheetDetail
          .getRangeByName('N$row')
          .setNumber(((timeSheet.otHours * 10).floor() / 10));
      //chỗ cột OT final: a dùng rouddown(x,1), nó ra giá trị đúng như e cần ạ
      sheetDetail
          .getRangeByName('O$row')
          .setNumber(roundDouble(timeSheet.otHoursApproved, 1));

      timeSheets[i].otHoursFinal = (timeSheet.otHoursFinal * 10).floor() / 10;
      sheetDetail
          .getRangeByName('P$row')
          .setNumber((timeSheet.otHoursFinal * 10).floor() / 10);
      //chỗ cột OT final: a dùng rouddown(x,1), nó ra giá trị đúng như e cần ạ
      sheetDetail.getRangeByName('Q$row').setText(timeSheet.attNote1);
      if (timeSheet.attNote1.contains('Không chấm công')) {
        sheetDetail.getRangeByName('Q$row:Q$row').cellStyle = styleAttNote;
      }
      if (timeSheet.attNote1.contains('CN') ||
          timeSheet.attNote1.contains('OT trước & sau ca làm việc')) {
        sheetDetail.getRangeByName('Q$row:Q$row').cellStyle = styleAttNote2;
      }

      sheetDetail.getRangeByName('S$row').numberFormat = 'dd-MMM-yyyy';
      sheetDetail.getRangeByName('S$row').setDateTime(joiningDate);
      if (resignDate.year < 2099) {
        // sheetDetail.getRangeByName('T$row:T$row').cellStyle =
        //     styleHeaderDateJoiningResign;
        sheetDetail.getRangeByName('T$row').numberFormat = 'dd-MMM-yyyy';
        sheetDetail.getRangeByName('T$row').setDateTime(resignDate);
      } else {
        sheetDetail.getRangeByName('T$row').setText('');
      }
      if (timeSheet.attNote2 != '') {
        sheetDetail.getRangeByName('R$row').setText('X');
      }
    }

    // Auto-Fit column the range
    sheetDetail.autoFitColumn(1);
    sheetDetail.autoFitColumn(2);
    sheetDetail.autoFitColumn(5);
    sheetDetail.autoFitColumn(19);
    sheetDetail.autoFitColumn(20);
    final ExcelTable tableDetail = sheetDetail.tableCollection
        .create('tableDetail', sheetDetail.getRangeByName('A1:T$row'));
    tableDetail.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight1;

    //------------Summary
    sheetSummary.getRangeByName('A1:F1').cellStyle = styleHeader;
    sheetSummary.getRangeByName('G1:K1').cellStyle = styleHeaderTime;
    sheetSummary.getRangeByName('L1:M1').cellStyle =
        styleHeaderDateJoiningResign;
    sheetSummary.getRangeByName('C1').columnWidth = 12;
    sheetSummary.getRangeByName('F1').columnWidth = 15;
    sheetSummary.getRangeByName('H1').columnWidth = 10;
    sheetSummary.getRangeByName('I1').columnWidth = 10;
    sheetSummary.getRangeByName('J1').columnWidth = 10;
    sheetSummary.getRangeByName('K1').columnWidth = 10;
    sheetSummary.getRangeByName('L1').columnWidth = 10;
    sheetSummary.getRangeByName('A1:N1').cellStyle.wrapText = true;
    sheetSummary.getRangeByName('A1').setText('No');
    sheetSummary.getRangeByName('B1').setText('Employee ID');
    sheetSummary.getRangeByName('C1').setText('Full name');
    sheetSummary.getRangeByName('D1').setText('Department');
    sheetSummary.getRangeByName('E1').setText('Section');
    sheetSummary.getRangeByName('F1').setText('Group');
    sheetSummary.getRangeByName('G1').setText('Total Working (hours)');
    sheetSummary.getRangeByName('H1').setText('Total Working (days)');
    sheetSummary.getRangeByName('I1').setText('Total OT Actual (hours)');
    sheetSummary.getRangeByName('J1').setText('Total OT Aproved (hours)');
    sheetSummary.getRangeByName('K1').setText('Total OT Final (hours)');
    sheetSummary.getRangeByName('L1').setText('Joining Date');
    sheetSummary.getRangeByName('M1').setText('Resign Date');
    sheetSummary.getRangeByName('N1').setText('Count of late in / early out');
    sheetSummary.getRangeByName('O1').setText(
        'Export at ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(DateTime.now())}');
    final empIds = timeSheets.map((e) => e.empId).toSet().toList();
    row = 1;
    List<EmployeeWO> employeeWOs = [];
    for (var empId in empIds) {
      EmployeeWO employeeWO = EmployeeWO();

      final empInfo =
          gValue.employees.firstWhere((element) => element.empId == empId);
      final double totalNormalHours = timeSheets
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.normalHours);
      double totalDay = timeSheets
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.normalHours);
      totalDay = totalNormalHours / 8;
      final double totalOtHours = timeSheets
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.otHours);
      final double totalOtHoursApproved = timeSheets
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.otHoursApproved);
      final double totalOtHoursFinal = timeSheets
          .where((element) => element.empId == empId)
          .fold(0, (sum, item) => sum + item.otHoursFinal);
      employeeWO.empId = empInfo.empId;
      employeeWO.name = empInfo.name;
      employeeWO.department = empInfo.department;
      employeeWO.section = empInfo.section;
      employeeWO.group = empInfo.group;
      employeeWO.lineTeam = empInfo.lineTeam;
      employeeWO.totalW = totalNormalHours;
      employeeWO.totalDay = totalDay;
      employeeWO.totalOt = totalOtHours;
      employeeWO.totalOtApproved = totalOtHoursApproved;
      employeeWO.totalOtFinal = totalOtHoursFinal;
      employeeWOs.add(employeeWO);
    }
    employeeWOs.sort((a, b) => b.totalOt.round().compareTo(a.totalOt.round()));
    for (var element in employeeWOs) {
      DateTime joiningDate = gValue.employees
          .firstWhere((emp) => emp.empId == element.empId)
          .joiningDate!;
      DateTime resignDate;
      try {
        resignDate = gValue.employees
            .firstWhere((emp) => emp.empId == element.empId)
            .resignOn!;
      } catch (e) {
        resignDate = DateTime(2099, 1, 1);
      }
      row++;
      sheetSummary.getRangeByName('A$row').setNumber((row - 1));
      sheetSummary.getRangeByName('B$row').setText(element.empId);
      sheetSummary.getRangeByName('C$row').setText(element.name);
      sheetSummary.getRangeByName('D$row').setText(element.department);
      sheetSummary.getRangeByName('E$row').setText(element.section);
      sheetSummary.getRangeByName('F$row').setText(element.group);
      sheetSummary
          .getRangeByName('G$row')
          .setNumber(roundDouble(element.totalW, 1));
      sheetSummary
          .getRangeByName('H$row')
          .setNumber(roundDouble(element.totalDay, 2));
      sheetSummary
          .getRangeByName('I$row')
          .setNumber(roundDouble(element.totalOt, 1));
      sheetSummary
          .getRangeByName('J$row')
          .setNumber(roundDouble(element.totalOtApproved, 1));
      sheetSummary
          .getRangeByName('K$row')
          .setNumber(roundDouble(element.totalOtFinal, 1));
      sheetSummary.getRangeByName('L$row').numberFormat = 'dd-MMM-yyyy';
      sheetSummary.getRangeByName('L$row').setDateTime(joiningDate);
      if (resignDate.year < 2099) {
        sheetSummary.getRangeByName('M$row:M$row').cellStyle =
            styleHeaderDateJoiningResign;
        sheetSummary.getRangeByName('M$row').numberFormat = 'dd-MMM-yyyy';
        sheetSummary.getRangeByName('M$row').setDateTime(resignDate);
      } else {
        sheetSummary.getRangeByName('M$row').setText('');
      }
      sheetSummary.getRangeByName('N$row').setFormula(
          '=COUNTIFS(Detail!Q:Q,"Vào trễ ; Ra sớm",Detail!C:C,B$row)+COUNTIFS(Detail!Q:Q,"Vào trễ",Detail!C:C,B$row)');
    }

    sheetSummary.autoFitColumn(1);
    sheetSummary.autoFitColumn(2);
    sheetSummary.autoFitColumn(3);
    sheetSummary.autoFitColumn(4);
    sheetSummary.autoFitColumn(12);
    sheetSummary.autoFitColumn(13);
    final ExcelTable tableSummary = sheetSummary.tableCollection
        .create('tableSummary', sheetSummary.getRangeByName('A1:N$row'));
    tableSummary.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight1;
    // Sheet Important Note

    sheetImportantNote
        .getRangeByName('A1')
        .setText('Chấm công sau khi nghỉ việc');
    sheetImportantNote.getRangeByName('A1').cellStyle = styleHeader;
    int line = 2;
    gValue.timeSheetNoteAttAfterResign.split('\n').forEach((element) {
      sheetImportantNote.getRangeByName('A$line').setText('$element');
      line++;
    });

    sheetImportantNote.autoFitColumn(1);
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook
        .dispose(); //Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  static Future<void> createExcelShiftRegisters(
      List<ShiftRegister> shiftRegisters, String fileName) async {
//Create an Excel document.
//Creating a workbook.

    final Workbook workbook = Workbook();
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Attendance Log';
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 160, 168, 174);
// Set the text value.
    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('From');
    sheet.getRangeByName('C1').setText('To');
    sheet.getRangeByName('D1').setText('Employee ID');
    sheet.getRangeByName('E1').setText('Name');
    sheet.getRangeByName('F1').setText('Shift');
    sheet.getRangeByName('A1:F1').cellStyle = styleHeader;
    int row = 1;
    for (var shiftRegister in shiftRegisters) {
      row++;
      sheet.getRangeByName('A$row').setNumber((row - 1));
      sheet.getRangeByName('B$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('B$row').setDateTime(shiftRegister.fromDate);
      sheet.getRangeByName('C$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('C$row').setDateTime(shiftRegister.toDate);
      sheet.getRangeByName('D$row').setText(shiftRegister.empId);
      sheet.getRangeByName('E$row').setText(shiftRegister.name);
      sheet.getRangeByName('F$row').setText(shiftRegister.shift);
    }

    final Range range = sheet.getRangeByName('A2:F2');

// Auto-Fit column the range
    range.autoFitColumns();
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  static Future<List<ShiftRegister>> readExcelShiftRegister() async {
    List<ShiftRegister> shiftRegisters = [];
    print('readExcelAttLog'); //sheet Name
    gValue.logs.clear();
    List<Employee> emps = [];
    try {
      File file = await getFile();
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      gValue.logs.add('File : ${file.path}');
      for (var table in excel.tables.keys) {
        print('Sheet Name: $table'); //sheet Name
        print('maxColumns: ${excel.tables[table]?.maxColumns}');
        print('maxRows: ${excel.tables[table]?.maxRows}');
        gValue.logs.add(
            'Sheet Name: $table   Columns: ${excel.tables[table]?.maxColumns}   Rows: ${excel.tables[table]?.maxRows}\n');
        for (int rowIndex = 1;
            rowIndex < excel.tables[table]!.maxRows;
            rowIndex++) {
          var row = [];
          row = excel.tables[table]!.rows[rowIndex];
          if (row[1] == null ||
              row[2] == null ||
              row[3] == null ||
              row[4] == null) {
            gValue.logs.add('ERROR : Row $rowIndex: is not enought infor\n');
            continue;
          }
          ShiftRegister shiftRegister = ShiftRegister(
              objectId: '',
              fromDate: DateTime.parse(row[1].value.toString()),
              toDate: DateTime.parse(row[2].value.toString()),
              empId: row[3].value.toString(),
              name: row[4].value.toString(),
              shift: row[5].value.toString());

          shiftRegisters.add(shiftRegister);
          gValue.logs.add(
              'OK : Row $rowIndex: ${shiftRegister.fromDate} to ${shiftRegister.toDate}  ${shiftRegister.empId}  ${shiftRegister.name}  ${shiftRegister.shift}\n');
        }
      }
    } catch (e) {}
    return shiftRegisters;
  }

  static Future<void> createExcelOtRegisters(
      List<OtRegister> otRegisters, String fileName) async {
//Create an Excel document.
//Creating a workbook.

    final Workbook workbook = Workbook();
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'OT Registers';
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 214, 230, 242);
// Set the text value.
    sheet.getRangeByName('A1').setText('_id');
    sheet.getRangeByName('B1').setText('Request number');
    sheet.getRangeByName('C1').setText('Request date');
    sheet.getRangeByName('D1').setText('OT date');
    sheet.getRangeByName('E1').setText('Time begin');
    sheet.getRangeByName('F1').setText('Time end');
    sheet.getRangeByName('G1').setText('Employee ID');
    sheet.getRangeByName('H1').setText('Full name');
    sheet.getRangeByName('A1:H1').cellStyle = styleHeader;
    int row = 1;
    for (var otRegister in otRegisters) {
      row++;
      sheet.getRangeByName('A$row').setNumber(otRegister.id.toDouble());
      sheet.getRangeByName('A$row').numberFormat = '0';
      sheet.getRangeByName('B$row').setText(otRegister.requestNo);
      sheet.getRangeByName('C$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('C$row').setDateTime(otRegister.requestDate);
      sheet.getRangeByName('D$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('D$row').setDateTime(otRegister.otDate);
      sheet.getRangeByName('E$row').setText(otRegister.otTimeBegin);
      sheet.getRangeByName('F$row').setText(otRegister.otTimeEnd);
      sheet.getRangeByName('G$row').setText(otRegister.empId);
      sheet.getRangeByName('H$row').setText(otRegister.name);
    }
    final Range range = sheet.getRangeByName('A2:H2');
    final ExcelTable table = sheet.tableCollection
        .create('tableData', sheet.getRangeByName('A1:H${row + 4}'));
    table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight1;
    if (sheet.getRangeByName('G2').text == 'TIQN-9999') {
      sheet.getRangeByName('J1').setText('HƯỚNG DẪN :');
      sheet.getRangeByName('J2').setText(
          'Cột B (Request number): Kiểu dữ liệu TEXT, định dạng yyyyMMdd-comment');
      sheet
          .getRangeByName('J3')
          .setText('Cột C (Request date) & D (OT date): Kiểu dữ liệu NGÀY');
      sheet
          .getRangeByName('J4')
          .setText('Cột E (Time begin) & F (Time end): Kiểu dữ liệu TEXT');
      sheet.getRangeByName('J5').setText('Cột A (_id) : Có thể để trống');
      sheet
          .getRangeByName('J6')
          .setText('Sheet name :"OT Registers" : Không được rename');
    }
// Auto-Fit column the range
    range.autoFitColumns();
    sheet.autoFitColumn(4);
    sheet.autoFitColumn(5);
    sheet.autoFitColumn(7);
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  static Future<List<OtRegister>> readExcelOtRegister() async {
    List<OtRegister> otRegisters = [];
    print('readExcelOtRegister'); //sheet Name
    gValue.logs.clear();
    try {
      File file = await getFile();
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      gValue.logs.add('File : ${file.path}');
      var sheet = excel.tables.keys.first;

      for (var table in excel.tables.keys) {
        print('Sheet Name: $table'); //sheet Name

        print('maxColumns: ${excel.tables[table]?.maxColumns}');
        print('maxRows: ${excel.tables[table]?.maxRows}');
        gValue.logs.add(
            'Sheet Name: $table   Columns: ${excel.tables[table]?.maxColumns}   Rows: ${excel.tables[table]?.maxRows}\n');
        if (table == 'OT Registers') {
          print('get data in sheet : $table');
          for (int rowIndex = 1;
              rowIndex < excel.tables[table]!.maxRows;
              rowIndex++) {
            var row = [];
            row = excel.tables[table]!.rows[rowIndex];
            print('row[1] : ${row[1].value.toString()}');
            print('row[2] : ${row[2].value.toString()}');
            print('row[3] : ${row[3].value.toString()}');
            print('row[4] : ${row[4].value.toString()}');
            print('row[5] : ${row[5].value.toString()}');
            print('row[6] : ${row[6].value.toString()}');
            if (row[1] == null ||
                row[2] == null ||
                row[3] == null ||
                row[4] == null ||
                row[5] == null) {
              gValue.logs.add('ERROR : Row $rowIndex: is not enought infor\n');
              continue;
            }
            OtRegister otRegister = OtRegister(
              id: 0,
              empId: row[6].value.toString(),
              name: row[7].value.toString(),
              requestNo: row[1].value.toString(),
              requestDate: DateTime.parse(row[2].value.toString()),
              otDate: DateTime.parse(row[3].value.toString()),
              otTimeBegin: row[4].value.toString().substring(0, 5),
              otTimeEnd: row[5].value.toString().substring(0, 5),
            );

            otRegisters.add(otRegister);
            gValue.logs.add(
                'OK : Row $rowIndex: ${DateFormat('dd-MMM-yyyy').format(otRegister.requestDate)} otDate ${DateFormat('dd-MMM-yyyy').format(otRegister.otDate)}  ${otRegister.empId}  ${otRegister.name}  ${otRegister.otTimeBegin} to ${otRegister.otTimeEnd}\n');
          }
        }
      }
    } catch (e) {}
    return otRegisters;
  }

  static Future<void> createExcelLeaveRegisters(
      List<LeaveRegister> leaveRegisters, String fileName) async {
//Create an Excel document.
//Creating a workbook.

    final Workbook workbook = Workbook();
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Leave Registers';
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 214, 230, 242);
// Set the text value.
    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('Employee ID');
    sheet.getRangeByName('C1').setText('Name');
    sheet.getRangeByName('D1').setText('From date');
    sheet.getRangeByName('E1').setText('From time');
    sheet.getRangeByName('F1').setText('To date');
    sheet.getRangeByName('G1').setText('To time');
    sheet.getRangeByName('H1').setText('Type');
    sheet.getRangeByName('I1').setText('Note');
    sheet.getRangeByName('A1:I1').cellStyle = styleHeader;
    int row = 1;
    for (var leaveRegister in leaveRegisters) {
      row++;
      sheet.getRangeByName('A$row').setNumber(leaveRegister.no.toDouble());
      sheet.getRangeByName('B$row').setText(leaveRegister.empId);
      sheet.getRangeByName('C$row').setText(leaveRegister.name);
      sheet.getRangeByName('D$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('D$row').setDateTime(leaveRegister.fromDate);
      sheet.getRangeByName('E$row').setText(leaveRegister.fromTime);
      sheet.getRangeByName('F$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('F$row').setDateTime(leaveRegister.toDate);
      sheet.getRangeByName('G$row').setText(leaveRegister.toTime);
      try {
        sheet
            .getRangeByName('H$row')
            .setNumber(double.parse(leaveRegister.type));
      } catch (e) {
        sheet.getRangeByName('H$row').setText(leaveRegister.type);
      }

      sheet.getRangeByName('I$row').setText(leaveRegister.note);
    }
    final Range range = sheet.getRangeByName('A2:I2');
    final ExcelTable table = sheet.tableCollection
        .create('tableData', sheet.getRangeByName('A1:I${row + 4}'));
    table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight1;
    if (sheet.getRangeByName('B2').text == 'TIQN-9999') {
      sheet.getRangeByName('L1').setText('HƯỚNG DẪN :');
      sheet
          .getRangeByName('L2')
          .setText('Cột D (From Date) & F (To Date): Kiểu dữ liệu NGÀY');
      sheet
          .getRangeByName('L3')
          .setText('Cột E (From Time) & G (To Time): Kiểu dữ liệu TEXT');
      sheet.getRangeByName('L4').setText(
          'Cột A (No) : Có thể để trống -  Phần mềm tự tạo theo quyy tắc : yyyyMMdd-EmpployeeID');
      sheet.getRangeByName('L5').setText('Cột I (Note): có thể để trống');
      sheet
          .getRangeByName('L6')
          .setText('Tên sheet : "Leave Registers" : không được rename');
    }

// Auto-Fit column the range
    range.autoFitColumns();
    sheet.autoFitColumn(4);
    sheet.autoFitColumn(5);
    sheet.autoFitColumn(7);
    sheet.autoFitColumn(8);
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  static Future<List<LeaveRegister>> readExcelLeaveRegister() async {
    List<LeaveRegister> leaveRegisters = [];
    gValue.logs.clear();
    try {
      File file = await getFile();
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      gValue.logs.add('File : ${file.path}');
      var sheet = excel.tables.keys.first;

      for (var table in excel.tables.keys) {
        print('Sheet Name: $table'); //sheet Name
        print('maxColumns: ${excel.tables[table]?.maxColumns}');
        print('maxRows: ${excel.tables[table]?.maxRows}');
        gValue.logs.add(
            'Sheet Name: $table   Columns: ${excel.tables[table]?.maxColumns}   Rows: ${excel.tables[table]?.maxRows}\n');
        if (table == 'Leave Registers') {
          print('get data in sheet : $table');
          for (int rowIndex = 1;
              rowIndex < excel.tables[table]!.maxRows;
              rowIndex++) {
            var row = [];
            row = excel.tables[table]!.rows[rowIndex];
            // print('row[0] : ${row[0].value.toString()}');
            // print('row[1] : ${row[1].value.toString()}');
            // print('row[2] : ${row[2].value.toString()}');
            // print('row[3] : ${row[3].value.toString()}');
            // print('row[4] : ${row[4].value.toString()}');
            // print('row[5] : ${row[5].value.toString()}');
            // print('row[6] : ${row[6].value.toString()}');
            // print('row[7] : ${row[7].value.toString()}');
            // print('row[8] : ${row[8].value.toString()}');

            if (row[1] == null ||
                row[2] == null ||
                row[3] == null ||
                row[4] == null ||
                row[5] == null ||
                row[6] == null ||
                row[7] == null) {
              gValue.logs.add('ERROR : Row $rowIndex: is not enought info\n');
              continue;
            }
            LeaveRegister leaveRegister = LeaveRegister(
              no: int.parse(row[0].value.toString()),
              empId: row[1].value.toString(),
              name: row[2].value.toString(),
              fromDate: DateTime.parse(row[3].value.toString()),
              fromTime: row[4].value.toString().substring(0, 5),
              toDate: DateTime.parse(row[5].value.toString()),
              toTime: row[6].value.toString().substring(0, 5),
              type: row[7].value.toString(),
              note: row[8].value.toString(),
            );
            // print('leaveRegister : $leaveRegister');
            leaveRegisters.add(leaveRegister);
            gValue.logs
                .add('OK : Row $rowIndex: ${leaveRegister.toString()}\n');
          }
        }
      }
    } catch (e) {
      print('readExcelLeaveRegister : $e');
    }
    return leaveRegisters;
  }
}
