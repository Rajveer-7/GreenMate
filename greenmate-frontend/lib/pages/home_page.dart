import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_mate/components/bottom_nav_bar.dart';
import 'package:green_mate/pages/plants_page.dart';
import 'package:green_mate/pages/profile_page.dart';
import 'package:green_mate/pages/scan_page.dart';
import 'package:green_mate/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  // variable to control nav bar
  int _selectedIndex = 0;

  //function to update selected index when user taps
  void navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  //pages to display

  final List<Widget> _pages = [
    const ScanPage(),

    const SearchPage(),

    const PlantsPage(),

    const ProfilePage(),


  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
    ),
      appBar: AppBar(
        backgroundColor: Colors.transparent ,
        elevation: 0,
        leading:Builder(builder: (context) =>IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: (){
            Scaffold.of(context).openDrawer();
          },
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
              DrawerHeader(child: Image.asset('lib/images/Green_Mate_White3.png'
              )
              ),



              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                      Icons.home,
                      color: Colors.white
                  ),
                  title: Text('Home', style: TextStyle(color: Colors.white),),

                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                      Icons.info,
                      color: Colors.white
                  ),
                  title: Text('About', style: TextStyle(color: Colors.white),),

                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: signUserOut, // 👈 This calls your signOut function
            ),
          ),


        ],
        ),
      ),

      body: _pages[_selectedIndex],
    );
  }
}

