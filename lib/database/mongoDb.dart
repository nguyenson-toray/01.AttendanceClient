import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:tiqn/database/history.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/leaveRegister.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/shift.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:tiqn/database/timeSheetMonthYear.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/main.dart';

class MongoDb {
  String ipServer = '10.0.1.4';

  late var colEmployee,
      colAttLog,
      colShift,
      colShiftRegister,
      colOtRegister,
      colConfig,
      colTimesheetsMonthYear,
      colHistory,
      colListPc,
      colLeaveRegister;
  late Db db;
  initDB() async {
    if (kReleaseMode) {
      ipServer = '10.0.1.4';
    } else {
      ipServer = 'localhost';
      // ipServer = '10.0.1.4';
    }
    db = Db("mongodb://$ipServer:27017/tiqn");
    try {
      await db.open();
      colEmployee = db.collection('Employee');
      colAttLog = db.collection('AttLog');
      colShift = db.collection('Shift');
      colShiftRegister = db.collection('ShiftRegister');
      colOtRegister = db.collection('OtRegister');
      colConfig = db.collection('Config');
      colTimesheetsMonthYear = db.collection('TimesheetsMonthYear');
      colHistory = db.collection('History');
      colListPc = db.collection('ListPc');
      colLeaveRegister = db.collection('LeaveRegister');
      gValue.isConectedDb = true;
    } catch (e) {
      print(e);
      gValue.isConectedDb = false;
    }
  }

