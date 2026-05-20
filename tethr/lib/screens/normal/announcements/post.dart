import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tethr/widgets/bottom_sheet.dart';
import 'package:tethr/widgets/loader.dart';

import './logic.dart' as logic;

class PostAnnouncement extends StatefulWidget {
  final void Function(logic.Announcement) addAnnouncement;
  const PostAnnouncement(this.addAnnouncement, {super.key});

  @override
  State<PostAnnouncement> createState() => _PostAnnouncementState();
}

class _PostAnnouncementState extends State<PostAnnouncement> {

  final _key = GlobalKey<FormBuilderState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return BottomSheetModal(FormBuilder(
      key: _key,
      child: Column(
        mainAxisSize: .min, crossAxisAlignment: .stretch,
        spacing: 10,
        children: [
          FormBuilderTextField(
            name: "title", decoration: InputDecoration(label: Text("Title")),
          ),

          FormBuilderTextField(
            name: "content", decoration: InputDecoration(label: Text("Message")),
          ),

          LoaderButton(
              text: "Post Announcement", loading: loading,
              onPressed: () async {
                if (!_key.currentState!.saveAndValidate()) return;
                final time = DateTime.now();
                setState(() { loading = true; });

                final data = _key.currentState!.value;
                final success = await logic.postAnnouncement(context,data);
                if (success) {
                  widget.addAnnouncement(logic.Announcement("You", data["title"], data["content"], time));
                  Navigator.pop(context);
                }
              }
          )
        ],
      )
    ));
  }
}
