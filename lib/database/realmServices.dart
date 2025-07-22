// import 'package:realm/realm.dart';
// import 'package:flutter/material.dart';
// import 'package:tiqn/database/attLog.dart';
// import 'package:tiqn/database/attReport.dart';
// import 'package:tiqn/database/attUser.dart';
// import 'package:tiqn/database/_employeeBasic.dart';
// import 'package:tiqn/gValue.dart';
// import 'package:tiqn/main.dart';

// class RealmServices with ChangeNotifier {
//   static const String queryAllEmployeeBasic = "queryAllEmployeeBasic";
//   static const String queryAllAttUser = "queryAllAttUser";
//   static const String queryAllAttLog = "queryAllAttLog";
//   static const String queryAllAttReport = "queryAllAttReport";

//   bool showAll = true;
//   bool offlineModeOn = false;
//   bool isWaiting = false;
//   late Realm realm;
//   late App app;
//   int _count = 0;

//   int get count => _count;

//   void increment() {
//     _count++;
//     notifyListeners();
//   }

//   Future<void> initRealm() async {
//     app = App(AppConfiguration('tiqn-app-nyzfl'));
//     final user = await app.logIn(Credentials.anonymous());
//     // Configure and open the realm
//     final realmConfig = Configuration.flexibleSync(user, [
//       EmployeeBasic.schema,
//       AttLog.schema,
//       AttUser.schema,
//       AttReport.schema,
//       AttReportDetail.schema
//     ]);
//     realm = Realm(realmConfig);
//     if (realm.subscriptions.isEmpty) {
//       updateSubscriptions();
//     }
//   }

//   Future<void> logInAsAnonymous() async {
//     final user = await app.logIn(Credentials.anonymous());
//   }

//   Future<void> updateSubscriptions() async {
//     realm.subscriptions.update((mutableSubscriptions) {
//       mutableSubscriptions.clear();
//       if (showAll) {
//         mutableSubscriptions.add(realm.all<EmployeeBasic>(),
//             name: queryAllEmployeeBasic);
//         mutableSubscriptions.add(realm.all<AttUser>(), name: queryAllAttUser);
//         mutableSubscriptions.add(realm.all<AttLog>(), name: queryAllAttLog);
//         mutableSubscriptions.add(realm.all<AttReport>(),
//             name: queryAllAttReport);
//       } else {}
//     });
//     await realm.subscriptions.waitForSynchronization();
//   }

//   // Future<void> initOfflineHrData() async {
//   //   gValue.employeeBasics.clear();
//   //   gValue.attLogs.clear();
//   //   gValue.attReports.clear();
//   //   gValue.employeeBasics = getAllEmployeeBasic();
//   //   gValue.attLogs =
//   //       await getAttLogByRangeDate(gValue.timeBegin, gValue.timeEnd);
//   //   gValue.attReports = getAllAttReport();
//   //   gValue.logger.t(
//   //       'initOfflineHrData: dateBegin: ${gValue.timeBegin}   to  dateEnd: ${gValue.timeEnd} \ngValue.employeeBasics.length: ${gValue.employeeBasics.length}\ngValue.attLogs.length: ${gValue.attLogs.length}\ngValue.attReports.length: ${gValue.attReports.length}');
//   // }

//   Stream<RealmResultsChanges<EmployeeBasic>> getEmployeeBasic() {
//     final realmResultsChanges = realm
//         .query<EmployeeBasic>(r'empId != $0 SORT(empId DESC)', ['']).changes;
//     return realmResultsChanges;
//   }

//   List<EmployeeBasic> getAllEmployeeBasic() {
//     List<EmployeeBasic> result = [];
//     realm.all<EmployeeBasic>().forEach((emp) {
//       result.add(emp);
//     });
//     return result;
//   }

//   ObjectId checkExitsEmployee(EmployeeBasic emp) {
//     ObjectId id = gValue.defaultObjectId;
//     final allEmp = realm.query<EmployeeBasic>(r'empId != $0 SORT(empId DESC)');
//     for (var empDB in allEmp) {
//       if (empDB.empId == empDB.empId) {
//         id = empDB.id!;
//         break;
//       }
//     }
//     return id;
//   }

//   EmployeeBasic getEmpObjectByEmpId(String empId) {
//     late EmployeeBasic result;
//     final allEmp = realm.query<EmployeeBasic>(r'empId != $0 SORT(empId DESC)');
//     for (var element in allEmp) {
//       if (element.empId == empId) {
//         result = element;
//         break;
//       }
//     }
//     return result;
//   }

//   ObjectId? getIdObjectEmployeeBasic(EmployeeBasic empCheck) {
//     final emps = realm.all<EmployeeBasic>();
//     for (var emp in emps) {
//       if (emp.empId == empCheck.empId) {
//         return emp.id;
//       }
//     }
//     return gValue.defaultObjectId;
//   }

