class User {
  final int? id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? token;
  final String? refreshToken;
  final DateTime? tokenExpiry;

  const User({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.token,
    this.refreshToken,
    this.tokenExpiry,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num?)?.toInt(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
      token: json['token']?.toString() ?? json['access_token']?.toString(),
      refreshToken: json['refresh_token']?.toString(),
      tokenExpiry: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar': avatar,
        'token': token,
        'refresh_token': refreshToken,
        'expires_at': tokenExpiry?.toIso8601String(),
      };

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? avatar,
    String? token,
    String? refreshToken,
    DateTime? tokenExpiry,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        token: token ?? this.token,
        refreshToken: refreshToken ?? this.refreshToken,
        tokenExpiry: tokenExpiry ?? this.tokenExpiry,
      );

  bool get isAuthenticated => token != null && token!.isNotEmpty;
}

class AuthResponse {
  final bool success;
  final String? message;
  final User? user;
  final String? accessToken;
  final String? refreshToken;

  const AuthResponse({
    required this.success,
    this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString(),
      user: json['user'] != null
          ? User.fromJson(Map<String, dynamic>.from(json['user']))
          : (json['data'] != null
              ? User.fromJson(Map<String, dynamic>.from(json['data']))
              : null),
      accessToken: json['access_token']?.toString() ?? json['token']?.toString(),
      refreshToken: json['refresh_token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'user': user?.toJson(),
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
}

class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'remember_me': rememberMe,
      };
}

class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      };
}

class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ResetPasswordRequest {
  final String email;
  final String password;
  final String confirmPassword;
  final String token;

  const ResetPasswordRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.token,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'token': token,
      };
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      };
}