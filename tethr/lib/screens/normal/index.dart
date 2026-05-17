import 'package:flutter/material.dart';
import 'package:tethr/lib/store.dart';
import 'package:tethr/widgets/fragment.dart';

import 'announcements/index.dart' as announcements;

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  String? name = null;
  int currIdx = 0;

  FloatingActionButton? fab = null;
  void setFab(FloatingActionButton btn) => setState(() { fab = btn; });

  @override
  void initState() {
    super.initState();
    () async {
      final name = await Store.get(Store.NAME);
      setState(() { this.name = name!; });
    }();
  }

  @override
  Widget build(BuildContext context) {
      return Fragment(
        loading: name == null, fab: fab,
        title: "Welcome, $name",
        body: SafeArea(child: [
          Center(child: Text("Home")),
          announcements.Screen(setFab),
          Center(child: Text("Requests")),
          Center(child: Text("Profile"))
        ][currIdx]),
        bottomNavBar: BottomNavigationBar(
          currentIndex: currIdx,
          onTap: (idx) => setState(() { currIdx = idx; fab = null; }),
          items: [
            BottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: "Home", active: currIdx == 0),
            BottomNavItem(icon: Icons.announcement_outlined, activeIcon: Icons.announcement, label: "Board", active: currIdx == 1),
            BottomNavItem(icon: Icons.fact_check_outlined, activeIcon: Icons.fact_check, label: "Requests", active: currIdx == 2),
            BottomNavItem(icon: Icons.person_2_outlined, activeIcon: Icons.person_2, label: "Profile", active: currIdx == 3)
          ],
        ),
      );
  }
}

