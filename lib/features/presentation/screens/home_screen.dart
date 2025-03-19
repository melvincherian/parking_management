import 'package:flutter/material.dart';
import 'package:parking_management/features/presentation/provider/bottom_navbar.dart';
import 'package:parking_management/features/presentation/screens/history_screen.dart';
import 'package:parking_management/features/presentation/screens/profile_screen.dart';
import 'package:parking_management/features/presentation/screens/screen_home.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavbarprovider = Provider.of<BottomNavbarprovider>(context);

    final pages = [
      const ScreenHome(),
      const HistoryScreen(),
      const ProfileScreen()
    
    ];

    return Scaffold(
      body: pages[bottomNavbarprovider.currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavbarprovider.currentindex,
        onTap: (index) {
          bottomNavbarprovider.setIndex(index);
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          
        ],
      ),
    );
  }
}
