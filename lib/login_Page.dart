import 'package:flutter/material.dart';
// ignore: file_names

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0)
            ],
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 300,
                  child: Column(children: [
                    Image.asset('assets/image/01.png', fit: BoxFit.cover),
                  ]),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
                child: Container(
                  child: (Image.asset(
                    'assets/gif/44.gif', width: 250,
                    //fit: BoxFit.cover,
                  )),
                ),
              ),
            ]),
      ),
    );
  }
}
