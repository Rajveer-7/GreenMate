import 'package:flutter/material.dart';
import 'package:green_mate/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<void> editField(String field) async{}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [

          const SizedBox(height: 30,),
          //Profile Pic
          Icon(Icons.person,size: 80,),

          //Email
          Text(
            "xyz123@gmail.com",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),

          const SizedBox(height: 10,),
          //Details
          Padding(
            padding: EdgeInsets.only(left: 35),
            child: Text("My Details"),
          ),

          //Name
          MyTextBox(
            text: 'Name123',
            sectionName: 'Username',
            onPressed: () => editField('username'),
          ),

          //Bio

          MyTextBox(
            text: 'Empty Bio',
            sectionName: 'Bio',
            onPressed: () => editField('bio'),
          ),

        ],
      ),
    );
  }
}
