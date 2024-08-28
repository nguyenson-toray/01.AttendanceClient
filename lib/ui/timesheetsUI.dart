import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/timeSheetDate.dart';
import 'package:tiqn/database/timeSheetMonthYear.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/tools/myFunction.dart';
import 'package:tiqn/tools/myfile.dart';
import 'package:toastification/toastification.dart';

class TimesheetsUI extends StatefulWidget {
  const TimesheetsUI({super.key});

  @override
  State<TimesheetsUI> createState() => _TimesheetsUIState();
}

class _TimesheetsUIState extends State<TimesheetsUI> {
  late PlutoGridStateManager stateManager;
  bool expandYear = false,
      isLoading = false,
      firstBuild = true,
      showLoading = true;
  int expandMonth = 0;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  List<PlutoRow> rowsYear = [];
  List<TimeSheetMonthYear> yearData = [];
  double maxOtYear = 0;

  @override
  void initState() {
    // TODO: implement initState
    columns = getColumns();
    yearData = gValue.timeSheetMonthYears['2024']!;
    maxOtYear =
        yearData.fold<double>(0, (max, e) => e.otHours > max ? e.otHours : max);
    rowsYear = getRows(yearData);
    Timer.periodic(const Duration(seconds: 10), (_) => refreshData());
    super.initState();
  }

