// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:tiqn/database/employee.dart';

// class EmployeeDataSource extends DataGridSource {
//   /// Creates the employee data source class with required details.
//   EmployeeDataSource({required List<Employee> employeeData}) {
//     _employeeData = employeeData
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//               DataGridCell<String>(
//                 columnName: 'workStatus',
//                 value: e.workStatus,
//               ),
//               DataGridCell<String>(columnName: 'empId', value: e.empId),
//               DataGridCell<String>(columnName: 'name', value: e.name),
//               DataGridCell<int>(
//                   columnName: 'empFingerId', value: e.empFingerId),
//               DataGridCell<String>(
//                   columnName: 'department', value: e.department),
//               DataGridCell<String>(columnName: 'section', value: e.section),
//               DataGridCell<String>(columnName: 'gender', value: e.gender),
//               DataGridCell<DateTime>(columnName: 'dob', value: e.dob),
//             ]))
//         .toList();
//   }

//   List<DataGridRow> _employeeData = [];

//   /// Helps to hold the new value of all editable widgets.
//   /// Based on the new value we will commit the new value into the corresponding
//   /// DataGridCell on the onCellSubmit method.
//   dynamic newCellValue;

//   /// Helps to control the editable text in the [TextField] widget.
//   TextEditingController editingController = TextEditingController();
//   List<DataGridRow> get rows => _employeeData;

//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//       return Container(
//         alignment: Alignment.centerLeft,
//         padding: EdgeInsets.all(8.0),
//         child: Text(
//           e.value.toString(),
//           style: TextStyle(
//               overflow: TextOverflow.ellipsis,
//               color: e.value == 'Resigned'
//                   ? Colors.red
//                   : e.value == 'Maternity'
//                       ? Colors.orangeAccent
//                       : Colors.black),
//         ),
//       );
//     }).toList());
//   }
// }
