import 'package:flutter/material.dart';
import 'package:green_mate/pages/home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.grey[300],

       body: Center(
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 25),
           child: Column(
             mainAxisAlignment:MainAxisAlignment.center,
             children: [

              Image.asset('lib/images/Green_Mate_White2.png',height: 290,color: Colors.black,),
              /* Text(
                 'Green Mate',
                 style:TextStyle(fontWeight: FontWeight.bold, fontSize: 60) ,
               ),*/

               const SizedBox(height: 100),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12)
                  ),
                  padding: EdgeInsets.all(25),
                  child: Center(
                    child: Text(
                      'Log In',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )

             ],
           ),
         ),
       )
     );

  }
}
