import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/gValue.dart';
import 'package:intl/intl.dart';
import 'package:tiqn/main.dart';
import 'package:tiqn/tools/myFunction.dart';
import 'package:tiqn/tools/myfile.dart';
import 'package:toastification/toastification.dart';

class AttLogUI extends StatefulWidget {
  const AttLogUI({super.key});

  @override
  State<AttLogUI> createState() => _AttLogUIState();
}

class _AttLogUIState extends State<AttLogUI>
    with AutomaticKeepAliveClientMixin {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  late DateTime timeBegin, timeEnd, dateAddRecord, lastUpdate;
  var listOfEmpIdPresent = [];
  String selectedMonth = '';
  List<String> monthYears2025 = [];
  late final PlutoGridStateManager stateManager;
  bool firstBuild = true,
      showButtonOKSellectRangeDate = false,
      isLoaded = true,
      exportTimeSheetDaysVisible = true,
      pauseLoad = false,
      refreshDataCancel = false;
  int countNoName = 0;

  @override
  void initState() {
    // TODO: implement initState
    lastUpdate = DateTime.now();
    monthYears2025 = MyFuntion.getMonthYearList('2025');
    selectedMonth = monthYears2025.first;
    timeBegin = DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
      hour: 0,
      minute: 0,
    ));
    timeEnd = DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
      hour: 23,
      minute: 59,
    ));
    dateAddRecord = timeBegin;
    Future.delayed(Durations.long2).then(
      (value) {
        Timer.periodic(const Duration(minutes: 1),
            (_) => refreshData(timeBegin, timeEnd, false));
      },
    );

    columns = getColumns();
    rows = getRows(gValue.attLogs);
    super.initState();
  }

  checkIsFilter() {
    bool isFilter = false;
    for (int i = 0; i < columns.length; i++) {
      if (stateManager.isFilteredColumn(columns[i])) {
        isFilter = true;

        break;
      }
    }
    return isFilter;
  }

  Future<void> refreshData(
      DateTime timeBegin, DateTime timeEnd, bool forceLoadData) async {
    if (refreshDataCancel) return;
    if (forceLoadData) {
      gValue.attLogs = await gValue.mongoDb.getAttLogs(timeBegin, timeEnd);

      if (mounted) {
        setState(() {
          countNoName = 0;
          rows = getRows(gValue.attLogs);
          stateManager.removeRows(stateManager.rows);
          stateManager.appendRows(rows);
          MyFuntion.calculateAttendanceStatus();
          isLoaded = true;
          exportTimeSheetDaysVisible = true;
          toastification.dismissAll();
          showButtonOKSellectRangeDate = false;
          lastUpdate = DateTime.now();
        });
      }
    } else if (isLoaded && !checkIsFilter()) {
      List<AttLog> temp = await gValue.mongoDb.getAttLogs(timeBegin, timeEnd);

      if ((temp.length != gValue.attLogs.length) && mounted) {
        setState(() {
          rows = getRows(gValue.attLogs);
          stateManager.removeRows(stateManager.rows);
          stateManager.appendRows(rows);
          MyFuntion.calculateAttendanceStatus();
          isLoaded = true;
          exportTimeSheetDaysVisible = true;
          toastification.dismissAll();
          showButtonOKSellectRangeDate = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Row(
      children: [
        Container(
          width: 500,
          color: Colors.blue[50],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Data load every 1 minute"),
                  Text('Last update at $lastUpdate')
                ],
              ),
              SizedBox(
                height: 220,
                width: 500,
                child: SfDateRangePicker(
                  enableMultiView: true,
                  monthViewSettings: const DateRangePickerMonthViewSettings(
                      enableSwipeSelection: true,
                      showWeekNumber: false,
                      firstDayOfWeek: 1,
                      weekendDays: [7]),
                  view: DateRangePickerView.month,
                  showTodayButton: true,
                  minDate: DateTime.utc(2023, 12, 26),
                  maxDate: DateTime.now(),
                  backgroundColor: Colors.blue[100],
                  todayHighlightColor: Colors.green,
                  selectionColor: Colors.orange,
                  headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: Colors.blue[200],
                  ),
                  onSelectionChanged: onSelectionChanged,
                  onSubmit: (value) {
                    refreshDataCancel = false;
                    setState(() {
                      if (value is PickerDateRange) {
                        timeBegin = value.startDate!;
                        timeEnd = (value.endDate ?? value.startDate)!;
                      } else if (value is DateTime) {
                        timeBegin = value;
                        timeEnd = value;
                      }
                      timeBegin =
                          timeBegin.appliedFromTimeOfDay(const TimeOfDay(
                        hour: 0,
                        minute: 0,
                      ));
                      timeEnd = timeEnd.appliedFromTimeOfDay(const TimeOfDay(
                        hour: 23,
                        minute: 59,
                      ));
                      isLoaded = false;
                      refreshData(timeBegin, timeEnd, true);
                      int time =
                          (timeEnd.difference(timeBegin).inDays / 6).round();
                      exportTimeSheetDaysVisible = false;
                      if (time > 1) {
                        toastification.show(
                          showProgressBar: true,
                          backgroundColor: Colors.blue[100],
                          alignment: Alignment.center,
                          context: context,
                          title: const Text('Data is loading...!'),
                          autoCloseDuration: Duration(seconds: time),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 16),
                              spreadRadius: 0,
                            )
                          ],
                        );
                      }
                    });
                  },
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(timeBegin, timeEnd),
                  showActionButtons: showButtonOKSellectRangeDate,
                ),
              ),
              showButtonOKSellectRangeDate
                  ? const Text(
                      'Press button OK to load data',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20),
                    )
                  : Container(),
              const Divider(),
              Row(children: [
                Visibility(
                  visible: timeEnd.difference(timeBegin).inHours <= 24,
                  child: TextButton.icon(
                    onPressed: () async {
                      if (gValue.attLogs.isEmpty) {
                        toastification.show(
                          backgroundColor: Colors.orange,
                          alignment: Alignment.center,
                          context: context,
                          title: const Text('Data not yet loaded, try again!'),
                          autoCloseDuration: const Duration(seconds: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x07000000),
                              blurRadius: 16,
                              offset: Offset(0, 16),
                              spreadRadius: 0,
                            )
                          ],
                        );
                      } else {
                        List<Employee> absents = [];
                        for (var empId in gValue.employeeIdAbsents) {
                          absents.add(gValue.employees
                              .firstWhere((element) => element.empId == empId));
                        }
                        print('timeBegin : $timeBegin');
                        print('timeEnd : $timeEnd');
                        // var listAbsentInDate = await gValue.mongoDb
                        //     .getLeaveRegisterByRangeDate(timeBegin, timeEnd);
                        MyFile.createExcelEmployeeAbsent(
                            absents,
                            gValue.shiftRegisters,
                            "Absents ${DateFormat('dd-MMM-yyyy').format(timeBegin)}");
                        // MyFile.createExcelEmployee(absents, true,
                        //     "Absents ${DateFormat('dd-MMM-yyyy').format(timeBegin)}");
                      }
                    },
                    icon: const Icon(
                      Icons.supervised_user_circle,
                      color: Colors.orangeAccent,
                    ),
                    label: const Text('Export absent list'),
                  ),
                ),
                Visibility(
                  visible: exportTimeSheetDaysVisible,
                  child: TextButton.icon(
                    onPressed: () async {
                      List<OtRegister> otRegister = await gValue.mongoDb
                          .getOTRegisterByRangeDate(timeBegin, timeEnd);

                      MyFile.createExcelTimeSheet(
                          MyFuntion.createTimeSheetsDate(
                              gValue.employees,
                              gValue.shifts,
                              gValue.shiftRegisters,
                              otRegister,
                              gValue.leaveRegisters,
                              gValue.attLogs,
                              timeBegin,
                              timeEnd),
                          'Timesheets from ${DateFormat('dd-MMM-yyyy').format(timeBegin)} to ${DateFormat('dd-MMM-yyyy').format(timeEnd)} ${DateFormat('hhmmss').format(DateTime.now())}');
                    },
                    icon: const Icon(
                      Icons.timelapse,
                      color: Colors.blueAccent,
                    ),
                    label: const Text('Export timesheets - days'),
                  ),
                ),
              ]),
              const Divider(),
              Row(
                children: [
                  DropdownButtonHideUnderline(
                      child: DropdownButton2(
                          isExpanded: true,
                          hint: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: monthYears2025
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedMonth,
                          onChanged: (String? value) {
                            setState(() {
                              print(value);
                              selectedMonth = value!;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ))),
                  TextButton.icon(
                      onPressed: () async {
                        // var today = DateTime.now();
                        var yearEnd =
                            DateFormat.yMMMM().parse(selectedMonth).year;
                        var monthEnd =
                            DateFormat.yMMMM().parse(selectedMonth).month;
                        var dateEnd = 26;
                        var dateBegin = 26;
                        int monBegin, yearBegin;
                        var end = DateTime.utc(yearEnd, monthEnd, dateEnd);
                        if (monthEnd == 1) {
                          yearBegin = yearEnd - 1;
                          monBegin = 12;
                        } else {
                          yearBegin = yearEnd;
                          monBegin = monthEnd - 1;
                        }
                        var begin =
                            DateTime.utc(yearBegin, monBegin, dateBegin);
                        toastification.show(
                          backgroundColor: Colors.blue[200],
                          alignment: Alignment.center,
                          context: context,
                          title: const Text('Data is loading...!'),
                          autoCloseDuration: const Duration(seconds: 5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 16),
                              spreadRadius: 0,
                            )
                          ],
                        );
                        List<OtRegister> otRegister1 = await gValue.mongoDb
                            .getOTRegisterByRangeDate(begin, end);

                        List<AttLog> attLogs1 =
                            await gValue.mongoDb.getAttLogs(begin, end);
                        print('${otRegister1.length}');
                        print('${attLogs1.length}');
                        MyFile.createExcelTimeSheet(
                            MyFuntion.createTimeSheetsDate(
                              gValue.employees,
                              gValue.shifts,
                              gValue.shiftRegisters,
                              otRegister1,
                              gValue.leaveRegisters,
                              attLogs1,
                              begin,
                              end,
                            ),
                            'Timesheets $selectedMonth ${DateFormat('yyyyMMddhhmmss').format(DateTime.now())}');
                      },
                      icon: const Icon(
                        Icons.timelapse_sharp,
                        color: Colors.greenAccent,
                      ),
                      label: const Text('Export timesheets - month'))
                ],
              ),
              const Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attendance history :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    TextButton.icon(
                      onPressed: () {
                        if (gValue.accessMode != 'edit') {
                          toastification.show(
                            showProgressBar: true,
                            backgroundColor: Colors.amber[200],
                            alignment: Alignment.center,
                            context: context,
                            title: const Text(
                                'Bạn không có quyền sử dụng chức năng này !'),
                            autoCloseDuration: const Duration(seconds: 2),
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
                        final TextEditingController textEditingController =
                            TextEditingController();
                        int hour = 8, minute = 0;
                        String employeeIdName = gValue.employeeIdNames.first;
                        String empId = employeeIdName.split('   ')[0];
                        String empName = employeeIdName.split('   ')[1];
                        List<String> hourList = [
                          for (var i = 5; i <= 23; i++) i.toString()
                        ];
                        List<String> minuteList = [
                          '0',
                          '5',
                          '10',
                          '15',
                          '20',
                          '25',
                          '30',
                          '35',
                          '40',
                          '45',
                          '50',
                          '55'
                        ];
                        AwesomeDialog(
                                padding: const EdgeInsets.all(10),
                                context: context,
                                body: SizedBox(
                                  width: 500,
                                  height: 450,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            "Employee : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          StatefulBuilder(
                                              builder: (context, setState) {
                                            return SizedBox(
                                              width: 300,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Select Item',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                    ),
                                                  ),
                                                  items: gValue.employeeIdNames
                                                      .map((String item) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: employeeIdName,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      employeeIdName =
                                                          value!.toString();
                                                      empId = employeeIdName
                                                          .split('   ')[0];
                                                      empName = employeeIdName
                                                          .split('   ')[1];
                                                      print(
                                                          'select: $empId   $empName');
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    height: 40,
                                                    width: 140,
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    height: 40,
                                                  ),
                                                  dropdownSearchData:
                                                      DropdownSearchData(
                                                    searchController:
                                                        textEditingController,
                                                    searchInnerWidgetHeight: 50,
                                                    searchInnerWidget:
                                                        Container(
                                                      height: 50,
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 8,
                                                        bottom: 4,
                                                        right: 8,
                                                        left: 8,
                                                      ),
                                                      child: TextFormField(
                                                        expands: true,
                                                        maxLines: null,
                                                        controller:
                                                            textEditingController,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 10,
                                                            vertical: 8,
                                                          ),
                                                          hintText:
                                                              'Search employee ID or name...',
                                                          hintStyle:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    searchMatchFn:
                                                        (item, searchValue) {
                                                      return item.value
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(searchValue
                                                              .toLowerCase());
                                                    },
                                                  ),
                                                  //This to clear the search value when you close the menu
                                                  onMenuStateChange: (isOpen) {
                                                    if (!isOpen) {
                                                      textEditingController
                                                          .clear();
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                      SfDateRangePicker(
                                        showTodayButton: true,
                                        minDate: DateTime.now()
                                            .subtract(const Duration(days: 31)),
                                        maxDate: DateTime.now(),
                                        backgroundColor: Colors.blue[100],
                                        todayHighlightColor: Colors.green,
                                        selectionColor: Colors.orangeAccent,
                                        headerStyle: DateRangePickerHeaderStyle(
                                          backgroundColor: Colors.blue[200],
                                        ),
                                        onSelectionChanged:
                                            onSelectionChangedAddRecord,
                                        selectionMode:
                                            DateRangePickerSelectionMode.single,
                                        initialSelectedDate: DateTime.now(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            "Time",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text('Hour : '),
                                          StatefulBuilder(
                                              builder: (context, setState) {
                                            return SizedBox(
                                              width: 100,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                      child: DropdownButton2(
                                                          isExpanded: true,
                                                          hint: Text(
                                                            'Select Item',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                            ),
                                                          ),
                                                          items: hourList
                                                              .map((String
                                                                      item) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value: item,
                                                                    child: Text(
                                                                      item,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                    ),
                                                                  ))
                                                              .toList(),
                                                          value:
                                                              hour.toString(),
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              hour = int.parse(
                                                                  value!);
                                                            });
                                                          },
                                                          buttonStyleData:
                                                              const ButtonStyleData(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            height: 40,
                                                            width: 140,
                                                          ),
                                                          menuItemStyleData:
                                                              const MenuItemStyleData(
                                                            height: 40,
                                                          ))),
                                            );
                                          }),
                                          const Text("Minute :"),
                                          StatefulBuilder(
                                              builder: (context, setState) {
                                            return SizedBox(
                                              width: 130,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                      child: DropdownButton2(
                                                          isExpanded: true,
                                                          hint: Text(
                                                            'Select Item',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                            ),
                                                          ),
                                                          items: minuteList
                                                              .map((String
                                                                      item) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value: item,
                                                                    child: Text(
                                                                      item,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                    ),
                                                                  ))
                                                              .toList(),
                                                          value:
                                                              minute.toString(),
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              minute =
                                                                  int.parse(
                                                                      value!);
                                                            });
                                                          },
                                                          buttonStyleData:
                                                              const ButtonStyleData(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            height: 40,
                                                            width: 140,
                                                          ),
                                                          menuItemStyleData:
                                                              const MenuItemStyleData(
                                                            height: 40,
                                                          ))),
                                            );
                                          }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                width: 500,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'Add attendance record ?',
                                enableEnterKey: true,
                                showCloseIcon: true,
                                btnOkText: "ADD ONE",
                                btnCancel: TextButton.icon(
                                  // change to Ok and Add more
                                  onPressed: () async {
                                    stateManager.resetCurrentState();
                                    if (empName.isNotEmpty) {
                                      var time = dateAddRecord
                                          .appliedFromTimeOfDay(TimeOfDay(
                                              hour: hour, minute: minute));
                                      int finger = gValue.employees
                                          .where((element) =>
                                              element.empId == empId.trim())
                                          .first
                                          .attFingerId!;
                                      AttLog attLog = AttLog(
                                          objectId: '',
                                          attFingerId: finger,
                                          empId: empId,
                                          name: empName,
                                          machineNo: 0,
                                          timestamp: time);

                                      textEditingController.clear();
                                      await gValue.mongoDb
                                          .insertAttLogs([attLog]);
                                      await MyFuntion.insertHistory(
                                          'ADD attendance log : ${attLog.attFingerId}   ${attLog.empId}   ${attLog.name}   ${DateFormat('dd-MMM-yyyy hh:mm:ss').format(attLog.timestamp)}');
                                      refreshData(timeBegin, timeEnd, true);

                                      toastification.show(
                                        showProgressBar: true,
                                        backgroundColor: Colors.blue[100],
                                        alignment: Alignment.center,
                                        context: context,
                                        title: Text(
                                            'Adding:  $empId   $empName: time: $time'),
                                        autoCloseDuration:
                                            const Duration(seconds: 1),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8,
                                            offset: Offset(0, 16),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      );
                                    }
                                  },
                                  label: const Text('ADD MORE'),
                                ),
                                btnOkOnPress: () async {
                                  stateManager.resetCurrentState();
                                  if (empName.isNotEmpty) {
                                    var time = dateAddRecord
                                        .appliedFromTimeOfDay(TimeOfDay(
                                            hour: hour, minute: minute));
                                    int finger = gValue.employees
                                        .where((element) =>
                                            element.empId == empId.trim())
                                        .first
                                        .attFingerId!;
                                    AttLog attLog = AttLog(
                                        objectId: '',
                                        attFingerId: finger,
                                        empId: empId,
                                        name: empName,
                                        machineNo: 0,
                                        timestamp: time);

                                    await gValue.mongoDb
                                        .insertAttLogs([attLog]);
                                    await MyFuntion.insertHistory(
                                        'ADD attendance log : ${attLog.attFingerId}   ${attLog.empId}   ${attLog.name}   ${DateFormat('dd-MMM-yyyy hh:mm:ss').format(attLog.timestamp)}');
                                    refreshData(timeBegin, timeEnd, true);

                                    toastification.show(
                                      showProgressBar: true,
                                      backgroundColor: Colors.blue[100],
                                      alignment: Alignment.center,
                                      context: context,
                                      title: Text(
                                          'Adding:  $empId   $empName: time: $time'),
                                      autoCloseDuration:
                                          const Duration(seconds: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          offset: Offset(0, 16),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    );
                                  }
                                },
                                closeIcon: const Icon(Icons.close))
                            .show();
                      },
                      icon: const Icon(
                        Icons.add_box,
                        color: Colors.greenAccent,
                      ),
                      label: const Text('Add'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        print('(gValue.attLogs : ${gValue.attLogs.length}');
                        MyFile.createExcelAttLog(gValue.attLogs,
                            'Attendance logs from ${DateFormat('dd-MMM-yyyy').format(timeBegin)} to ${DateFormat('dd-MMM-yyyy').format(timeEnd)}');
                      },
                      icon: const Icon(
                        Icons.download,
                        color: Colors.blueAccent,
                      ),
                      label: const Text('Export all'),
                    ),
                    TextButton.icon(
                        icon: const Icon(
                          Icons.download,
                          color: Colors.pink,
                        ),
                        onPressed: () {
                          List<AttLog> attLogs = [];
                          for (var row in stateManager.refRows) {
                            var tempJson = row.toJson();
                            attLogs.add(AttLog(
                                objectId: tempJson['objectId'],
                                attFingerId: tempJson['attFingerId'],
                                empId: tempJson['empId'],
                                name: tempJson['name'],
                                timestamp: DateFormat('dd-MMM-yyyy hh:mm:ss')
                                    .parse(tempJson['timeStamp']),
                                machineNo: tempJson['machineNo']));
                          }

                          MyFile.createExcelAttLog(attLogs, 'Attendance logs');
                        },
                        label: const Text('Export current filter')),
                    TextButton.icon(
                      onPressed: () async {
                        if (gValue.accessMode != 'edit') {
                          toastification.show(
                            showProgressBar: true,
                            backgroundColor: Colors.amber[200],
                            alignment: Alignment.center,
                            context: context,
                            title: const Text(
                                'Bạn không có quyền sử dụng chức năng này !'),
                            autoCloseDuration: const Duration(seconds: 2),
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
                        List<Text> logs = [];
                        gValue.mongoDb
                            .insertAttLogs(await MyFile.readExcelAttLog());
                        for (var log in gValue.logs) {
                          MyFuntion.insertHistory(
                              'IMPORT attendance log : $log');
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: logs,
                                  ),
                                  width: 800,
                                  dialogType:
                                      gValue.logs.toString().contains("ERROR")
                                          ? DialogType.warning
                                          : DialogType.info,
                                  animType: AnimType.rightSlide,
                                  title: 'Import attendance record result',
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
                      label: const Text('Import'),
                    ),
                  ]),
                ],
              ),
              const Divider(),
              countNoName > 0
                  ? Container(
                      width: 500,
                      color: Colors.amberAccent,
                      child: Text(
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                          'Tồn tại Tên & MSNV chưa được cập nhật trong CSDL.\nLọc "No Emp Id" trên cột Employee ID\nBấm biểu tượng refresh trên mỗi dòng để cập nhật'),
                    )
                  : timeBegin.day == timeEnd.day
                      ? chartPresent(
                          gValue.employeeIdPresents.length,
                          gValue.employeeIdMaternityLeaves.length,
                          gValue.employeeIdPresents.length,
                          gValue.employeeIdAbsents.length)
                      : Container(),
            ],
          ),
        ),
        const VerticalDivider(
          width: 8,
          color: Colors.transparent,
        ),
        Container(
          width: 130,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent),
                  'Total records: ${gValue.attLogs.length}'),
              Text(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  'Manual : ${gValue.attLogs.where((log) => log.machineNo == 0).length}'),
              Text(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  'Machine 1 : ${gValue.attLogs.where((log) => log.machineNo == 1).length}'),
              Text(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  'Machine 2 : ${gValue.attLogs.where((log) => log.machineNo == 2).length}'),
              Text(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  'Machine 3 : ${gValue.attLogs.where((log) => log.machineNo == 3).length}'),
              Text(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  'Machine 4 : ${gValue.attLogs.where((log) => log.machineNo == 4).length}'),
              Text(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  'Machine 5 : ${gValue.attLogs.where((log) => log.machineNo == 5).length}'),
              Text(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  'Machine 6 : ${gValue.attLogs.where((log) => log.machineNo == 6).length}'),
              Text(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  'Machine 7 : ${gValue.attLogs.where((log) => log.machineNo == 7).length}'),
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
            //  columnFilter: PlutoGridColumnFilterConfig(),
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
            print('onLoaded');
            firstBuild = false;
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
            print('rows lenght : ${rows.length}');
          },
          onSelected: (event) {
            print('onSelected  :$event');
          },
          onSorted: (event) {
            print('onSorted  :$event');
          },
        )),
      ],
    )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  List<PlutoColumn> getColumns() {
    List<PlutoColumn> columns;
    columns = [
      PlutoColumn(
          title: 'Finger ID',
          field: 'attFingerId',
          type: PlutoColumnType.number(),
          width: 140,
          renderer: (rendererContext) {
            return Row(
              children: [
                rendererContext.row.toJson()['empId'] == "No Emp Id"
                    ? IconButton(
                        icon: const Icon(
                          color: Colors.green,
                          Icons.refresh_outlined,
                        ),
                        onPressed: () async {
                          var row = rendererContext.row.toJson();
                          refreshDataCancel = true;
                          print(row);
                          var style = const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold);
                          int fingerId = -1;
                          int machineNo = 0;
                          String objectId = '';
                          String empIdUpdate = '';
                          String empNameUpdate = '';
                          DateTime time, timeStamp = DateTime.now();
                          objectId = row['objectId'].toString();
                          fingerId = row['attFingerId'];
                          machineNo = row['machineNo'];
                          DateFormat dateFormat =
                              DateFormat("dd-MMM-yyyy HH:mm:ss");
                          time = dateFormat.parse(row['timeStamp']);
                          timeStamp = time.appliedFromTimeOfDay(TimeOfDay(
                            hour: time.hour,
                            minute: time.minute,
                          ));
                          empIdUpdate = gValue.employees
                              .firstWhere(
                                  (element) => element.attFingerId == fingerId)
                              .empId!;
                          empNameUpdate = gValue.employees
                              .firstWhere(
                                  (element) => element.attFingerId == fingerId)
                              .name!;
                          print(
                              'fingerId : $fingerId\nempIdUpdate: $empIdUpdate\nempNameUpdate:$empNameUpdate\ntimeStamp: $timeStamp\nobjectId: $objectId');
                          await gValue.mongoDb.deleteOneAttLog(
                              row['objectId'].toString().substring(10, 34));
                          AttLog attLog = AttLog(
                              objectId: '',
                              attFingerId: fingerId,
                              empId: empIdUpdate,
                              name: empNameUpdate,
                              machineNo: machineNo,
                              timestamp: timeStamp);
                          await gValue.mongoDb.insertAttLogs([attLog]);

                          refreshDataCancel = false;
                          refreshData(timeBegin, timeEnd, true);

                          String log =
                              'UPDATE attendance log : ${row['attFingerId']}  ${row['timeStamp']} : "No Emp Id" to  $empIdUpdate,  "No Name" to   $empNameUpdate   ';
                          await MyFuntion.insertHistory(log);
                          toastification.show(
                            showProgressBar: true,
                            backgroundColor: Colors.green[200],
                            alignment: Alignment.center,
                            context: context,
                            title: Text(log),
                            autoCloseDuration: const Duration(seconds: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 16),
                                spreadRadius: 0,
                              )
                            ],
                          );
                        },
                      )
                    : Container(),
                rendererContext.row.toJson()['machineNo'] == 0
                    ? IconButton(
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
                              title: const Text(
                                  'Bạn không có quyền sử dụng chức năng này !'),
                              autoCloseDuration: const Duration(seconds: 2),
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
                          var row = rendererContext.row.toJson();
                          refreshDataCancel = true;
                          print(row);
                          var style = const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold);

                          String objectId = '';
                          String deletedEmpId = '';
                          String deletedEmpName = '';
                          DateTime timeStamp = DateTime.now();
                          row.forEach((key, value) {
                            if (key == 'employeeId') {
                              objectId = row['objectId'].toString();
                              deletedEmpId = value;
                              deletedEmpName = row['name'];
                              timeStamp =
                                  DateTime.parse(row['timeStamp'].toString());
                            }
                          });

                          AwesomeDialog(
                                  context: context,
                                  body: Text(
                                    'DELETE ?\n${row['empId']}  ${row['name']}\nTime: ${row['timeStamp']}',
                                    style: style,
                                  ),
                                  width: 800,
                                  dialogType: DialogType.question,
                                  animType: AnimType.rightSlide,
                                  enableEnterKey: true,
                                  showCloseIcon: true,
                                  btnOkOnPress: () async {
                                    await gValue.mongoDb.deleteOneAttLog(
                                        row['objectId']
                                            .toString()
                                            .substring(10, 34));
                                    await MyFuntion.insertHistory(
                                        'DELETE attendance log : ${row['attFingerId']}    ${row['empId']}   ${row['name']}    ${row['timeStamp']}');
                                    setState(() {
                                      rendererContext.stateManager
                                          .removeRows([rendererContext.row]);
                                    });
                                    refreshDataCancel = false;
                                    refreshData(timeBegin, timeEnd, true);
                                  },
                                  closeIcon: const Icon(Icons.close))
                              .show();
                        },
                        iconSize: 18,
                        color: Colors.red,
                        padding: const EdgeInsets.all(0),
                      )
                    : Container(),
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
          title: 'Employee ID',
          field: 'empId',
          type: PlutoColumnType.text(),
          width: 120),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          title: 'Group',
          field: 'group',
          type: PlutoColumnType.text(),
          width: 150),
      PlutoColumn(
        title: 'Time',
        field: 'timeStamp',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Machine',
        field: 'machineNo',
        width: 100,
        type: PlutoColumnType.number(),
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

  List<PlutoRow> getRows(List<AttLog> data) {
    List<PlutoRow> rows = [];
    data.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    for (var log in data) {
      if (log.empId == 'No Emp Id') {
        setState(() {
          countNoName++;
        });

        data.sort((a, b) => a.empId.compareTo(b.empId));
      }
    }
    for (var log in data) {
      String? group = '';
      try {
        group = gValue.employees
            .firstWhere((element) => element.empId == log.empId)
            .group;
      } catch (e) {
        print('Error finding group for empId ${log.empId}: $e');
      }

      rows.add(
        PlutoRow(
          cells: {
            'attFingerId': PlutoCell(value: log.attFingerId),
            'empId': PlutoCell(value: log.empId),
            'name': PlutoCell(value: log.name),
            'group': PlutoCell(value: group),
            'timeStamp': PlutoCell(
                value:
                    DateFormat("dd-MMM-yyyy HH:mm:ss").format(log.timestamp)),
            'machineNo': PlutoCell(value: log.machineNo),
            'objectId': PlutoCell(value: log.objectId),
          },
        ),
      );
    }

    return rows;
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print('-----onSelectionChanged : ${args.value}');
    stateManager.removeAllRows();
    refreshDataCancel = true;
    setState(
      () {
        if (args.value is PickerDateRange) {
          timeBegin = args.value.startDate;
          timeEnd = args.value.endDate ?? args.value.startDate;

          showButtonOKSellectRangeDate = true;
          exportTimeSheetDaysVisible = false;
        } else if (args.value is DateTime) {
          exportTimeSheetDaysVisible = false;
          timeBegin = args.value;
          timeEnd = args.value;
          showButtonOKSellectRangeDate = false;
        }
        timeBegin = timeBegin.appliedFromTimeOfDay(const TimeOfDay(
          hour: 0,
          minute: 0,
        ));
        timeEnd = timeEnd.appliedFromTimeOfDay(const TimeOfDay(
          hour: 23,
          minute: 59,
        ));

        Future.delayed(Durations.short1).then(
          (value) {
            if (timeBegin.day == timeEnd.day) {
              setState(() {
                showButtonOKSellectRangeDate = false;
                isLoaded = false;
                refreshDataCancel = false;
                refreshData(timeBegin, timeEnd, true);
              });
            }
          },
        );
      },
    );

    // print(
    //     'onSelectionChanged : timeBegin: $timeBegin       timeEnd: $timeEnd ');
  }

  void onSelectionChangedAddRecord(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        dateAddRecord = args.value.startDate;
        dateAddRecord = args.value.endDate ?? args.value.startDate;
      } else if (args.value is DateTime) {
        dateAddRecord = args.value;
        dateAddRecord = args.value;
      }
      dateAddRecord = dateAddRecord.appliedFromTimeOfDay(const TimeOfDay(
        hour: 23,
        minute: 59,
      ));
    });
    print('onSelectionChangedAddRecord : dateAddRecord: $dateAddRecord  ');
  }

  chartPresent(int workingNormal, int maternityLeave, int present, int absent) {
    final List<ChartPresent> chartData = [
      ChartPresent(
          'Maternity leave', maternityLeave.toDouble(), Colors.purpleAccent),
      ChartPresent('Present', present.toDouble(), Colors.green[400]),
      ChartPresent('Absent', absent.toDouble(), Colors.orange),
    ];
    return SizedBox(
      width: 500,
      height: 250,
      child: SfCircularChart(
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
                widget: Container(
                    child: Text('Enrolled\n    ${gValue.enrolled}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))))
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: const Legend(
              position: LegendPosition.bottom,
              // height: '50%',
              overflowMode: LegendItemOverflowMode.wrap,
              isVisible: true,
              textStyle: TextStyle(fontSize: 15)),
          series: <CircularSeries<ChartPresent, String>>[
            DoughnutSeries<ChartPresent, String>(
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: chartData,
              xValueMapper: (ChartPresent data, _) => data.x,
              yValueMapper: (ChartPresent data, _) => data.y,
              pointColorMapper: (ChartPresent data, _) => data.color,
            )
          ]),
    );
  }
}

class ChartPresent {
  ChartPresent(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
