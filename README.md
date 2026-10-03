# Shougot Flutter - API Implementation Guide

A comprehensive guide for implementing new features with the **Model → API → Repository → Riverpod → View** pattern.

---

## 📁 Project Structure

```
lib/
├── app/                      # App bootstrap & root widget
├── core/                     # Shared core functionality
│   ├── network/              # API layer (Dio, interceptors, responses)
│   │   ├── api_client.dart       # Main HTTP client (GET/POST/PUT/PATCH/DELETE/Multipart)
│   │   ├── api_response.dart     # Standard response wrapper
│   │   ├── api_endpoint.dart     # Base URLs, timeouts, endpoints
│   │   ├── api_interceptor.dart  # Auth, token refresh, logging
│   │   ├── token_manager.dart    # Secure token storage
│   │   └── network_exceptions.dart # Error handling
│   ├── constants/            # App-wide constants (colors, strings)
│   └── theme/                # Theme configuration
├── feature/                  # Feature modules (each feature is self-contained)
│   └── product/              # Example feature
│       ├── data/
│       │   ├── model/        # Data models (DTOs)
│       │   └── repository/   # Repository layer
│       ├── provider/         # Riverpod providers
│       └── view/             # UI screens/widgets
└── utils/                    # Helper utilities
    ├── app_snackbar.dart     # Snackbar utility
    └── internet_checker.dart # Connectivity checker
```

---

## 🚀 Quick Start: Creating a New Feature

### 1. Create Feature Directory Structure

```bash
# For a new feature called "user"
mkdir -p lib/feature/user/data/model
mkdir -p lib/feature/user/data/repository
mkdir -p lib/feature/user/provider
mkdir -p lib/feature/user/view
```

### 2. Define the Model (`lib/feature/user/data/model/user.dart`)

```dart
class User {
  final int? id;
  final String? name;
  final String? email;
  final String? avatar;

  const User({
    this.id,
    this.name,
    this.email,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num?)?.toInt(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar': avatar,
      };

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? avatar,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
      );
}
```

> **Tip**: Always include `copyWith` for immutable updates.

---

### 3. Create Repository (`lib/feature/user/data/repository/user_repository.dart`)

```dart
import 'package:shougot_flutter/core/network/api_client.dart';
import 'package:shougot_flutter/core/network/api_response.dart';
import 'package:shougot_flutter/feature/user/data/model/user.dart';

class UserRepository {
  UserRepository(this._apiClient);

  final ApiClient _apiClient;

  // ─── GET: List Users ───
  Future<List<User>> getUsers({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get<List<User>>(
      path: '/users',
      queryParameters: {'page': page, 'limit': limit},
      needAuth: true,
      checkInternet: true,
      responseParser: (data) {
        if (data is! List) return <User>[];
        return data
            .map((item) => User.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      },
    );

    if (response.isSuccess) return response.data ?? <User>[];
    throw Exception(response.message ?? 'Failed to load users');
  }

  // ─── GET: Single User ───
  Future<User> getUserById(int id) async {
    final response = await _apiClient.get<User>(
      path: '/users/$id',
      needAuth: true,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) throw Exception('User not found');
        return User.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Failed to load user');
  }

  // ─── POST: Create User ───
  Future<User> createUser({required User user}) async {
    final response = await _apiClient.post<User>(
      path: '/users',
      data: user.toJson(),
      needAuth: true,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) throw Exception('Failed to create');
        return User.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Failed to create user');
  }

  // ─── PUT: Update User ───
  Future<User> updateUser({required int id, required User user}) async {
    final response = await _apiClient.put<User>(
      path: '/users/$id',
      data: user.toJson(),
      needAuth: true,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) throw Exception('Failed to update');
        return User.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Failed to update user');
  }

  // ─── PATCH: Partial Update ───
  Future<User> patchUser({required int id, required Map<String, dynamic> data}) async {
    final response = await _apiClient.patch<User>(
      path: '/users/$id',
      data: data,
      needAuth: true,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) throw Exception('Failed to patch');
        return User.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Failed to patch user');
  }

  // ─── DELETE: Remove User ───
  Future<bool> deleteUser(int id) async {
    final response = await _apiClient.delete<void>(
      path: '/users/$id',
      needAuth: true,
      checkInternet: true,
    );
    return response.isSuccess;
  }

  // ─── MULTIPART: Upload Avatar ───
  Future<User> uploadAvatar({required int id, required String filePath}) async {
    final response = await _apiClient.multipart<User>(
      path: '/users/$id/avatar',
      fieldName: 'avatar',
      filePath: filePath,
      needAuth: true,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) throw Exception('Upload failed');
        return User.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Failed to upload avatar');
  }
}
```

---

### 4. Create Riverpod Providers (`lib/feature/user/provider/user_provider.dart`)

