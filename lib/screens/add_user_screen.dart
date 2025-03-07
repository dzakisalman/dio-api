import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_colors.dart';
import '../controllers/user_controller.dart';

class AddUserScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  AddUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Add User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<UserController>(
        builder: (controller) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: firstNameController,
                label: 'First Name',
                icon: Icons.person_outline,
                enabled: !controller.isLoading,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: lastNameController,
                label: 'Last Name',
                icon: Icons.person_outline,
                enabled: !controller.isLoading,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () => _handleSubmit(controller),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.accent,
                  ),
                  child: controller.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Create User',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.surface),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
        prefixIcon: Icon(icon, color: AppColors.accent),
        filled: true,
        fillColor: AppColors.surface.withOpacity(0.2),
      ),
      textCapitalization: TextCapitalization.words,
      enabled: enabled,
    );
  }

  void _handleSubmit(UserController controller) {
    Get.focusScope?.unfocus();

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both first and last name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surface,
        colorText: AppColors.textPrimary,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    controller.createUser(firstName, lastName);
  }
}