  Future<String> checkPermission(String pcName) async {
    late var allowEdit, allowRead;
    String permission = 'no';
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      await colListPc.find().forEach((item) => {allowEdit = item['allowEdit']});
      await colListPc.find().forEach((item) => {allowRead = item['allowRead']});
    } catch (e) {
      print(e);
    }
    if (allowEdit.contains(pcName)) {
      return 'edit';
    } else if (allowRead.contains(pcName)) {
      return 'read';
    } else {
      return permission;
    }
  }

  getConfig() async {
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      List<Map<String, dynamic>> result = [];
      result = await colConfig.find().toList();
      gValue.showObjectId = result.first['showObjectId'];
    } catch (e) {
      print(e);
    }
  }

  Future<List<Shift>> getShifts() async {
    List<Shift> result = [];
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      await colShift
          .find(where.sortBy('shift', descending: false))
          .forEach((shift) => {result.add(Shift.fromMap(shift))});
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<List<Employee>> getEmployees() async {
    List<Employee> result = [];
    try {
      if (!db.isConnected) {
        print('getEmployees - DB not connected, try connect again');
        await initDB();
      }
      await colEmployee
          .find(where.sortBy('empId', descending: true))
          .forEach((emp) => {result.add(Employee.fromMap(emp))});
    } catch (e) {
      print('getEmployees: $e');
    }

    return result;
  }

  Future<void> removeEmployee(String empId) async {
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      await colEmployee.deleteOne({"empId": empId});
    } catch (e) {
      print(e);
    }
  }

  Future<void> insertManyEmployees(List<Employee> inputEmps) async {
    try {
      if (!db.isConnected) {
        print('insertManyEmployees - DB not connected, try connect again');
        await initDB();
      }
      List<Employee> allEmps = await getEmployees();
      List<Employee> empNews = [];
      List<Employee> empExits = [];
      var str = allEmps.toString();
      for (var element in inputEmps) {
        str.contains(element.empId.toString())
            ? empExits.add(element)
            : empNews.add(element);
      }
      List<Map<String, dynamic>> mapNews = [];
      for (var element in empNews) {
        mapNews.add(element.toMap());
      }
      if (mapNews.isNotEmpty) await colEmployee.insertMany(mapNews);
      if (empExits.isNotEmpty) {
        empExits.forEach((element) async {
          await colEmployee.deleteOne({"empId": element.empId});
          await colEmployee.insertOne(element.toMap());
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<AttLog>> getAttLogs(DateTime timneBegin, DateTime timeEnd) async {
    List<AttLog> result = [];
    try {
      if (!db.isConnected) {
        print('getAttLogs DB not connected, try connect again');
        await initDB();
      }
      await colAttLog
          .find(where
                  .gt('timestamp', timneBegin)
                  .and(where.lt('timestamp', timeEnd))
              // .sortBy('timestamp', descending: true)
              )
          .forEach((log) => {result.add(AttLog.fromMap(log))});
    } catch (e) {
      print(e);
    }
    // print(
    //     'getAttLogs ${timneBegin}  to ${timeEnd} => ${result.length} records');
    return result;
  }

  Future<void> deleteOneAttLog(String objectIdString) async {
    if (objectIdString.isNotEmpty) {
      try {
        if (!db.isConnected) {
          print('deleteOneAttLog DB not connected, try connect again');
          await initDB();
        }

        print('deleteOneAttLog :$objectIdString');
        var myObjectId = ObjectId.parse(objectIdString);
        await colAttLog.deleteOne({"_id": myObjectId});
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> insertAttLogs(List<AttLog> logs) async {
    if (logs.isNotEmpty) {
      try {
        if (!db.isConnected) {
          print('insertAttLogs DB not connected, try connect again');
          await initDB();
        }
        List<Map<String, dynamic>> maps = [];
        for (var element in logs) {
          print('insertAttLogs element : $element');
          maps.add(element.toMap());
        }
        await colAttLog.insertMany(maps);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<List<ShiftRegister>> getShiftRegister() async {
    List<ShiftRegister> result = [];
    try {
      if (!db.isConnected) {
        print('getShiftRegister DB not connected, try connect again');
        await initDB();
      }
      await colShiftRegister
          // .find(where.sortBy('toDate', descending: true))
          .find()
          .forEach((e) => {result.add(ShiftRegister.fromMap(e))});
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List<ShiftRegister>> getShiftRegisterByYear(int year) async {
    List<ShiftRegister> result = [];
    late DateTime timeBegin, timeEnd;
    if (year == 2024) {
      timeBegin = DateTime(2023, 12, 26).appliedFromTimeOfDay(const TimeOfDay(
        hour: 0,
        minute: 0,
      ));
      timeEnd = DateTime(2024, 12, 25).appliedFromTimeOfDay(const TimeOfDay(
        hour: 23,
        minute: 59,
      ));
    } else if (year == 2025) {
      timeBegin = DateTime(2024, 12, 26).appliedFromTimeOfDay(const TimeOfDay(
        hour: 0,
        minute: 0,
      ));
      timeEnd = DateTime(2025, 12, 25).appliedFromTimeOfDay(const TimeOfDay(
        hour: 23,
        minute: 59,
      ));
    }
    try {
      if (!db.isConnected) {
        print('getShiftRegister DB not connected, try connect again');
        await initDB();
      }
      await colShiftRegister
          .find(
              where.gte('toDate', timeBegin).and(where.lte('toDate', timeEnd)))
          .forEach((e) => {result.add(ShiftRegister.fromMap(e))});
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<void> deleteOneShiftRegister(String objectIdString) async {
    if (objectIdString.isNotEmpty) {
      try {
        if (!db.isConnected) {
          print('deleteOneShiftRegister DB not connected, try connect again');
          await initDB();
        }
        print('deleteOneShiftRegister :$objectIdString');
        var myObjectId = ObjectId.parse(objectIdString);
        await colShiftRegister.deleteOne({"_id": myObjectId});
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> addOneShiftRegister(ShiftRegister shiftRegister) async {
    try {
      if (!db.isConnected) {
        print('addOneShiftRegister DB not connected, try connect again');
        await initDB();
      }
      await colShiftRegister.insertOne(shiftRegister.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOneShiftRegisterFromMap(Map shiftRegister) async {
    try {
      if (!db.isConnected) {
        print('addOneShiftRegisterFromMap DB not connected, try connect again');
        await initDB();
      }
      await colShiftRegister.insertOne(shiftRegister);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOneShiftRegisterByObjectId(
      String objectIdString, String key, dynamic value) async {
    print('updateOneShiftRegisterByObjectId');
    try {
      if (!db.isConnected) {
        print(
            'updateOneShiftRegisterByObjectId DB not connected, try connect again');
        await initDB();
      }
      var myObjectId = ObjectId.parse(objectIdString);
      await colShiftRegister.updateOne(
          where.eq('_id', myObjectId), modify.set(key, value));
    } catch (e) {
      print(e);
    }
  }

  Future<void> insertShiftRegisters(List<ShiftRegister> shiftRegisters) async {
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      List<Map<String, dynamic>> maps = [];
      for (var element in shiftRegisters) {
        maps.add(element.toMap());
        // await Future.delayed(Duration(milliseconds: 100));
        // await colShiftRegister.insertOne(element.toMap());
      }
      await colShiftRegister.insertMany(maps);
    } catch (e) {
      print(e);
    }
  }

  Future<List<History>> getHistoryAll() async {
    print('getHistoryAll');
    List<History> result = [];
    try {
      if (!db.isConnected) {
        print('getHistoryAll DB not connected, try connect again');
        await initDB();
      }
      await colHistory
          .find(where.sortBy('time', descending: false))
          .forEach((history) => {result.add(History.fromMap(history))});
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List<History>> getHistoryByYear(int year) async {
    print('getHistoryAll');
    late DateTime timeBegin, timeEnd;
    if (year == 2024) {
      timeBegin = DateTime(2023, 12, 26).appliedFromTimeOfDay(const TimeOfDay(
        hour: 0,
        minute: 0,
      ));
      timeEnd = DateTime(2024, 12, 25).appliedFromTimeOfDay(const TimeOfDay(
        hour: 23,
        minute: 59,
      ));
    } else if (year == 2025) {
      timeBegin = DateTime(2024, 12, 26).appliedFromTimeOfDay(const TimeOfDay(
        hour: 0,
        minute: 0,
      ));
      timeEnd = DateTime(2025, 12, 25).appliedFromTimeOfDay(const TimeOfDay(
        hour: 23,
        minute: 59,
      ));
    }
    List<History> result = [];
    try {
      if (!db.isConnected) {
        print('getHistoryAll DB not connected, try connect again');
        await initDB();
      }
      await colHistory
          .find(where
              .gte('time', timeBegin)
              .and(where.lte('time', timeEnd))
              .sortBy('time', descending: false))
          .forEach((history) => {result.add(History.fromMap(history))});
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<void> insertHistory(List<History> histories) async {
    // print('insertHistory : $histories');
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      List<Map<String, dynamic>> maps = [];
      for (var history in histories) {
        print(history);
        maps.add(history.toMap());
      }
      await colHistory.insertMany(maps);
    } catch (e) {
      print('insertHistory: $e');
    }
  }

  Future<List<OtRegister>> getOTRegisterByRangeDate(
      DateTime timeBegin, DateTime timeEnd) async {
    List<OtRegister> result = [];
    try {
      if (!db.isConnected) {
        print('getOTRegisterByRangeDate DB not connected, try connect again');
        await initDB();
      }

      await colOtRegister
          .find(where
              .gte('otDate', timeBegin)
              .and(where.lte('otDate', timeEnd))
              .sortBy('otDate', descending: true))
          .forEach((ot) => {result.add(OtRegister.fromMap(ot))});
    } catch (e) {
      print(e);
    }
    // print('getOTRegisterByRangeDate: timeBegin: $timeBegin timeEnd:$timeEnd');
    // print('====> ${result.length}');
    return result;
  }

  Future<List<OtRegister>> getOTRegisterAll() async {
    print('--------------getOTRegisterAll');
    List<OtRegister> result = [];
    DateTime date = DateTime.utc(2024, 12, 25, 0, 0, 0);
    try {
      // Kiểm tra kết nối DB
      if (!db.isConnected) {
        print('getOTRegisterAll DB not connected, try connect again');
        await initDB();
      }

      // Tạo điều kiện query
      final query = where.gt('OtDate', date).sortBy('_id', descending: true);

      // Thực hiện query và chuyển đổi kết quả
      await colOtRegister.find(query).forEach((ot) {
        print('--------------ot: $ot');
        try {
          result.add(OtRegister.fromMap(ot));
        } catch (e) {
          print('Error parsing OT record: $e');
          // Có thể log thêm data gốc để debug: print('Raw data: $ot');
        }
      });

      return result;
    } catch (e) {
      print('Error in getOTRegisterAll: $e');
      // Có thể throw exception để caller xử lý
      // throw Exception('Failed to fetch OT registers: $e');
      return result;
    }
  }

  Future<void> deleteOneOtRegister(int id) async {
    if (id <= 0) return;
    try {
      if (!db.isConnected) {
        print('deleteOneOtRegister DB not connected, try connect again');
        await initDB();
      }
      print('deleteOneOtRegister :$id');

      await colOtRegister.deleteOne({"_id": id});
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOneOtRegister(OtRegister otRegister) async {
    try {
      if (!db.isConnected) {
        print('addOneOtRegister DB not connected, try connect again');
        await initDB();
      }
      await colOtRegister.insertOne(otRegister.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOneOtRegisterFromMap(Map otRegister) async {
    try {
      if (!db.isConnected) {
        print('addOneOtRegisterFromMap DB not connected, try connect again');
        await initDB();
      }
      await colOtRegister.insertOne(otRegister);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOneOtRegisterByObjectId(
      String objectIdString, String key, dynamic value) async {
    if (!db.isConnected) {
      print('DB not connected, try connect again');
      initDB();
    }
    if (!db.isConnected) return;
    var myObjectId = ObjectId.parse(objectIdString);
    await colOtRegister.updateOne(
        where.eq('_id', myObjectId), modify.set(key, value));
  }

  Future<void> insertOtRegisters(List<OtRegister> otRegisters) async {
    try {
      if (!db.isConnected) {
        print('insertOtRegisters DB not connected, try connect again');
        await initDB();
      }
      List<Map<String, dynamic>> maps = [];
      int maxId = await getMaxIdOtRegisters();
      for (var element in otRegisters) {
        maxId++;
        element.id = maxId;
        print(element);
        maps.add(element.toMap());
      }
      await colOtRegister.insertMany(maps);
    } catch (e) {
      print(e);
    }
  }

  Future<int> getMaxIdOtRegisters() async {
    int max = -1;
    try {
      if (!db.isConnected) {
        print('insertOtRegisters DB not connected, try connect again');
        await initDB();
      }

      var temp = await colOtRegister
          .find(where.sortBy('_id', descending: true).limit(1))
          .forEach((ot) => {max = ot['_id']});
      print('getMaxIdOtRegisters: max id = $max');
    } catch (e) {
      print(e);
    }
    return max;
  }

  Future<List<TimeSheetMonthYear>> getTimesheetsMonthYear(
      String monthYear) async {
    List<TimeSheetMonthYear> result = [];
    try {
      if (!db.isConnected) {
        print('getTimesheetsMonthYear - DB not connected, try connect again');
        await initDB();
      }

      await colTimesheetsMonthYear
          .find(where.eq('monthYear', monthYear)
              // .sortBy('monthYear', descending: true)
              )
          .forEach((ts) => {result.add(TimeSheetMonthYear.fromMap(ts))});
      // print('getAllEmployee => ${result.length} records');
    } catch (e) {
      print(e);
    }
    print('getTimesheetsMonthYear : -$monthYear--------> ${result.length}');
    return result;
  }

  Future<void> updateTimesheetsMonthYear(
      List<TimeSheetMonthYear> timeSheetMonthYear, String monthYear) async {
    print(
        'updateTimesheetsMonthYear updateTimesheetsMonthYear: ${timeSheetMonthYear.length} monthYear: $monthYear ');
    try {
      if (!db.isConnected) {
        print('insertOtRegisters DB not connected, try connect again');
        await initDB();
      }
      await colTimesheetsMonthYear.deleteMany({"monthYear": monthYear});
      List<Map<String, dynamic>> maps = [];
      for (var ts in timeSheetMonthYear) {
        maps.add(ts.toMap());
      }
      await colTimesheetsMonthYear.insertMany(maps);
    } catch (e) {
      print(e);
    }
  }

  Future<List<LeaveRegister>> getLeaveRegister() async {
    // print('getLeaveRegister');
    List<LeaveRegister> result = [];
    try {
      if (!db.isConnected) {
        print('getLeaveRegister DB not connected, try connect again');
        await initDB();
      }
      await colLeaveRegister
          .find(where.sortBy('no', descending: true))
          .forEach((leave) => {result.add(LeaveRegister.fromMap(leave))});
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<void> insertLeaveRegister(List<LeaveRegister> leaveRegister) async {
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      List<Map<String, dynamic>> maps = [];
      for (var leaveRegister in leaveRegister) {
        maps.add(leaveRegister.toMap());
      }
      await colLeaveRegister.insertMany(maps);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteOneLeaveRegister(String no) async {
    try {
      if (!db.isConnected) {
        print('deleteOneLeaveRegister DB not connected, try connect again');
        await initDB();
      }
      print('deleteOneLeaveRegister :$no');
      await colLeaveRegister.deleteOne({"no": no});
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOneleaveRegister(LeaveRegister leaveRegister) async {
    try {
      if (!db.isConnected) {
        print('addOneleaveRegister DB not connected, try connect again');
        await initDB();
      }
      await colLeaveRegister.insertOne(leaveRegister.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<List<LeaveRegister>> getLeaveRegisterByRangeDate(
    DateTime begin,
    DateTime end,
  ) async {
    List<LeaveRegister> result = [];

    try {
      if (!db.isConnected) {
        print(
            'getLeaveRegisterByRangeDate DB not connected, try connect again');
        await initDB();
      }

      await colLeaveRegister
          .find(where
              .lte('fromDate', begin)
              .and(where.gte(
                  'toDate',
                  end.appliedFromTimeOfDay(
                      const TimeOfDay(hour: 00, minute: 00))))
              .sortBy('no', descending: true))
          .forEach((record) => {result.add(LeaveRegister.fromMap(record))});
    } catch (e) {
      print(e);
    }
    return result;
  }
}
