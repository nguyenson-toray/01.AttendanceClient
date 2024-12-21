import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tiqn/gValue.dart';
import 'package:url_launcher/url_launcher.dart';

class SettinngUi extends StatefulWidget {
  const SettinngUi({super.key});

  @override
  State<SettinngUi> createState() => _SettinngUiState();
}

class _SettinngUiState extends State<SettinngUi> {
  List<String> minOtList = ['0', '15', '20', '25', '30'];
  List<String> maxOtList = [
    '30',
    '60',
    '90',
    '120',
    '150',
    '180',
    '210',
    '240'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Card(
            elevation: 8,
            child: ListTile(
              leading: InkWell(
                child: const Icon(
                  Icons.folder,
                  size: 40,
                  color: Colors.orange,
                ),
                onTap: () {
                  launch(
                      'file://T:/03.Department/01.Operation Management/03.HR-GA/01.HR/4. EMPLOYEE/7.OT request/01.Imported');
                },
              ),
              title: const Text('Folder save OT form'),
              subtitle: const Row(
                children: [
                  Text(
                      r'T:\03.Department\01.Operation Management\03.HR-GA\01.HR\4. EMPLOYEE\7.OT request\01.Imported'),
                ],
              ),
            ),
          ),
          Card(
            elevation: 8,
            child: ListTile(
              leading: InkWell(
                child: const Icon(
                  Icons.file_open,
                  size: 40,
                  color: Colors.greenAccent,
                ),
                onTap: () {
                  launch(
                      'file://T:/03.Department/01.Operation Management/03.HR-GA/01.HR/4. EMPLOYEE/7.OT request/01.OT summary-link data OT.xlsx');
                },
              ),
              title: const Text('File OT summary'),
              subtitle: const Row(
                children: [
                  Text(
                      r'T:\03.Department\01.Operation Management\03.HR-GA\01.HR\4. EMPLOYEE\7.OT request\01.OT summary-link data OT.xlsx'),
                ],
              ),
            ),
          ),
          Card(
            elevation: 8,
            child: ListTile(
              leading: InkWell(
                child: const Icon(
                  Icons.file_open,
                  size: 40,
                  color: Colors.pinkAccent,
                ),
                onTap: () {
                  launch(
                      'file://T:/02.Public/02.Form/1.Overtime request form_Ngay binh thuong.xlsx');
                },
              ),
              title: const Text('File form OT'),
              subtitle: const Row(
                children: [
                  Text(
                      r'T:\02.Public\02.Form\1.Overtime request form_Ngay binh thuong.xlsx'),
                ],
              ),
            ),
          ),
          Card(
            elevation: 8,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text('1'),
              ),
              title: Row(
                children: [
                  const Text('Shift 1 & 2 : Not allow OT'),
                  Checkbox(
                    value: gValue.shift12NoOt,
                    onChanged: (value) {
                      setState(() {
                        gValue.shift12NoOt = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 8,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.indigoAccent,
                child: Text('2'),
              ),
              title: const Text(
                  'OT minutes allow - Reset to default after exit app (Min : 30,  Max : 240)'),
              subtitle: Row(
                children: [
                  const Text('Min'),
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
                          items: minOtList
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
                          value: gValue.minOtMinutes.toString(),
                          onChanged: (String? value) {
                            setState(() {
                              gValue.minOtMinutes = int.parse(value!);
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
                  const Text('Max:'),
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
                          items: maxOtList
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
                          value: gValue.maxOtMinutes.toString(),
                          onChanged: (String? value) {
                            setState(() {
                              gValue.maxOtMinutes = int.parse(value!);
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
                ],
              ),
            ),
          ),

          /*  Card(
            elevation: 8,
            child: ListTile(
              leading: CircleAvatar(
                child: Text('3'),
                backgroundColor: Colors.tealAccent,
              ),
              title: Row(
                children: [
                  Text('Alert OT by:  Total hours actual'),
                  Radio(
                    value: 'Actual',
                    groupValue: gValue.alertOTByActualFinal,
                    onChanged: (value) {
                      setState(() {
                        gValue.alertOTByActualFinal = 'Actual';
                      });
                    },
                  ),
                  Text('     Total hours finnal'),
                  Radio(
                    value: 'Final',
                    groupValue: gValue.alertOTByActualFinal,
                    onChanged: (value) {
                      setState(() {
                        gValue.alertOTByActualFinal = 'Final';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        */
        ],
      ),
    );
  }
}
