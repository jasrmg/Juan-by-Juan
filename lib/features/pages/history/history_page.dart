import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/history/history_controller.dart';
import 'package:juan_by_juan/utils/currency_formatter.dart';

/// history screen showing list of saved bills
class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bill History')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bills.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No saved bills yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Save a bill from the summary screen',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.bills.length,
          itemBuilder: (context, index) {
            final bill = controller.bills[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.receipt, color: Colors.white),
                ),
                title: Text(
                  bill.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(bill.formattedDate),
                trailing: Text(
                  CurrencyFormatter.format(bill.totalAmount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => controller.openBill(bill),
                onLongPress: () => _showDeleteDialog(context, bill),
              ),
            );
          },
        );
      }),
    );
  }

  /// show delete confirmation dialog
  void _showDeleteDialog(BuildContext context, bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bill'),
        content: Text('Delete "${bill.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteBill(bill.id!, bill.name);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
