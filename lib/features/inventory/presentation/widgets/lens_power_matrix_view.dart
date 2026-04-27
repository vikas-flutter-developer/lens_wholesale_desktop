import 'package:flutter/material.dart';

class LensPowerMatrixView extends StatelessWidget {
  final List<Map<String, dynamic>> reportData;

  const LensPowerMatrixView({
    super.key,
    required this.reportData,
  });

  @override
  Widget build(BuildContext context) {
    if (reportData.isEmpty) {
      return const Center(child: Text("Select a Lens Group to view matrix"));
    }

    // Extract unique SPH and CYL values
    final sphValues = reportData
        .map((r) => (r['sph'] ?? 0.0).toDouble())
        .toSet()
        .toList()
      ..sort();
    
    final cylValues = reportData
        .map((r) => (r['cyl'] ?? 0.0).toDouble())
        .toSet()
        .toList()
      ..sort();

    // Map data for quick lookup
    final Map<String, int> matrixData = {};
    for (var r in reportData) {
      final key = "${r['sph']}_${r['cyl']}";
      matrixData[key] = (matrixData[key] ?? 0) + (r['stock'] as int? ?? 0);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SPH / CYL MATRIX",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: Table(
                        defaultColumnWidth: const FlexColumnWidth(1.0),
                        border: TableBorder.all(color: Colors.grey.shade200),
                        children: [
                          // Header Row: SPH Values
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFF0F172A)),
                            children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("SPH / CYL",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              ...sphValues.map((sph) => TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(sph.toStringAsFixed(2),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  )),
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Total",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                          // Data Rows: CYL x SPH
                          ...cylValues.map((cyl) {
                            int rowTotal = 0;
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    color: Colors.grey.shade100,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(cyl.toStringAsFixed(2),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 10)),
                                  ),
                                ),
                                ...sphValues.map((sph) {
                                  final qty = matrixData["${sph}_$cyl"] ?? 0;
                                  rowTotal += qty;
                                  return TableCell(
                                    child: Container(
                                      color: qty > 0
                                          ? Colors.green.shade50
                                          : Colors.transparent,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        qty > 0 ? qty.toString() : "—",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: qty > 0
                                              ? Colors.green.shade700
                                              : Colors.grey.shade400,
                                          fontWeight: qty > 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                TableCell(
                                  child: Container(
                                    color: const Color(0xFFF1F5F9),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      rowTotal.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          // Bottom Totals Row
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                            children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 10)),
                                ),
                              ),
                              ...sphValues.map((sph) {
                                int colTotal = 0;
                                for (var cyl in cylValues) {
                                  colTotal += matrixData["${sph}_$cyl"] ?? 0;
                                }
                                return TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(colTotal.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 10)),
                                  ),
                                );
                              }),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    reportData.fold(0, (sum, r) => sum + (r['stock'] as int? ?? 0)).toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
