import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tiqn/database/shift.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/tools/myFunction.dart';
import 'package:tiqn/tools/myfile.dart';

class ShiftRegisterUI extends StatefulWidget {
  const ShiftRegisterUI({super.key});

  @override
  State<ShiftRegisterUI> createState() => _ShiftRegisterUIState();
}

class _ShiftRegisterUIState extends State<ShiftRegisterUI>
    with AutomaticKeepAliveClientMixin {
  List<PlutoColumn> columns = [], columnsShift = [];
  List<PlutoRow> rows = [], rowsShift = [];
  PlutoGridMode plutoGridMode = PlutoGridMode.normal;
  late PlutoGridStateManager stateManager;
  bool firstBuild = true;
  String newOrEdit = '';
  int rowIdChanged = 0, colIdChange = 0;
  Map<String, dynamic> rowChangedJson = {};
  @override
  void initState() {
    // TODO: implement initState
    columns = getColumns();
    rows = getRows(gValue.shiftRegisters);
    columnsShift = getColumnsShift();
    Timer.periodic(const Duration(seconds: 1), (_) => refreshData());
    super.initState();
  }

  bool checkDiff(List<ShiftRegister> oldList, List<ShiftRegister> newList) {
    bool diff = false;
    if (newList.isEmpty) return false;
    if (oldList.length != newList.length) {
      print('checkDiff ShiftRegister : TRUE : Diff length');
      diff = true;
    } else {
      for (int i = 0; i < oldList.length; i++) {
        if (oldList[i] != newList[i]) {
          diff = true;
          print('checkDiff ShiftRegister: TRUE : Diff element');
          break;
        }
      }
    }
    return diff;
  }

  Future<void> getShift() async {
    gValue.shifts = await gValue.mongoDb.getShifts();
  }

  Future<void> refreshData() async {
    List<ShiftRegister> newList = await gValue.mongoDb.getShiftRegister();
    if (checkDiff(gValue.shiftRegisters, newList)) {
      print(
          'ShistRegisterUI Data changed : ${gValue.shiftRegisters.length} => ${newList.length} records');
      gValue.shiftRegisters = newList;
      setState(() {
        if ((!firstBuild)) {
          var rows = getRows(gValue.shiftRegisters);
          stateManager.removeRows(stateManager.rows);
          stateManager.appendRows(rows);
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
            color: Colors.blue[50],
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 210,
                  height: 300,
                  child: ListView.builder(
                    itemCount: gValue.shifts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            gValue.shifts[index].shift,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              '${gValue.shifts[index].begin} - ${gValue.shifts[index].end}'));
                    },
                  ),
                ),
                const Divider(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      newOrEdit = 'new';
                      rowIdChanged = 0;
                      stateManager.scroll.vertical?.resetScroll();
                      stateManager.prependNewRows();
                    });
                  },
                  icon: const Icon(
                    Icons.add_box,
                    color: Colors.greenAccent,
                  ),
                  label: const Text('Add one record'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    gValue.mongoDb.insertShiftRegisters(
                        await MyFile.readExcelShiftRegister());
                    List<Text> logs = [];
                    for (var log in gValue.logs) {
                      MyFuntion.insertHistory('Import Shift: $log');
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
                              title: 'Import Shifts Result',
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
                    MyFile.createExcelShiftRegisters(gValue.shiftRegisters,
                        'Shift Registers ${DateFormat('dd-MMM-yyyy hhmmss').format(DateTime.now())}');
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
            width: 8,
            color: Colors.transparent,
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
              onSelected: (event) {
                print('onSelected $event');
              },
              onRowChecked: (event) {
                print('onRowChecked $event');
              },
              onLoaded: (PlutoGridOnLoadedEvent event) {
                print('onLoaded');
                firstBuild = false;
                stateManager = event.stateManager;
                stateManager.setShowColumnFilter(true);
              },
              rowColorCallback: (rowColorContext) {
                if (rowColorContext.row.cells.entries
                        .elementAt(4)
                        .value
                        .value ==
                    'Shift 1') {
                  return Color.fromARGB(255, 179, 216, 235);
                } else if (rowColorContext.row.cells.entries
                        .elementAt(4)
                        .value
                        .value ==
                    'Shift 2') {
                  return Color.fromARGB(255, 169, 189, 245);
                } else
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
          width: 200,
          title: 'From',
          field: 'fromDate',
          type: PlutoColumnType.date(
              format: "dd-MMM-yyyy", defaultValue: DateTime.now()),
          renderer: (rendererContext) {
            return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outlined,
                ),
                onPressed: () {
                  var row = rendererContext.row.toJson();
                  print(row);
                  var style = const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold);
                  setState(() {
                    newOrEdit = '';
                  });
                  if (row['objectId'].toString().isEmpty ||
                      row['objectId'] == null) {
                    rendererContext.stateManager
                        .removeRows([rendererContext.row]);
                  } else {
                    AwesomeDialog(
                            context: context,
                            body: Column(
                              children: [
                                Text(
                                  'Delete ?\nFROM ${row['fromDate']} TO ${row['toDate']}\nEmployee ID: ${row['empId']}\nName: ${row['name']}\nShift: ${row['shift']}',
                                  style: style,
                                ),
                              ],
                            ),
                            width: 800,
                            dialogType: DialogType.question,
                            animType: AnimType.rightSlide,
                            title: 'Import Employee Result',
                            enableEnterKey: true,
                            showCloseIcon: true,
                            btnOkOnPress: () async {
                              gValue.mongoDb.deleteOneShiftRegister(
                                  row['objectId'].toString().substring(10, 34));
                              MyFuntion.insertHistory(
                                  'Delete Shift: FROM ${row['fromDate']} TO ${row['toDate']}\nEmployee ID: ${row['empId']}\nName: ${row['name']}\nShift: ${row['shift']}');
                              rendererContext.stateManager
                                  .removeRows([rendererContext.row]);
                            },
                            closeIcon: const Icon(Icons.close))
                        .show();
                  }
                },
                iconSize: 18,
                color: Colors.red,
                padding: const EdgeInsets.all(0),
              ),
              Expanded(
                child: Text(
                  rendererContext.row.cells[rendererContext.column.field]!.value
                      .toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              newOrEdit != '' && rendererContext.rowIdx == rowIdChanged
                  ? IconButton(
                      onPressed: () {
                        var currentShiftRegister = <String, dynamic>{
                          'fromDate': DateFormat('dd-MMM-yyyy').parseUtc(
                              stateManager
                                  .currentRow?.cells['fromDate']?.value),
                          'toDate': DateFormat('dd-MMM-yyyy').parseUtc(
                              stateManager.currentRow?.cells['toDate']?.value),
                          'empId':
                              stateManager.currentRow?.cells['empId']?.value,
                          'name': stateManager.currentRow?.cells['name']?.value,
                          'shift':
                              stateManager.currentRow?.cells['shift']?.value,
                        };
                        var key, value;
                        switch (colIdChange) {
                          case 0:
                            key = 'fromDate';
                            value = currentShiftRegister['fromDate'];
                            break;
                          case 1:
                            key = 'toDate';
                            value = currentShiftRegister['toDate'];
                            break;
                          case 2:
                            key = 'empId';
                            value = currentShiftRegister['empId'];
                            break;
                          case 3:
                            key = 'name';
                            value = currentShiftRegister['name'];
                            break;
                          case 4:
                            key = 'shift';
                            value = currentShiftRegister['shift'];
                            break;
                          default:
                        }
                        newOrEdit == 'edit'
                            ? {
                                gValue.mongoDb.updateOneShiftRegisterByObjectId(
                                    rowChangedJson['objectId']
                                        .toString()
                                        .substring(10, 34),
                                    key,
                                    value)
                              }
                            : {
                                checkNewShiftRegisterEditBeforeImport(
                                    currentShiftRegister)
                              };
                        setState(() {
                          newOrEdit = '';
                        });
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Colors.green,
                      ),
                    )
                  : Container(),
            ]);
          }),
      PlutoColumn(
        width: 120,
        title: 'To',
        field: 'toDate',
        type: PlutoColumnType.date(
            format: "dd-MMM-yyyy",
            defaultValue: DateTime.now().add(const Duration(days: 31))),
      ),
      PlutoColumn(
        width: 200,
        title: 'Employee ID',
        field: 'empId',
        type: PlutoColumnType.select(gValue.employeeIdNames,
            enableColumnFilter: true),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 80,
        title: 'Shift',
        field: 'shift',
        type: PlutoColumnType.select(['Shift 1', 'Shift 2', 'Day'],
            defaultValue: 'Shift 1'),
      ),
      PlutoColumn(
        width: 350,
        title: 'objectId',
        field: 'objectId',
        type: PlutoColumnType.text(),
        hide: !gValue.showObjectId,
      )
    ];
    return columns;
  }

  List<PlutoRow> getRows(List<ShiftRegister> data) {
    List<PlutoRow> rows = [];
    for (var element in data.reversed) {
      rows.add(
        PlutoRow(
          cells: {
            'fromDate': PlutoCell(value: element.fromDate),
            'toDate': PlutoCell(value: element.toDate),
            'empId': PlutoCell(value: element.empId),
            'name': PlutoCell(value: element.name),
            'shift': PlutoCell(value: element.shift),
            'objectId': PlutoCell(value: element.objectId),
          },
        ),
      );
    }
    return rows;
  }

  List<PlutoColumn> getColumnsShift() {
    List<PlutoColumn> columns = [];
    columns = [
      PlutoColumn(
        title: 'Shift',
        field: 'shift',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Begin Work',
        field: 'begin',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'End Work',
        field: 'end',
        type: PlutoColumnType.text(),
      ),
    ];
    return columns;
  }

  List<PlutoRow> getRowsShift(List<Shift> shifts) {
    List<PlutoRow> rows = [];
    for (var element in shifts) {
      rows.add(
        PlutoRow(
          cells: {
            'shift': PlutoCell(value: element.shift),
            'begin': PlutoCell(value: element.begin),
            'end': PlutoCell(value: element.end),
          },
        ),
      );
    }
    return rows;
  }

  checkNewShiftRegisterEditBeforeImport(
      Map<String, dynamic> newShiftRegisterMap) {
    for (var currentShiftRegister in gValue.shiftRegisters) {
      if (currentShiftRegister.toDate
              .isAfter(newShiftRegisterMap['fromDate']) &&
          currentShiftRegister.empId == newShiftRegisterMap['empId']) {
        gValue.mongoDb.updateOneShiftRegisterByObjectId(
            currentShiftRegister.objectId.substring(10, 34),
            'toDate',
            newShiftRegisterMap['fromDate'].subtract(const Duration(days: 1)));
      }
      gValue.mongoDb.addOneShiftRegisterFromMap(newShiftRegisterMap);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
