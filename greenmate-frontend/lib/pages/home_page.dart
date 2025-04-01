import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_mate/components/bottom_nav_bar.dart';
import 'package:green_mate/pages/plants_page.dart';
import 'package:green_mate/pages/profile_page.dart';
import 'package:green_mate/pages/scan_page.dart';
import 'package:green_mate/pages/search_page.dart';
import 'package:green_mate/pages/email_auth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final user = FirebaseAuth.instance.currentUser;
  late final bool isGuest;

  @override
  void initState() {
    super.initState();
    isGuest = user != null && user!.isAnonymous;
  }

  // Pages to display
  final List<Widget> _pages = [
    const ScanPage(),
    const SearchPage(),
    const PlantsPage(),
    const ProfilePage(),
  ];

  // Navigation logic with guest restriction
  void navigateBottomBar(int index) {
    if (isGuest && index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Guest access is limited to the Scan Page only. Please log in for full access.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Image.asset('lib/images/Green_Mate_White3.png'),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text('Home', style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.white),
                  title: Text('About', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 25),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
