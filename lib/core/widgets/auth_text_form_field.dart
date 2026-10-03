import 'package:flutter/material.dart';

enum AuthTextFieldType {
  email,
  password,
  confirmPassword,
  text,
  name,
  phone,
  number,
  multiline,
}

class AuthTextFormField extends StatefulWidget {
  final AuthTextFieldType type;
  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final bool obscureTextInitial;
  final String? initialValue;
  final bool showCounter;

  const AuthTextFormField({
    super.key,
    this.type = AuthTextFieldType.text,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.keyboardType,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.contentPadding,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.helperStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.obscureTextInitial = false,
    this.initialValue,
    this.showCounter = false,
  });

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  late bool _obscureText;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = _shouldObscureInitially();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  bool _shouldObscureInitially() {
    switch (widget.type) {
      case AuthTextFieldType.password:
      case AuthTextFieldType.confirmPassword:
        return true;
      default:
        return widget.obscureTextInitial;
    }
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPasswordType = widget.type == AuthTextFieldType.password ||
        widget.type == AuthTextFieldType.confirmPassword;

    final effectiveFillColor = widget.fillColor ?? theme.inputDecorationTheme.fillColor;
    final effectiveBorderColor = widget.borderColor ?? theme.colorScheme.primary.withValues(alpha: 0.3);
    final effectiveFocusedBorderColor = widget.focusedBorderColor ?? theme.colorScheme.primary;
    final effectiveErrorBorderColor = widget.errorBorderColor ?? theme.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ??
                theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          validator: widget.validator ?? _defaultValidator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.type == AuthTextFieldType.multiline ? (widget.maxLines ?? 4) : widget.maxLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          textCapitalization: widget.textCapitalization,
          obscureText: _obscureText && isPasswordType,
          keyboardType: _getKeyboardType(),
          textAlignVertical: TextAlignVertical.center,
          style: widget.style ??
              theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
          decoration: InputDecoration(
            hintText: widget.hint ?? _getDefaultHint(),
            hintStyle: widget.hintStyle ??
                theme.inputDecorationTheme.hintStyle?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
            helperText: widget.helperText,
            helperStyle: widget.helperStyle ??
                theme.inputDecorationTheme.helperStyle?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
            errorStyle: widget.errorStyle ??
                theme.inputDecorationTheme.errorStyle?.copyWith(
                  color: theme.colorScheme.error,
                ),
            filled: true,
            fillColor: effectiveFillColor,
            contentPadding: widget.contentPadding ??
                theme.inputDecorationTheme.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            prefixIcon: widget.prefixIcon ?? _getDefaultPrefixIcon(context),
            suffixIcon: isPasswordType
                ? _buildPasswordToggle(context)
                : widget.suffixIcon,
            counterText: widget.showCounter ? null : '',
            border: widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: effectiveBorderColor, width: 1),
                ),
            enabledBorder: widget.enabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: effectiveBorderColor, width: 1),
                ),
            focusedBorder: widget.focusedBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: effectiveFocusedBorderColor, width: 2),
                ),
            errorBorder: widget.errorBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: effectiveErrorBorderColor, width: 1),
                ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: effectiveErrorBorderColor, width: 2),
            ),
            disabledBorder: widget.disabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Widget? _buildPasswordToggle(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 20,
        color: _hasFocus ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      onPressed: () => setState(() => _obscureText = !_obscureText),
      splashRadius: 20,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
  }

  Widget? _getDefaultPrefixIcon(BuildContext context) {
    final theme = Theme.of(context);
    final color = _hasFocus ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5);

    switch (widget.type) {
      case AuthTextFieldType.email:
        return Icon(Icons.email_outlined, color: color, size: 20);
      case AuthTextFieldType.password:
      case AuthTextFieldType.confirmPassword:
        return Icon(Icons.lock_outline, color: color, size: 20);
      case AuthTextFieldType.name:
        return Icon(Icons.person_outline, color: color, size: 20);
      case AuthTextFieldType.phone:
        return Icon(Icons.phone_outlined, color: color, size: 20);
      case AuthTextFieldType.number:
        return Icon(Icons.numbers_outlined, color: color, size: 20);
      default:
        return null;
    }
  }

  String? _getDefaultHint() {
    switch (widget.type) {
      case AuthTextFieldType.email:
        return 'Enter your email';
      case AuthTextFieldType.password:
        return 'Enter your password';
      case AuthTextFieldType.confirmPassword:
        return 'Confirm your password';
      case AuthTextFieldType.name:
        return 'Enter your name';
      case AuthTextFieldType.phone:
        return 'Enter phone number';
      case AuthTextFieldType.number:
        return 'Enter number';
      case AuthTextFieldType.multiline:
        return 'Enter details...';
      default:
        return 'Enter text';
    }
  }

  TextInputType _getKeyboardType() {
    if (widget.keyboardType != null) return widget.keyboardType!;
    switch (widget.type) {
      case AuthTextFieldType.email:
        return TextInputType.emailAddress;
      case AuthTextFieldType.phone:
        return TextInputType.phone;
      case AuthTextFieldType.number:
        return const TextInputType.numberWithOptions(decimal: true);
      case AuthTextFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '${widget.label ?? 'This field'} is required';
    }

    switch (widget.type) {
      case AuthTextFieldType.email:
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
          return 'Enter a valid email address';
        }
        break;
      case AuthTextFieldType.password:
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return 'Password must contain uppercase letter';
        }
        if (!RegExp(r'[a-z]').hasMatch(value)) {
          return 'Password must contain lowercase letter';
        }
        if (!RegExp(r'[0-9]').hasMatch(value)) {
          return 'Password must contain a number';
        }
        break;
      case AuthTextFieldType.confirmPassword:
        // Note: confirm password validation should be done in form level
        break;
      case AuthTextFieldType.phone:
        if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)) {
          return 'Enter a valid phone number';
        }
        break;
      default:
        break;
    }
    return null;
  }
}

class AuthFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? initialValue;

  const AuthFormField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction,
    this.focusNode,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextFormField(
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      obscureTextInitial: obscureText,
      keyboardType: keyboardType ?? TextInputType.text,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enabled,
      maxLines: maxLines,
      textInputAction: textInputAction,
      focusNode: focusNode,
      initialValue: initialValue,
    );
  }
}