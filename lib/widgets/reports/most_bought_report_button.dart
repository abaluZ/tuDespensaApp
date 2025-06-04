import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/provider/shopping_list_provider.dart';

class MostBoughtReportButton extends StatefulWidget {
  const MostBoughtReportButton({Key? key}) : super(key: key);

  @override
  State<MostBoughtReportButton> createState() => _MostBoughtReportButtonState();
}

class _MostBoughtReportButtonState extends State<MostBoughtReportButton> {
  void _showRangeOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Período'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Última Semana'),
              onTap: () {
                Navigator.pop(context);
                _generateReport(
                  DateTime.now().subtract(const Duration(days: 7)),
                  DateTime.now(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Último Mes'),
              onTap: () {
                Navigator.pop(context);
                _generateReport(
                  DateTime.now().subtract(const Duration(days: 30)),
                  DateTime.now(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_month),
              title: const Text('Últimos 3 Meses'),
              onTap: () {
                Navigator.pop(context);
                _generateReport(
                  DateTime.now().subtract(const Duration(days: 90)),
                  DateTime.now(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: const Text('Año Actual'),
              onTap: () {
                Navigator.pop(context);
                _generateReport(
                  DateTime(DateTime.now().year, 1, 1),
                  DateTime.now(),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateReport(DateTime startDate, DateTime endDate) async {
    final provider = Provider.of<ShoppingListProvider>(context, listen: false);
    await provider.getMostBoughtReport(
      context,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _showRangeOptions,
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text('Generar Reporte PDF'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
    );
  }
}
