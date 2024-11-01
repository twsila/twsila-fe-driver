import 'package:flutter/material.dart';

class CoastCalculationBottomSheetView extends StatefulWidget {
  const CoastCalculationBottomSheetView();

  @override
  State<CoastCalculationBottomSheetView> createState() =>
      _CoastCalculationBottomSheetViewState();
}

// CustomBottomSheet.displayModalBottomSheetList(
// context: context,
// showCloseButton: false,
// initialChildSize: 0.9,
// customWidget: CustomSearchBottomsheet(
// title: 'AppStrings.selectDeliveryPoint.tr()',
// onSelectPlace: widget.onSelectDestinPlace,
// ),
// );

class _CoastCalculationBottomSheetViewState
    extends State<CoastCalculationBottomSheetView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2), // Set border here
        borderRadius: BorderRadius.circular(5), // Optional: for rounded corners
      ),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Column 1')),
          DataColumn(label: Text('Column 2')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('Row 1, Col 1')),
            DataCell(Text('Row 1, Col 2')),
          ]),
          DataRow(cells: [
            DataCell(Text('Row 2, Col 1')),
            DataCell(Text('Row 2, Col 2')),
          ]),
          DataRow(cells: [
            DataCell(Text('Row 3, Col 1')),
            DataCell(Text('Row 3, Col 2')),
          ]),
        ],
      ),
    );
  }
}
