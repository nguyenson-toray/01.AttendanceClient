import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tiqn/database/leaveRegister.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/main.dart';
import 'package:tiqn/tools/myFunction.dart';
import 'package:tiqn/tools/myfile.dart';
import 'package:toastification/toastification.dart';

class LeaveRegisterUI extends StatefulWidget {
  const LeaveRegisterUI({super.key});

  @override
  State<LeaveRegisterUI> createState() => _LeaveRegisterUIState();
}

class _LeaveRegisterUIState extends State<LeaveRegisterUI>
    with AutomaticKeepAliveClientMixin {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridMode plutoGridMode = PlutoGridMode.normal;
  late PlutoGridStateManager stateManager;
  bool firstBuild = true;
  String newOrEdit = '';
  int rowIdChanged = 0, colIdChange = 0, countLeave = 0;
  Map<String, dynamic> rowChangedJson = {};
  late DateTime timeBegin;
  late DateTime timeEnd;
  bool isDataChanged = false, filterByDate = false, refreshDataCancel = false;
  @override
  void initState() {
    // TODO: implement initState
    columns = getColumns();
    rows = getRows(gValue.leaveRegisters);
    Timer.periodic(const Duration(seconds: 3), (_) => refreshData());
    timeBegin = DateTime.now()
        .subtract(const Duration(days: 7))
        .appliedFromTimeOfDay(const TimeOfDay(
          hour: 0,
          minute: 0,
        ));
    timeEnd = timeBegin
        .add(const Duration(days: 31))
        .appliedFromTimeOfDay(const TimeOfDay(
          hour: 23,
          minute: 59,
        ));
    super.initState();
  }

  bool checkDiff(List<LeaveRegister> oldList, List<LeaveRegister> newList) {
    bool diff = false;
    if (newList.isEmpty) {
      if (isDataChanged) {
        toastification.show(
          backgroundColor: Colors.orange,
          alignment: Alignment.center,
          context: context,
          title: Text(
              'No data from ${DateFormat("dd-MMM-yyyy").format(timeBegin)} to  ${DateFormat("dd-MMM-yyyy").format(timeEnd)} !!!'),
          autoCloseDuration: const Duration(seconds: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x07000000),
              blurRadius: 16,
              offset: Offset(0, 16),
              spreadRadius: 0,
            )
          ],
        );
      }
      isDataChanged = false;
      return false;
    } else if (oldList.length != newList.length) {
      print('checkDiff OtRegister : TRUE : Diff length');
      diff = true;
      isDataChanged = true;
    } else {
      for (int i = 0; i < oldList.length; i++) {
        if (oldList[i] != newList[i]) {
          isDataChanged = true;
          diff = true;
          print('checkDiff OtRegister: TRUE : Diff element');
          break;
        }
      }
    }
    return diff;
  }

  Future<void> refreshData() async {
    if (refreshDataCancel) {
      print('refreshData- refreshDataCancel = true');
      return;
    }
    List<LeaveRegister> newList = [];
    if (filterByDate) {
      newList =
          await gValue.mongoDb.getLeaveRegisterByRangeDate(timeBegin, timeEnd);
    } else {
      newList = await gValue.mongoDb.getLeaveRegister();
    }
    if (checkDiff(gValue.leaveRegisters, newList) && mounted) {
      print(
          'LeaveRegisterUI Data changed : ${gValue.leaveRegisters.length} => ${newList.length} records');
      gValue.leaveRegisters = newList;
      setState(() {
        if ((!firstBuild)) {
          var rows = getRows(gValue.leaveRegisters);
          stateManager.removeRows(stateManager.rows);
          stateManager.appendRows(rows);
          countLeave = gValue.leaveRegisters
              .map((e) => e.empId)
              .toList()
              .toSet()
              .toList()
              .length;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue[50],
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Filter by date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Checkbox(
                      value: filterByDate,
                      onChanged: (value) {
                        setState(() {
                          filterByDate = value!;
                        });
                        refreshData();
                      },
                    )
                  ],
                ),
                Visibility(
                  visible: filterByDate,
                  child: SizedBox(
                    height: 230,
                    width: 500,
                    child: SfDateRangePicker(
                      enableMultiView: true,
                      // monthViewSettings: DateRangePickerMonthViewSettings(
                      //     showWeekNumber: false, firstDayOfWeek: 1, weekendDays: [7]),
                      view: DateRangePickerView.month,
                      showTodayButton: true,
                      // minDate: DateTime.now().subtract(Duration(days: 31)),
                      maxDate: DateTime.now().add(const Duration(days: 31)),
                      backgroundColor: Colors.blue[100],
                      todayHighlightColor: Colors.green,
                      selectionColor: Colors.orangeAccent,
                      headerStyle: DateRangePickerHeaderStyle(
                        backgroundColor: Colors.blue[200],
                      ),
                      onSelectionChanged: onSelectionChangedDate,
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(timeBegin, timeEnd),
                    ),
                  ),
                ),
                const Divider(),
                Text('Total records: ${gValue.leaveRegisters.length}'),
                Text('Total employees: $countLeave'),
                const Divider(),
                TextButton.icon(
                  onPressed: () {
                    MyFile.createExcelLeaveRegisters([
                      LeaveRegister(
                          no: 1,
                          name: 'Lê Văn A',
                          empId: 'TIQN-9999',
                          fromDate: DateTime.now().appliedFromTimeOfDay(
                              TimeOfDay(hour: 0, minute: 0)),
                          fromTime: '08:00',
                          toDate: DateTime.now().appliedFromTimeOfDay(
                              TimeOfDay(hour: 0, minute: 0)),
                          toTime: '17:00',
                          type: 'Phép năm',
                          note: '')
                    ], 'Import Leave Registers ${DateFormat('dd-MMM-yyyy hhmm').format(DateTime.now())}');
                  },
                  icon: const Icon(
                    Icons.star,
                    color: Colors.green,
                  ),
                  label: const Text('Excel template for import data'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    if (gValue.accessMode != 'edit') {
                      toastification.show(
                        showProgressBar: true,
                        backgroundColor: Colors.amber[200],
                        alignment: Alignment.center,
                        context: context,
                        title:
                            Text('Bạn không có quyền sử dụng chức năng này !'),
                        autoCloseDuration: Duration(seconds: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 16),
                            spreadRadius: 0,
                          )
                        ],
                      );
                      return;
                    }
                    gValue.mongoDb.insertLeaveRegister(
                        await MyFile.readExcelLeaveRegister());
                    List<Text> logs = [];
                    for (var log in gValue.logs) {
                      MyFuntion.insertHistory('IMPORT leave register: $log');
                      logs.add(Text(
                        log,
                        style: TextStyle(
                            color: log.contains("ERROR")
                                ? Colors.red
                                : Colors.black),
                      ));
                    }
                    if (gValue.logs.isNotEmpty) {
                      AwesomeDialog(
                              context: context,
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: logs,
                              ),
                              width: 800,
                              dialogType:
                                  gValue.logs.toString().contains("ERROR")
                                      ? DialogType.warning
                                      : DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Import OT Result',
                              desc: gValue.logs.toString(),
                              enableEnterKey: true,
                              showCloseIcon: true,
                              closeIcon: const Icon(Icons.close))
                          .show();
                    }
                  },
                  icon: const Icon(
                    Icons.upload,
                    color: Colors.orangeAccent,
                  ),
                  label: const Text('Import from excel'),
                ),
                TextButton.icon(
                  onPressed: () {
                    MyFile.createExcelLeaveRegisters(gValue.leaveRegisters,
                        'Leave Registers ${DateFormat('dd-MMM-yyyy hhmmss').format(DateTime.now())}');
                  },
                  icon: const Icon(
                    Icons.download,
                    color: Colors.blueAccent,
                  ),
                  label: const Text('Export all to excel'),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            color: Colors.transparent,
            width: 8,
          ),
          Expanded(
            child: PlutoGrid(
              mode: PlutoGridMode.normal,
              configuration: const PlutoGridConfiguration(
                enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
                scrollbar: PlutoGridScrollbarConfig(
                  scrollbarThickness: 8,
                  scrollbarThicknessWhileDragging: 20,
                  isAlwaysShown: true,
                ),
                style: PlutoGridStyleConfig(
                  rowColor: Colors.white,
                  enableGridBorderShadow: true,
                ),
                columnFilter: PlutoGridColumnFilterConfig(),
              ),
              columns: columns,
              rows: rows,
              onChanged: (event) {
                print('onChanged : $event');

                setState(() {
                  if (newOrEdit == '') newOrEdit = 'edit';
                  rowIdChanged = event.rowIdx;
                  colIdChange = event.columnIdx;
                  rowChangedJson = stateManager.currentRow!.toJson();
                  print(
                      '=>>> rowIdChanged: $rowIdChanged     colIdChange: $colIdChange  rowChangedJson: $rowChangedJson ');

                  if (colIdChange == 2) {
                    var empId =
                        rowChangedJson['empId'].split('   ')[0]; // 3 spaces
                    stateManager.currentRow?.cells['empId']?.value = empId;
                    var name = rowChangedJson['empId'].split('   ')[1];
                    stateManager.currentRow?.cells['name']?.value = name;
                  }
                });
              },
              onLoaded: (PlutoGridOnLoadedEvent event) {
                print('onLoaded');
                firstBuild = false;
                stateManager = event.stateManager;
                stateManager.setShowColumnFilter(true);
              },
              rowColorCallback: (rowColorContext) {
                if (rowColorContext.row.cells.entries
                    .elementAt(3)
                    .value
                    .value
                    .toString()
                    .contains('16:00')) {
                  return const Color.fromARGB(255, 164, 201, 245);
                }
                return Colors.white;
              },
            ),
          ),
        ],
      ),
    );
  }

  List<PlutoColumn> getColumns() {
    List<PlutoColumn> columns = [];
    columns = [
      PlutoColumn(
          enableEditingMode: false,
          title: 'Leave #',
          field: 'no',
          width: 160,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outlined,
                  ),
                  onPressed: () {
                    if (gValue.accessMode != 'edit') {
                      toastification.show(
                        showProgressBar: true,
                        backgroundColor: Colors.amber[200],
                        alignment: Alignment.center,
                        context: context,
                        title:
                            Text('Bạn không có quyền sử dụng chức năng này !'),
                        autoCloseDuration: Duration(seconds: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 16),
                            spreadRadius: 0,
                          )
                        ],
                      );
                      return;
                    }
                    refreshDataCancel = true;
                    var row = rendererContext.row.toJson();
                    print(row);
                    var style = const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold);
                    int no = row['no'];
                    String empId = row['empId'];
                    String name = row['name'];
                    String fromDate = row['fromDate'];
                    String fromTime = row['fromTime'].toString();
                    String toDate = row['toDate'];
                    String toTime = row['toTime'].toString();
                    String type = row['type'];
                    AwesomeDialog(
                            context: context,
                            body: Text(
                              'Delete: no#: ${no}      $type\n$empId    $name\nFrom: $fromDate $fromTime to: $toDate  $toTime',
                              style: style,
                            ),
                            width: 800,
                            dialogType: DialogType.question,
                            animType: AnimType.rightSlide,
                            // title: 'Import Employee Result',
                            enableEnterKey: true,
                            showCloseIcon: true,
                            btnOkOnPress: () async {
                              setState(() {
                                rendererContext.stateManager
                                    .removeRows([rendererContext.row]);
                              });
                              await gValue.mongoDb
                                  .deleteOneLeaveRegister(no.toString());
                              await MyFuntion.insertHistory(
                                  'DELETE leave register: ${no} Name: $empId-$name  $type   From: $fromDate $fromTime to: $toDate  $toTime');
                              refreshDataCancel = false;
                            },
                            closeIcon: const Icon(Icons.close))
                        .show();
                  },
                  iconSize: 18,
                  color: Colors.red,
                  padding: const EdgeInsets.all(0),
                ),
                Expanded(
                  child: Text(
                    rendererContext
                        .row.cells[rendererContext.column.field]!.value
                        .toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            );
          }),
      PlutoColumn(
        enableEditingMode: false,
        title: 'Employee ID',
        field: 'empId',
        width: 120,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'Name',
        field: 'name',
        width: 170,
        type: PlutoColumnType.text(),
      ),
      // PlutoColumn(
      //   enableEditingMode: false,
      //   title: 'Section',
      //   field: 'section',
      //   width: 120,
      //   type: PlutoColumnType.text(),
      // ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'From date',
        field: 'fromDate',
        width: 120,
        type: PlutoColumnType.date(
          format: "dd-MMM-yyyy",
        ),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'Time',
        field: 'fromTime',
        width: 80,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'To date',
        field: 'toDate',
        width: 120,
        type: PlutoColumnType.date(
          format: "dd-MMM-yyyy",
        ),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'Time',
        field: 'toTime',
        width: 80,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'Type',
        field: 'type',
        width: 150,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'Note',
        field: 'note',
        width: 200,
        type: PlutoColumnType.text(),
      ),
    ];
    return columns;
  }

  List<PlutoRow> getRows(List<LeaveRegister> data) {
    List<PlutoRow> rows = [];
    for (var element in data) {
      rows.add(
        PlutoRow(
          cells: {
            'no': PlutoCell(value: element.no),
            'empId': PlutoCell(value: element.empId),
            'name': PlutoCell(value: element.name),
            // 'section': PlutoCell(value: element.section),
            'fromDate': PlutoCell(value: element.fromDate),
            'fromTime': PlutoCell(value: element.fromTime),
            'toDate': PlutoCell(value: element.toDate),
            'toTime': PlutoCell(value: element.toTime),
            'note': PlutoCell(value: element.note),
            'type': PlutoCell(value: element.type),
          },
        ),
      );
    }
    return rows;
  }

  void onSelectionChangedDate(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        timeBegin = args.value.startDate;
        timeEnd = args.value.endDate ?? args.value.startDate;
      } else if (args.value is DateTime) {
        timeBegin = args.value;
        timeEnd = args.value;
      }
      timeBegin = timeBegin.appliedFromTimeOfDay(const TimeOfDay(
        hour: 0,
        minute: 0,
      ));
      timeEnd = timeEnd.appliedFromTimeOfDay(const TimeOfDay(
        hour: 23,
        minute: 59,
      ));
      isDataChanged = true;
      stateManager.resetCurrentState();
      stateManager.filterRows.clear();
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
