import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shougot_flutter/core/widgets/app_button.dart';
import 'package:shougot_flutter/core/widgets/auth_text_form_field.dart'
    show AuthTextFormField, AuthTextFieldType;
import 'package:shougot_flutter/feature/auth/data/model/auth_models.dart';
import 'package:shougot_flutter/feature/auth/provider/auth_provider.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  final String token;

  const ResetPasswordView({super.key, required this.token});

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordChanged = false;

  @override
  void dispose() {
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

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = ResetPasswordRequest(
        email: '', // Not needed if token is used
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        token: widget.token,
      );

      await ref.read(authControllerProvider.notifier).resetPassword(request);

      if (mounted) {
        setState(() => _passwordChanged = true);
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
                Icon(
                  _passwordChanged ? Icons.check_circle_outline : Icons.lock_outline,
                  size: 80,
                  color: _passwordChanged ? Colors.green : theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  _passwordChanged ? 'Password Reset!' : 'Reset Password',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _passwordChanged
                      ? 'Your password has been successfully updated. You can now sign in with your new password.'
                      : 'Enter your new password below.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                if (!_passwordChanged) ...[
                  AuthTextFormField(
                    type: AuthTextFieldType.password,
                    label: 'New Password',
                    hint: 'Enter new password',
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) {
                      _formKey.currentState?.validate();
                      _confirmPasswordController.clear();
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthTextFormField(
                    type: AuthTextFieldType.confirmPassword,
                    label: 'Confirm New Password',
                    hint: 'Confirm new password',
                    controller: _confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    validator: _validateConfirmPassword,
                    onSubmitted: (_) => _handleResetPassword(),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Reset Password',
                    type: AppButtonType.filled,
                    size: AppButtonSize.large,
                    isLoading: _isLoading,
                    isFullWidth: true,
                    onPressed: _handleResetPassword,
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
                        const SizedBox(height: 12),
                        Text(
                          'Password Updated!',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Go to Sign In',
                    type: AppButtonType.filled,
                    size: AppButtonSize.large,
                    isFullWidth: true,
                    onPressed: () => context.go('/auth/login'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}