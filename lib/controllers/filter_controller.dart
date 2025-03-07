import 'package:get/get.dart';
import '../models/user_model.dart';

class FilterController extends GetxController {
  List<User> users;
  List<User> filteredUsers;
  List<User> tempSelectedUsers = [];

  FilterController({required this.users, required this.filteredUsers});

  void filterSearch(String query) {
    filteredUsers = users.where((user) {
      return user.firstName.toLowerCase().contains(query.toLowerCase()) ||
          user.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    update(); // Update the UI
  }

  void toggleUserSelection(User user) {
    if (tempSelectedUsers.contains(user)) {
      tempSelectedUsers.remove(user);
    } else {
      tempSelectedUsers.add(user);
    }
    update(); // Update the UI
  }

  void applyFilter(Function(List<User>) onApplyFilter) {
    onApplyFilter(List<User>.from(tempSelectedUsers));
  }

  void resetFilter(Function(List<User>) onApplyFilter) {
    tempSelectedUsers.clear();
    onApplyFilter(users); // Reset filter
    update(); // Update the UI
  }
}