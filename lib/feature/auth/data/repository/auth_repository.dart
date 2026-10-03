import 'package:shougot_flutter/core/network/api_client.dart';
import 'package:shougot_flutter/feature/auth/data/model/auth_models.dart';

class AuthRepository {
  AuthRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiClient.post<AuthResponse>(
      path: '/auth/login',
      data: request.toJson(),
      needAuth: false,
      checkInternet: true,
      showFloatingError: true,
      responseParser: (data) {
        if (data == null || data is! Map) {
          throw Exception('Invalid response format');
        }
        return AuthResponse.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message ?? 'Login failed');
  }

  Future<AuthResponse> signup(SignupRequest request) async {
    final response = await _apiClient.post<AuthResponse>(
      path: '/auth/register',
      data: request.toJson(),
      needAuth: false,
      checkInternet: true,
      showFloatingError: true,
      responseParser: (data) {
        if (data == null || data is! Map) {
          throw Exception('Invalid response format');
        }
        return AuthResponse.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message ?? 'Signup failed');
  }

  Future<void> logout() async {
    final response = await _apiClient.post<void>(
      path: '/auth/logout',
      needAuth: true,
      checkInternet: true,
    );
    if (!response.isSuccess) {
      throw Exception(response.message ?? 'Logout failed');
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _apiClient.post<AuthResponse>(
      path: '/auth/refresh',
      data: {'refresh_token': refreshToken},
      needAuth: false,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) {
          throw Exception('Invalid response format');
        }
        return AuthResponse.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message ?? 'Token refresh failed');
  }

  Future<User> getProfile() async {
    final response = await _apiClient.get<User>(
      path: '/auth/me',
      needAuth: true,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) {
          throw Exception('Invalid response format');
        }
        return User.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message ?? 'Failed to get profile');
  }

  Future<User> updateProfile({required String name, String? avatar}) async {
    final response = await _apiClient.put<User>(
      path: '/auth/profile',
      data: {'name': name, if (avatar != null) 'avatar': avatar},
      needAuth: true,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) {
          throw Exception('Invalid response format');
        }
        return User.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message ?? 'Failed to update profile');
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    final response = await _apiClient.post<void>(
      path: '/auth/forgot-password',
      data: request.toJson(),
      needAuth: false,
      checkInternet: true,
      showFloatingError: true,
    );

    if (!response.isSuccess) {
      throw Exception(response.message ?? 'Failed to send reset email');
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    final response = await _apiClient.post<void>(
      path: '/auth/reset-password',
      data: request.toJson(),
      needAuth: false,
      checkInternet: true,
      showFloatingError: true,
    );

    if (!response.isSuccess) {
      throw Exception(response.message ?? 'Failed to reset password');
    }
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    final response = await _apiClient.post<void>(
      path: '/auth/change-password',
      data: request.toJson(),
      needAuth: true,
      checkInternet: true,
      showFloatingError: true,
    );

    if (!response.isSuccess) {
      throw Exception(response.message ?? 'Failed to change password');
    }
  }

  Future<User> uploadAvatar(String filePath) async {
    final response = await _apiClient.multipart<User>(
      path: '/auth/avatar',
      fieldName: 'avatar',
      filePath: filePath,
      needAuth: true,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) {
          throw Exception('Invalid response format');
        }
        return User.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message ?? 'Failed to upload avatar');
  }

  Future<void> deleteAccount() async {
    final response = await _apiClient.delete<void>(
      path: '/auth/account',
      needAuth: true,
      checkInternet: true,
    );

    if (!response.isSuccess) {
      throw Exception(response.message ?? 'Failed to delete account');
    }
  }
}