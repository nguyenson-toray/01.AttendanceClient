import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/main.dart';
import 'package:tiqn/tools/myFunction.dart';
import 'package:tiqn/ui/historyUI.dart';
import 'package:tiqn/ui/attLogUI.dart';
import 'package:tiqn/ui/employeeUI.dart';
import 'package:tiqn/ui/leaveRegisterUI.dart';
import 'package:tiqn/ui/otRegisterUI.dart';
import 'package:tiqn/ui/settingUI.dart';
import 'package:tiqn/ui/shiftRegisterUI.dart';
import 'package:tiqn/ui/timesheetsUI.dart';

class HRUI extends StatefulWidget {
  const HRUI({super.key});

  @override
  State<HRUI> createState() => _HRUIState();
}

class _HRUIState extends State<HRUI>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(milliseconds: 200), () async {
      gValue.screenWidth = MediaQuery.of(context).size.width;
      gValue.screenHeight = MediaQuery.of(context).size.height;
      print('screen size : ${gValue.screenWidth} x ${gValue.screenHeight}');
    });
    tabController = TabController(length: 7, vsync: this);
    // final department = jsonDecode(gValue.departmentJson);
    Future.delayed(const Duration(milliseconds: 300)).then((value) async => {
          gValue.accessMode =
              await gValue.mongoDb.checkPermission(gValue.pcName),
          getHrData()
        });
    checkDbState();
    // Timer.periodic(const Duration(minutes: 1), (_) => checkDbState());
    tabController.index = 0;
    super.initState();
  }

  Future<void> checkDbState() async {
    try {
      setState(() {
        gValue.isConectedDb = gValue.mongoDb.db.isConnected;
      });
      setState(() {
        gValue.isConectedDb = gValue.mongoDb.db.isConnected;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> getHrData() async {
    var timeBegin = DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
      hour: 0,
      minute: 0,
    ));
    var timeEnd = DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
      hour: 23,
      minute: 59,
    ));
    gValue.employees = await gValue.mongoDb.getEmployees();
    gValue.attLogs = await gValue.mongoDb.getAttLogs(timeBegin, timeEnd);
    gValue.shifts = await gValue.mongoDb.getShifts();
    gValue.shiftRegisters = await gValue.mongoDb.getShiftRegisterByYear(2025);
    gValue.history = await gValue.mongoDb.getHistoryByYear(2025);
    // gValue.otRegisters = await gValue.mongoDb.getOTRegisterByRangeDate(
    //     DateTime.utc(2024, 12, 26), timeBegin.add(const Duration(days: 30)));
    // gValue.leaveRegisters = await gValue.mongoDb.getLeaveRegister();
    gValue.monthYears = MyFuntion.getMonthYearList('2025');
    for (var month in gValue.monthYears) {
      gValue.timeSheetMonthYears[month] =
          await gValue.mongoDb.getTimesheetsMonthYear(month);
    }
    gValue.timeSheetMonthYears['2025'] =
        await gValue.mongoDb.getTimesheetsMonthYear('2025');
    setState(() {
      MyFuntion.calculateEmployeeStatus();
      MyFuntion.calculateAttendanceStatus();
      gValue.isLoadigBasicHrData = false;
    });
  }

  @override
  Future<void> dispose() async {
    tabController.dispose();

    await gValue.mongoDb.db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //calling super.build is required by the mixin.
    return DefaultTabController(
      initialIndex: 2,
      length: 3,
      child: gValue.isLoadigBasicHrData
          ? MyFuntion.showLoading()
          : Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                flexibleSpace: TabBar(
                    labelColor: Colors.teal,
                    unselectedLabelColor: Colors.black,
                    dividerHeight: 0,
                    controller: tabController,
                    indicatorColor: Colors.teal,
                    indicatorWeight: 5,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(
                        icon: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.blueAccent,
                        ),
                        text: "Employees",
                      ),
                      Tab(
                        icon: Icon(
                          Icons.fingerprint,
                          color: Colors.green,
                        ),
                        text: "Attendance",
                      ),
                      Tab(
                        icon: Icon(
                          Icons.work,
                          color: Colors.orangeAccent,
                        ),
                        text: "Overtime",
                      ),
                      // Tab(
                      //   icon: Icon(
                      //     Icons.work_off,
                      //     color: Colors.red,
                      //   ),
                      //   text: "Leave",
                      // ),
                      Tab(
                        icon: Icon(
                          Icons.work_history,
                          color: Colors.purpleAccent,
                        ),
                        text: "Shift",
                      ),
                      Tab(
                        icon: Icon(
                          Icons.timeline,
                          color: Colors.red,
                        ),
                        text: "Timesheets",
                      ),
                      Tab(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.blueGrey,
                        ),
                        text: "Setting",
                      ),
                      Tab(
                        icon: Icon(
                          Icons.history,
                          color: Colors.pink,
                        ),
                        text: "History",
                      ),
                    ]),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: gValue.isConectedDb ? 0 : 1,
                          child: const LinearProgressIndicator(
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 90,
                          width: double.maxFinite,
                          child: TabBarView(
                            controller: tabController,
                            children: const [
                              EmployeeUI(),
                              AttLogUI(),
                              OtRegisterUI(),
                              // LeaveRegisterUI(),
                              ShiftRegisterUI(), TimesheetsUI(),
                              SettinngUi(), HistoryUI()

                              // ScanQr()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  gValue.accessMode == 'no'
                      ? MyFuntion.showErrorPermission()
                      : Positioned(
                          bottom: 2,
                          right: 10,
                          child: Text(
                            'Version: ${gValue.packageInfo.version}',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[700]),
                          ),
                        )
                ],
              ),
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
