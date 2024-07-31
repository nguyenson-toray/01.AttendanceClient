import 'package:package_info_plus/package_info_plus.dart';
import 'package:tiqn/database/history.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/department.dart';
import 'package:tiqn/database/leaveRegister.dart';
import 'package:tiqn/database/mongoDb.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/shift.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:tiqn/database/timeSheet.dart';
import 'package:tiqn/database/timeSheetMonthYear.dart';

class gValue {
  // static _Config config = _Config(mainFuntion: "mainFuntion");
  static String accessMode = 'no'; //'no', 'read', 'edit'
  static String alertOTByActualFinal = 'Actual';
  static double screenWidth = 0, screenHeight = 0;
  static List<String> mainFuntions = [];
  static String appName = '';
  static String pcName = '';
  static List<History> history = [];
  static int enrolled = 0;
  static int inLate = 0;
  static int outEarly = 0;
  static int minOtMinutes = 30, maxOtMinutes = 240;
  static MongoDb mongoDb = MongoDb();
  static bool isConectedDb = false;
  static List<AttLog> attLogs = <AttLog>[];
  static List<TimeSheet> timeSheets = <TimeSheet>[];
  static List<Shift> shifts = <Shift>[];
  static List<ShiftRegister> shiftRegisters = <ShiftRegister>[];
  static List<OtRegister> otRegisters = <OtRegister>[];
  static List<LeaveRegister> leaveRegisters = <LeaveRegister>[];
  static bool miniInfoEmployee = true,
      disableEditEmp = true,
      showObjectId = false,
      shift12NoOt = true;
  // static double minHourOt = 0;
  // static int defaultOtMinutes = 0;
  // static List<AttReport> attReports = <AttReport>[];
  static Map<String, List<TimeSheetMonthYear>> timeSheetMonthYears = {};
  static bool isLoadigBasicHrData = true;
  static List<String> monthYears = [];
  static List<Employee> employees = <Employee>[];
  static List<String> employeeIdNames = [];
  static List<String> employeeIdAbsents = [];
  static List<String> employeeIdPresents = [];
  static List<String> employeeIdWorkings = [];
  static List<String> employeeIdMaternityLeaves = [];
  static List<String> employeeIdPregnantYoungchilds = [];
  static String urlUpdateApp = '';
  static String latestVersion = '';
  static String updateBinaryUrl = '';
  static String updateChangeLog = '';
  static int lastEmpId = 0, lastFingerId = 0;
  static List<String> logs = [];
  static PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  static List<String> departments = [
    "Operation Management",
    "Production",
    "Purchase",
    "QA",
    "Warehouse",
    "Factory Manager"
  ];
  static Department department = Department();
  static String departmentJson = '''
{
  "Operation Management": [
    "Accounting",
    "Canteen",
    "HR/GA",
    "Operation Management",
    "Supply chain management"
  ],
  "Production": [
    "Production",
    "Development&Production Technology",
    "Preparation",
    "Pattern"
  ],
  "Purchase": [
    "Purchase"
  ],
  "QA": [
    "QA",
    "QC"
  ],
  "Warehouse": [
    "Warehouse"
  ],
  "Factory Manager": [
    "Factory Manager"
  ]
}
  ''';
  static List<String> empsByPass = [
    'TIQN-1187',
    'TIQN-0967',
    'TIQN-0905',
    'TIQN-0879',
    'TIQN-0872',
    'TIQN-0795',
    'TIQN-0762',
    'TIQN-0752',
    'TIQN-0750',
    'TIQN-0748',
    'TIQN-0745',
    'TIQN-0741',
    'TIQN-0406',
    'TIQN-0375',
    'TIQN-0358',
    'TIQN-0357',
    'TIQN-0355',
    'TIQN-0354',
    'TIQN-0353',
    'TIQN-0349',
    'TIQN-0335',
    'TIQN-0331',
    'TIQN-0328',
    'TIQN-0307',
    'TIQN-0301',
    'TIQN-0299',
    'TIQN-0270',
    'TIQN-0263',
    'TIQN-0255',
    'TIQN-0251',
    'TIQN-0249',
    'TIQN-0245',
    'TIQN-0237',
    'TIQN-0236',
    'TIQN-0235',
    'TIQN-0234',
    'TIQN-0229',
    'TIQN-0217',
    'TIQN-0202',
    'TIQN-0201',
    'TIQN-0190',
    'TIQN-0149',
    'TIQN-0146',
    'TIQN-0144',
    'TIQN-0134',
    'TIQN-0132',
    'TIQN-0131',
    'TIQN-0127',
    'TIQN-0126',
    'TIQN-0125',
    'TIQN-0121',
    'TIQN-0118',
    'TIQN-0116',
    'TIQN-0112',
    'TIQN-0111',
    'TIQN-0110',
    'TIQN-0107',
    'TIQN-0101',
    'TIQN-0099',
    'TIQN-0098',
    'TIQN-0096',
    'TIQN-0088',
    'TIQN-0087',
    'TIQN-0085',
    'TIQN-0080',
    'TIQN-0078',
    'TIQN-0076',
    'TIQN-0070',
    'TIQN-0064',
    'TIQN-0062',
    'TIQN-0059',
    'TIQN-0058',
    'TIQN-0053',
    'TIQN-0052',
    'TIQN-0051',
    'TIQN-0049',
    'TIQN-0011'
  ];
}
