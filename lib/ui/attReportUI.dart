// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import 'package:realm/realm.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:tiqn/database/attReport.dart';
// import 'package:tiqn/gValue.dart';
// import 'package:tiqn/main.dart';
// import 'package:tiqn/tools/myFunction.dart';
// import 'package:tiqn/tools/myfile.dart';

// class AttReportUI extends StatefulWidget {
//   const AttReportUI({super.key});

//   @override
//   State<AttReportUI> createState() => _AttReportUIState();
// }

// class _AttReportUIState extends State<AttReportUI> {
//   List<PlutoColumn> columns = [];
//   List<PlutoRow> rows = [];
//   bool firstBuild = true;
//   late final PlutoGridStateManager stateManager;
//   late DateTime timeBegin;
//   late DateTime timeEnd;

//   final StreamController<RealmResultsChanges<AttReport>> streamController =
//       StreamController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     columns = getColumns();
//     timeBegin = DateTime.now();
//     timeEnd = DateTime.now();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: StreamBuilder<RealmResultsChanges<AttReport>>(
//       stream: gValue.realmService.getAttReportCurrentMonth(),
//       builder: (context, snapshot) {
//         final data = snapshot.data;
//         if (data == null) {
//           return const SizedBox(
//               height: 20,
//               width: 200,
//               child: LinearProgressIndicator(
//                 backgroundColor: Colors.white,
//                 color: Colors.orange,
//               ));
//         }

//         final results = data.results;

//         const TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold);

//         if (!firstBuild) {
//           rows = getRows(results);
//           stateManager.removeRows(stateManager.rows);
//           stateManager.appendRows(rows);
//         }

//         return Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             explanationAndAction(),
//             Expanded(
//               child: PlutoGrid(
//                 mode: PlutoGridMode.readOnly,
//                 configuration: const PlutoGridConfiguration(
//                   enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
//                   scrollbar: PlutoGridScrollbarConfig(
//                     scrollbarThickness: 8,
//                     scrollbarThicknessWhileDragging: 20,
//                     isAlwaysShown: true,
//                   ),
//                   style: PlutoGridStyleConfig(
//                     rowColor: Colors.white,
//                     enableGridBorderShadow: true,
//                   ),
//                   columnFilter: PlutoGridColumnFilterConfig(),
//                 ),
//                 columns: columns,
//                 columnGroups: columnGroups,
//                 rows: getRows(results),
//                 onLoaded: (PlutoGridOnLoadedEvent event) {
//                   firstBuild = false;
//                   stateManager = event.stateManager;

//                   // stateManager.setShowColumnFilter(true);
//                   // context.read<AttLog>().summaryAll(results);
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     ));
//   }

//   /// columnGroups that can group columns can be omitted.
//   final List<PlutoColumnGroup> columnGroups = [
//     PlutoColumnGroup(
//       backgroundColor: Colors.blue[100],
//       title: 'Direct',
//       fields: [
//         'directN',
//         'directR',
//         'directM',
//         'directW',
//         'directE',
//         'directAW',
//         'directA',
//         'directP'
//       ],
//     ),
//     PlutoColumnGroup(
//       backgroundColor: Colors.green[100],
//       title: 'Indirect',
//       fields: [
//         'indirectN',
//         'indirectR',
//         'indirectM',
//         'indirectW',
//         'indirectE',
//         'indirectAW',
//         'indirectA',
//         'indirectP'
//       ],
//     ),
//     PlutoColumnGroup(
//       backgroundColor: Colors.orange[100],
//       title: 'Management',
//       fields: [
//         'managementN',
//         'managementR',
//         'managementM',
//         'managementW',
//         'managementE',
//         'managementAW',
//         'managementA',
//         'managementP'
//       ],
//     ),
//     PlutoColumnGroup(
//       backgroundColor: Colors.teal[100],
//       title: 'Total',
//       fields: [
//         'totalN',
//         'totalR',
//         'totalM',
//         'totalW',
//         'totalE',
//         'totalAW',
//         'totalA',
//         'totalP'
//       ],
//     ),
//     // PlutoColumnGroup(title: 'Direct', fields: ['directN','directR','directM','directE','directAW','directA','directP'], expandedColumn: true),
//   ];

