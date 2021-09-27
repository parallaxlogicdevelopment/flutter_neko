import 'dart:convert';

class LoginResponse {
  final String message;
  final String token;
  final UserResponse user;

  LoginResponse({
    this.message,
    this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
      user: UserResponse.fromJson(json['user']),
    );
  }
}

class UserResponse {
  final String email;
  final int id;

  UserResponse({
    this.email,
    this.id,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      email: json['email'],
      id: json['id'],
    );
  }
}
