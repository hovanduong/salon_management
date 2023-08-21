import 'package:flutter/material.dart';

class Navigationbarrrr extends StatelessWidget {
  const Navigationbarrrr({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final void Function(int) onTap;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_ethernet),
          label: 'Search',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.attach_money),
        //   label: 'Search',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
