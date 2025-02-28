import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

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
      final updatedUser =
          await ApiService().updateUser(id, firstName, lastName);
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
    final List<User> selectedUsers = filteredUsers.toList();

    await FilterListDialog.display<User>(
      Get.context!,
      listData: users,
      selectedListData: selectedUsers,
      choiceChipLabel: (user) =>
          '${user?.firstName ?? "Unknown"} ${user?.lastName ?? ""}',
      validateSelectedItem: (list, user) => list?.contains(user) ?? false,
      onItemSearch: (user, query) {
        return (user?.firstName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (user?.lastName?.toLowerCase().contains(query.toLowerCase()) ??
                false);
      },
      onApplyButtonClick: (list) {
        if (list != null) {
          filteredUsers = list;
          update();
        }
        Get.back();
      },
    );

    Get.defaultDialog(
      title: "Filter Applied",
      middleText: "Click Reset to show all users again.",
      textConfirm: "Reset",
      onConfirm: () {
        _updateFilteredUsers();
        update();
        Get.back();
      },
      textCancel: "Close",
    );
  }

  void _updateFilteredUsers() {
    filteredUsers = List.from(users);
  }
}
