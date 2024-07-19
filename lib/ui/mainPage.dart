import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/ui/carBooking.dart';
import 'package:tiqn/ui/gateControl.dart';
import 'package:tiqn/ui/hrUI.dart';
import 'package:tiqn/ui/myWidget.dart';
import 'package:tiqn/ui/production.dart';
import 'package:tiqn/ui/roomBooking.dart';
import 'package:tiqn/ui/setting.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController(initialPage: 0);

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // gValue.realmService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              alwaysShowFooter: true,
              controller: sideMenu,
              style: SideMenuStyle(
                  itemBorderRadius:
                      const BorderRadius.all(Radius.circular(5.0)),
                  arrowOpen: Colors.white,
                  showTooltip: true,
                  displayMode: SideMenuDisplayMode.auto,
                  showHamburger: true,
                  hoverColor: Colors.white,
                  selectedHoverColor: Colors.blue[200],
                  selectedColor: Colors.lightBlue,
                  selectedTitleTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  selectedIconColor: Colors.white,
                  itemOuterPadding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  backgroundColor: Colors.blue[100]),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    gValue.appName,
                    textAlign: TextAlign.center,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 150,
                      maxWidth: 150,
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                  const Divider(
                    indent: 8.0,
                    endIndent: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
              footer: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyWidget.digitalClock(context),
                    Text(
                      'Version: ${gValue.packageInfo.version}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
              items: [
                // SideMenuItem(
                //   iconWidget: Image.asset('assets/images/home.png'),
                //   title: 'Home',
                //   onTap: (index, _) {
                //     sideMenu.changePage(index);
                //   },
                //   // icon: const Icon(Icons.fingerprint),
                //   badgeContent: const Text(
                //     '9',
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   tooltipContent: "This is a tooltip for Dashboard item",
                // ),
                // SideMenuItem(
                //   builder: (context, displayMode) {
                //     return const Divider(
                //       endIndent: 8,
                //       indent: 8,
                //       color: Colors.white,
                //     );
                //   },
                // ),
                SideMenuItem(
                  iconWidget: Image.asset('assets/images/Employee.png'),
                  title: 'HR',
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                  // icon: const Icon(Icons.fingerprint),
                  badgeContent: const Text(
                    '9',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SideMenuItem(
                  builder: (context, displayMode) {
                    return const Divider(
                      endIndent: 8,
                      indent: 8,
                      color: Colors.white,
                    );
                  },
                ),
                SideMenuExpansionItem(
                  title: "Booking",
                  icon: const Icon(Icons.kitchen),
                  children: [
                    SideMenuItem(
                      title: 'Car',
                      iconWidget: Image.asset('assets/images/Car Booking.png'),
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      badgeContent: const Text(
                        '3',
                        style: TextStyle(color: Colors.white),
                      ),
                      tooltipContent: "Expansion Item 1",
                    ),
                    SideMenuItem(
                      title: 'Meeting Room',
                      iconWidget:
                          Image.asset('assets/images/Meeting Room Booking.png'),
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                    )
                  ],
                ),
                SideMenuItem(
                  title: 'Gate control',
                  iconWidget: Image.asset('assets/images/Gate Control.png'),
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
                SideMenuItem(
                  builder: (context, displayMode) {
                    return const Divider(
                      endIndent: 8,
                      indent: 8,
                      color: Colors.white,
                    );
                  },
                ),
                SideMenuItem(
                  title: 'Production',
                  iconWidget: Image.asset('assets/images/Sewing Machine.png'),
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
                SideMenuItem(
                  builder: (context, displayMode) {
                    return const Divider(
                      endIndent: 8,
                      indent: 8,
                      color: Colors.white,
                    );
                  },
                ),
                SideMenuItem(
                  title: 'Settings',
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            const VerticalDivider(
              width: 5,
              color: Colors.white,
            ),
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  print('Page index:$value');
                },
                controller: pageController,
                children: const [
                  // HomePage(),
                  // SizedBox
                  //     .shrink(), // this is for SideMenuItem with builder (divider)
                  HRUI(),

                  SizedBox
                      .shrink(), // this is for SideMenuItem with builder (divider)
                  CarBooking(),
                  RoomBooking(),
                  GateControl(),
                  SizedBox
                      .shrink(), // this is for SideMenuItem with builder (divider)
                  Production(), SizedBox.shrink(),
                  Setting(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
