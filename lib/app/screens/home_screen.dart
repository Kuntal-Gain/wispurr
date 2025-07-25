import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wispurr/app/screens/chats/chat_screen.dart';
import 'package:wispurr/utils/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const ChatScreen(),
    const NotImplementedPage(),
    const NotImplementedPage(),
    const NotImplementedPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        color: kBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconBtns(
                iconPath: 'assets/icons/chat.png',
                title: 'Chat',
                isSelected: _currentIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              iconBtns(
                iconPath: 'assets/icons/story.png',
                title: 'Stories',
                isSelected: _currentIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
              iconBtns(
                iconPath: 'assets/icons/group-users.png',
                title: 'Groups',
                isSelected: _currentIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
              iconBtns(
                iconPath: 'assets/icons/call.png',
                title: 'Calls',
                isSelected: _currentIndex == 3,
                onTap: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget iconBtns({
  required String iconPath,
  required String title,
  required bool isSelected,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: isSelected ? Alignment.center : Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 60,
            height: 35,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? kAccentPurple.withOpacity(0.5) // subtle bg
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(isSelected ? 14 : 0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: Image.asset(
                    iconPath,
                    height: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: isSelected ? kAccentPurple : Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

class NotImplementedPage extends StatelessWidget {
  const NotImplementedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: kBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            'Feature is Not Implemented',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
