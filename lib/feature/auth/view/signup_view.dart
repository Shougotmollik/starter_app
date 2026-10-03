import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shougot_flutter/core/widgets/app_button.dart';
import 'package:shougot_flutter/core/widgets/auth_text_form_field.dart'
    show AuthTextFormField, AuthTextFieldType;
import 'package:shougot_flutter/feature/auth/data/model/auth_models.dart';
import 'package:shougot_flutter/feature/auth/provider/auth_provider.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = SignupRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      final response = await ref.read(authControllerProvider.notifier).signup(request);

      if (mounted) {
        if (response.success && response.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${response.user!.name ?? 'User'}')),
          );
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? 'Signup failed')),
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
                const SizedBox(height: 24),
                // Logo/Brand
                Icon(
                  Icons.person_add_outlined,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Create Account',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Join Shougot Flutter today',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Name Field
                AuthTextFormField(
                  type: AuthTextFieldType.name,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _formKey.currentState?.validate(),
                ),
                const SizedBox(height: 16),

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
                  hint: 'Create a password',
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    _formKey.currentState?.validate();
                    _confirmPasswordController.clear();
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                AuthTextFormField(
                  type: AuthTextFieldType.confirmPassword,
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  onSubmitted: (_) => _handleSignup(),
                ),
                const SizedBox(height: 24),

                // Terms & Conditions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreeTerms,
                      onChanged: (value) => setState(() => _agreeTerms = value ?? false),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _agreeTerms = !_agreeTerms),
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign Up Button
                AppButton(
                  label: 'Create Account',
                  type: AppButtonType.filled,
                  size: AppButtonSize.large,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  onPressed: _handleSignup,
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

                // Social Signup Buttons
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
                          // TODO: Implement Google Sign Up
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
                          // TODO: Implement Apple Sign Up
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/auth/login'),
                      child: Text(
                        'Sign In',
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