```dart
import 'package:shougot_flutter/core/network/api_client.dart';
import 'package:shougot_flutter/feature/user/data/model/user.dart';
import 'package:shougot_flutter/feature/user/data/repository/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

// ─── Repository Provider ───
@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(ref.watch(apiClientProvider));
}

// ─── State Providers ───

/// List of users (cached, auto-refetch on changes)
@Riverpod(keepAlive: true)
Future<List<User>> users(Ref ref, {int page = 1}) async {
  return ref.watch(userRepositoryProvider).getUsers(page: page);
}

/// Single user by ID
@riverpod
Future<User> userById(Ref ref, int id) async {
  return ref.watch(userRepositoryProvider).getUserById(id);
}

/// Create user mutation (returns Future<bool> for success)
@riverpod
Future<User> createUser(Ref ref, {required User user}) async {
  return ref.read(userRepositoryProvider).createUser(user: user);
}

/// Update user mutation
@riverpod
Future<User> updateUser(Ref ref, {required int id, required User user}) async {
  return ref.read(userRepositoryProvider).updateUser(id: id, user: user);
}

/// Delete user mutation
@riverpod
Future<bool> deleteUser(Ref ref, int id) async {
  return ref.read(userRepositoryProvider).deleteUser(id);
}

/// Upload avatar
@riverpod
Future<User> uploadAvatar(Ref ref, {required int id, required String filePath}) async {
  return ref.read(userRepositoryProvider).uploadAvatar(id: id, filePath: filePath);
}
```

> **Run code generation**: `flutter pub run build_runner build --delete-conflicting-outputs`

---

### 5. Create View (`lib/feature/user/view/user_list_view.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shougot_flutter/feature/user/data/model/user.dart';
import 'package:shougot_flutter/feature/user/provider/user_provider.dart';

