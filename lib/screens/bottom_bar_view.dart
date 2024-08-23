import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Content goes here')),
      bottomNavigationBar: SizedBox(
        height: 70, 
        child: BottomNavigationBar(
          currentIndex: 0, 
          onTap: (index) {
            // Handle navigation logic here, e.g., updating state
          },
          type: BottomNavigationBarType.fixed, 
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
                  'assets/images/chat.png', 
                  width: 22,
                ),
              ),
              label: 'Chats',
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/chat.png',
                  width: 22,
                  color: Colors.blue, 
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/more.png', 
                  width: 22,
                ),
              ),
              label: 'More',
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/more.png', 
                  width: 22,
                  color: Colors.blue, 
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/profile.png', 
                  width: 22,
                ),
              ),
              label: 'Profile',
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  'assets/images/profile.png',
                  width: 22,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
