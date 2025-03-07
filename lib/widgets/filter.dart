import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio_api/app_colors.dart';
import '../models/user_model.dart';
import '../controllers/filter_controller.dart';

class FilterDialog extends StatelessWidget {
  final List<User> users;
  final List<User> filteredUsers;
  final Function(List<User>) onApplyFilter;

  FilterDialog({
    required this.users,
    required this.filteredUsers,
    required this.onApplyFilter,
  });

  @override
  Widget build(BuildContext context) {
    final FilterController controller = Get.put(FilterController(users: users, filteredUsers: filteredUsers));

    controller.filteredUsers = List<User>.from(filteredUsers);

    return FractionallySizedBox(
      heightFactor: 0.5,
      child: GetBuilder<FilterController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Filter Users",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (query) {
                    controller.filterSearch(query);
                  },
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: "Search user...",
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    prefixIcon: Icon(Icons.search, color: AppColors.accent),
                    filled: true,
                    fillColor: AppColors.surface.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.surface),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.surface),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.accent, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: controller.filteredUsers.isEmpty
                      ? Center(
                    child: Text(
                      "No users found",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = controller.filteredUsers[index];
                      final isSelected = controller.tempSelectedUsers.contains(user);

                      return CheckboxListTile(
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        value: isSelected,
                        onChanged: (bool? value) {
                          controller.toggleUserSelection(user);
                        },
                        activeColor: AppColors.accent,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.applyFilter(onApplyFilter);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Apply Filter", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.resetFilter(onApplyFilter);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Reset", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}