//   List<PlutoColumn> getColumns() {
//     List<PlutoColumn> columns;
//     columns = [
//       PlutoColumn(
//           title: 'Date',
//           field: 'date',
//           type: PlutoColumnType.date(format: 'dd-MMM-yyyy'),
//           width: 110),
//       //--------------------
//       PlutoColumn(
//           title: 'N',
//           field: 'directN',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'R',
//           field: 'directR',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'M',
//           field: 'directM',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'W',
//           field: 'directW',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'E',
//           field: 'directE',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'AW',
//           field: 'directAW',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'A',
//           field: 'directA',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'P',
//           field: 'directP',
//           type: PlutoColumnType.text(),
//           width: 70),
//       //-----------------
//       //
//       PlutoColumn(
//           title: 'N',
//           field: 'indirectN',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'R',
//           field: 'indirectR',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'M',
//           field: 'indirectM',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'W',
//           field: 'indirectW',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'E',
//           field: 'indirectE',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'AW',
//           field: 'indirectAW',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'A',
//           field: 'indirectA',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'P',
//           field: 'indirectP',
//           type: PlutoColumnType.text(),
//           width: 70),
//       //--------
//       PlutoColumn(
//           title: 'N',
//           field: 'managementN',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'R',
//           field: 'managementR',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'M',
//           field: 'managementM',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'W',
//           field: 'managementW',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'E',
//           field: 'managementE',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'AW',
//           field: 'managementAW',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'A',
//           field: 'managementA',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'P',
//           field: 'managementP',
//           type: PlutoColumnType.text(),
//           width: 70),
//       //--------
//       PlutoColumn(
//           title: 'N',
//           field: 'totalN',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'R',
//           field: 'totalR',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'M',
//           field: 'totalM',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'W',
//           field: 'totalW',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'E',
//           field: 'totalE',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'AW',
//           field: 'totalAW',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'A',
//           field: 'totalA',
//           type: PlutoColumnType.number(),
//           width: 50),
//       PlutoColumn(
//           title: 'P', field: 'totalP', type: PlutoColumnType.text(), width: 70),
//     ];
//     return columns;
//   }

//   List<PlutoRow> getRows(RealmResults<AttReport> data) {
//     gValue.attReports.clear();
//     List<PlutoRow> rows = [];
//     for (var element in data) {
//       var directN =
//           element.direct!.newlyJoined + element.direct!.maternityComeback;

//       var indirectN =
//           element.inDirect!.newlyJoined + element.inDirect!.maternityComeback;
//       var managementN = element.management!.newlyJoined +
//           element.management!.maternityComeback;
//       var totalN =
//           element.total!.newlyJoined + element.total!.maternityComeback;
//       gValue.attReports.add(element);
//       rows.add(
//         PlutoRow(
//           cells: {
//             'date': PlutoCell(value: element.date),
//             //--------

//             'directN': PlutoCell(value: directN),
//             'directR': PlutoCell(value: element.direct?.resigned),
//             'directM': PlutoCell(value: element.direct?.maternityLeave),
//             'directW': PlutoCell(value: element.direct?.working),
//             'directE': PlutoCell(value: element.direct?.enrolledTotal),
//             'directAW': PlutoCell(value: element.direct?.actualWorking),
//             'directA': PlutoCell(value: element.direct?.absent),
//             'directP': PlutoCell(
//                 value:
//                     '${(element.direct!.absentPercent * 100).toStringAsFixed(2)}%'),
//             //---------
//             'indirectN': PlutoCell(value: indirectN),
//             'indirectR': PlutoCell(value: element.inDirect?.resigned),
//             'indirectM': PlutoCell(value: element.inDirect?.maternityLeave),
//             'indirectW': PlutoCell(value: element.inDirect?.working),
//             'indirectE': PlutoCell(value: element.inDirect?.enrolledTotal),
//             'indirectAW': PlutoCell(value: element.inDirect?.actualWorking),
//             'indirectA': PlutoCell(value: element.inDirect?.absent),
//             'indirectP': PlutoCell(
//                 value:
//                     '${(element.inDirect!.absentPercent * 100).toStringAsFixed(2)}%'),

