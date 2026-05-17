import 'package:flutter/material.dart';
import 'package:tethr/widgets/fragment.dart';
import 'package:tethr/widgets/loader.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool loading = true;
  String name = "";



  @override
  Widget build(BuildContext context) {
    return Fragment(
      body: Loader(
        loading: loading,
        child: Text("Disaster")
      ),
    );
  }
}

