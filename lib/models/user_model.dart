class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
    );
  }
}

class UserResponse {
  final List<User> data;
  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  UserResponse({
    required this.data,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    List<User> userList = list.map((i) => User.fromJson(i)).toList();
    return UserResponse(
      data: userList,
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 6,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((user) => user.toJson()).toList(),
      'page': page,
      'per_page': perPage,
      'total': total,
      'total_pages': totalPages,
    };
  }
}
