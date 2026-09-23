import 'package:flutter/material.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Study Library'));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
