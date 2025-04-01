import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:green_mate/pages/home_page.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  //Loading Time....
  Duration get loadingTime => const Duration(milliseconds: 2000);

  //Temporary Email and Password
  final String tempEmail = 'abc@gmail.com';
  final String tempPassword = '123';

  //Login Function
  Future<String?> _authUser(LoginData data) async {


    //Delay for loading
    await Future.delayed(loadingTime);

    //Check if entered credentials match
    if (data.name != tempEmail || data.password != tempPassword) {
      return 'Invalid email or password';
    }

    //Return null if login is successful
    return null;
  }

  //Forgot Password
  Future<String?> _recoverPassword(String data){
    return Future.delayed(loadingTime).then((value) => null);
  }

  //Sign Up
  Future<String?> _signUp(SignupData data){
    return Future.delayed(loadingTime).then((value) => null);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
          onLogin: _authUser,
          onRecoverPassword: _recoverPassword,
          onSignup: _signUp,
          logo: 'lib/images/Green_Mate_White3.png',
          theme: LoginTheme(
            primaryColor: Colors.grey[900],
            cardTheme: CardTheme(
              color: Colors.grey[300],


            )
          ),
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },

      ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: const Icon(Icons.arrow_forward),
        )

    );
  }
}
