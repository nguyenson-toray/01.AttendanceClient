// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:realm/realm.dart';
// import 'package:tiqn/database/_employeeBasic.dart';

// class EmployeeSummary with ChangeNotifier {
//   int total = 0;
//   int working = 0;
//   int maternity = 0;
//   int resigned = 0;

//   get getTotal => total;

//   get getWorking => working;

//   get getMaternity => maternity;

//   get getResigned => resigned;

//   setTotal(int count) {
//     total = count;
//     gValue.logger.t('EmployeeSummary setTotal : $total');
//     notifyListeners();
//   }

//   setWorking(int count) {
//     working = count;
//     gValue.logger.t('EmployeeSummary setWorking : $working');
//     notifyListeners();
//   }

//   setMaternity(int count) {
//     maternity = count;
//     gValue.logger.t('EmployeeSummary setMaternity : $maternity');
//     notifyListeners();
//   }

//   setResigned(int count) {
//     resigned = count;
//     gValue.logger.t('EmployeeSummary setMaternity : $resigned');
//     notifyListeners();
//   }

//   sumTotal(RealmResults<EmployeeBasic> data) {
//     data == null ? total = 0 : total = data.length;
//     notifyListeners();
//   }

//   sumMaternity(RealmResults<EmployeeBasic> data) {
//     data == null
//         ? maternity = 0
//         : maternity =
//             data.where((element) => element.workStatus == "Maternity").length;
//     notifyListeners();
//   }

//   sumResigned(RealmResults<EmployeeBasic> data) {
//     data == null
//         ? resigned = 0
//         : resigned =
//             data.where((element) => element.workStatus == "Resigned").length;
//     notifyListeners();
//   }

//   sumWorking(RealmResults<EmployeeBasic> data) {
//     data == null
//         ? working = 0
//         : working =
//             data.where((element) => element.workStatus == "Working").length;
//     notifyListeners();
//   }

//   summaryAll(RealmResults<EmployeeBasic> data) {
//     sumTotal(data);
//     sumMaternity(data);
//     sumResigned(data);
//     sumWorking(data);
//   }
// }