//             //--------
//             'managementN': PlutoCell(value: managementN),
//             'managementR': PlutoCell(value: element.management?.resigned),
//             'managementM': PlutoCell(value: element.management?.maternityLeave),
//             'managementW': PlutoCell(value: element.management?.working),
//             'managementE': PlutoCell(value: element.management?.enrolledTotal),
//             'managementAW': PlutoCell(value: element.management?.actualWorking),
//             'managementA': PlutoCell(value: element.management?.absent),
//             'managementP': PlutoCell(
//                 value:
//                     '${(element.management!.absentPercent * 100).toStringAsFixed(2)}%'),
//             //--------
//             'totalN': PlutoCell(value: totalN),
//             'totalR': PlutoCell(value: element.total?.resigned),
//             'totalM': PlutoCell(value: element.total?.maternityLeave),
//             'totalW': PlutoCell(value: element.total?.working),
//             'totalE': PlutoCell(value: element.total?.enrolledTotal),
//             'totalAW': PlutoCell(value: element.total?.actualWorking),
//             'totalA': PlutoCell(value: element.total?.absent),
//             'totalP': PlutoCell(
//                 value:
//                     '${(element.total!.absentPercent * 100).toStringAsFixed(2)}%'),
//           },
//         ),
//       );
//     }
//     gValue.logger.t(
//         '######### getRows(RealmResults<AttReport> data) ==>>>>> ${rows.length}');
//     return rows;
//   }

//   explanationAndAction() {
//     return SizedBox(
//       width: 200,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//               'N :Newly joined & \nMaternity return to work\nW : Working\nE : Enrolled Total\nAW : Actual working\nA : Absent\nP : Percent Absent'),
//           const Divider(
//             indent: 5,
//             thickness: 3,
//             color: Colors.black12,
//           ),
//           SfDateRangePicker(
//             showTodayButton: true,
//             minDate: DateTime.now().subtract(const Duration(days: 31)),
//             maxDate: DateTime.now(),
//             backgroundColor: Colors.blue[100],
//             todayHighlightColor: Colors.green,
//             selectionColor: Colors.orangeAccent,
//             headerStyle: DateRangePickerHeaderStyle(
//               backgroundColor: Colors.blue[200],
//             ),
//             onSelectionChanged: onSelectionChanged,
//             selectionMode: DateRangePickerSelectionMode.single,
//             initialSelectedDate: DateTime.now(),
//           ),
//           const Divider(
//             indent: 5,
//             thickness: 3,
//             color: Colors.black12,
//           ),
//           TextButton.icon(
//             onPressed: () async {
//               // gValue.attLogs =
//               // gValue.realmService.getAttLogByRangeDate(timeBegin, timeEnd);
//               var reports =
//                   MyFuntion.createAttGeneralReport(timeBegin, gValue.attLogs);
//               // gValue.realmService.addAttReport([reports]);
//               setState(() {});
//             },
//             icon: const Icon(
//               Icons.refresh,
//               color: Colors.green,
//             ),
//             label: const Text('Refresh report'),
//           ),
//           TextButton.icon(
//             onPressed: () {
//               MyFile.createExcelAttReport(gValue.attReports);
//             },
//             icon: const Icon(
//               Icons.download,
//               color: Colors.blue,
//             ),
//             label: const Text('Download report'),
//           ),
//           TextButton.icon(
//             onPressed: () {
//               // gValue.attLogs =
//               //     gValue.realmService.getAttLogByRangeDate(timeBegin, timeEnd);

//               // MyFile.createExcelEmployeeBasic(
//               //     MyFuntion.getListEmployeeAbsent(
//               //         gValue.employeeBasics, gValue.attLogs),
//               //     'Working',
//               //     'Employees absent ');
//             },
//             icon: const Icon(
//               Icons.download,
//               color: Colors.orange,
//             ),
//             label: const Text('Download absent list'),
//           ),
//           TextButton.icon(
//             onPressed: () {
//               setState(() {});
//             },
//             icon: const Icon(
//               Icons.timelapse,
//               color: Colors.teal,
//             ),
//             label: const Text('Download timesheet'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> onSelectionChanged(
//       DateRangePickerSelectionChangedArgs args) async {
//     setState(() {
//       if (args.value is DateTime) {
//         timeBegin = args.value;
//       }
//     });
//     timeBegin = timeBegin.appliedFromTimeOfDay(const TimeOfDay(
//       hour: 0,
//       minute: 0,
//     ));
//     timeEnd = timeBegin.appliedFromTimeOfDay(const TimeOfDay(
//       hour: 23,
//       minute: 59,
//     ));
//     gValue.logger.t('onSelectionChanged : timeBegin : $timeBegin');
//     gValue.logger.t('onSelectionChanged : timeEnd : $timeEnd');
//   }
// }
