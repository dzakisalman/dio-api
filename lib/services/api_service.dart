import 'package:dio/dio.dart';

import '../models/user_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://reqres.in/api';

  Future<UserResponse> fetchUsers() async {
    try {
      final response = await _dio.get('$baseUrl/users?page=1');
      if (response.statusCode == 200) {
        return UserResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<User> createUser(String firstName, String lastName) async {
    try {
      final response = await _dio.post('$baseUrl/users', data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': '$firstName.$lastName@reqres.in'.toLowerCase(),
        'avatar':
            'https://reqres.in/img/faces/${DateTime.now().millisecond % 12 + 1}-image.jpg'
      });

      print('Create User Response: ${response.data}');

      if (response.statusCode == 201) {
        return User(
          id: int.parse(response.data['id'].toString()),
          firstName: firstName,
          lastName: lastName,
          email: '$firstName.$lastName@reqres.in'.toLowerCase(),
          avatar:
              'https://reqres.in/img/faces/${(DateTime.now().millisecond % 12) + 1}-image.jpg',
        );
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      print('Create User Error: $e');
      throw Exception('Failed to create user: $e');
    }
  }

  Future<User> updateUser(int id, String firstName, String lastName) async {
    try {
      final response = await _dio.put('$baseUrl/users/$id', data: {
        'first_name': firstName,
        'last_name': lastName,
      });

      if (response.statusCode == 200) {
        return User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: '$firstName.$lastName@reqres.in'.toLowerCase(),
            avatar: 'https://reqres.in/img/faces/${id % 12 + 1}-image.jpg');
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await _dio.delete('$baseUrl/users/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
