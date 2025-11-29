import 'dart:math' as math;

import 'package:flutter/material.dart';

const double kTableHeadingHeight = 50.0;

typedef DataRowColorBuilder = Color Function(BuildContext context, int index);

class FlexibleDataTable extends StatelessWidget {
  /// The configuration and labels for the columns in the table.
  final List<DataColumn> columns;

  /// The data to show in each row (excluding the row that contains
  /// the column headings).
  ///
  /// Must be non-null, but may be empty.
  final List<DataRow> rows;

  final List<int>? flexes;

  final TextStyle? headingTextStyle;

  final TextStyle? dataTextStyle;

  final EdgeInsetsGeometry? dataRowPadding;

  FlexibleDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.flexes,
    this.headingTextStyle,
    this.dataTextStyle,
    this.dataRowPadding,
  })  : assert(columns.isNotEmpty),
        assert(!rows.any((DataRow row) => row.cells.length != columns.length)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle _headingTextStyle = headingTextStyle ??
        (Theme.of(context).textTheme.bodyLarge ?? const TextStyle());

    return Column(
      children: [
        SizedBox(
          height: kTableHeadingHeight,
          child: Row(
            children: List.generate(
              columns.length,
              (index) {
                final column = columns[index];
                return Expanded(
                  flex: _getFlexValue(index),
                  child: Center(
                    child: DefaultTextStyle(
                      style: _headingTextStyle,
                      child: column.label,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        ..._buildRows(context),
      ],
    );
  }

  int _getFlexValue(int index) {
    if (flexes != null) {
      assert(flexes!.length == columns.length);
      assert(flexes![index] != 0);
      return flexes![index];
    }
    return 1;
  }

  List<Widget> _buildRows(BuildContext context) {
    return List.generate(
      _computeActualChildCount(rows.length),
      (index) {
        final int itemIndex = index ~/ 2;
        final row = rows[itemIndex];
        final Widget widget;
        if (index.isEven) {
          widget = _buildRowData(context, row: row);
        } else {
          widget = const Divider(height: 0);
        }
        return widget;
      },
    );
  }

  Widget _buildRowData(BuildContext context, {required DataRow row}) {
    final TextStyle _dataTextStyle = dataTextStyle ??
        (Theme.of(context).textTheme.bodyMedium ?? const TextStyle());
    return Container(
      color: row.color?.resolve({WidgetState.selected}),
      padding: dataRowPadding ??
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
      child: Row(
        children: List.generate(
          row.cells.length,
          (index) {
            final cell = row.cells[index];
            return Expanded(
              flex: _getFlexValue(index),
              child: DefaultTextStyle(
                style: _dataTextStyle,
                child: cell.child,
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to compute the actual child count for the separated constructor.
  static int _computeActualChildCount(int itemCount) {
    return math.max(0, itemCount * 2 - 1);
  }
}
