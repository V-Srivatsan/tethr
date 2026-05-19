import 'package:flutter/material.dart';
import 'package:tethr/lib/profile.dart';
import './logic.dart' as logic;

class Members extends StatefulWidget {
  final Map<String, logic.Member> members;
  const Members(this.members, {super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> with TickerProviderStateMixin {

  late final TabController controller;
  List<logic.Member> members = [], requests = [];
  int index = 0; Offset _tapPos = Offset.zero;

  void processMembers([bool init = false]) {
    List<logic.Member> mems = [], reqs = [];
    widget.members.values.forEach((member) {
      if (member.verified) mems.add(member);
      else reqs.add(member);
    });

    if (init) { members = mems; requests = reqs; }
    else setState(() { members = mems; requests = reqs; });
  }

  void acceptMember(String uid) { widget.members[uid]?.verified = true; processMembers(); }
  void rejectMember(String uid) { widget.members.remove(uid); processMembers(); }
  void makeAdmin(String uid) { widget.members[uid]?.is_admin = true; processMembers(); }
  void removeAdmin(String uid) { widget.members[uid]?.is_admin = false; processMembers(); }
  void removeFromCommunity(String uid) { widget.members.remove(uid); processMembers(); }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() => setState(() => index = controller.index));
    processMembers(true);
  }

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min, crossAxisAlignment: .stretch,
      children: [

        if (Profile.comm_admin)
          TabBar(
            controller: controller, indicatorSize: .tab,
            tabs: const [ Tab(text: "Members"), Tab(text: "Requests") ]
          ),

        [
          ListView.builder(
            shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
            itemCount: members.length,
            itemBuilder: (ctx, i) => GestureDetector(
              onTapDown: (details) => _tapPos = details.globalPosition,
              child: ListTile(
                title: Text(members[i].name), subtitle: Text(members[i].phone),
                trailing: !members[i].is_admin ? null : Chip(label: Text("Admin")),
                onLongPress: !Profile.comm_admin ? null : () => showMenu(
                    context: ctx,
                    position: .fromSize(.fromLTWH(_tapPos.dx, _tapPos.dy, .minPositive, .minPositive), Size(0, 0)),
                    items: [
                      PopupMenuItem(
                        onTap: () async {

                          if (members[i].is_admin) {
                            if (await logic.removeAdmin(context, members[i].uid))
                              removeAdmin(members[i].uid);
                          } else {
                            print("DEBUG: CAME HERE");
                            if (await logic.makeAdmin(context, members[i].uid))
                              makeAdmin(members[i].uid);
                          }
                        },
                        child: Text(members[i].is_admin ? "Dismiss as Admin" : "Make Admin")
                      ),

                      if (!members[i].is_admin)
                        PopupMenuItem(
                            onTap: () async {
                              if (await logic.removeFromCommunity(context, members[i].uid))
                                removeFromCommunity(members[i].uid);
                            },
                            child: Text("Remove")
                        )
                    ]
                ),
              ),
            ),
          ),

          ListView.builder(
            shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            itemBuilder: (ctx, i) => ListTile(
              title: Text(requests[i].name), subtitle: Text(requests[i].phone),
              trailing: Row(
                mainAxisSize: .min,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (await logic.rejectMembership(context, requests[i].uid))
                        rejectMember(requests[i].uid);
                    },
                    icon: Icon(Icons.delete_outline)
                  ),
                  IconButton(
                    onPressed: () async {
                      if (await logic.acceptMembership(context, requests[i].uid))
                        rejectMember(requests[i].uid);
                    },
                    icon: Icon(Icons.check)
                  )
                ],
              ),
            ),
          )
        ][index]

      ],
    );
  }
}

