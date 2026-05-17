import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tethr/widgets/loader.dart';
import 'package:tethr/screens/normal/community/setup/index.dart' as comm_setup;

import './logic.dart' as logic;
import './post.dart';

class Screen extends StatefulWidget {
  final void Function(FloatingActionButton) setFab;
  const Screen(this.setFab, {super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool loading = true, community_found = true;
  List<logic.Announcement> announcements = [];

  void addAnnouncement(logic.Announcement ann) => setState(() {
    announcements = [...announcements, ann];
  });

  @override
  void initState() {
    super.initState();
    () async {
      final res = await logic.getAnnouncements(context);
      if (res == null) {
        setState(() { community_found = false; loading = false; });
        return;
      }

      if (res.$1) widget.setFab(FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context, enableDrag: true, showDragHandle: true,
          builder: (ctx) => PostAnnouncement(addAnnouncement)
        ),
        child: Icon(Icons.add_comment),
      ));
      setState(() {announcements = res.$2; loading = false; });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(
      loading: loading,
      child: Padding(
        padding: .symmetric(horizontal: 20),
        child: !community_found ? Center(child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => comm_setup.Screen())),
          child: Text("Join a Community")
        )) :
        ListView(
          children: announcements.map((ann) => Card(
            child: Padding(
              padding: .symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisSize: .min, crossAxisAlignment: .start, spacing: 7.5,
                children: [
                  Text(
                    ann.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: .bold),
                  ),

                  Text(ann.content),

                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(ann.user, style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        DateFormat("hh:mm, dd/MM/yyyy").format(ann.timestamp.toLocal()),
                        style: Theme.of(context).textTheme.bodySmall),
                    ],
                  )
                ],
              ),
            ),
          )).toList(),
        ),
      )
    );
  }
}
