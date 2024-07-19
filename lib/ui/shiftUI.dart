import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tiqn/database/shift.dart';
import 'package:tiqn/gValue.dart';

class ShiftUI extends StatefulWidget {
  const ShiftUI({super.key});

  @override
  State<ShiftUI> createState() => _ShiftUIState();
}

class _ShiftUIState extends State<ShiftUI> with AutomaticKeepAliveClientMixin {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridMode plutoGridMode = PlutoGridMode.normal;
  late PlutoGridStateManager stateManager;
  bool firstBuild = true;
  @override
  void initState() {
    // TODO: implement initState
    columns = getColumns();
    Timer.periodic(const Duration(seconds: 2), (_) => refreshData());
    super.initState();
  }

  Future<void> refreshData() async {
    List<Shift> newList = await gValue.mongoDb.getShifts();
    if (newList.isEmpty) {
      return;
    } else if (gValue.shifts.length != newList.length) {
      gValue.shifts = newList;
      setState(() {
        if (!firstBuild) {
          print('ShiftUI Data changed => ${newList.length}');
          rows = getRows(gValue.shifts);

          stateManager.removeRows(stateManager.rows);
          stateManager.appendRows(rows);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlutoGrid(
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
        onLoaded: (PlutoGridOnLoadedEvent event) {
          print('onLoaded');
          firstBuild = false;
          stateManager = event.stateManager;
          stateManager.setShowColumnFilter(false);
        },
      ),
    );
  }

  List<PlutoColumn> getColumns() {
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

  List<PlutoRow> getRows(List<Shift> shifts) {
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
