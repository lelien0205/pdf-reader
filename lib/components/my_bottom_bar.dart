import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class MyBottomBar extends StatelessWidget {
  final void Function(int)? onTap;
  const MyBottomBar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: CurvedNavigationBar(
        onTap: onTap,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Theme.of(context).colorScheme.surface,
        color: Theme.of(context).colorScheme.secondary,
        items: [
          Icon(
            AntDesign.file_fill,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          Icon(
            Icons.history_rounded,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          Icon(
            Icons.star_rounded,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ],
      ),
    );
  }
}
