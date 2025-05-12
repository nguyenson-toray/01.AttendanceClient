import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/gValue.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tiqn/tools/myFunction.dart';
import 'package:tiqn/tools/myfile.dart';
import 'package:toastification/toastification.dart';

class EmployeeUI extends StatefulWidget {
  const EmployeeUI({super.key});
  @override
  State<EmployeeUI> createState() => _EmployeeUIState();
}

class _EmployeeUIState extends State<EmployeeUI>
    with AutomaticKeepAliveClientMixin {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  int total = 0, resigned = 0, maternity = 0, working = 0;
  late Employee newEmp; //= EmployeeBasic(ObjectId());
  bool enableEdit = false;
  bool firstBuild = true;
  String tempDept = '', tempSection = '', temp = '';
  PlutoGridMode plutoGridMode = PlutoGridMode.normal;
  late PlutoGridStateManager stateManager;
  bool pauseLoadData = false;
  bool showResigned = false;
  late DateTime lastUpdate;

  @override
  void initState() {
    // TODO: implement initState
    print('initState EmployeeUI ');
    lastUpdate = DateTime.now();
    Future.delayed(Durations.long2).then((value) =>
        Timer.periodic(const Duration(minutes: 30), (_) => refreshData()));

    columns = getColumns();
    rows = getRows(gValue.employees, showResigned);
    super.initState();
  }

  Future<void> refreshData() async {
    await gValue.mongoDb.getConfig();
    if (!pauseLoadData) {
      final newList = await gValue.mongoDb.getEmployees();
      if (checkDiff(gValue.employees, newList)) {
        setState(() {
          if (!firstBuild) {
            gValue.employees = newList;
            stateManager.removeRows(stateManager.rows);
            rows = getRows(gValue.employees, showResigned);
            stateManager.appendRows(rows);
            MyFuntion.calculateEmployeeStatus();
          }
        });
      }
      setState(() {
        lastUpdate = DateTime.now();
      });
      toastification.show(
        backgroundColor: Colors.greenAccent,
        alignment: Alignment.center,
        context: context,
        title: const Text('Data loaded !'),
        autoCloseDuration: const Duration(seconds: 2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(6, 93, 250, 87),
            blurRadius: 16,
            offset: Offset(0, 16),
            spreadRadius: 0,
          )
        ],
      );
    }
  }

  bool checkDiff(List<Employee> oldList, List<Employee> newList) {
    bool diff = false;
    if (newList.isEmpty) {
      return false;
    } else if (oldList.length != newList.length) {
      print('checkDiff Employees: TRUE : Diff length');
      diff = true;
    } else {
      for (int i = 0; i < oldList.length; i++) {
        if (oldList[i] != newList[i]) {
          diff = true;
          print('checkDiff Employees : TRUE : Diff element');
          break;
        }
      }
    }

    return diff;
  }
  // Stream<List<Employee>> getEmployees() async* {
  //   final url = Uri.parse('${gValue.flaskServer}/employees');
  //   // while (true) {
  //   await Future.delayed(Duration(seconds: 1));
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body) as List<dynamic>;
  //     yield data.map((post) => Employee.fromMap(post)).toList();
  //   } else {
  //     // Handle error
  //     throw Exception('Failed to load Employee');
  //     // }
  //   }
  // }

  changeGridMode() {
    if (enableEdit) {
      plutoGridMode = PlutoGridMode.normal;
    } else {
      plutoGridMode = PlutoGridMode.readOnly;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !gValue.disableEditEmp
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text("Import / Export"),
                        popupMenuImportExport(),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Edit mode"),
                        Switch(
                          value: enableEdit,
                          onChanged: (value) {
                            setState(() {
                              setState(() {
                                enableEdit = !enableEdit;
                                // changeGridMode();
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    // chartWorkingMaternity(),
                  ],
                )
              : Column(
                  children: [
                    popupMenuImportExport(),
                    RotatedBox(
                        quarterTurns: 45,
                        child: Text('Last update at $lastUpdate')),
                  ],
                ),
          Expanded(
            child: PlutoGrid(
              mode: plutoGridMode,
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
              onChanged: (PlutoGridOnChangedEvent event) {
                print('onChanged  :$event');
              },
              onRowDoubleTap: (event) {
                print('onRowDoubleTap');
              },
              onLoaded: (PlutoGridOnLoadedEvent event) {
                print('onLoaded : rows.length: ${rows.length}');
                firstBuild = false;
                stateManager = event.stateManager;
                stateManager.setShowColumnFilter(true);

                // context.read<EmployeeSummary>().summaryAll(results);
              },
              onSelected: (event) {
                print('onSelected  :$event');
              },
              onSorted: (event) {
                print('onSorted  :$event');
              },
              rowColorCallback: (rowColorContext) {
                if (rowColorContext.row.cells.entries
                    .elementAt(14)
                    .value
                    .value
                    .toString()
                    .contains('Resigned')) {
                  return Colors.black12;
                } else if (rowColorContext.row.cells.entries
                    .elementAt(14)
                    .value
                    .value
                    .toString()
                    .contains('leave')) {
                  return const Color.fromARGB(255, 249, 231, 237);
                }

                return Colors.white;
              },
            ),
          )
        ],
      ),
    ));
  }

  List<PlutoColumn> getColumns() {
    List<PlutoColumn> columns;
    columns = [
      PlutoColumn(
        title: 'Employee ID',
        field: 'empId',
        frozen: PlutoColumnFrozen.start,
        type:
            PlutoColumnType.text(defaultValue: "TIQN-${gValue.lastEmpId + 1}"),
        width: 150,
        minWidth: 150,
        renderer: (rendererContext) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              enableEdit
                  ? Row(
                      children: [
                        // IconButton(
                        //     icon: const Icon(
                        //       Icons.add_circle,
                        //     ),
                        //     onPressed: () {
                        //       rendererContext.stateManager.insertRows(
                        //         rendererContext.rowIdx,
                        //         [rendererContext.stateManager.getNewRow()],
                        //       );
                        //     },
                        //     iconSize: 18,
                        //     color: Colors.green,
                        //     padding: const EdgeInsets.all(0)),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outlined,
                          ),
                          onPressed: () {
                            var row = rendererContext.row.toJson();

                            AwesomeDialog(
                                    context: context,
                                    body: Column(
                                      children: [
                                        Text('Delete: ${row['name']}',
                                            style: const TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Text('Employee ID:  ${row['empId']}'),
                                        Text(
                                            'Finger ID:  ${row['attFingerId']}'),
                                        Text('Position: ${row['positionE']}'),
                                        Text('Section: ${row['section']}'),
                                      ],
                                    ),
                                    width: 800,
                                    dialogType: DialogType.question,
                                    animType: AnimType.rightSlide,
                                    title: 'Import Employee Result',
                                    enableEnterKey: true,
                                    showCloseIcon: true,
                                    btnOkOnPress: () {
                                      gValue.mongoDb
                                          .removeEmployee(row['empId']);
                                      rendererContext.stateManager
                                          .removeRows([rendererContext.row]);
                                    },
                                    closeIcon: const Icon(Icons.close))
                                .show();
                          },
                          iconSize: 18,
                          color: Colors.red,
                          padding: const EdgeInsets.all(0),
                        ),
                      ],
                    )
                  : const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
              Expanded(
                child: Text(
                  rendererContext.row.cells[rendererContext.column.field]!.value
                      .toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
      PlutoColumn(
        title: 'Finger',
        field: 'attFingerId',
        frozen: PlutoColumnFrozen.start,
        width: 60,
        type: PlutoColumnType.number(
            format: '#.###', defaultValue: gValue.lastFingerId + 1),
      ),
      PlutoColumn(
          title: 'Name',
          field: 'name',
          frozen: PlutoColumnFrozen.start,
          type: PlutoColumnType.text(),
          minWidth: 220),
      // PlutoColumn(
      //     title: 'Shift',
      //     field: 'shift',
      //     frozen: PlutoColumnFrozen.start,
      //     type: PlutoColumnType.select(
      //         defaultValue: 'Day shift', ['Day shift', 'Shift 1']),
      //     width: 90),
      PlutoColumn(
        hide: gValue.miniInfoEmployee,
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.select(gValue.departments,
            defaultValue: gValue.departments[1]),
      ),
      PlutoColumn(
          title: 'Section', field: 'section', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Group',
        field: 'group',
        type: PlutoColumnType.text(),
        // hide: gValue.miniInfoEmployee,
      ),
      // PlutoColumn(
      //     title: 'Line Team', field: 'lineTeam', type: PlutoColumnType.text()),
      PlutoColumn(
          hide: gValue.miniInfoEmployee,
          title: 'Gender',
          field: 'gender',
          width: 90,
          type: PlutoColumnType.select(
              defaultValue: 'Female', ['Male', 'Female'])),
      PlutoColumn(
        title: 'Position',
        field: 'position',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          hide: gValue.miniInfoEmployee,
          title: 'Level',
          field: 'level',
          type: PlutoColumnType.text(),
          width: 70),
      PlutoColumn(
        title: 'Direct Indirect',
        field: 'directIndirect',
        width: 140,
        type: PlutoColumnType.select(["Direct", "Indirect", "Management"],
            defaultValue: 'Direct'),
      ),
      PlutoColumn(
          title: 'Sewing NonSewing',
          field: 'sewingNonSewing',
          width: 140,
          type: PlutoColumnType.select(["Sewing", "Non sewing", "Management"],
              defaultValue: "Sewing")),
      PlutoColumn(
        hide: gValue.miniInfoEmployee,
        title: 'Supporting',
        field: 'supporting',
        width: 90,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        hide: gValue.miniInfoEmployee,
        title: 'DOB',
        field: 'dob',
        width: 120,
        type: PlutoColumnType.date(format: "dd-MMM-yyyy"),
      ),
      PlutoColumn(
        title: 'Work Status',
        field: 'workStatus',
        width: 150,
        type: PlutoColumnType.text(),
      ),

      PlutoColumn(
        // hide: gValue.miniInfoEmployee,
        title: 'Joining Date',
        field: 'joiningDate',
        width: 120,
        type: PlutoColumnType.date(format: "dd-MMM-yyyy"),
      ),
      PlutoColumn(
        // hide: gValue.miniInfoEmployee,
        title: 'Resign On',
        field: 'resignOn',
        width: 120,
        type: PlutoColumnType.date(format: "dd-MMM-yyyy"),
      ),
    ];
    return columns;
  }

  List<PlutoRow> getRows(List<Employee> data, bool showResigned) {
    List<PlutoRow> rows = [];
    int all = 0;
    total = 0;
    working = 0;
    maternity = 0;
    resigned = 0;
    gValue.lastFingerId = 0;
    gValue.lastEmpId = 0;
    if (!showResigned) {
      data = data.where((element) => element.workStatus != 'Resigned').toList();
    }
    for (var employee in data) {
      final finger = employee.attFingerId;
      // final id = int.tryParse(employee.empId.toString().split('TIQN-')[1])!;
      // if (finger! > gValue.lastFingerId) {
      //   gValue.lastFingerId = finger;
      // }
      // if (id > gValue.lastEmpId) {
      //   gValue.lastEmpId = id;
      // }

      all++;
      if (employee.workStatus == 'Working') {
        working++;
      } else if (employee.workStatus == 'Maternity')
        maternity++;
      else if (employee.workStatus == 'Resigned') resigned++;

      rows.add(
        PlutoRow(
          cells: {
            'empId': PlutoCell(value: employee.empId),
            'attFingerId': PlutoCell(value: employee.attFingerId),
            'name': PlutoCell(value: employee.name),
            // 'shift': PlutoCell(value: employee.shift),
            'department': PlutoCell(value: employee.department),
            'section': PlutoCell(value: employee.section),
            'group': PlutoCell(value: employee.group),
            'lineTeam': PlutoCell(value: employee.lineTeam),
            'gender': PlutoCell(value: employee.gender),
            'position': PlutoCell(value: employee.positionE),
            'level': PlutoCell(value: employee.level),
            'directIndirect': PlutoCell(value: employee.directIndirect),
            'sewingNonSewing': PlutoCell(value: employee.sewingNonSewing),
            'supporting': PlutoCell(value: employee.supporting),
            'dob': PlutoCell(value: employee.dob),
            'workStatus': PlutoCell(
              value: employee.workStatus,
            ),

            'joiningDate': PlutoCell(value: employee.joiningDate),
            'resignOn': PlutoCell(
                value:
                    employee.resignOn?.year == 2099 ? '' : employee.resignOn),
          },
        ),
      );
    }
    // print(' getRows(List<Employee>) => length : ${rows.length}');
    return rows;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  editWidget() {
    return Row(
      children: [
        Switch(
          value: enableEdit,
          onChanged: (bool value) {
            setState(() {
              pauseLoadData = value;
              enableEdit = !enableEdit;
              plutoGridMode = PlutoGridMode.normal;
            });
          },
        ),
        const Text('Edit'),
        enableEdit
            ? Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        stateManager.scroll.vertical?.resetScroll();
                        stateManager.prependNewRows();
                      });
                    },
                    icon: const Icon(Icons.add, color: Colors.greenAccent),
                    label: const Text('Add'),
                  ),
                  const Divider(
                    indent: 5,
                    thickness: 3,
                    color: Colors.white,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        enableEdit = !enableEdit;
                      });
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.blue,
                    ),
                    label: const Text('Save'),
                  ),
                ],
              )
            : Container()
      ],
    );
  }

  // chartWorkingMaternity() {
  //   final List<DonutChartEmployee> chartData = [
  //     DonutChartEmployee('Working',
  //         context.watch<EmployeeSummary>().getWorking.toDouble(), Colors.blue),
  //     DonutChartEmployee(
  //         'Maternity',
  //         context.watch<EmployeeSummary>().getMaternity.toDouble(),
  //         Colors.purple),
  //   ];
  //   return SizedBox(
  //     width: 220,
  //     height: 200,
  //     child: SfCircularChart(
  //         annotations: <CircularChartAnnotation>[
  //           CircularChartAnnotation(
  //               widget: Container(
  //                   child: Text(
  //                       'Total\n${context.watch<EmployeeSummary>().getTotal - context.watch<EmployeeSummary>().getResigned}',
  //                       style: const TextStyle(
  //                           color: Colors.black, fontWeight: FontWeight.bold))))
  //         ],
  //         tooltipBehavior: TooltipBehavior(enable: true),
  //         legend: const Legend(
  //           position: LegendPosition.bottom,
  //           isVisible: true,
  //         ),
  //         series: <CircularSeries<DonutChartEmployee, String>>[
  //           DoughnutSeries<DonutChartEmployee, String>(
  //             dataLabelSettings: const DataLabelSettings(isVisible: true),
  //             dataSource: chartData,
  //             xValueMapper: (DonutChartEmployee data, _) => data.x,
  //             yValueMapper: (DonutChartEmployee data, _) => data.y,
  //             pointColorMapper: (DonutChartEmployee data, _) => data.color,
  //           )
  //         ]),
  //   );
  // }

  popupMenuImportExport() {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case 'refresh':
            {
              refreshData();
            }
            break;
          case 'showResigned':
            {
              showResigned = !showResigned;
              setState(() {
                stateManager.removeRows(stateManager.rows);
                rows = getRows(gValue.employees, showResigned);
                stateManager.appendRows(rows);
              });
            }
            break;
          case 'Import':
            // gValue.mongoDb
            //     .insertManyEmployees(await MyFile.readExcelEmployee());
            List<Text> logs = [];
            for (var log in gValue.logs) {
              logs.add(Text(
                log,
                style: TextStyle(
                    color: log.contains("ERROR") ? Colors.red : Colors.black),
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
                      dialogType: gValue.logs.toString().contains("ERROR")
                          ? DialogType.warning
                          : DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'Import Employee Result',
                      desc: gValue.logs.toString(),
                      enableEnterKey: true,
                      showCloseIcon: true,
                      closeIcon: const Icon(Icons.close))
                  .show();
            }
            break;
          case 'Import':
            break;
          case 'all':
            MyFile.createExcelEmployee(
                gValue.employees, false, "All Employees");
            break;
          case 'working':
            MyFile.createExcelEmployee(
                gValue.employees
                    .where((element) =>
                        (element.workStatus.toString().contains('Working')))
                    .toList(),
                false,
                "Working Employees");
            break;
          case 'maternity leave':
            MyFile.createExcelEmployee(
                gValue.employees
                    .where((element) =>
                        (element.workStatus.toString().contains('leave')))
                    .toList(),
                false,
                "Maternity Employees");
            break;
          case 'pregnantYoungChild':
            MyFile.createExcelEmployee(
                gValue.employees
                    .where((element) =>
                        (element.workStatus.toString().contains('pregnant') ||
                            element.workStatus.toString().contains('child')))
                    .toList(),
                false,
                "Pregnant - young child");
            break;

          default:
        }
      },
      itemBuilder: (BuildContext bc) {
        return [
          const PopupMenuItem(
            value: 'refresh',
            child: Row(
              children: [
                Icon(
                  Icons.refresh,
                  color: Colors.green,
                ),
                Text("Refresh Data"),
              ],
            ),
          ),
          PopupMenuItem(
              value: 'showResigned',
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: showResigned ? Colors.red : Colors.green,
                  ),
                  Text(showResigned
                      ? 'HIDE resigned employees'
                      : 'SHOW resigned employees'),
                ],
              )),
          const PopupMenuItem(
            value: 'all',
            child: Row(
              children: [
                Icon(
                  Icons.download,
                  color: Colors.blue,
                ),
                Text("Export all"),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'working',
            child: Row(
              children: [
                Icon(
                  Icons.download,
                  color: Colors.teal,
                ),
                Text("Export working"),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'maternity leave',
            child: Row(
              children: [
                Icon(
                  Icons.download,
                  color: Colors.pinkAccent,
                ),
                Text("Export maternity leave"),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'pregnantYoungChild',
            child: Row(
              children: [
                Icon(
                  Icons.download,
                  color: Colors.purple,
                ),
                Text("Export pregnant, young child"),
              ],
            ),
          ),
        ];
      },
    );
  }
}
