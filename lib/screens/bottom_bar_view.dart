import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Content goes here')),
      bottomNavigationBar: SizedBox(
        height: 70, // Specify the height of the bottom navigation bar
        child: BottomNavigationBar(
          currentIndex: 0, // Set the initial index
          onTap: (index) {
            // Handle navigation logic here, e.g., updating state
          },
          type: BottomNavigationBarType.fixed, // Ensures all items are displayed
          elevation: 0, // No shadow
          selectedLabelStyle: const TextStyle(
            fontFamily: 'OutfitMedium',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'OutfitMedium',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/chat.png', // Replace with your image path
                  width: 22,
                ),
              ),
              label: 'Chats',
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/chat.png', // Replace with your image path
                  width: 22,
                  color: Colors.blue, // Replace with your active color
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/more.png', // Replace with your image path
                  width: 22,
                ),
              ),
              label: 'More',
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/more.png', // Replace with your image path
                  width: 22,
                  color: Colors.blue, // Replace with your active color
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/profile.png', // Replace with your image path
                  width: 22,
                ),
              ),
              label: 'Profile',
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/profile.png', // Replace with your image path
                  width: 22,
                  color: Colors.blue, // Replace with your active color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
