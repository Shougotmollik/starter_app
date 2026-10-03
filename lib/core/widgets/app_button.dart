import 'package:flutter/material.dart';

enum AppButtonType { elevated, outlined, text, filled, tonal }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.type = AppButtonType.elevated,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
  }) : assert(label != null || child != null, 'Either label or child must be provided');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? _getBorderRadius(theme);
    final effectivePadding = padding ?? _getPadding(size);

    final buttonChild = _buildChild(context);

    Widget button;

    switch (type) {
      case AppButtonType.elevated:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _elevatedStyle(theme, effectiveBorderRadius, effectivePadding),
          child: buttonChild,
        );
        break;
      case AppButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: _outlinedStyle(theme, effectiveBorderRadius, effectivePadding),
          child: buttonChild,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _textStyle(theme, effectiveBorderRadius, effectivePadding),
          child: buttonChild,
        );
        break;
      case AppButtonType.filled:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: _filledStyle(theme, effectiveBorderRadius, effectivePadding),
          child: buttonChild,
        );
        break;
      case AppButtonType.tonal:
        button = FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: _tonalStyle(theme, effectiveBorderRadius, effectivePadding),
          child: buttonChild,
        );
        break;
    }

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildChild(BuildContext context) {
    if (child != null) return child!;

    if (isLoading) {
      return SizedBox(
        width: _getLoaderSize(size),
        height: _getLoaderSize(size),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ??
                (type == AppButtonType.text || type == AppButtonType.outlined
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      );
    }

    final widgets = <Widget>[];

    if (leadingIcon != null) {
      widgets.add(Icon(leadingIcon, size: _getIconSize(size)));
      widgets.add(SizedBox(width: _getIconSpacing(size)));
    }

    widgets.add(Text(
      label!,
      style: TextStyle(
        fontSize: _getFontSize(size),
        fontWeight: FontWeight.w600,
        color: foregroundColor,
      ),
    ));

    if (trailingIcon != null) {
      widgets.add(SizedBox(width: _getIconSpacing(size)));
      widgets.add(Icon(trailingIcon, size: _getIconSize(size)));
    }

    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  ButtonStyle _elevatedStyle(ThemeData theme, double radius, EdgeInsetsGeometry padding) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      elevation: 2,
      shadowColor: (backgroundColor ?? theme.colorScheme.primary).withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      padding: padding,
      textStyle: TextStyle(fontSize: _getFontSize(size), fontWeight: FontWeight.w600),
      disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.4),
      disabledForegroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.4),
    );
  }

  ButtonStyle _outlinedStyle(ThemeData theme, double radius, EdgeInsetsGeometry padding) {
    final border = borderColor ?? theme.colorScheme.primary;
    return OutlinedButton.styleFrom(
      foregroundColor: foregroundColor ?? theme.colorScheme.primary,
      side: BorderSide(color: border, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      padding: padding,
      textStyle: TextStyle(fontSize: _getFontSize(size), fontWeight: FontWeight.w600),
      disabledForegroundColor: theme.colorScheme.primary.withValues(alpha: 0.4),
    );
  }

  ButtonStyle _textStyle(ThemeData theme, double radius, EdgeInsetsGeometry padding) {
    return TextButton.styleFrom(
      foregroundColor: foregroundColor ?? theme.colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      padding: padding,
      textStyle: TextStyle(fontSize: _getFontSize(size), fontWeight: FontWeight.w600),
      disabledForegroundColor: theme.colorScheme.primary.withValues(alpha: 0.4),
    );
  }

  ButtonStyle _filledStyle(ThemeData theme, double radius, EdgeInsetsGeometry padding) {
    return FilledButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      padding: padding,
      textStyle: TextStyle(fontSize: _getFontSize(size), fontWeight: FontWeight.w600),
      disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.4),
      disabledForegroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.4),
    );
  }

  ButtonStyle _tonalStyle(ThemeData theme, double radius, EdgeInsetsGeometry padding) {
    return FilledButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.colorScheme.secondaryContainer,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSecondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      padding: padding,
      textStyle: TextStyle(fontSize: _getFontSize(size), fontWeight: FontWeight.w600),
    );
  }

  double _getBorderRadius(ThemeData theme) {
    final buttonTheme = switch (type) {
      AppButtonType.elevated => theme.elevatedButtonTheme.style,
      AppButtonType.outlined => theme.outlinedButtonTheme.style,
      AppButtonType.text => theme.textButtonTheme.style,
      _ => theme.filledButtonTheme.style,
    };
    final shape = buttonTheme?.shape?.resolve({}) as RoundedRectangleBorder?;
    return (shape?.borderRadius as BorderRadius?)?.topLeft.x ?? 12;
  }

  EdgeInsetsGeometry _getPadding(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 18);
    }
  }

  double _getFontSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 13;
      case AppButtonSize.medium:
        return 16;
      case AppButtonSize.large:
        return 18;
    }
  }

  double _getIconSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  double _getIconSpacing(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 6;
      case AppButtonSize.medium:
        return 8;
      case AppButtonSize.large:
        return 10;
    }
  }

  double _getLoaderSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.type = AppButtonType.elevated,
    this.size = AppButtonSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSize = _getButtonSize(size);
    final effectiveBorderRadius = borderRadius ?? 12;

    Widget button;

    switch (type) {
      case AppButtonType.elevated:
        button = IconButton.filled(
          icon: Icon(icon, size: _getIconSize(size)),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.primary,
            foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
            fixedSize: Size(effectiveSize, effectiveSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          tooltip: tooltip,
        );
        break;
      case AppButtonType.outlined:
        button = IconButton.outlined(
          icon: Icon(icon, size: _getIconSize(size)),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            side: BorderSide(color: borderColor ?? theme.colorScheme.primary, width: 1.5),
            fixedSize: Size(effectiveSize, effectiveSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          tooltip: tooltip,
        );
        break;
      case AppButtonType.text:
        button = IconButton(
          icon: Icon(icon, size: _getIconSize(size)),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            fixedSize: Size(effectiveSize, effectiveSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          tooltip: tooltip,
        );
        break;
      case AppButtonType.filled:
      case AppButtonType.tonal:
        button = IconButton.filled(
          icon: Icon(icon, size: _getIconSize(size)),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: type == AppButtonType.tonal
                ? (backgroundColor ?? theme.colorScheme.secondaryContainer)
                : (backgroundColor ?? theme.colorScheme.primary),
            foregroundColor: type == AppButtonType.tonal
                ? (foregroundColor ?? theme.colorScheme.onSecondaryContainer)
                : (foregroundColor ?? theme.colorScheme.onPrimary),
            fixedSize: Size(effectiveSize, effectiveSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          tooltip: tooltip,
        );
        break;
    }

    return button;
  }

  double _getButtonSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 44;
      case AppButtonSize.large:
        return 52;
    }
  }

  double _getIconSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 18;
      case AppButtonSize.medium:
        return 22;
      case AppButtonSize.large:
        return 28;
    }
  }
}