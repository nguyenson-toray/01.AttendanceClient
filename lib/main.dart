import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/tools/myFunction.dart';
import 'package:tiqn/ui/hrUI.dart';
import 'package:window_manager/window_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(1280, 720));
    WindowManager.instance.setTitle('Author: Sơn.NT');
  }
  await initPackageInfo();
  print(gValue.packageInfo.toString());
  gValue.pcName = Platform.localHostname;
  WidgetsFlutterBinding.ensureInitialized();
  // await gValue.realmService.initRealm();
  await gValue.mongoDb.initDB();
  runApp(const MyApp());
}

extension DateTimeFromTimeOfDay on DateTime {
  DateTime appliedFromTimeOfDay(TimeOfDay timeOfDay) {
    return DateTime.utc(year, month, day, timeOfDay.hour, timeOfDay.minute);
  }
}

Future<void> initPackageInfo() async {
  final info = await PackageInfo.fromPlatform();
  gValue.packageInfo = info;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: gValue.isConectedDb ? const HRUI() : MyFuntion.showError(''),
      debugShowCheckedModeBanner: false,
      // localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // supportedLocales: const [
      //   Locale('en', ''),
      //   Locale('vi', ''),
      //   Locale('jp', ''),
      // ]
    );
  }
}
