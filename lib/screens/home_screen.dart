import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_colors.dart';
import '../controllers/user_controller.dart';
import 'add_user_screen.dart';
import 'edit_user_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  void _handleLogout() {
    userController.reset();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Users',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.primary.withOpacity(0.9),
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.logout, color: AppColors.accent),
          onPressed: _handleLogout,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.accent),
            onPressed: () {
              userController.openFilterDialog();
            },
          ),
        ],
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = controller.filteredUsers[index];
                    return Card(
                      color: AppColors.surface.withOpacity(0.9),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user.avatar),
                          backgroundColor: AppColors.accent.withOpacity(0.2),
                        ),
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          user.email,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: AppColors.accent),
                              onPressed: () {
                                Get.to(() => EditUserScreen(user: user));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () {
                                showDeleteConfirmation(user.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (controller.hasMoreData)
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.isLoadingMore
                        ? null
                        : () => controller.loadMore(),
                    child: controller.isLoadingMore
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Load More',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddUserScreen()),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
      ),
    );
  }

  void showDeleteConfirmation(int userId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              userController.deleteUser(userId);
              Get.back();
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
