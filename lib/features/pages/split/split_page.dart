import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/split/split_controller.dart';

/// split assignment screen - third part
/// users select which people pay for each item
class SplitPage extends GetView<SplitController> {
  const SplitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Split Items'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.goBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // progress indicator
            Obx(
              () => LinearProgressIndicator(
                value:
                    (controller.currentItemIndex.value + 1) /
                    controller.items.length,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),

            // item counter
            Obx(
              () => Text(
                'Item ${controller.currentItemIndex.value + 1} of ${controller.items.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // current item card
            Obx(
              () => Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        controller.currentItem.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.currentItem.formattedPrice,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // instructions
            const Text(
              'Who will pay for this item?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // people selection chips
            Expanded(
              child: Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(controller.people.length, (index) {
                    final person = controller.people[index];
                    final isSelected = controller.isPersonSelected(index);

                    return FilterChip(
                      label: Text(person.name),
                      selected: isSelected,
                      onSelected: (_) =>
                          controller.togglePersonSelection(index),
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      checkmarkColor: Theme.of(context).colorScheme.primary,
                    );
                  }),
                ),
              ),
            ),
            // navigfation button
            Row(
              children: [
                // previous button
                Obx(
                  () => Expanded(
                    child: OutlinedButton(
                      onPressed: controller.currentItemIndex.value > 0
                          ? controller.goToPreviousItem
                          : null,
                      child: const Text('Previous'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // next/caculate button
                Obx(
                  () => Expanded(
                    child: ElevatedButton(
                      onPressed: controller.hasSelection
                          ? controller.goToNextItem
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        controller.currentItemIndex.value ==
                                controller.items.length - 1
                            ? 'Calculate'
                            : 'Next Item',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
