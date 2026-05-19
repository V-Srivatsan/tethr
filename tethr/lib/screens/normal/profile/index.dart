import 'package:flutter/material.dart';
import './logic.dart' as logic;

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(
      mainAxisSize: .min, crossAxisAlignment: .stretch,
      children: [
        ElevatedButton(
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
          onPressed: () => logic.signOut(context),
          child: Row(
            mainAxisAlignment: .center, spacing: 10,
            children: [
              Text("Sign Out"),
              Icon(Icons.logout)
            ],
          ),
        )
      ],
    ));
  }
}
