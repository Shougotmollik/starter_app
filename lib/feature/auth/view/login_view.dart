import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shougot_flutter/core/widgets/app_button.dart';
import 'package:shougot_flutter/core/widgets/auth_text_form_field.dart';
import 'package:shougot_flutter/feature/auth/data/model/auth_models.dart';
import 'package:shougot_flutter/feature/auth/provider/auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      final response = await ref.read(authControllerProvider.notifier).login(request);

      if (mounted) {
        if (response.success && response.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome back, ${response.user!.name ?? 'User'}')),
          );
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? 'Login failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo/Brand
                Icon(
                  Icons.lock_outline_rounded,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome Back',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue to Shougot Flutter',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Email Field
                AuthTextFormField(
                  type: AuthTextFieldType.email,
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _formKey.currentState?.validate(),
                ),
                const SizedBox(height: 16),

                // Password Field
                AuthTextFormField(
                  type: AuthTextFieldType.password,
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => _formKey.currentState?.validate(),
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 16),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value ?? false),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        Text(
                          'Remember me',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push('/auth/forgot-password'),
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Login Button
                AppButton(
                  label: 'Sign In',
                  type: AppButtonType.filled,
                  size: AppButtonSize.large,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.colorScheme.outline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.colorScheme.outline)),
                  ],
                ),
                const SizedBox(height: 24),

                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Google',
                        type: AppButtonType.outlined,
                        size: AppButtonSize.medium,
                        leadingIcon: Icons.g_mobiledata,
                        isFullWidth: true,
                        onPressed: () {
                          // TODO: Implement Google Sign In
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: 'Apple',
                        type: AppButtonType.outlined,
                        size: AppButtonSize.medium,
                        leadingIcon: Icons.apple,
                        isFullWidth: true,
                        onPressed: () {
                          // TODO: Implement Apple Sign In
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/auth/signup'),
                      child: Text(
                        'Sign Up',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}