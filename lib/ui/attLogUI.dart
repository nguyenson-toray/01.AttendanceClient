import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pluto_grid/pluto_grid.dart';
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
  bool _isDisposed = false;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  late DateTime timeBegin, timeEnd, dateAddRecord;
  var listOfEmpIdPresent = [];
  String selectedMonth = '';
  String labelExportTimesheetsDays = 'Export timesheets - Days - With filtered';
  String labelExportTimesheetsMonth = 'Export timesheets - Full month';
  String status = '';
  List<String> monthYears2025 = [];
  late final PlutoGridStateManager stateManager;
  bool firstBuild = true, isLoaded = true, exportTimeSheetDaysVisible = true;
  int countNoName = 0;
  String updateMode = 'manual'; // manual, auto

  @override
  void initState() {
    // TODO: implement initState
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
        Timer.periodic(const Duration(seconds: 30),
            (_) => refreshData(timeBegin, timeEnd, 'auto'));
      },
    );

    columns = getColumns();
    rows = getRows(gValue.attLogs);
    status =
        'Last update: ${DateFormat('HH:mm:ss').format(DateTime.now())}   Range Date : ${DateFormat('dd/MM/yyyy').format(timeBegin)} - ${DateFormat('dd/MM/yyyy').format(timeEnd)}';

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
      DateTime timeBegin, DateTime timeEnd, String updateMode) async {
    gValue.logger.t(
        'refreshData : $timeBegin - $timeEnd - updateMode:$updateMode - isLoaded : $isLoaded   - _isDisposed: $_isDisposed - isFilter: ${checkIsFilter()}');

    if (_isDisposed || !mounted) return;
    int timeLoading = timeEnd.difference(timeBegin).inDays + 1;
    if (updateMode == 'manual') {
      toastification.show(
        context: context,
        type: ToastificationType.info,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: Duration(seconds: timeLoading),
        title: const Text(
          'Data is loading ...',
        ),
        showProgressBar: true,
        progressBarTheme: ProgressIndicatorThemeData(color: Colors.green),
        // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
        showIcon: true,
        description: Text('From $timeBegin to $timeEnd'),
        alignment: Alignment.center,
        padding: EdgeInsets.all(3),
      );
      gValue.attLogs = await gValue.mongoDb.getAttLogs(timeBegin, timeEnd);
      setState(() {
        countNoName = 0;
        MyFuntion.calculateAttendanceStatus();
        rows = getRows(gValue.attLogs);
        stateManager.removeAllRows();
        stateManager.appendRows(rows);
        stateManager.setFilter(null);
        updateMode = 'auto';
        status =
            'Last update: ${DateFormat('HH:mm:ss').format(DateTime.now())}   Range Date : ${DateFormat('dd/MM/yyyy').format(timeBegin)} - ${DateFormat('dd/MM/yyyy').format(timeEnd)}';
      });
    } else if (updateMode == 'auto' &&
        isLoaded &&
        !checkIsFilter() &&
        timeBegin.day == DateTime.now().day) {
      // auto update when selected date range contain today
      List<AttLog> temp = await gValue.mongoDb.getAttLogs(timeBegin, timeEnd);

      if ((temp.length != gValue.attLogs.length)) {
        setState(() {
          rows = getRows(gValue.attLogs);
          stateManager.removeAllRows;
          stateManager.appendRows(rows);
          MyFuntion.calculateAttendanceStatus();
          status =
              'Last update: ${DateFormat('HH:mm:ss').format(DateTime.now())}   Range Date : ${DateFormat('dd/MM/yyyy').format(timeBegin)} - ${DateFormat('dd/MM/yyyy').format(timeEnd)}';
        });
      }
    }
    isLoaded = true;
    toastification.dismissAll();
    setState(() {
      exportTimeSheetDaysVisible = true;
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
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
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        status,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 200,
                width: 500,
                child: SfDateRangePicker(
                    cancelText: 'Cancel',
                    enableMultiView: true,
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                        enableSwipeSelection: true,
                        showWeekNumber: false,
                        firstDayOfWeek: 1,
                        weekendDays: [7]),
                    view: DateRangePickerView.month,
                    showTodayButton: false,
                    minDate: DateTime.utc(2023, 12, 26),
                    maxDate: DateTime.now(),
                    backgroundColor: Colors.blue[100],
                    todayHighlightColor: Colors.green,
                    selectionColor: Colors.orange,
                    headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor: Colors.blue[200],
                    ),
                    onSelectionChanged: (args) {
                      setState(() {
                        exportTimeSheetDaysVisible = false;
                      });
                      updateMode = 'manual';
                      timeBegin = args.value.startDate;
                      timeEnd = args.value.endDate ?? args.value.startDate;

                      gValue.logger.t(
                          'onSelectionChanged :\n Input ${args.value}\n Output timeBegin: $timeBegin, timeEnd: $timeEnd  ');
                    },
                    onSubmit: (value) {
                      refreshData(timeBegin, timeEnd, updateMode);
                    },
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(timeBegin, timeEnd),
                    showActionButtons: true,
                    onCancel: () {
                      setState(() {
                        timeBegin =
                            DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
                          hour: 0,
                          minute: 0,
                        ));
                        timeEnd =
                            DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
                          hour: 23,
                          minute: 59,
                        ));
                        toastification.dismissAll();
                      });
                    }),
              ),
              const Divider(),
              SizedBox(
                height: 40,
                child: Row(children: [
                  Visibility(
                    visible: timeBegin.day == DateTime.now().day,
                    child: TextButton.icon(
                      onPressed: () async {
                        if (gValue.attLogs.isEmpty) {
                          toastification.show(
                            context: context,
                            type: ToastificationType.warning,
                            style: ToastificationStyle.flatColored,
                            autoCloseDuration: Duration(seconds: 2),
                            title: const Text(
                              'Data is loading ...',
                            ),
                            showProgressBar: true,
                            progressBarTheme:
                                ProgressIndicatorThemeData(color: Colors.green),
                            // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
                            showIcon: true,
                            description:
                                Text('Data not yet loaded, try again!'),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                          );
                        } else {
                          List<Employee> absents = [];
                          for (var empId in gValue.employeeIdAbsents) {
                            absents.add(gValue.employees.firstWhere(
                                (element) => element.empId == empId));
                          }
                          gValue.logger.t('timeBegin : $timeBegin');
                          gValue.logger.t('timeEnd : $timeEnd');
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
                        toastification.show(
                          context: context,
                          type: ToastificationType.info,
                          style: ToastificationStyle.flatColored,
                          autoCloseDuration: Duration(seconds: 5),
                          title: const Text(
                            'Data is loading ...',
                          ),
                          showProgressBar: true,
                          progressBarTheme:
                              ProgressIndicatorThemeData(color: Colors.green),
                          // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
                          showIcon: true,
                          description: Text('From $timeBegin to $timeEnd'),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(3),
                        );

                        List<OtRegister> otRegister = await gValue.mongoDb
                            .getOTRegisterByRangeDate(timeBegin, timeEnd);

                        List<String> employeeIdFilter = [];

                        if (checkIsFilter()) {
                          for (var row in stateManager.refRows) {
                            var tempJson = row.toJson();
                            employeeIdFilter.add(tempJson['empId']);
                          }
                          employeeIdFilter = employeeIdFilter.toSet().toList();
                        }
                        MyFile.createExcelTimeSheet(
                            MyFuntion.createTimeSheetsDate(
                                gValue.employees,
                                gValue.shifts,
                                gValue.shiftRegisters,
                                otRegister,
                                gValue.leaveRegisters,
                                gValue.attLogs,
                                timeBegin,
                                timeEnd,
                                employeeIdFilter),
                            'Timesheets from ${DateFormat('dd-MMM-yyyy').format(timeBegin)} to ${DateFormat('dd-MMM-yyyy').format(timeEnd)} ${DateFormat('hhmmss').format(DateTime.now())}');
                        toastification.dismissAll();
                      },
                      icon: const Icon(
                        Icons.timelapse,
                        color: Colors.blueAccent,
                      ),
                      label: Text(labelExportTimesheetsDays),
                    ),
                  ),
                ]),
              ),
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
                        var dateBegin = 26;
                        var dateEnd = 25;
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
                          context: context,
                          type: ToastificationType.info,
                          style: ToastificationStyle.flatColored,
                          autoCloseDuration: Duration(seconds: 10),
                          title: const Text(
                            'Data is loading ...',
                          ),
                          showProgressBar: true,
                          progressBarTheme:
                              ProgressIndicatorThemeData(color: Colors.green),
                          // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
                          showIcon: true,
                          description: Text('From $begin to $end'),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(3),
                        );
                        List<OtRegister> otRegister1 = await gValue.mongoDb
                            .getOTRegisterByRangeDate(begin, end);

                        List<AttLog> attLogs1 =
                            await gValue.mongoDb.getAttLogs(begin, end);
                        gValue.logger.t('${otRegister1.length}');
                        gValue.logger.t('${attLogs1.length}');
                        MyFile.createExcelTimeSheet(
                            MyFuntion.createTimeSheetsDate(
                                gValue.employees,
                                gValue.shifts,
                                gValue.shiftRegisters,
                                otRegister1,
                                gValue.leaveRegisters,
                                attLogs1,
                                begin,
                                end, []),
                            'Timesheets $selectedMonth ${DateFormat('yyyyMMddhhmmss').format(DateTime.now())}');
                        toastification.dismissAll();
                      },
                      icon: const Icon(
                        Icons.timelapse_sharp,
                        color: Colors.greenAccent,
                      ),
                      label: Text(labelExportTimesheetsMonth))
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
                            context: context,
                            type: ToastificationType.warning,
                            style: ToastificationStyle.flatColored,
                            autoCloseDuration: Duration(seconds: 2),
                            title: const Text(
                              'Waring',
                            ),
                            showProgressBar: true,
                            progressBarTheme:
                                ProgressIndicatorThemeData(color: Colors.red),
                            // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
                            showIcon: true,
                            description: Text(
                                'Bạn không có quyền sử dụng chức năng này !'),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
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
                                                      gValue.logger.t(
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
                                      updateMode = 'manual';
                                      refreshData(
                                          timeBegin, timeEnd, updateMode);
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.info,
                                        style: ToastificationStyle.flatColored,
                                        autoCloseDuration: Duration(seconds: 2),
                                        title: const Text(
                                          'Adding attendance log',
                                        ),
                                        showProgressBar: true,
                                        progressBarTheme:
                                            ProgressIndicatorThemeData(
                                                color: Colors.green),
                                        // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
                                        showIcon: true,
                                        description: Text(
                                            '$empId   $empName: time: $time'),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(3),
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
                                    updateMode = 'manual';
                                    refreshData(timeBegin, timeEnd, updateMode);
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.info,
                                      style: ToastificationStyle.flatColored,
                                      autoCloseDuration: Duration(seconds: 2),
                                      title: const Text(
                                        'Adding attendance log',
                                      ),
                                      showProgressBar: true,
                                      progressBarTheme:
                                          ProgressIndicatorThemeData(
                                              color: Colors.green),
                                      // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
                                      showIcon: true,
                                      description: Text(
                                          '$empId   $empName: time: $time'),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(3),
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
                        gValue.logger
                            .t('(gValue.attLogs : ${gValue.attLogs.length}');
                        MyFile.createExcelAttLog(
                            gValue.attLogs
                                .where((log) => log.empId.contains('TIQN'))
                                .toList(),
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

                          MyFile.createExcelAttLog(
                              attLogs
                                  .where((log) => log.empId.contains('TIQN'))
                                  .toList(),
                              'Attendance logs');
                        },
                        label: const Text('Export current filter')),
                    TextButton.icon(
                      onPressed: () async {
                        if (gValue.accessMode != 'edit') {
                          toastification.show(
                            context: context,
                            type: ToastificationType.warning,
                            style: ToastificationStyle.flatColored,
                            autoCloseDuration: Duration(seconds: 2),
                            title: const Text(
                              'Waring',
                            ),
                            showProgressBar: true,
                            progressBarTheme:
                                ProgressIndicatorThemeData(color: Colors.red),
                            // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
                            showIcon: true,
                            description: Text(
                                'Bạn không có quyền sử dụng chức năng này !'),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
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
                      ?
                      // Text(
                      //     'Enrolled: ${gValue.enrolled}\nPresent: ${gValue.employeeIdPresents.length}\nMaternity Leaves: ${gValue.employeeIdMaternityLeaves.length}\nAbsents : ${gValue.employeeIdAbsents.length}',
                      //   )
                      chartPresent(
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
                  'Machine 7 : ${gValue.attLogs.where((log) => log.machineNo == 7).length}')
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
            // columnFilter: PlutoGridColumnFilterConfig(),
          ),
          columns: columns,
          rows: rows,
          onChanged: (PlutoGridOnChangedEvent event) {
            gValue.logger.t('onChanged  :$event');
            // setState(() {
            //   checkIsFilter()
            //       ? labelExportTimesheetsDays =
            //           'Export timesheets - days : Filtered : ${stateManager.refRows.length} records'
            //       : labelExportTimesheetsDays = 'Export timesheets - days';
            // });
          },
          onRowDoubleTap: (event) {
            gValue.logger.t('onRowDoubleTap');
          },
          onLoaded: (PlutoGridOnLoadedEvent event) {
            gValue.logger.t('onLoaded');
            firstBuild = false;
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
            gValue.logger.t('rows lenght : ${rows.length}');
          },
          onSelected: (event) {
            gValue.logger.t('onSelected  :$event');
          },
          onSorted: (event) {
            gValue.logger.t('onSorted  :$event');
          },
          // on filter
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
                          gValue.logger.t('onPressed: $row');
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
                          gValue.logger.t(
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
                          updateMode = 'manual';
                          refreshData(timeBegin, timeEnd, updateMode);

                          String log =
                              'UPDATE attendance log : ${row['attFingerId']}  ${row['timeStamp']} : "No Emp Id" to  $empIdUpdate,  "No Name" to   $empNameUpdate   ';
                          await MyFuntion.insertHistory(log);
                          toastification.show(
                            context: context,
                            type: ToastificationType.info,
                            style: ToastificationStyle.flatColored,
                            autoCloseDuration: Duration(seconds: 4),
                            title: const Text(
                              'Info',
                            ),
                            showProgressBar: true,
                            progressBarTheme:
                                ProgressIndicatorThemeData(color: Colors.green),
                            // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
                            showIcon: true,
                            description: Text(log),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                          );
                        },
                      )
                    : Container(),
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outlined,
                  ),
                  onPressed: () {
                    if (gValue.accessMode != 'edit') {
                      toastification.show(
                        context: context,
                        type: ToastificationType.warning,
                        style: ToastificationStyle.flatColored,
                        autoCloseDuration: Duration(seconds: 2),
                        title: const Text(
                          'Info',
                        ),
                        showProgressBar: true,
                        progressBarTheme:
                            ProgressIndicatorThemeData(color: Colors.red),
                        // icon: Icon(Icons.error_sharp, color: Colors.redAccent),
                        showIcon: true,
                        description:
                            Text('Bạn không có quyền sử dụng chức năng này !'),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(3),
                      );
                      return;
                    }
                    var row = rendererContext.row.toJson();
                    gValue.logger.t(row);
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
                        timeStamp = DateTime.parse(row['timeStamp'].toString());
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
                                  row['objectId'].toString().substring(10, 34));
                              await MyFuntion.insertHistory(
                                  'DELETE attendance log : ${row['attFingerId']}    ${row['empId']}   ${row['name']}    ${row['timeStamp']}');
                              setState(() {
                                rendererContext.stateManager
                                    .removeRows([rendererContext.row]);
                              });
                              updateMode = 'manual';
                              refreshData(timeBegin, timeEnd, updateMode);
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

  List<DateTime> getDateRangeSimple(String dateRangeString) {
    gValue.logger.t('getDateRangeSimple : $dateRangeString');
    // dateRange = 'PickerDateRange#6494f(startDate: 2025-07-18 00:00:00.000, endDate: 2025-07-18 00:00:00.000)'
    List<DateTime> result = [];

    try {
      // Tìm vị trí của startDate và endDate
      int startIndex = dateRangeString.indexOf('startDate:');
      int endIndex = dateRangeString.indexOf('endDate:');

      if (startIndex == -1 || endIndex == -1) {
        throw Exception('Invalid date range format');
      }

      // Extract startDate
      String startDatePart = dateRangeString
          .substring(startIndex + 'startDate:'.length, endIndex)
          .trim();

      // Remove dấu phẩy cuối nếu có
      startDatePart = startDatePart.replaceAll(',', '').trim();

      DateTime startDate = DateTime.parse(startDatePart);
      result.add(startDate);

      // Extract endDate
      String endDatePart =
          dateRangeString.substring(endIndex + 'endDate:'.length).trim();

      // Remove dấu ngoặc đóng và khoảng trắng
      endDatePart = endDatePart.replaceAll(')', '').trim();

      if (endDatePart != 'null') {
        DateTime endDate = DateTime.parse(endDatePart);
        result.add(endDate);
      }
    } catch (e) {
      gValue.logger.t('Error parsing date range string: $e');
    }

    return result;
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
        // gValue.logger.t('Error finding group for empId ${log.empId}: $e');
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
    gValue.logger
        .t('onSelectionChangedAddRecord : dateAddRecord: $dateAddRecord  ');
  }

  chartPresent(int workingNormal, int maternityLeave, int present, int absent) {
    Map<String, double> dataMap = {
      "Maternity leave": maternityLeave.toDouble(),
      "Present": present.toDouble(),
      "Absent": absent.toDouble(),
    };
    List<Color> colorList = [
      Colors.purpleAccent,
      Colors.green[400]!,
      Colors.orange,
    ];
    return Container(
        margin: const EdgeInsets.all(8),
        width: 500,
        height: 250,
        padding: const EdgeInsets.all(8),
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.disc,
          ringStrokeWidth: 32,
          centerText: "Enrolled: ${workingNormal + maternityLeave}",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            // legendShape: _BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: true,
            decimalPlaces: 0,
          ),
        ));
  }

  void parseDateRangeString(String dateRangeString) {
    try {
      gValue.logger.t('parseDateRangeString Input: $dateRangeString');

      // Parse string để lấy startDate và endDate
      List<DateTime> dates = [];

      // RegExp để extract startDate và endDate
      final RegExp regExp = RegExp(
          r'startDate:\s*(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}\.\d{3}),\s*endDate:\s*(null|\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}\.\d{3})');

      final match = regExp.firstMatch(dateRangeString);

      if (match != null) {
        // Extract startDate
        String startDateStr = match.group(1)!;
        DateTime startDate = DateTime.parse(startDateStr);
        dates.add(startDate);

        gValue.logger.t('Parsed startDate: $startDate');

        // Extract endDate nếu không phải null
        String? endDateStr = match.group(2);
        if (endDateStr != null && endDateStr != 'null') {
          DateTime endDate = DateTime.parse(endDateStr);
          dates.add(endDate);
          gValue.logger.t('Parsed endDate: $endDate');
        } else {
          gValue.logger.t('endDate is null');
        }
      } else {
        gValue.logger.w('RegExp không match với input string');
      }

      // Gán giá trị cho timeBegin và timeEnd
      if (dates.isNotEmpty) {
        timeBegin = dates[0];

        if (dates.length > 1) {
          timeEnd = dates[1];
        } else {
          timeEnd = dates[0]; // Nếu chỉ có startDate thì timeEnd = timeBegin
        }
      } else {
        // Nếu không parse được thì set về today
        DateTime today = DateTime.now();
        timeBegin = today;
        timeEnd = today;
        gValue.logger.w('Không parse được dates, fallback to today');
      }
    } catch (e) {
      // Nếu có lỗi thì set cả hai về today
      DateTime today = DateTime.now();
      timeBegin = today;
      timeEnd = today;
      gValue.logger.e('Error parsing date range: $e');
    }

    // Apply time of day
    timeBegin = timeBegin!.appliedFromTimeOfDay(const TimeOfDay(
      hour: 0,
      minute: 0,
    ));
    timeEnd = timeEnd!.appliedFromTimeOfDay(const TimeOfDay(
      hour: 23,
      minute: 59,
    ));

    // Log kết quả
    gValue.logger.t(
        'parseDateRangeString Output - timeBegin: $timeBegin, timeEnd: $timeEnd');
  }
}
