import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/routes.dart';
import 'package:juan_by_juan/features/components/empty_state_widget.dart';
import 'package:juan_by_juan/features/components/full_width_button.dart';
import 'package:juan_by_juan/features/components/loading_button.dart';
import 'package:juan_by_juan/features/pages/items/items_controller.dart';

import 'package:juan_by_juan/features/components/list_item_card.dart';

/// items screen - first step
/// users add items with name and price
class ItemsPage extends GetView<ItemsController> {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.toNamed(AppRoutes.history),
            tooltip: 'Bill History',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // input form
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  // item name field
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      hintText: 'e.g., Pizza',
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // price field
                  TextFormField(
                    controller: controller.priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (₱)',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter price';
                      }
                      final price = double.tryParse(value.trim());
                      if (price == null || price <= 0) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // add item button
                  Obx(
                    () => LoadingButton(
                      isLoading: controller.isLoading.value,
                      onPressed: controller.addItem,
                      label: 'Add Item',
                      loadingLabel: 'Adding...',
                      icon: Icons.add,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // items list
            Expanded(
              child: Obx(() {
                if (controller.items.isEmpty) {
                  return const EmptyStateWidget(
                    message: 'No items yet.\nAdd your first item above.',
                    icon: Icons.shopping_bag_outlined,
                  );
                }

                return ListView.builder(
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return ListItemCard(
                      index: index,
                      title: item.name,
                      subtitle: item.formattedPrice,
                      onDelete: () => controller.removeItem(index),
                    );
                  },
                );
              }),
            ),
            // next button
            Obx(
              () => FullWidthButton(
                onPressed: controller.items.isEmpty
                    ? null
                    : controller.goToNextScreen,
                label: 'Next: Add People',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
