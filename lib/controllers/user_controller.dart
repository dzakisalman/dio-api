import 'package:dio_api/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:filter_list/filter_list.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '/widgets/filter.dart';

class UserController extends GetxController {
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  bool hasMoreData = true;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void reset() {
    users = [];
    filteredUsers = [];
    isLoading = false;
    isLoadingMore = false;
    currentPage = 1;
    hasMoreData = true;
    update();
    fetchUsers(); // Fetch first page after reset
  }

  Future<void> fetchUsers() async {
    if (isLoading) return;
    
    isLoading = true;
    currentPage = 1; // Reset to page 1
    update();

    try {
      final userResponse = await ApiService().fetchUsers(page: currentPage);
      if (userResponse.data.isNotEmpty) {
        users = userResponse.data; // Replace existing data with page 1
        _updateFilteredUsers();
      }
      // Check if we have more pages
      hasMoreData = userResponse.totalPages > currentPage;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMoreData) return;

    isLoadingMore = true;
    update();
    
    final nextPage = currentPage + 1;

    try {
      final userResponse = await ApiService().fetchUsers(page: nextPage);
      if (userResponse.data.isNotEmpty) {
        users.addAll(userResponse.data); // Add new data to existing list
        _updateFilteredUsers();
        currentPage = nextPage; // Update page number only after successful load
      }
      // Check if we have more pages
      hasMoreData = userResponse.totalPages > currentPage;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load more users: $e');
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      _updateFilteredUsers();
    } else {
      filteredUsers = users.where((user) {
        return (user.firstName.toLowerCase().contains(query.toLowerCase()) ||
            user.lastName.toLowerCase().contains(query.toLowerCase()));
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
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> openFilterDialog() async {
    Get.bottomSheet(
      FilterDialog(
        users: users,
        filteredUsers: filteredUsers,
        onApplyFilter: (List<User> selectedUsers) {
          filteredUsers = selectedUsers;
          update();
        },
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void _updateFilteredUsers() {
    filteredUsers = List.from(users);
    update();
  }
}
