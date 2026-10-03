import 'package:shougot_flutter/core/network/api_client.dart';
import 'package:shougot_flutter/core/network/token_manager.dart';
import 'package:shougot_flutter/feature/auth/data/model/auth_models.dart';
import 'package:shougot_flutter/feature/auth/data/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(apiClientProvider));
}

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<User?> build() async {
    final accessToken = await TokenStorage.getAccessToken();
    final refreshToken = await TokenStorage.getRefreshToken();
    if (accessToken != null && refreshToken != null) {
      return User(token: accessToken, refreshToken: refreshToken);
    }
    return null;
  }

  Future<AuthResponse> login(LoginRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await ref.read(authRepositoryProvider).login(request);
      if (response.user != null && response.accessToken != null) {
        final user = response.user!.copyWith(
          token: response.accessToken,
          refreshToken: response.refreshToken,
        );
        await TokenStorage.saveTokens(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken,
        );
        state = AsyncData(user);
        return response;
      }
      state = AsyncData(null);
      return response;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<AuthResponse> signup(SignupRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await ref.read(authRepositoryProvider).signup(request);
      if (response.user != null && response.accessToken != null) {
        final user = response.user!.copyWith(
          token: response.accessToken,
          refreshToken: response.refreshToken,
        );
        await TokenStorage.saveTokens(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken,
        );
        state = AsyncData(user);
        return response;
      }
      state = AsyncData(null);
      return response;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).logout();
      await TokenStorage.clearTokens();
      state = const AsyncData(null);
    } catch (e, stack) {
      await TokenStorage.clearTokens();
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<User> refreshUser() async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).getProfile();
      state = AsyncData(user);
      return user;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<User> updateProfile({required String name, String? avatar}) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).updateProfile(
        name: name,
        avatar: avatar,
      );
      state = AsyncData(user);
      return user;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      await ref.read(authRepositoryProvider).forgotPassword(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await ref.read(authRepositoryProvider).resetPassword(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    try {
      await ref.read(authRepositoryProvider).changePassword(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> uploadAvatar(String filePath) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).uploadAvatar(filePath);
      state = AsyncData(user);
      return user;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      await TokenStorage.clearTokens();
      state = const AsyncData(null);
    } catch (e, stack) {
      await TokenStorage.clearTokens();
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  void clearAuth() {
    TokenStorage.clearTokens();
    state = const AsyncData(null);
  }
}

@riverpod
Future<User?> currentUser(Ref ref) async {
  final authState = ref.watch(authControllerProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
}

@riverpod
bool isAuthenticated(Ref ref) {
  final user = ref.watch(currentUserProvider);
  return user.asData?.value?.isAuthenticated ?? false;
}