  refreshData() async {
    Map<String, List<TimeSheetMonthYear>> temp = {};
    for (var month in gValue.monthYears) {
      gValue.mongoDb.getTimesheetsMonthYear(month).then(
        (value) {
          temp[month] = value;
        },
      );
    }
    gValue.mongoDb.getTimesheetsMonthYear('2024').then(
      (value2024) {
        temp['2024'] = value2024;
        if (mounted &&
            temp.toString() != gValue.timeSheetMonthYears.toString()) {
          toastification.show(
            backgroundColor: Colors.greenAccent,
            alignment: Alignment.center,
            context: context,
            title: const Text('Data updating...'),
            autoCloseDuration: const Duration(seconds: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.green,
                blurRadius: 16,
                offset: Offset(0, 16),
                spreadRadius: 0,
              )
            ],
          );
          setState(() {
            gValue.timeSheetMonthYears = temp;
            yearData = gValue.timeSheetMonthYears['2024']!;
            maxOtYear = yearData.fold<double>(
                0, (max, e) => e.otHours > max ? e.otHours : max);
            rowsYear = getRows(yearData);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Max OT allowed : 300h/year - 40h/month'),
                  const Text('Highlight color by current OT hours : '),
                  Container(
                    padding: const EdgeInsets.all(2),
                    color: Colors.redAccent,
                    child: const Text(
                      '>= 100% : red',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    color: Colors.orangeAccent,
                    child: const Text(
                      '>= 75% : orange',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    color: Colors.greenAccent,
                    child: const Text(
                      '< 75% : green',
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Card(
              elevation: 8,
              color: getColorByPercent(maxOtYear, 300, false),
              child: SizedBox(
                  height: expandYear ? 600 : 50,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: 95,
                            child: const Text(
                              'YEAR 2024',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            height: maxOtYear >= 300 ? 25 : 0,
                            child: Image.asset('assets/images/warningRed.gif'),
                          ),
                          SizedBox(
                            width: 200,
                            child: TextButton.icon(
                              icon: Icon(expandYear
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                              label: Text(expandYear
                                  ? 'Minimize window'
                                  : 'Open window '),
                              onPressed: () {
                                setState(() {
                                  expandYear = !expandYear;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 250,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Highest overtime : ${maxOtYear.round()} hours\n' 'Last update at : ${DateFormat('dd-MMM-yyyy hh:mm:ss').format(gValue.timeSheetMonthYears['2024']!.first.lastUpdate.add(const Duration(hours: 7)))}'),
                          ),
                          // gValue.timeSheetMonthYears['2024']!.isNotEmpty
                          //     ? Text(
                          //         'Last update at : ${DateFormat('dd-MMM-yyyy hh:mm:ss').format(gValue.timeSheetMonthYears['2024']!.first.lastUpdate.add(Duration(hours: 7)))}')
                          //     : Container(),
                          expandYear
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: TextButton.icon(
                                        icon: const Icon(Icons.download),
                                        label: const Text('Export data '),
                                        onPressed: () {
                                          MyFile.createExcelTimeSheetYear(
                                              yearData, '2024');
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: TextButton.icon(
                                        icon: const Icon(Icons.update),
                                        label: const Text('Update data'),
                                        onPressed: () async {
                                          yearData =
                                              MyFuntion.createTimeSheetsYear(
                                                  gValue.timeSheetMonthYears,
                                                  '2024');
                                          await gValue.mongoDb
                                              .updateTimesheetsMonthYear(
                                                  yearData, '2024');
                                          gValue.timeSheetMonthYears['2024'] =
                                              await gValue.mongoDb
                                                  .getTimesheetsMonthYear(
                                                      '2024');
                                          setState(() {
                                            rowsYear = getRows(yearData);
                                            stateManager
                                                .removeRows(stateManager.rows);
                                            stateManager.appendRows(rowsYear);
                                            stateManager.sortDescending(
                                                PlutoColumn(
                                                    title: 'OT Actual',
                                                    field: 'otActual',
                                                    type: PlutoColumnType
                                                        .number()));
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
                      expandYear
                          ? Expanded(
                              child: PlutoGrid(
                                  mode: PlutoGridMode.readOnly,
                                  configuration: const PlutoGridConfiguration(
                                    enterKeyAction: PlutoGridEnterKeyAction
                                        .editingAndMoveRight,
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
                                  columns: getColumns(),
                                  rows: getRows(yearData),
                                  onChanged: (PlutoGridOnChangedEvent event) {
                                    print('onChanged  :$event');
                                  },
                                  onRowDoubleTap: (event) {
                                    print('onRowDoubleTap');
                                  },
                                  onLoaded: (PlutoGridOnLoadedEvent event) {
                                    print(' Timesheets - onLoaded');
                                    // firstBuild = false;
                                    stateManager = event.stateManager;
                                    stateManager.setShowColumnFilter(true);
                                    stateManager.sortDescending(PlutoColumn(
                                        title: 'OT Actual',
                                        field: 'otActual',
                                        type: PlutoColumnType.number()));
                                  },
                                  onSelected: (event) {
                                    print('onSelected  :$event');
                                  },
                                  onSorted: (event) {
                                    print('onSorted  :$event');
                                  },
                                  rowColorCallback: (rowColorContext) {
                                    var value = rowColorContext
                                        .row.cells.entries
                                        .elementAt(7)
                                        .value
                                        .value;
                                    return getColorByPercent(
                                        double.parse(value.toString()),
                                        300,
                                        true);
                                  }))
                          : Container()
                    ],
                  )),
            ),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var monthName = gValue.monthYears[index];
                List<TimeSheetMonthYear> dataMonth = [];

                dataMonth = gValue.timeSheetMonthYears[monthName]
                    as List<TimeSheetMonthYear>;
                final maxOt = dataMonth.fold<double>(
                    0, (max, e) => e.otHours > max ? e.otHours : max);
                String info = 'Highest overtime : ${maxOt.round()} hours\n';
                info += gValue.timeSheetMonthYears[monthName]!.isNotEmpty
                    ? 'Last update at : ${DateFormat('dd-MMM-yyyy hh:mm:ss').format(gValue.timeSheetMonthYears[monthName]!.first.lastUpdate.add(const Duration(hours: 7)))}'
                    : '';

                return Card(
                  elevation: 8,
                  margin: const EdgeInsets.fromLTRB(2, 2, 0, 0),
                  color: Colors.white,
                  child: SizedBox(
                      height: expandMonth == index ? 800 : 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  backgroundColor:
                                      getColorByPercent(maxOt, 40, false),
                                  radius: 45,
                                  // padding: const EdgeInsets.all(5),
                                  // width: 150,
                                  // height: 100,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    monthName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                height: maxOt >= 40 ? 25 : 0,
                                child:
                                    Image.asset('assets/images/warningRed.gif'),
                              ),
                              SizedBox(
                                width: 200,
                                height: 25,
                                child: TextButton.icon(
                                  icon: Icon(expandMonth == index
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down),
                                  label: Text(expandMonth == index
                                      ? 'Minimize window'
                                      : 'Open window '),
                                  onPressed: () {
                                    print(
                                        ' onPressed-isLoading: $isLoading monthName=$monthName');
                                    print(gValue.timeSheetMonthYears[monthName]
                                        ?.length);
                                    setState(() {
                                      expandYear = false;
                                      expandMonth != index
                                          ? {
                                              expandMonth = index,
                                            }
                                          : expandMonth = 20;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: 250,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  info,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              expandMonth != index
                                  ? Container()
                                  : Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: TextButton.icon(
                                            icon: const Icon(Icons.download),
                                            label: const Text('Export data'),
                                            onPressed: () {
                                              exportMonnthTimesheets(monthName);
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: TextButton.icon(
                                            icon: const Icon(Icons.update),
                                            label: const Text('Update'),
                                            onPressed: () async {
                                              updateMonnthTimesheets(monthName);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                          expandMonth == index
                              ? Expanded(
                                  child: PlutoGrid(
                                      mode: PlutoGridMode.readOnly,
                                      configuration:
                                          const PlutoGridConfiguration(
                                        enterKeyAction: PlutoGridEnterKeyAction
                                            .editingAndMoveRight,
                                        scrollbar: PlutoGridScrollbarConfig(
                                          scrollbarThickness: 8,
                                          scrollbarThicknessWhileDragging: 20,
                                          isAlwaysShown: true,
                                        ),
                                        style: PlutoGridStyleConfig(
                                          rowColor: Colors.white,
                                          enableGridBorderShadow: true,
                                        ),
                                        columnFilter:
                                            PlutoGridColumnFilterConfig(),
                                      ),
                                      columns: getColumns(),
                                      rows: getRows(dataMonth),
                                      onChanged:
                                          (PlutoGridOnChangedEvent event) {
                                        print('onChanged  :$event');
                                      },
                                      onRowDoubleTap: (event) {
                                        print('onRowDoubleTap');
                                      },
                                      onLoaded: (PlutoGridOnLoadedEvent event) {
                                        print(' Timesheets - onLoaded');
                                        stateManager = event.stateManager;
                                        stateManager.setShowColumnFilter(true);
                                        stateManager.sortDescending(PlutoColumn(
                                            title: 'OT Actual',
                                            field: 'otActual',
                                            type: PlutoColumnType.number()));
                                      },
                                      onSelected: (event) {
                                        print('onSelected  :$event');
                                      },
                                      onSorted: (event) {
                                        print('onSorted  :$event');
                                      },
                                      rowColorCallback: (rowColorContext) {
                                        var value = rowColorContext
                                            .row.cells.entries
                                            .elementAt(7)
                                            .value
                                            .value;
                                        return getColorByPercent(
                                            double.parse(value.toString()),
                                            40.0,
                                            true);
                                      }))
                              : const SizedBox(
                                  height: 0,
                                  width: double.maxFinite,
                                )
                        ],
                      )),
                );
              },
              itemCount: MyFuntion.getMonthYearList().length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List<PlutoColumn> getColumns() {
    List<PlutoColumn> columns;
    columns = [
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
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Section',
        field: 'section',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Group',
        field: 'group',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          title: 'Line-Team',
          field: 'lineTeam',
          type: PlutoColumnType.text(),
          width: 120),
      PlutoColumn(
          title: 'Working',
          field: 'working',
          type: PlutoColumnType.number(),
          width: 120),
      PlutoColumn(
          enableSorting: true,
          sort: PlutoColumnSort.descending,
          title: 'OT Actual',
          field: 'otActual',
          type: PlutoColumnType.number(),
          width: 120),
      PlutoColumn(
          title: 'OT Approved',
          field: 'otApproved',
          type: PlutoColumnType.number(),
          width: 120),
      PlutoColumn(
          title: 'OT Final',
          field: 'otFinal',
          type: PlutoColumnType.number(),
          width: 120),
    ];
    return columns;
  }

  List<PlutoRow> getRows(List<TimeSheetMonthYear> data) {
    List<PlutoRow> rows = [];
    for (var element in data) {
      rows.add(
        PlutoRow(
          cells: {
            'empId': PlutoCell(value: element.empId),
            'name': PlutoCell(value: element.name),
            'department': PlutoCell(value: element.department),
            'section': PlutoCell(value: element.section),
            'group': PlutoCell(value: element.group),
            'lineTeam': PlutoCell(value: element.lineTeam),
            'working': PlutoCell(value: element.normalHours),
            'otActual': PlutoCell(value: element.otHours),
            'otApproved': PlutoCell(value: element.otHoursApproved),
            'otFinal': PlutoCell(value: element.otHoursFinal),
          },
        ),
      );
    }
    return rows;
  }

  getColorByPercent(double current, double max, bool normalColorWhite) {
    if (current / max >= 1) {
      return Colors.red[200];
    } else if (current / max >= 0.75)
      return Colors.orange[100];
    else if (normalColorWhite == true)
      return Colors.white;
    else
      return Colors.green[100];
  }

  updateMonnthTimesheets(String monthName) async {
    var yearEnd = DateFormat.yMMMM().parse(monthName).year;
    var monthEnd = DateFormat.yMMMM().parse(monthName).month;
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
    var begin = DateTime.utc(yearBegin, monBegin, dateBegin);
    toastification.show(
      backgroundColor: Colors.greenAccent,
      alignment: Alignment.center,
      context: context,
      title: const Text('Data is loading...'),
      autoCloseDuration: const Duration(seconds: 5),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(6, 93, 250, 87),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
    );
    List<OtRegister> otRegisters =
        await gValue.mongoDb.getOTRegisterByRangeDate(begin, end);

    List<AttLog> attLogs = await gValue.mongoDb.getAttLogs(begin, end);
    List<TimeSheetDate> timeSheetDates = MyFuntion.createTimeSheetsDate(
        gValue.employees,
        gValue.shifts,
        gValue.shiftRegisters,
        otRegisters,
        gValue.leaveRegisters,
        attLogs,
        begin,
        end);
    List<TimeSheetMonthYear> timeSheetMonth =
        MyFuntion.createTimeSheetsMonth(timeSheetDates, monthName);
    await gValue.mongoDb.updateTimesheetsMonthYear(timeSheetMonth, monthName);
    gValue.timeSheetMonthYears[monthName] =
        await gValue.mongoDb.getTimesheetsMonthYear(monthName);

    setState(() {
      rows = getRows(gValue.timeSheetMonthYears[monthName]!);
      stateManager.removeRows(stateManager.rows);
      stateManager.appendRows(rows);
      stateManager.sortDescending(PlutoColumn(
          title: 'OT Actual',
          field: 'otActual',
          type: PlutoColumnType.number()));
    });
  }

  exportMonnthTimesheets(String selectedMonth) async {
    var yearEnd = DateFormat.yMMMM().parse(selectedMonth).year;
    var monthEnd = DateFormat.yMMMM().parse(selectedMonth).month;
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
    var begin = DateTime.utc(yearBegin, monBegin, dateBegin);
    toastification.show(
      backgroundColor: Colors.greenAccent,
      alignment: Alignment.center,
      context: context,
      title: const Text('Data is loading...'),
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
    List<OtRegister> otRegister =
        await gValue.mongoDb.getOTRegisterByRangeDate(begin, end);

    List<AttLog> attLogs = await gValue.mongoDb.getAttLogs(begin, end);
    MyFile.createExcelTimeSheet(
        MyFuntion.createTimeSheetsDate(
            gValue.employees,
            gValue.shifts,
            gValue.shiftRegisters,
            otRegister,
            gValue.leaveRegisters,
            attLogs,
            begin,
            end),
        'Timesheets $selectedMonth ${DateFormat('yyyyMMddhhmmss').format(DateTime.now())}');
  }
}
