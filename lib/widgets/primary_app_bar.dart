import 'package:flutter/material.dart';

/// Shared app bar used on all 5 screens.
///
/// Matches the Design System spec (title, onBack, actions), plus one small
/// addition: an optional [leading] override, needed because Home's app bar
/// uses a menu icon (not a back arrow) and Settings uses a home icon.
/// If [leading] is omitted, falls back to a back arrow when [onBack] is set,
/// or no leading widget at all (root tabs reached via the bottom nav).
class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.leading,
    this.actions,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading ??
          (onBack != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBack,
                  tooltip: 'Back',
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
