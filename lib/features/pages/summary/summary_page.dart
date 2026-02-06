import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/summary/summary_controller.dart';
import 'package:juan_by_juan/utils/currency_formatter.dart';

/// summary screen showing leaderboard of who pays what
class SummaryPage extends GetView<SummaryController> {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Summary'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // total bill card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Bill',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    CurrencyFormatter.format(controller.totalBill),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // leaderboard title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Leaderboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // leaderboard list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.people.length,
              itemBuilder: (context, index) {
                final person = controller.people[index];
                final percentage = controller.getPersonPercentage(person);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      person.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${percentage.toStringAsFixed(1)}% of total',
                    ),
                    trailing: Text(
                      person.formattedTotal,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _showPersonDetails(context, person, index),
                  ),
                );
              },
            ),
          ),
          // new bill button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.startNewBill,
                child: const Text('Start New Bill'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// show modal with person's item and breakdown
  void _showPersonDetails(BuildContext context, person, int personIndex) {
    final items = controller.getPersonItems(personIndex);
    final percentage = controller.getPersonPercentage(person);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  person.formattedTotal,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(1)}% of total bill',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const Divider(height: 24),

            // items list
            const Text(
              'Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(item.name), Text(item.formattedPrice)],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
