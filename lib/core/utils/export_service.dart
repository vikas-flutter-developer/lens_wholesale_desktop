import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class ExportService {
  static Future<String?> exportToCSV({
    required String fileName,
    required String reportTitle,
    required List<String> headers,
    required List<List<dynamic>> data,
  }) async {
    try {
      final List<List<dynamic>> rows = [];

      // 1. Professional Header (Company Metadata)
      rows.add(['BRADING CATALYST PVT LTD (LENS WHOLESALE)']);
      rows.add(['Report:', reportTitle]);
      rows.add(['Export Date:', DateFormat('dd-MMM-yyyy HH:mm:ss').format(DateTime.now())]);
      rows.add([]); // Spacer

      // 2. Data Header
      rows.add(headers);

      // 3. Data Body
      rows.addAll(data);

      String csvData = const ListToCsvConverter().convert(rows);

      // 4. Save to Downloads/Documents
      Directory? directory;
      if (Platform.isWindows) {
        directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      } else {
        directory = await getExternalStorageDirectory();
      }

      if (directory == null) return null;

      final path = p.join(directory.path, '$fileName.csv');
      final file = File(path);
      await file.writeAsString(csvData);

      return path;
    } catch (e) {
      debugPrint('Export Error: $e');
      return null;
    }
  }
}
