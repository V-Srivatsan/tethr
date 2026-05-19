import 'package:flutter/material.dart';
import 'package:tethr/widgets/fragment.dart';

import 'home/index.dart' as home;
import 'announcements/index.dart' as announcements;
import 'profile/index.dart' as profile;


import 'profile/logic.dart' as profile_logic;

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool loading = true; int currIdx = 0;
  FloatingActionButton? fab = null;
  void setFab(FloatingActionButton btn) => setState(() { fab = btn; });

  @override
  void initState() {
    super.initState();
    () async {
      await profile_logic.getProfile(context);
      if (mounted) setState(() => loading = false);
      else loading = false;
    }();
  }

  @override
  Widget build(BuildContext context) {
      return Fragment(
        loading: loading, fab: fab,
        title: ["Tethr", "Announcements", "Your Requests", "Profile"][currIdx],

        body: SafeArea(child: [
          home.Screen(),
          announcements.Screen(setFab),
          Center(child: Text("Requests")),
          profile.Screen()
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