//   void addUpdateEmployeeBasic(List<EmployeeBasic> emps) {
//     for (var emp in emps) {
//       final objectId = getIdObjectEmployeeBasic(emp);
//       gValue.logger.t(objectId);
//       if (objectId == gValue.defaultObjectId) // not exits
//       {
//         realm.write<EmployeeBasic>(() => realm.add<EmployeeBasic>(emp));
//       } else {
//         emp.id = objectId;
//         realm.write<EmployeeBasic>(
//             () => realm.add<EmployeeBasic>(emp, update: true));
//       }
//     }

//     notifyListeners();
//   }

//   void deleteEmployeeBasic(String empId) {
//     realm.write(() => realm.delete(getEmpObjectByEmpId(empId)));
//     notifyListeners();
//   }

//   Future<void> updateItem(EmployeeBasic emp) async {
//     realm.write<EmployeeBasic>(
//       () => realm.add<EmployeeBasic>(emp, update: true),
//     );
//     notifyListeners();
//   }

//   void deleteAttLog(String attLogDeleteObjectId) {
//     // Query for the object with matching ID

//     final results = realm.query<AttLog>('_id == oid($attLogDeleteObjectId)');
//     gValue.logger.t('---------------------${results.first}');
//     // Check if any objects were found
//     if (results.isNotEmpty) {
//       // Delete the first object (assuming unique IDs)
//       realm.write(() => realm.delete(results.first));
//     } else {
//       gValue.logger.t('No object found with ID: $attLogDeleteObjectId');
//     }
//     notifyListeners();
//   }

//   Stream<RealmResultsChanges<AttLog>> getAttLogStreamByRangeDate(
//       DateTime timeBegin, timeEnd) {
//     final realmResultsChanges = realm.query<AttLog>(
//         r'timestamp BETWEEN {$0, $1}  SORT(timestamp DESC) ',
//         [timeBegin, timeEnd]).changes;
//     return realmResultsChanges;
//   }

//   List<AttLog> getAttLogByRangeDate(DateTime timeBegin, timeEnd) {
//     List<AttLog> result = [];
//     final data = realm.query<AttLog>(
//         r'timestamp BETWEEN {$0, $1}  SORT(timestamp DESC) ',
//         [timeBegin, timeEnd]);
//     for (var log in data) {
//       final temp = AttLog(log.id,
//           attFingerId: log.attFingerId,
//           employeeId: log.employeeId,
//           machineNo: log.machineNo,
//           name: log.name,
//           timestamp: log.timestamp?.toLocal());
//       result.add(temp);
//     }
//       gValue.logger.t(
//         'getAttLogByRangeDate : $timeBegin  to $timeEnd  => lenght == ${result.length}');
//     return result;
//   }

//   Stream<RealmResultsChanges<AttReport>> getAttReportCurrentMonth() {
//     final realmResultsChanges =
//         realm.query<AttReport>(r'TRUEPREDICATE  SORT(date DESC) ').changes;

//     return realmResultsChanges;
//   }

//   void addAttLogs(List<AttLog> logs) {
//     for (var log in logs) {
//       gValue.logger.t('addAttLogs : $logs ');
//       realm.write<AttLog>(() => realm.add<AttLog>(log));
//     }
//   }

//   List<AttReport> getAllAttReport() {
//     List<AttReport> result = [];
//     var time = DateTime.now();
//     final data =
//         realm.query<AttReport>(r'date <= $1  SORT(date DESC) ', [time]);

//     for (var element in data) {
//       element.date = element.date?.toLocal();
//       result.add(element);
//     }

//     return result;
//   }

//   ObjectId getAttReportObjectIDByDate(DateTime date) {
//     final dateEnd = DateTime.now()
//         .appliedFromTimeOfDay(const TimeOfDay(hour: 23, minute: 59));
//     AttReport? result = realm.query<AttReport>(
//         r'date BETWEEN { $0, $1}  SORT(date DESC)',
//         [date, dateEnd]).firstOrNull;

//     return result == null ? gValue.defaultObjectId : result.id;
//   }

//   ObjectId getIdObjectAttReport(AttReport report) {
//     final reports = realm.all<AttReport>();
//     for (var element in reports) {
//       if (report.date?.difference(element.date!).inDays == 0) {
//         return element.id;
//       }
//     }
//     return gValue.defaultObjectId;
//   }

//   void addAttReport(List<AttReport> reports) {
//     for (var report in reports) {
//       gValue.logger.t('addAttReport : $report ');
//       final id = getIdObjectAttReport(report);
//       if (id == gValue.defaultObjectId) {
//         realm.write(() => realm.add<AttReport>(report));
//       } else {
//         report.id = id;
//         realm.write(() => realm.add<AttReport>(report, update: true));
//       }
//     }
//   }

//   Future<void> close() async {
//     realm.close();
//   }

//   @override
//   void dispose() {
//     realm.close();
//     super.dispose();
//   }
// }
