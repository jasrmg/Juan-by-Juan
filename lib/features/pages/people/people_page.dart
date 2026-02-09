import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/features/components/empty_state_widget.dart';
import 'package:juan_by_juan/features/components/list_item_card.dart';
import 'package:juan_by_juan/features/pages/people/people_controller.dart';

/// people screen - second step
class PeoplePage extends GetView<PeopleController> {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add People'),
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
            // input form
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  // person name field
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Person Name',
                      hintText: 'e.g., Master Eve',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter person name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // add person button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.addPerson,
                        icon: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.person_add),
                        label: Text(
                          controller.isLoading.value
                              ? 'Adding...'
                              : 'Add Person',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // people lsit
            Expanded(
              child: Obx(() {
                if (controller.people.isEmpty) {
                  return const EmptyStateWidget(
                    message:
                        'No people yet.\nAdd at least 2 people to continue.',
                    icon: Icons.people_outline,
                  );
                }

                return ListView.builder(
                  itemCount: controller.people.length,
                  itemBuilder: (context, index) {
                    final person = controller.people[index];
                    return ListItemCard(
                      index: index,
                      title: person.name,
                      onDelete: () => controller.removePerson(index),
                    );
                  },
                );
              }),
            ),

            // next button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.people.length < 2
                      ? null
                      : controller.goToNextScreen,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Next: Split Items'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
