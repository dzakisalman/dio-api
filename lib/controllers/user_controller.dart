import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import 'package:dio_api/app_colors.dart';

class UserController extends GetxController {
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading = true;
    update();

    try {
      final userResponse = await ApiService().fetchUsers();
      if (userResponse.data != null) {
        users = userResponse.data;
        _updateFilteredUsers();
        update();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      _updateFilteredUsers();
    } else {
      filteredUsers = users.where((user) {
        return (user.firstName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (user.lastName?.toLowerCase().contains(query.toLowerCase()) ??
                false);
      }).toList();
    }
    update();
  }

  Future<void> createUser(String firstName, String lastName) async {
    isLoading = true;
    update();

    try {
      final newUser = await ApiService().createUser(firstName, lastName);
      if (newUser != null) {
        users.add(newUser);
        _updateFilteredUsers();
        update();
        Get.back();
        Get.snackbar(
          'Success',
          'User created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create user: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateUser(int id, String firstName, String lastName) async {
    isLoading = true;
    update();

    try {
      final updatedUser = await ApiService().updateUser(id, firstName, lastName);
      final index = users.indexWhere((user) => user.id == id);
      if (index != -1) {
        users[index] = updatedUser;
        _updateFilteredUsers();
        update();
        Get.back();
        Get.snackbar(
          'Success',
          'User updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update user: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> deleteUser(int id) async {
    isLoading = true;
    update();

    try {
      await ApiService().deleteUser(id);
      users.removeWhere((user) => user.id == id);
      _updateFilteredUsers();
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> openFilterDialog() async {
    List<User> tempSelectedUsers = List<User>.from(filteredUsers);
    List<User> filteredList = List<User>.from(users);
    TextEditingController searchController = TextEditingController();

    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.background,
      builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.5, // Hanya setengah layar
        child: StatefulBuilder(
          builder: (context, setState) {
            void filterSearch(String query) {
              setState(() {
                filteredList = users
                    .where((user) =>
                user.firstName.toLowerCase().contains(query.toLowerCase()) ||
                    user.lastName.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

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
                    controller: searchController,
                    onChanged: filterSearch,
                    decoration: InputDecoration(
                      hintText: "Search user...",
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
                    child: filteredList.isEmpty
                        ? Center(
                      child: Text(
                        "No users found",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final user = filteredList[index];
                        final isSelected = tempSelectedUsers.contains(user);

                        return CheckboxListTile(
                          title: Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                tempSelectedUsers.add(user);
                              } else {
                                tempSelectedUsers.remove(user);
                              }
                            });
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
                            filteredUsers = List<User>.from(tempSelectedUsers);
                            update();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Apply Filter",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _updateFilteredUsers(); // Reset filter
                            searchController.clear();
                            update();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Reset",
                              style: TextStyle(color: Colors.white)),
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
      },
    );
  }




  void _updateFilteredUsers() {
    filteredUsers = List.from(users);
  }
}
