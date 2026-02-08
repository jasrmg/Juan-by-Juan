import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/home/home_controller.dart';
import 'package:juan_by_juan/utils/currency_formatter.dart';

import 'package:juan_by_juan/core/configurations/flavors.dart';

/// home screen - main landing page
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // app title
                  const Text(
                    'Juan-by-Juan',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Split bills easily',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 60),

                  // new bill button
                  ElevatedButton.icon(
                    onPressed: controller.startNewBill,
                    icon: const Icon(Icons.add_circle_outline, size: 28),
                    label: const Text(
                      'New Bill',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // bill history button
                  OutlinedButton.icon(
                    onPressed: controller.goToHistory,
                    icon: const Icon(Icons.history, size: 28),
                    label: const Text(
                      'Bill History',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // recent bills section
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.recentBills.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Bills',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.recentBills.length,
                              itemBuilder: (context, index) {
                                final bill = controller.recentBills[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      child: const Icon(
                                        Icons.receipt,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      bill.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(bill.formattedDate),
                                    trailing: Text(
                                      CurrencyFormatter.format(
                                        bill.totalAmount,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () => controller.openBill(bill),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // flavor banner (top-right corner)
          if (!FlavorConfig.instance.isProduction)
            Positioned(
              top: 0,
              right: 0,
              child: Banner(
                message: FlavorConfig.instance.flavorName,
                location: BannerLocation.topEnd,
                color: FlavorConfig.instance.isUAT
                    ? Colors.orange
                    : Colors.blue,
              ),
            ),
        ],
      ),
    );
  }
}
