import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tiqn/database/history.dart';
import 'package:tiqn/gValue.dart';

class HistoryUI extends StatefulWidget {
  const HistoryUI({super.key});

  @override
  State<HistoryUI> createState() => _HistoryUIState();
}

class _HistoryUIState extends State<HistoryUI> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  bool firstBuild = true;
  late final PlutoGridStateManager stateManager;
  @override
  void initState() {
    // TODO: implement initState
    columns = getColumns();
    rows = getRows(gValue.history);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () async {
            gValue.history = await gValue.mongoDb.getHistoryAll();
            setState(() {
              rows = getRows(gValue.history);
              stateManager.removeRows(stateManager.rows);
              stateManager.appendRows(rows);
            });
          },
          icon: const Icon(
            Icons.refresh_outlined,
            size: 40,
            color: Colors.greenAccent,
          ),
          label: const Text('Refresh'),
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
            firstBuild = false;
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
          },
          onSelected: (event) {
            print('onSelected  :$event');
          },
          onSorted: (event) {
            print('onSorted  :$event');
          },
        )),
      ],
    );
  }

  List<PlutoColumn> getColumns() {
    List<PlutoColumn> columns = [];
    columns = [
      PlutoColumn(
          title: 'PC Name',
          field: 'pcName',
          type: PlutoColumnType.text(),
          width: 100),
      PlutoColumn(
          title: 'Time',
          field: 'time',
          type: PlutoColumnType.text(),
          width: 170),
      PlutoColumn(
          title: 'Log',
          field: 'log',
          type: PlutoColumnType.text(),
          width: 1100),
    ];
    return columns;
  }

  List<PlutoRow> getRows(List<History> data) {
    List<PlutoRow> rows = [];
    for (var log in data.reversed) {
      rows.add(
        PlutoRow(
          cells: {
            // 'id': PlutoCell(value: log.objectId),
            'pcName': PlutoCell(value: log.pcName),
            'time': PlutoCell(
                value: DateFormat("yyyy-MM-dd HH:mm:ss").format(log.time)),
            'log': PlutoCell(value: log.log),
          },
        ),
      );
    }

    return rows;
  }
}
