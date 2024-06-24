/*
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DataTable to Excel'),
      ),
      body: Center(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Age')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('John')),
              DataCell(Text('30')),
            ]),
            DataRow(cells: [
              DataCell(Text('Alice')),
              DataCell(Text('25')),
            ]),
            DataRow(cells: [
              DataCell(Text('Bob')),
              DataCell(Text('35')),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exportToExcel(context);
        },
        child: Icon(Icons.file_download),
      ),
    );
  }

  Future<void> _exportToExcel(BuildContext context) async {
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Add headers
    sheetObject
      ..cell(CellIndex.indexByString("A1")).value = "Name"
      ..cell(CellIndex.indexByString("B1")).value = "Age";

    // Add data
    sheetObject
      ..cell(CellIndex.indexByString("A2")).value = "John"
      ..cell(CellIndex.indexByString("B2")).value = 30 // Corrected to integer value
      ..cell(CellIndex.indexByString("A3")).value = "Alice"
      ..cell(CellIndex.indexByString("B3")).value = 25 // Corrected to integer value
      ..cell(CellIndex.indexByString("A4")).value = "Bob"
      ..cell(CellIndex.indexByString("B4")).value = 35 // Corrected to integer value

    // Save the Excel file
    String dir = (await getApplicationDocumentsDirectory()).path;
    String path = '$dir/example.xlsx';
    File file = File(path);
    await excel.encode()?.then((onValue) {
      file.writeAsBytes(onValue);
    });

    // Show a dialog to indicate the export is completed
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Exported to Excel'),
        content: Text('Excel file saved at $path'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}*/
