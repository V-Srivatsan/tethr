import 'package:flutter/material.dart';

import 'package:tethr/lib/store.dart';
import 'package:tethr/screens/auth/index.dart' as auth;
import 'package:tethr/screens/disaster/dashboard/index.dart' as disaster;
import 'package:tethr/screens/normal/index.dart' as normal;

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    () async {
      final logged = await Store.get(Store.TOKEN) != null;
      final is_disaster = await PrefStore.isDisasterMode();

      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (ctx) => !logged ? auth.Screen() :
          is_disaster ? disaster.Screen() : normal.Screen()
      ));
    }();

    return Scaffold(
      body: Container(
        width: .infinity, height: .infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF007A71), Color(0xFF00B3A0)],
            begin: .topCenter, end: .bottomCenter
          )
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              Text(
                "Tethr",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
                  color: Colors.white, fontWeight: .bold
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