class UserListView extends ConsumerWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider(page: 1));

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: usersAsync.when(
        data: (users) => _UserList(users: users),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(usersProvider(page: 1)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateUserDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final user = User(name: nameController.text, email: emailController.text);
              await ref.read(createUserProvider(user: user).future);
              if (context.mounted) Navigator.pop(context);
              ref.invalidate(usersProvider(page: 1));
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  const _UserList({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          child: ListTile(
            leading: user.avatar != null
                ? CircleAvatar(backgroundImage: NetworkImage(user.avatar!))
                : const CircleAvatar(child: Icon(Icons.person)),
            title: Text(user.name ?? 'Unknown'),
            subtitle: Text(user.email ?? ''),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    _showEditDialog(context, ref, user);
                    break;
                  case 'delete':
                    await _confirmDelete(context, ref, user.id!);
                    break;
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, User user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final updated = user.copyWith(
                name: nameController.text,
                email: emailController.text,
              );
              await ref.read(updateUserProvider(id: user.id!, user: updated).future);
              if (context.mounted) Navigator.pop(context);
              ref.invalidate(usersProvider(page: 1));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(deleteUserProvider(id).future);
      ref.invalidate(usersProvider(page: 1));
    }
  }
}
```

---

### 6. Register Route (in `lib/app/app.dart` or your router)

```dart
// Add to your routes
GoRoute(
  path: '/users',
  builder: (context, state) => const UserListView(),
),
```

---

## 🔧 API Client Usage Reference

### Available Methods in `ApiClient`

| Method | Use Case | Example |
|--------|----------|---------|
| `get<T>()` | Fetch data | `get<List<User>>(path: '/users')` |
| `post<T>()` | Create resource | `post<User>(path: '/users', data: user.toJson())` |
| `put<T>()` | Full update | `put<User>(path: '/users/1', data: user.toJson())` |
| `patch<T>()` | Partial update | `patch<User>(path: '/users/1', data: {'name': 'New'})` |
| `delete<T>()` | Delete resource | `delete<void>(path: '/users/1')` |
| `multipart<T>()` | File upload | `multipart<User>(path: '/upload', filePath: path)` |

### Common Parameters

```dart
await apiClient.get<T>(
  path: '/endpoint',              // Required: API path
  queryParameters: {'page': 1},   // Optional: Query params
  needAuth: true,                 // Add auth header (default: true)
  checkInternet: true,            // Pre-flight connectivity check
  showFloatingError: false,       // Show snackbar on error
  responseParser: (data) => ...,  // Parse raw JSON to your model
  cancelToken: cancelToken,       // For request cancellation
);
```

---

## 📦 ApiResponse Pattern

All API calls return `ApiResponse<T>`:

```dart
final response = await apiClient.get<User>(path: '/users/1');

if (response.isSuccess) {
  final user = response.data; // Type: User?
} else {
  final error = response.message; // Error message
  final code = response.statusCode; // HTTP status code
}
```

---

## 🎯 Riverpod Patterns

### Provider Types

| Type | Use Case | Example |
|------|----------|---------|
| `@riverpod` | Simple computed values | `userRepository` |
| `@Riverpod(keepAlive: true)` | Cached async data | `users` list |
| `@riverpod` (async) | Single item by param | `userById(id)` |
| Mutation (`ref.read`) | Write operations | `createUser`, `updateUser` |

### Consuming in UI

```dart
// Watch (rebuilds on change)
final usersAsync = ref.watch(usersProvider(page: 1));

// Read (one-time, for mutations)
await ref.read(createUserProvider(user: newUser).future);

// Invalidate (trigger refetch)
ref.invalidate(usersProvider(page: 1));
```

### AsyncValue Handling

```dart
usersAsync.when(
  data: (users) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);

// Or use AsyncValueWidget (from riverpod v2.5+)
AsyncValueWidget<List<User>>(
  value: usersAsync,
  data: (users) => ListView(...),
);
```

---

## ✅ Checklist for New Features

- [ ] Create model with `fromJson`/`toJson`/`copyWith`
- [ ] Create repository with all CRUD methods
- [ ] Create Riverpod providers (repository + state + mutations)
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Create view with `ConsumerWidget` + `AsyncValue.when`
- [ ] Handle loading/error/empty states
- [ ] Add route to router
- [ ] Test offline/error scenarios

---

## 🛠 Useful Commands

```bash
# Generate Riverpod code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter pub run build_runner watch --delete-conflicting-outputs

# Check for analysis issues
flutter analyze

# Run tests
flutter test
```

---

## 📝 Key Principles

1. **Single Responsibility**: Each layer has one job
2. **Type Safety**: Use generics (`ApiResponse<T>`, `Future<T>`)
3. **Error Handling**: Always check `response.isSuccess` before using `data`
4. **Caching**: Use `keepAlive: true` for lists, invalidate on mutations
5. **Separation**: Models don't know about API; Views don't know about Dio
6. **Immutability**: Models use `final` fields + `copyWith`

---

## 🔐 Auth API Integration Guide

This section covers the complete authentication flow implementation using the established patterns.

---

### Auth Feature Structure

```
lib/feature/auth/
├── data/
│   ├── model/
│   │   └── auth_models.dart       # User, AuthResponse, LoginRequest, SignupRequest, etc.
│   └── repository/
│       └── auth_repository.dart   # Auth API calls
├── provider/
│   └── auth_provider.dart         # Riverpod providers + AuthController
└── view/
    ├── login_view.dart
    ├── signup_view.dart
    ├── forgot_password_view.dart
    └── reset_password_view.dart
```

---

### 1. Auth Models (`auth_models.dart`)

```dart
// User model with token management
class User {
  final int? id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? token;
  final String? refreshToken;
  final DateTime? tokenExpiry;

  bool get isAuthenticated => token != null && token!.isNotEmpty;
}

// Standard auth response wrapper
class AuthResponse {
  final bool success;
  final String? message;
  final User? user;
  final String? accessToken;
  final String? refreshToken;
}

// Request models
class LoginRequest { final String email; final String password; final bool rememberMe; }
class SignupRequest { final String name; final String email; final String password; final String confirmPassword; }
class ForgotPasswordRequest { final String email; }
class ResetPasswordRequest { final String email; final String password; final String confirmPassword; final String token; }
class ChangePasswordRequest { final String currentPassword; final String newPassword; final String confirmPassword; }
```

---

### 2. Auth Repository (`auth_repository.dart`)

All auth endpoints with proper error handling:

```dart
class AuthRepository {
  AuthRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<AuthResponse> login(LoginRequest request) async { ... }
  Future<AuthResponse> signup(SignupRequest request) async { ... }
  Future<void> logout() async { ... }
  Future<AuthResponse> refreshToken(String refreshToken) async { ... }
  Future<User> getProfile() async { ... }
  Future<User> updateProfile({required String name, String? avatar}) async { ... }
  Future<void> forgotPassword(ForgotPasswordRequest request) async { ... }
  Future<void> resetPassword(ResetPasswordRequest request) async { ... }
  Future<void> changePassword(ChangePasswordRequest request) async { ... }
  Future<User> uploadAvatar(String filePath) async { ... }
  Future<void> deleteAccount() async { ... }
}
```

**Key patterns:**
- `needAuth: false` for login/signup/forgot-password
- `needAuth: true` for protected endpoints
- `showFloatingError: true` for user-facing errors
- `responseParser` to convert JSON to models

---

### 3. Auth Provider (`auth_provider.dart`)

Using `AsyncNotifier` for mutable auth state:

```dart
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<User?> build() async => null;

  Future<AuthResponse> login(LoginRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await ref.read(authRepositoryProvider).login(request);
      if (response.user != null && response.accessToken != null) {
        final user = response.user!.copyWith(
          token: response.accessToken,
          refreshToken: response.refreshToken,
        );
        state = AsyncData(user);
      }
      return response;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<AuthResponse> signup(SignupRequest request) async { ... }
  Future<void> logout() async { ... }
  Future<User> refreshUser() async { ... }
  Future<User> updateProfile({required String name, String? avatar}) async { ... }
  // ... other mutations
}

@riverpod
Future<User?> currentUser(Ref ref) async {
  final authState = ref.watch(authControllerProvider);
  return authState.when(data: (user) => user, loading: () => null, error: (_, __) => null);
}

@riverpod
bool isAuthenticated(Ref ref) {
  final user = ref.watch(currentUserProvider);
  return user.asData?.value?.isAuthenticated ?? false;
}
```

---

### 4. Auth Views

#### Login View (`login_view.dart`)
- Email/password fields with validation
- Remember me checkbox
- Forgot password link
- Social login buttons (Google, Apple)
- Navigation to signup

#### Signup View (`signup_view.dart`)
- Name, email, password, confirm password
- Password strength validation
- Terms & conditions checkbox
- Social signup buttons
- Navigation to login

#### Forgot Password (`forgot_password_view.dart`)
- Email input
- Success state with resend option
- Back to login link

#### Reset Password (`reset_password_view.dart`)
- Token from URL parameter
- New password + confirmation
- Success state with navigation to login

---

### 5. Router Configuration

```dart
// lib/app/router.dart
import 'package:go_router/go_router.dart';
import 'package:shougot_flutter/feature/auth/view/login_view.dart';
import 'package:shougot_flutter/feature/auth/view/signup_view.dart';
import 'package:shougot_flutter/feature/auth/view/forgot_password_view.dart';
import 'package:shougot_flutter/feature/auth/view/reset_password_view.dart';

final router = GoRouter(
  initialLocation: '/auth/login',
  routes: [
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignupView(),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      builder: (context, state) => const ForgotPasswordView(),
    ),
    GoRoute(
      path: '/auth/reset-password',
      builder: (context, state) => ResetPasswordView(
        token: state.uri.queryParameters['token'] ?? '',
      ),
    ),
    // Protected routes
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeView(),
      redirect: (context, state) {
        final auth = ref.read(isAuthenticatedProvider);
        if (!auth) return '/auth/login';
        return null;
      },
    ),
  ],
);
```

---

### 6. Token Management (Auto-refresh)

The `ApiClient` handles token refresh automatically via `AuthInterceptor`:

```dart
// lib/core/network/api_interceptor.dart
class AuthInterceptor extends Interceptor {
  final Dio dio;
  AuthInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = ref.read(authControllerProvider).value?.token;
    if (token != null && options.extra['needAuth'] == true) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && err.requestOptions.extra['needAuth'] == true) {
      // Attempt token refresh
      final refreshToken = ref.read(authControllerProvider).value?.refreshToken;
      if (refreshToken != null) {
        try {
          final response = await _refreshToken(refreshToken);
          // Retry original request with new token
          return handler.resolve(await _retryRequest(err.requestOptions, response.accessToken!));
        } catch (_) {
          // Refresh failed, logout user
          ref.read(authControllerProvider.notifier).clearAuth();
        }
      }
    }
    handler.next(err);
  }
}
```

---

### 7. Usage in UI

```dart
// Check auth state
final isAuth = ref.watch(isAuthenticatedProvider);
final user = ref.watch(currentUserProvider);

// Login
await ref.read(authControllerProvider.notifier).login(
  LoginRequest(email: 'user@example.com', password: 'password123'),
);

// Signup
await ref.read(authControllerProvider.notifier).signup(
  SignupRequest(name: 'John', email: 'john@example.com', password: 'password123', confirmPassword: 'password123'),
);

// Logout
await ref.read(authControllerProvider.notifier).logout();

// Protected API calls (automatically adds Bearer token)
final profile = await ref.read(authControllerProvider.notifier).refreshUser();
```

---

### 8. Protected Route Guard

```dart
// In router redirect
redirect: (context, state) {
  final auth = ref.read(isAuthenticatedProvider);
  final isAuthRoute = state.matchedLocation.startsWith('/auth/');
  
  if (!auth && !isAuthRoute) return '/auth/login';
  if (auth && isAuthRoute) return '/home';
  return null;
},
```

---

## 🔗 Related Files

- `lib/core/network/api_client.dart` - Full HTTP client implementation
- `lib/core/network/api_response.dart` - Response wrapper
- `lib/feature/product/` - Complete working example
- `lib/feature/auth/` - Complete auth implementation
- `lib/app/app_bootstrap.dart` - App initialization