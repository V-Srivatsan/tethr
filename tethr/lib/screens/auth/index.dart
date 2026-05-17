import 'package:flutter/material.dart';
import 'package:tethr/widgets/fragment.dart';

import 'login.dart';
import 'signup.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool login = true;

  @override
  Widget build(BuildContext context) {
    final display = MediaQuery.of(context).size;

    return Fragment(
      showAppBar: false,
      body: SafeArea(child: SingleChildScrollView(child: Column(
        mainAxisSize: .min, spacing: 20,
        children: [
          Container(
            width: .infinity, height: display.height * 0.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF007A71), Color(0xFF00B3A0)],
                  begin: .topCenter, end: .bottomCenter
              ),
            ),
            padding: .symmetric(horizontal: display.width * 0.1),
            child: Column(
              crossAxisAlignment: .start, mainAxisAlignment: .center,
              mainAxisSize: .min,
              spacing: 5,
              children: [
                Text(
                  login ? "Welcome Back!" : "Welcome to Tethr!",
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: Colors.white, fontWeight: .bold),
                ),
                Text(
                  login ? "Catch up on your community" : "Join your community now",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
            padding: .symmetric(horizontal: display.width * 0.05),
            child: Column(
              mainAxisSize: .min, spacing: 5,
              children: [
                login ? LoginForm() : SignupForm(),
                Divider(),
                TextButton(
                  onPressed: () { setState(() { login = !login; }); },
                  child: Text(
                    login ? "Don't have an account? Sign up" :
                        "Already have an account? Login"
                  )
                )
              ],
            ),
          ),
        ]
      )))
    );
  }
}

