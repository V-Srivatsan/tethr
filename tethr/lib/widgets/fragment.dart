import 'package:flutter/material.dart';
import 'package:tethr/lib/store.dart';
import 'loader.dart';

import 'package:tethr/screens/splash/index.dart' as splash;


class Fragment extends StatefulWidget {
  final bool showAppBar; final bool loading;
  final String? title; final BottomNavigationBar? bottomNavBar;
  final Widget body; final FloatingActionButton? fab;


  const Fragment({
    super.key, this.showAppBar = true, this.title = null,
    required this.body, this.bottomNavBar, this.loading = false,
    this.fab
  });

  @override
  State<Fragment> createState() => _FragmentState();
}

class _FragmentState extends State<Fragment> {

  bool disaster = false;

  @override
  void initState() {
    super.initState();
    PrefStore.isDisasterMode().then((value) => setState(() { disaster = value; }));
  }

  @override
  Widget build(BuildContext context) {
    return widget.loading ? Scaffold(body: Loader(loading: true, child: widget.body)) :
      Scaffold(
        appBar: !widget.showAppBar ? null : AppBar(
          title: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(widget.title ?? "Tethr"),
              Row(
                mainAxisSize: .min,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        disaster ? Icons.shield : Icons.warning_amber
                      )
                  )
                ],
              )
            ],
          ),
        ),
        body: widget.body,
        bottomNavigationBar: widget.bottomNavBar,
        floatingActionButton: widget.fab,
      );
  }
}

BottomNavigationBarItem BottomNavItem({
  required IconData icon, required IconData activeIcon,
  required String label, required bool active
}) => BottomNavigationBarItem(
    icon: Icon(active ? activeIcon : icon),
    label: label
  );
